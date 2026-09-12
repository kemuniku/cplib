when not declared CPLIB_GRAPH_MAXFLOW:
    const CPLIB_GRAPH_MAXFLOW* = 1

    type
        MaxFlowEdge*[Cap] = object
            src*, dst*: int
            cap*, flow*: Cap
        MaxFlowArc[Cap] = object
            dst, rev: int
            cap: Cap
        MaxFlow*[Cap] = object
            graph: seq[seq[MaxFlowArc[Cap]]]
            positions: seq[tuple[src, index: int]]

    proc initMaxFlow*[Cap: SomeInteger](n: int, capacityZero: Cap = 0): MaxFlow[Cap] =
        ## n頂点の最大流グラフを構築する。容量型の省略時はint。capacityZeroは型推論用。O(n)。
        assert n >= 0
        result.graph = newSeq[seq[MaxFlowArc[Cap]]](n)

    proc add_edge*[Cap](g: var MaxFlow[Cap], src, dst: int, cap: Cap): int {.discardable.} =
        ## 容量capの有向辺を追加し、辺番号を返す。償却O(1)。
        assert src in 0..<g.graph.len and dst in 0..<g.graph.len
        assert cap >= Cap(0)
        result = g.positions.len
        let index = g.graph[src].len
        let rev = g.graph[dst].len + ord(src == dst)
        g.positions.add((src, index))
        g.graph[src].add(MaxFlowArc[Cap](dst: dst, rev: rev, cap: cap))
        g.graph[dst].add(MaxFlowArc[Cap](dst: src, rev: index, cap: Cap(0)))

    proc get_edge*[Cap](g: MaxFlow[Cap], i: int): MaxFlowEdge[Cap] =
        ## i番目の辺の容量と現在の流量を返す。O(1)。
        let (src, index) = g.positions[i]
        let e = g.graph[src][index]
        let flow = g.graph[e.dst][e.rev].cap
        MaxFlowEdge[Cap](src: src, dst: e.dst, cap: e.cap + flow, flow: flow)

    proc get_edges*[Cap](g: MaxFlow[Cap]): seq[MaxFlowEdge[Cap]] =
        ## 追加順に全辺の情報を返す。O(E)。
        for i in 0..<g.positions.len:
            result.add(g.get_edge(i))

    proc flow*[Cap](g: var MaxFlow[Cap], src, dst: int, limit: Cap = high(Cap)): Cap =
        ## Dinic法でlimit以下の流量を追加し、追加流量を返す。O(V^2 E)。
        assert src in 0..<g.graph.len and dst in 0..<g.graph.len and src != dst
        assert limit >= Cap(0)
        let n = g.graph.len
        var level = newSeq[int](n)
        var iter = newSeq[int](n)
        var queue = newSeq[int](n)
        var requested = newSeq[Cap](n)
        var sent = newSeq[Cap](n)
        while result < limit:
            for i in 0..<n:
                level[i] = -1
                iter[i] = 0
            level[src] = 0
            queue[0] = src
            var head = 0
            var tail = 1
            block bfs:
                while head < tail:
                    let v = queue[head]
                    inc head
                    for e in g.graph[v]:
                        if e.cap > Cap(0) and level[e.dst] < 0:
                            level[e.dst] = level[v] + 1
                            if e.dst == dst:
                                break bfs
                            queue[tail] = e.dst
                            inc tail
            if level[dst] < 0:
                break
            # 終点から逆向きに探索し、各頂点で送れた流量をまとめて親へ返す。
            var depth = 0
            queue[0] = dst
            requested[0] = limit - result
            sent[0] = Cap(0)
            while depth >= 0:
                let v = queue[depth]
                if v == src:
                    sent[depth] = requested[depth]
                else:
                    while iter[v] < g.graph[v].len and sent[depth] < requested[depth]:
                        let e = g.graph[v][iter[v]]
                        if level[e.dst] >= 0 and level[e.dst] < level[v] and g.graph[e.dst][e.rev].cap > Cap(0):
                            break
                        inc iter[v]
                    if sent[depth] < requested[depth] and iter[v] < g.graph[v].len:
                        let e = g.graph[v][iter[v]]
                        requested[depth + 1] = min(requested[depth] - sent[depth], g.graph[e.dst][e.rev].cap)
                        sent[depth + 1] = Cap(0)
                        queue[depth + 1] = e.dst
                        inc depth
                        continue
                    if sent[depth] < requested[depth]:
                        level[v] = n
                let pushed = sent[depth]
                dec depth
                if depth < 0:
                    result += pushed
                    break
                let parent = queue[depth]
                let i = iter[parent]
                let rev = g.graph[parent][i].rev
                g.graph[parent][i].cap += pushed
                g.graph[v][rev].cap -= pushed
                sent[depth] += pushed
                if sent[depth] < requested[depth]:
                    inc iter[parent]

    proc min_cut*[Cap](g: MaxFlow[Cap], src: int): seq[bool] =
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
