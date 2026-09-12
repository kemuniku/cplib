when not declared CPLIB_GRAPH_PUSH_RELABEL:
    const CPLIB_GRAPH_PUSH_RELABEL* = 1

    type
        PushRelabelEdge*[Cap] = object
            src*, dst*: int
            cap*, flow*: Cap
        PushRelabelArc[Cap] = object
            dst, rev: int
            cap: Cap
        PushRelabel*[Cap] = object
            graph: seq[seq[PushRelabelArc[Cap]]]
            positions: seq[tuple[src, index: int]]

    proc initPushRelabel*[Cap: SomeInteger](n: int, capacityZero: Cap = 0): PushRelabel[Cap] =
        ## n頂点の最大流グラフを構築する。容量型の省略時はint。capacityZeroは型推論用。O(n)。
        assert n >= 0
        result.graph = newSeq[seq[PushRelabelArc[Cap]]](n)

    proc add_edge*[Cap](g: var PushRelabel[Cap], src, dst: int, cap: Cap): int {.discardable.} =
        ## 容量capの有向辺を追加し、辺番号を返す。自己ループ・多重辺も可。償却O(1)。
        assert src in 0..<g.graph.len and dst in 0..<g.graph.len
        assert cap >= Cap(0)
        result = g.positions.len
        let index = g.graph[src].len
        let rev = g.graph[dst].len + ord(src == dst)
        g.positions.add((src, index))
        g.graph[src].add(PushRelabelArc[Cap](dst: dst, rev: rev, cap: cap))
        g.graph[dst].add(PushRelabelArc[Cap](dst: src, rev: index, cap: Cap(0)))

    proc get_edge*[Cap](g: PushRelabel[Cap], i: int): PushRelabelEdge[Cap] =
        ## i番目の辺の容量と現在の流量を返す。O(1)。
        let (src, index) = g.positions[i]
        let e = g.graph[src][index]
        let flow = g.graph[e.dst][e.rev].cap
        PushRelabelEdge[Cap](src: src, dst: e.dst, cap: e.cap + flow, flow: flow)

    proc get_edges*[Cap](g: PushRelabel[Cap]): seq[PushRelabelEdge[Cap]] =
        ## 追加順に全辺の情報を返す。O(E)。
        result = newSeqOfCap[PushRelabelEdge[Cap]](g.positions.len)
        for i in 0..<g.positions.len:
            result.add(g.get_edge(i))

    proc flow*[Cap](g: var PushRelabel[Cap], src, dst: int, limit: Cap = high(Cap)): Cap =
        ## Highest-label Push–Relabel法でlimit以下の追加流量を返す。再実行可。単純グラフでO(V^2√E)、追加領域O(V)。
        ## 多重辺を含む一般の場合はO(VE+V^2√E)。辺がない場合はO(V)。
        assert src in 0..<g.graph.len and dst in 0..<g.graph.len and src != dst
        assert limit >= Cap(0)
        if limit == Cap(0):
            return Cap(0)

        # 仮想始点からlimitだけ供給し、流量制限と余剰流の容量型オーバーフローを防ぐ。
        let source = g.graph.len
        let sourceIndex = g.graph[src].len
        g.graph.add(@[PushRelabelArc[Cap](dst: src, rev: sourceIndex, cap: Cap(0))])
        g.graph[src].add(PushRelabelArc[Cap](dst: source, rev: 0, cap: limit))
        defer:
            g.graph[src].setLen(sourceIndex)
            g.graph.setLen(source)

        let n = g.graph.len
        let unreachable = 2 * n
        var height = newSeq[int](n)
        var count = newSeq[int](unreachable + 1)
        var iter = newSeq[int](n)
        var excess = newSeq[Cap](n)
        var bucket = newSeq[int](unreachable + 1)
        var next = newSeq[int](n)
        var prev = newSeq[int](n)
        var active = newSeq[bool](n)
        var heightHead = newSeq[int](n)
        var heightNext = newSeq[int](n)
        var heightPrev = newSeq[int](n)
        var queue = newSeq[int](n)
        var highest = -1
        var highestLow = -1
        var highestFinite = -1
        var relabelWork = 0
        let relabelWorkLimit = 4 * n + 2 * g.positions.len + 2
        excess[src] = limit

        template activate(vertex: int) =
            ## 正の余剰流を持つ頂点を高さ別のリストへ追加する。O(1)。
            block:
                let v = vertex
                if v != source and v != dst:
                    let h = height[v]
                    next[v] = bucket[h]
                    prev[v] = -1
                    if next[v] >= 0:
                        prev[next[v]] = v
                    bucket[h] = v
                    active[v] = true
                    highest = max(highest, h)
                    if h < n:
                        highestLow = max(highestLow, h)

        template removeActive(vertex: int) =
            ## 活性頂点を高さ別のリストから取り除く。O(1)。
            block:
                let v = vertex
                if prev[v] < 0:
                    bucket[height[v]] = next[v]
                else:
                    next[prev[v]] = next[v]
                if next[v] >= 0:
                    prev[next[v]] = prev[v]
                active[v] = false

        template addHeight(vertex: int) =
            ## 終点へ送る高さ帯の頂点を高さ別のリストへ追加する。O(1)。
            block:
                let v = vertex
                let h = height[v]
                if h < n:
                    heightNext[v] = heightHead[h]
                    heightPrev[v] = -1
                    if heightNext[v] >= 0:
                        heightPrev[heightNext[v]] = v
                    heightHead[h] = v
                    highestFinite = max(highestFinite, h)

        template removeHeight(vertex: int) =
            ## 終点へ送る高さ帯の頂点を高さ別のリストから取り除く。O(1)。
            block:
                let v = vertex
                if height[v] < n:
                    if heightPrev[v] < 0:
                        heightHead[height[v]] = heightNext[v]
                    else:
                        heightNext[heightPrev[v]] = heightNext[v]
                    if heightNext[v] >= 0:
                        heightPrev[heightNext[v]] = heightPrev[v]

        template rebuildActive() =
            ## 高さの一括変更後に活性頂点のリストを再構築する。O(V)。
            for h in 0..unreachable:
                bucket[h] = -1
            highest = -1
            highestLow = -1
            for v in 0..<n:
                active[v] = false
                if excess[v] > Cap(0):
                    activate(v)

        template globalRelabel() =
            ## 終点への距離と、終点へ届かない頂点の仮想始点への距離を逆向きBFSで求める。O(V+E)。
            for v in 0..<n:
                height[v] = unreachable
                iter[v] = 0
            height[dst] = 0
            height[source] = n
            for root in [dst, source]:
                var head = 0
                var tail = 1
                queue[0] = root
                while head < tail:
                    let v = queue[head]
                    inc head
                    for e in g.graph[v]:
                        if height[e.dst] == unreachable and g.graph[e.dst][e.rev].cap > Cap(0):
                            height[e.dst] = height[v] + 1
                            queue[tail] = e.dst
                            inc tail
            for h in 0..unreachable:
                count[h] = 0
            for h in 0..<n:
                heightHead[h] = -1
            highestFinite = -1
            for v in 0..<n:
                inc count[height[v]]
                addHeight(v)
            rebuildActive()
            relabelWork = 0

        globalRelabel()
        while highest >= 0:
            if bucket[highest] < 0:
                # 始点へ戻す高さ帯から、終点へ送る高さ帯までの空区間を飛ばす。
                if highest == n:
                    highest = highestLow
                else:
                    dec highest
                    if highest < n:
                        highestLow = highest
                continue
            let v = bucket[highest]
            removeActive(v)
            while excess[v] > Cap(0):
                if iter[v] == g.graph[v].len:
                    let old = height[v]
                    var best = unreachable
                    var bestIndex = 0
                    for i, e in g.graph[v]:
                        if e.cap > Cap(0) and height[e.dst] < best:
                            best = height[e.dst]
                            bestIndex = i
                    # 高さ引き上げ時の走査だけを数え、一括更新とそれに伴う再走査の総費用をO(VE)に抑える。
                    relabelWork += g.graph[v].len
                    removeHeight(v)
                    dec count[old]
                    height[v] = best + 1
                    inc count[height[v]]
                    addHeight(v)
                    iter[v] = bestIndex
                    if old < n and count[old] == 0:
                        # 全頂点を走査せず、空になった高さより上の頂点だけを移す。
                        for h in old + 1..highestFinite:
                            while heightHead[h] >= 0:
                                let u = heightHead[h]
                                removeHeight(u)
                                let wasActive = active[u]
                                if wasActive:
                                    removeActive(u)
                                dec count[h]
                                height[u] = n + 1
                                inc count[height[u]]
                                iter[u] = 0
                                if wasActive:
                                    activate(u)
                        highestFinite = old
                        activate(v)
                        break
                else:
                    let i = iter[v]
                    let e = g.graph[v][i]
                    if e.cap > Cap(0) and height[v] == height[e.dst] + 1:
                        let amount = min(excess[v], e.cap)
                        if excess[e.dst] == Cap(0):
                            activate(e.dst)
                        g.graph[v][i].cap -= amount
                        g.graph[e.dst][e.rev].cap += amount
                        excess[v] -= amount
                        excess[e.dst] += amount
                    else:
                        inc iter[v]
            if relabelWork >= relabelWorkLimit:
                globalRelabel()
        return excess[dst]

    proc min_cut*[Cap](g: PushRelabel[Cap], src: int): seq[bool] =
        ## 残余グラフでsrcから到達可能な頂点を返す。最大流計算後は最小カット。O(V+E)。
        assert src in 0..<g.graph.len
        result = newSeq[bool](g.graph.len)
        result[src] = true
        var queue = @[src]
        var head = 0
        while head < queue.len:
            let v = queue[head]
            inc head
            for e in g.graph[v]:
                if e.cap > Cap(0) and not result[e.dst]:
                    result[e.dst] = true
                    queue.add(e.dst)
