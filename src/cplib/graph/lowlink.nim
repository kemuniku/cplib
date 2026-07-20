when not declared CPLIB_GRAPH_LOWLINK:
    const CPLIB_GRAPH_LOWLINK* = 1

    import cplib/graph/graph
    import sequtils

    type LowLink* = object
        ## 無向グラフの LowLink。
        ## bridge の端点は DFS 木で親だった頂点、子だった頂点の順で入る。
        ord*, low*: seq[int]
        bridges*: seq[(int, int)]
        articulationPoints*: seq[int]

    proc initLowLink*(G: UnWeightedUnDirectedGraph or
                           UnWeightedUnDirectedStaticGraph): LowLink =
        let n = len(G)
        var ord = newSeqWith(n, -1)
        var low = newSeq[int](n)
        var bridges: seq[(int, int)]
        var articulationPoints: seq[int]
        var timer = 0

        proc dfs(v, parent: int) =
            ord[v] = timer
            low[v] = timer
            timer += 1
            var children = 0
            var skippedParentEdge = false
            var articulation = false

            for to in G[v]:
                # 親との多重辺を考慮し、木辺そのものだけを一度無視する。
                if to == parent and not skippedParentEdge:
                    skippedParentEdge = true
                    continue
                if ord[to] == -1:
                    children += 1
                    dfs(to, v)
                    low[v] = min(low[v], low[to])
                    if ord[v] < low[to]:
                        bridges.add((v, to))
                    if parent != -1 and ord[v] <= low[to]:
                        articulation = true
                else:
                    low[v] = min(low[v], ord[to])

            if parent == -1 and children >= 2:
                articulation = true
            if articulation:
                articulationPoints.add(v)

        for v in 0 ..< n:
            if ord[v] == -1:
                dfs(v, -1)
        result = LowLink(ord: ord, low: low, bridges: bridges,
                         articulationPoints: articulationPoints)

    proc lowLink*(G: UnWeightedUnDirectedGraph or
                       UnWeightedUnDirectedStaticGraph): LowLink =
        ## `initLowLink` の別名。
        initLowLink(G)
