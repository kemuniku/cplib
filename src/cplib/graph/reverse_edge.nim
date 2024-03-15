when not declared CPLIB_GRAPH_REVERSE_EDGE:
    const CPLIB_GRAPH_REVERSE_EDGE* = 1
    include cplib/graph/graph, std/math
    proc reverse_edge*[T](G: WeightedDirectedGraph[T]): WeightedDirectedGraph[T] =
        result = WeightedDirectedGraph[T](edges: newSeq[seq[(int, T)]](G.N), N: G.N)
        for i in 0..<G.N:
            for (j, c) in G[i]:
                result.add_edge(j, i, c)
    proc reverse_edge*(G: UnWeightedDirectedGraph): UnWeightedDirectedGraph =
        result = UnWeightedDirectedGraph(edges: newSeq[seq[(int, int)]](G.N), N: G.N)
        for i in 0..<G.N:
            for j in G[i]:
                result.add_edge(j, i)

    #FIXME: optimize for CSR graph
    proc reverse_edge*[T](G: WeightedDirectedStaticGraph[T]): WeightedDirectedStaticGraph[T] =
        result = WeightedDirectedStaticGraph[T](
            src: G.dst,
            dst: G.src,
            cost: G.cost,
            elist: newSeq[(int, T)](0),
            start: newSeq[int](0),
            N: G.N
        )
        result.build

    proc reverse_edge*(G: UnWeightedDirectedStaticGraph): UnWeightedDirectedStaticGraph =
        result = UnWeightedDirectedStaticGraph(
            src: G.dst,
            dst: G.src,
            cost: G.cost,
            elist: newSeq[(int, int)](0),
            start: newSeq[int](0),
            N: G.N
        )
        result.build
