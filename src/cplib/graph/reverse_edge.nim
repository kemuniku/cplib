when not declared CPLIB_GRAPH_REVERSE_EDGE:
    const CPLIB_GRAPH_REVERSE_EDGE* = 1
    import cplib/graph/graph

    proc reverse_edge*[T](g: WeightedDirectedGraph[T]): WeightedDirectedGraph[T] =
        ## 辺番号を維持して全辺の向きを反転する。O(V + E)。
        result = initWeightedDirectedGraph(g.len, T)
        for e in g.edge_info:
            result.add_edge(e.dst, e.src, e.cost)

    proc reverse_edge*(g: UnWeightedDirectedGraph): UnWeightedDirectedGraph =
        ## 辺番号を維持して全辺の向きを反転する。O(V + E)。
        result = initUnWeightedDirectedGraph(g.len)
        for e in g.edge_info:
            result.add_edge(e.dst, e.src)

    proc reverse_edge*[T](g: WeightedDirectedStaticGraph[T]): WeightedDirectedStaticGraph[T] =
        ## 辺番号を維持して全辺の向きを反転する。O(V + E)。
        result = initWeightedDirectedStaticGraph(g.len, T)
        for e in g.edge_info:
            result.add_edge(e.dst, e.src, e.cost)
        result.build()

    proc reverse_edge*(g: UnWeightedDirectedStaticGraph): UnWeightedDirectedStaticGraph =
        ## 辺番号を維持して全辺の向きを反転する。O(V + E)。
        result = initUnWeightedDirectedStaticGraph(g.len)
        for e in g.edge_info:
            result.add_edge(e.dst, e.src)
        result.build()
