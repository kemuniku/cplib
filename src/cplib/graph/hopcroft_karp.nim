when not declared CPLIB_GRAPH_HOPCROFT_KARP:
    const CPLIB_GRAPH_HOPCROFT_KARP* = 1
    import cplib/graph/graph

    type HopcroftKarp* = object
        edges: seq[tuple[left, right: int]]
        leftOffset, rightOffset, leftEdges, rightEdges: seq[int]
        leftMatch, rightMatch: seq[int]
        size: int
        built: bool

    proc initHopcroftKarp*(left, right: int): HopcroftKarp =
        ## 左側left頂点、右側right頂点の二部グラフを構築する。O(left+right)。
        assert left >= 0 and right >= 0, "左右の頂点数は非負である必要があります"
        result.leftMatch = newSeq[int](left)
        result.rightMatch = newSeq[int](right)
        for i in 0..<left:
            result.leftMatch[i] = -1
        for i in 0..<right:
            result.rightMatch[i] = -1

    proc add_edge*(g: var HopcroftKarp, left, right: int) =
        ## 左右それぞれ0始まりの頂点間に辺を追加する。多重辺も可。償却O(1)。
        assert left in 0..<g.leftMatch.len and right in 0..<g.rightMatch.len, "頂点番号が範囲外です"
        g.edges.add((left, right))
        g.built = false

    proc build(g: var HopcroftKarp) =
        ## 左右両方向の隣接辺をCSR形式にまとめる。辺追加後の初回のみO(V+E)。
        if g.built:
            return
        let left = g.leftMatch.len
        let right = g.rightMatch.len
        let m = g.edges.len
        g.leftOffset = newSeq[int](left + 1)
        g.rightOffset = newSeq[int](right + 1)
        for (v, u) in g.edges:
            inc g.leftOffset[v]
            inc g.rightOffset[u]
        for v in 1..<left:
            g.leftOffset[v] += g.leftOffset[v - 1]
        for u in 1..<right:
            g.rightOffset[u] += g.rightOffset[u - 1]
        g.leftOffset[left] = m
        g.rightOffset[right] = m
        g.leftEdges = newSeq[int](m)
        g.rightEdges = newSeq[int](m)
        for (v, u) in g.edges:
            dec g.leftOffset[v]
            dec g.rightOffset[u]
            g.leftEdges[g.leftOffset[v]] = u
            g.rightEdges[g.rightOffset[u]] = v
        g.built = true

    proc matching*(g: var HopcroftKarp, useRelabel: bool = true): int {.discardable.} =
        ## 最大マッチングの総サイズを返す。既定ではGlobal relabel前処理付き。再実行可。O((V+E)√V)、領域O(V+E)。
        let n = g.leftMatch.len
        let right = g.rightMatch.len
        let limit = min(n, right)
        if g.size == limit:
            return g.size
        g.build()
        var dist = newSeq[int](n)
        var queue = newSeq[int](n)
        if useRelabel:
            var active = newSeq[int](right)
            var head = 0
            var tail = 0
            var count = 0
            for u in 0..<right:
                if g.rightMatch[u] < 0 and g.rightOffset[u] < g.rightOffset[u + 1]:
                    active[tail] = u
                    inc tail
                    inc count
            if tail == right:
                tail = 0
            let period = n + right
            let workLimit = 16 * (n + right + g.edges.len)
            var work = 0
            var steps = 0
            while count > 0 and g.size < limit and work < workLimit:
                if steps == 0:
                    # 未マッチの左頂点から交互道の距離を計算する。マッチした辺の組を1段と数える。
                    var first = 0
                    var last = 0
                    for v in 0..<n:
                        if g.leftMatch[v] < 0:
                            dist[v] = 0
                            queue[last] = v
                            inc last
                        else:
                            dist[v] = n
                    work += n
                    while first < last:
                        let v = queue[first]
                        inc first
                        for i in g.leftOffset[v]..<g.leftOffset[v + 1]:
                            let w = g.rightMatch[g.leftEdges[i]]
                            if w >= 0 and dist[w] == n:
                                dist[w] = dist[v] + 1
                                queue[last] = w
                                inc last
                        work += g.leftOffset[v + 1] - g.leftOffset[v]
                    steps = period
                    if work >= workLimit:
                        break
                let u = active[head]
                inc head
                if head == right:
                    head = 0
                dec count
                dec steps
                var best = -1
                var bestHeight = n
                for i in g.rightOffset[u]..<g.rightOffset[u + 1]:
                    inc work
                    let v = g.rightEdges[i]
                    if dist[v] < bestHeight:
                        best = v
                        bestHeight = dist[v]
                        if bestHeight == 0:
                            break
                if best < 0:
                    continue
                let previous = g.leftMatch[best]
                if previous < 0:
                    inc g.size
                else:
                    g.rightMatch[previous] = -1
                    active[tail] = previous
                    inc tail
                    if tail == right:
                        tail = 0
                    inc count
                g.leftMatch[best] = u
                g.rightMatch[u] = best
                dist[best] = bestHeight + 1
            if g.size == limit:
                return g.size
        else:
            for v in 0..<n:
                if g.leftMatch[v] < 0:
                    for i in g.leftOffset[v]..<g.leftOffset[v + 1]:
                        let u = g.leftEdges[i]
                        if g.rightMatch[u] < 0:
                            g.leftMatch[v] = u
                            g.rightMatch[u] = v
                            inc g.size
                            break

        # 前処理が走査量の上限に達した場合も、最短増加路を処理するHK法で完了させる。
        var iter = newSeq[int](n)
        var freeLeft = newSeqOfCap[int](n - g.size)
        for v in 0..<n:
            if g.leftMatch[v] < 0 and g.leftOffset[v] < g.leftOffset[v + 1]:
                freeLeft.add(v)
        while g.size < limit:
            var head = 0
            var tail = 0
            for v in 0..<n:
                iter[v] = g.leftOffset[v]
                dist[v] = -1
            for v in freeLeft:
                dist[v] = 0
                queue[tail] = v
                inc tail
            var shortest = n
            while head < tail:
                let v = queue[head]
                inc head
                if dist[v] >= shortest:
                    break
                for i in g.leftOffset[v]..<g.leftOffset[v + 1]:
                    let u = g.leftEdges[i]
                    let w = g.rightMatch[u]
                    if w < 0:
                        shortest = dist[v]
                    elif dist[w] < 0 and dist[v] < shortest:
                        dist[w] = dist[v] + 1
                        queue[tail] = w
                        inc tail
            if shortest == n:
                break

            # BFSのキューをDFSの経路スタックとして再利用する。
            for root in freeLeft:
                if g.leftMatch[root] >= 0 or dist[root] != 0:
                    continue
                var depth = 0
                queue[0] = root
                while depth >= 0:
                    let v = queue[depth]
                    var descended = false
                    var endpoint = -1
                    while iter[v] < g.leftOffset[v + 1]:
                        let u = g.leftEdges[iter[v]]
                        inc iter[v]
                        let w = g.rightMatch[u]
                        if w < 0:
                            if dist[v] == shortest:
                                endpoint = u
                                break
                        elif dist[v] < shortest and dist[w] == dist[v] + 1:
                            inc depth
                            queue[depth] = w
                            descended = true
                            break
                    if endpoint >= 0:
                        while depth >= 0:
                            let x = queue[depth]
                            let previous = g.leftMatch[x]
                            g.leftMatch[x] = endpoint
                            g.rightMatch[endpoint] = x
                            endpoint = previous
                            dist[x] = -1
                            dec depth
                        inc g.size
                        break
                    if not descended:
                        dist[v] = -1
                        dec depth
            var remaining = 0
            for v in freeLeft:
                if g.leftMatch[v] < 0:
                    freeLeft[remaining] = v
                    inc remaining
            freeLeft.setLen(remaining)
        return g.size

    proc get_matching*(g: HopcroftKarp): seq[tuple[left, right: int]] =
        ## 現在のマッチングの辺を左頂点順で返す。最大化には先にmatchingを呼ぶ。O(left)。
        result = newSeqOfCap[tuple[left, right: int]](g.size)
        for left, right in g.leftMatch:
            if right >= 0:
                result.add((left, right))

    proc minimum_vertex_cover*(g: var HopcroftKarp): int =
        ## 最大マッチングを計算し、最小点被覆の大きさを返す。O((V+E)√V)。
        g.matching()

    proc maximum_independent_set*(g: var HopcroftKarp): int =
        ## 最大マッチングを計算し、最大安定集合の大きさを返す。O((V+E)√V)。
        g.leftMatch.len + g.rightMatch.len - g.matching()

    proc alternatingReachable(g: var HopcroftKarp): tuple[left, right: seq[bool]] =
        ## 最大化後、未マッチの左頂点から交互道で到達できる頂点を求める。最大化の計算量に加えてO(V+E)。
        g.matching()
        g.build()
        result.left = newSeq[bool](g.leftMatch.len)
        result.right = newSeq[bool](g.rightMatch.len)
        var queue = newSeqOfCap[int](g.leftMatch.len)
        for v in 0..<g.leftMatch.len:
            if g.leftMatch[v] < 0:
                result.left[v] = true
                queue.add(v)
        var head = 0
        while head < queue.len:
            let v = queue[head]
            inc head
            for i in g.leftOffset[v]..<g.leftOffset[v + 1]:
                let u = g.leftEdges[i]
                if u == g.leftMatch[v] or result.right[u]:
                    continue
                result.right[u] = true
                let w = g.rightMatch[u]
                if w >= 0 and not result.left[w]:
                    result.left[w] = true
                    queue.add(w)

    proc get_minimum_vertex_cover*(g: var HopcroftKarp): tuple[left, right: seq[int]] =
        ## 最小点被覆を左右それぞれの頂点番号で昇順に返す。matchingの事前呼び出し不要。O((V+E)√V)。
        let reachable = g.alternatingReachable()
        for v in 0..<g.leftMatch.len:
            if not reachable.left[v]: result.left.add(v)
        for u in 0..<g.rightMatch.len:
            if reachable.right[u]: result.right.add(u)

    proc get_maximum_independent_set*(g: var HopcroftKarp): tuple[left, right: seq[int]] =
        ## 最大安定集合を左右それぞれの頂点番号で昇順に返す。matchingの事前呼び出し不要。O((V+E)√V)。
        let reachable = g.alternatingReachable()
        for v in 0..<g.leftMatch.len:
            if reachable.left[v]: result.left.add(v)
        for u in 0..<g.rightMatch.len:
            if not reachable.right[u]: result.right.add(u)

    proc minimum_edge_cover*(g: var HopcroftKarp): int =
        ## 最小辺被覆の大きさを返す。孤立点があれば-1、空グラフは0。O((V+E)√V)。
        g.build()
        for v in 0..<g.leftMatch.len:
            if g.leftOffset[v] == g.leftOffset[v + 1]: return -1
        for u in 0..<g.rightMatch.len:
            if g.rightOffset[u] == g.rightOffset[u + 1]: return -1
        g.leftMatch.len + g.rightMatch.len - g.matching()

    proc get_minimum_edge_cover*(g: var HopcroftKarp): seq[tuple[left, right: int]] =
        ## 最小辺被覆を構築する。孤立点があればValueError。matchingの事前呼び出し不要。O((V+E)√V)。
        let size = g.minimum_edge_cover()
        if size < 0:
            raise newException(ValueError, "孤立点があるため辺被覆は存在しません")
        result = g.get_matching()
        for v in 0..<g.leftMatch.len:
            if g.leftMatch[v] < 0:
                result.add((v, g.leftEdges[g.leftOffset[v]]))
        for u in 0..<g.rightMatch.len:
            if g.rightMatch[u] < 0:
                result.add((g.rightEdges[g.rightOffset[u]], u))

    proc prepareHopcroftKarp(g: UnDirectedGraph): tuple[matcher: HopcroftKarp, left, right: seq[int]] =
        ## 無向グラフを二部に分け、対応表とマッチング用グラフを構築する。非二部ならValueError。O(V+E)。
        when g is StaticGraphTypes:
            g.static_graph_initialized_check()
        var color = newSeq[int](g.len)
        var index = newSeq[int](g.len)
        var queue = newSeqOfCap[int](g.len)
        for root in 0..<g.len:
            if color[root] != 0: continue
            color[root] = 1
            queue.setLen(0)
            queue.add(root)
            var head = 0
            while head < queue.len:
                let v = queue[head]
                inc head
                for (u, _) in g.to_and_id(v):
                    if color[u] == 0:
                        color[u] = -color[v]
                        queue.add(u)
                    elif color[u] == color[v]:
                        raise newException(ValueError, "入力グラフは二部グラフである必要があります")
        for v in 0..<g.len:
            if color[v] == 1:
                index[v] = result.left.len
                result.left.add(v)
            else:
                index[v] = result.right.len
                result.right.add(v)
        result.matcher = initHopcroftKarp(result.left.len, result.right.len)
        for e in g.edge_info:
            if color[e.src] == 1:
                result.matcher.add_edge(index[e.src], index[e.dst])
            else:
                result.matcher.add_edge(index[e.dst], index[e.src])

    # グラフ型版は無向二部グラフ専用。重みは無視し、StaticGraphは事前にbuildする。
    # 各呼び出しで二部判定と最大化を行い、非二部グラフにはValueErrorを送出する。
    proc matching*(g: UnDirectedGraph, useRelabel: bool = true): int =
        ## 無向二部グラフの最大マッチングの大きさを返す。O((V+E)√V)。
        var prepared = g.prepareHopcroftKarp()
        prepared.matcher.matching(useRelabel)

    proc get_matching*(g: UnDirectedGraph, useRelabel: bool = true): seq[tuple[left, right: int]] =
        ## 最大マッチングを構築し、元の頂点番号の辺で返す。matchingの事前呼び出し不要。O((V+E)√V)。
        var prepared = g.prepareHopcroftKarp()
        prepared.matcher.matching(useRelabel)
        for (v, u) in prepared.matcher.get_matching():
            result.add((prepared.left[v], prepared.right[u]))

    proc minimum_vertex_cover*(g: UnDirectedGraph): int =
        ## 無向二部グラフの最小点被覆の大きさを返す。O((V+E)√V)。
        g.matching()

    proc maximum_independent_set*(g: UnDirectedGraph): int =
        ## 無向二部グラフの最大安定集合の大きさを返す。O((V+E)√V)。
        g.len - g.matching()

    proc get_minimum_vertex_cover*(g: UnDirectedGraph): seq[int] =
        ## 最小点被覆を構築し、元の頂点番号の列で返す。O((V+E)√V)。
        var prepared = g.prepareHopcroftKarp()
        let cover = prepared.matcher.get_minimum_vertex_cover()
        for v in cover.left: result.add(prepared.left[v])
        for u in cover.right: result.add(prepared.right[u])

    proc get_maximum_independent_set*(g: UnDirectedGraph): seq[int] =
        ## 最大安定集合を構築し、元の頂点番号の列で返す。O((V+E)√V)。
        var prepared = g.prepareHopcroftKarp()
        let independent = prepared.matcher.get_maximum_independent_set()
        for v in independent.left: result.add(prepared.left[v])
        for u in independent.right: result.add(prepared.right[u])

    proc minimum_edge_cover*(g: UnDirectedGraph): int =
        ## 無向二部グラフの最小辺被覆の大きさを返す。孤立点があれば-1、空グラフは0。O((V+E)√V)。
        var prepared = g.prepareHopcroftKarp()
        prepared.matcher.minimum_edge_cover()

    proc get_minimum_edge_cover*(g: UnDirectedGraph): seq[tuple[left, right: int]] =
        ## 最小辺被覆を元の頂点番号の辺で返す。孤立点があればValueError。O((V+E)√V)。
        var prepared = g.prepareHopcroftKarp()
        for (v, u) in prepared.matcher.get_minimum_edge_cover():
            result.add((prepared.left[v], prepared.right[u]))
