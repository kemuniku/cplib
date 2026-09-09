when not declared CPLIB_GRAPH_KRUSKAL:
    const CPLIB_GRAPH_KRUSKAL* = 1
    import cplib/graph/graph
    import algorithm
    import cplib/collections/unionfind
    import cplib/utils/constants

    proc get_MST_cost_impl[T](G: WeightedUnDirectedGraph[T] or WeightedUnDirectedStaticGraph[T], ZERO, INF: T): T =
        ## 最小全域木のコストの総和を求める。
        var edges : seq[(T,int,int)]
        var uf = initUnionFind(len(G))
        for i in 0..<len(G):
            for (j,c) in G[i]:
                if i < j:
                    edges.add((c,i,j))
        edges.sort()
        result = ZERO
        for (c,i,j) in edges:
            if not uf.issame(i,j):
                result += c
                uf.unite(i,j)
        if uf.count != 1:
            return INF

    proc get_MST_cost*(G: WeightedUnDirectedGraph[int] or WeightedUnDirectedStaticGraph[int], ZERO: int = 0, INF: int = INF64): int =
        get_MST_cost_impl(G, ZERO, INF)
    proc get_MST_cost*(G: WeightedUnDirectedGraph[int32] or WeightedUnDirectedStaticGraph[int32], ZERO: int32 = 0.int32, INF: int32 = INF32): int32 =
        get_MST_cost_impl(G, ZERO, INF)
    proc get_MST_cost*(G: WeightedUnDirectedGraph[float] or WeightedUnDirectedStaticGraph[float], ZERO: float = 0.0, INF: float = 1e100): float =
        get_MST_cost_impl(G, ZERO, INF)
    proc get_MST_cost*(G: WeightedUnDirectedGraph[float32] or WeightedUnDirectedStaticGraph[float32], ZERO: float32 = 0.0'f32, INF: float32 = 1e30'f32): float32 =
        get_MST_cost_impl(G, ZERO, INF)
    proc get_MST_cost*[T](G: WeightedUnDirectedGraph[T] or WeightedUnDirectedStaticGraph[T], ZERO, INF: T): T =
        get_MST_cost_impl(G, ZERO, INF)

    proc to_MST_Graph*[T](G: WeightedUnDirectedGraph[T] or WeightedUnDirectedStaticGraph[T]): WeightedUnDirectedGraph[T] =
        ## 最小全域木を取ったときのグラフを返す
        var edges : seq[(T,int,int)]
        var uf = initUnionFind(len(G))
        for i in 0..<len(G):
            for (j,c) in G[i]:
                if i < j:
                    edges.add((c,i,j))
        edges.sort()
        result = initWeightedUnDirectedGraph(len(G), T)
        for (c,i,j) in edges:
            if not uf.issame(i,j):
                result.add_edge(i,j,c)
                uf.unite(i,j)
