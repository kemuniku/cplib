when not declared CPLIB_GRAPH_TWO_EDGE_CONNECTED_COMPONENTS:
    const CPLIB_GRAPH_TWO_EDGE_CONNECTED_COMPONENTS* = 1
    import cplib/graph/graph
    import cplib/graph/lowlink

    type TwoEdgeConnectedComponents* = object
        groups*: seq[seq[int]]
        component*: seq[int]
        forest*: UnWeightedUnDirectedGraph

    proc initTwoEdgeConnectedComponents*(ll: LowLink): TwoEdgeConnectedComponents =
        ## 計算済みlowlinkから二重辺連結成分と橋で結ばれた縮約森をO(V)で構築します。
        result.component = newSeq[int](ll.ord.len)
        for v in ll.preorder:
            let p = ll.parent[v]
            if p == -1 or ll.low[v] > ll.ord[p]:
                result.component[v] = result.groups.len
                result.groups.add(@[v])
            else:
                result.component[v] = result.component[p]
                result.groups[result.component[v]].add(v)
        result.forest = initUnWeightedUnDirectedGraph(result.groups.len)
        for (u, v) in ll.bridges:
            result.forest.add_edge(result.component[u], result.component[v])

    proc initTwoEdgeConnectedComponents*(g: UnDirectedGraph): TwoEdgeConnectedComponents =
        ## 無向グラフをO(V+E)時間・領域で二重辺連結成分に分解します。
        result = initTwoEdgeConnectedComponents(initLowLink(g))
