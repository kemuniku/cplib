when not declared CPLIB_GRAPH_BICONNECTED_COMPONENTS:
    const CPLIB_GRAPH_BICONNECTED_COMPONENTS* = 1

    import cplib/graph/graph
    import sequtils

    type BiconnectedComponents* = object
        ## 二重頂点連結成分（block）。関節点は複数の groups に現れる。
        groups*: seq[seq[int]]
        articulationPoints*: seq[int]

    proc initBiconnectedComponents*(G: UnWeightedUnDirectedGraph or
                                         UnWeightedUnDirectedStaticGraph):
                                         BiconnectedComponents =
        let n = len(G)
        var ord = newSeqWith(n, -1)
        var low = newSeq[int](n)
        var timer = 0
        var edgeStack: seq[(int, int)]
        var groups: seq[seq[int]]
        var articulationPoints: seq[int]

        proc dfs(v, parent: int) =
            ord[v] = timer
            low[v] = timer
            timer += 1
            var children = 0
            var skippedParentEdge = false
            var articulation = false

            for to in G[v]:
                if to == parent and not skippedParentEdge:
                    skippedParentEdge = true
                    continue
                if ord[to] == -1:
                    children += 1
                    edgeStack.add((v, to))
                    dfs(to, v)
                    low[v] = min(low[v], low[to])
                    if ord[v] <= low[to]:
                        if parent != -1:
                            articulation = true
                        var vertices: seq[int]
                        while true:
                            let e = edgeStack.pop()
                            vertices.add(e[0])
                            vertices.add(e[1])
                            if e == (v, to):
                                break
                        vertices.sort()
                        var componentVertices: seq[int]
                        for x in vertices:
                            if componentVertices.len == 0 or componentVertices[^1] != x:
                                componentVertices.add(x)
                        groups.add(componentVertices)
                elif ord[to] < ord[v]:
                    # 無向辺を一度だけ stack に積む。
                    edgeStack.add((v, to))
                    low[v] = min(low[v], ord[to])

            if parent == -1 and children >= 2:
                articulation = true
            if articulation:
                articulationPoints.add(v)

        for s in 0 ..< n:
            if ord[s] != -1:
                continue
            let before = timer
            dfs(s, -1)
            # 辺を持たない頂点も一つの block とする。
            if timer == before + 1:
                groups.add(@[s])
        result = BiconnectedComponents(groups: groups,
                                       articulationPoints: articulationPoints)

    proc biconnectedComponents*(G: UnWeightedUnDirectedGraph or
                                    UnWeightedUnDirectedStaticGraph): seq[seq[int]] =
        ## 二重頂点連結成分の頂点列を返す。
        initBiconnectedComponents(G).groups

    proc twoVertexConnectedComponents*(G: UnWeightedUnDirectedGraph or
                                            UnWeightedUnDirectedStaticGraph):
                                            seq[seq[int]] =
        ## `biconnectedComponents` の別名。
        biconnectedComponents(G)
