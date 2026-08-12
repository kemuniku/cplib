when not declared CPLIB_GRAPH_TWO_EDGE_CONNECTED_COMPONENTS:
    const CPLIB_GRAPH_TWO_EDGE_CONNECTED_COMPONENTS* = 1

    import cplib/graph/graph
    import cplib/graph/lowlink
    import sequtils, sets

    type TwoEdgeConnectedComponents* = object
        ## 橋を除いて得られる二重辺連結成分と、その縮約 forest。
        component*: seq[int]       # 元の頂点 -> 成分番号
        groups*: seq[seq[int]]     # 成分番号 -> 元の頂点列
        tree*: UnWeightedUnDirectedGraph
        bridges*: seq[(int, int)]

    proc initTwoEdgeConnectedComponents*(G: UnWeightedUnDirectedGraph or
                                              UnWeightedUnDirectedStaticGraph):
                                              TwoEdgeConnectedComponents =
        let ll = initLowLink(G)
        let n = len(G)
        var bridgeSet = initHashSet[(int, int)]()
        for (u, v) in ll.bridges:
            bridgeSet.incl((min(u, v), max(u, v)))

        result.component = newSeqWith(n, -1)
        for s in 0 ..< n:
            if result.component[s] != -1:
                continue
            let cid = result.groups.len
            result.groups.add(@[])
            result.component[s] = cid
            var stack = @[s]
            while stack.len != 0:
                let v = stack.pop()
                result.groups[cid].add(v)
                for to in G[v]:
                    if (min(v, to), max(v, to)) in bridgeSet:
                        continue
                    if result.component[to] == -1:
                        result.component[to] = cid
                        stack.add(to)

        result.tree = initUnWeightedUnDirectedGraph(result.groups.len)
        result.bridges = ll.bridges
        for (u, v) in ll.bridges:
            result.tree.add_edge(result.component[u], result.component[v])

    proc twoEdgeConnectedComponents*(G: UnWeightedUnDirectedGraph or
                                          UnWeightedUnDirectedStaticGraph):
                                          seq[seq[int]] =
        ## 二重辺連結成分の頂点列を返す。
        initTwoEdgeConnectedComponents(G).groups
