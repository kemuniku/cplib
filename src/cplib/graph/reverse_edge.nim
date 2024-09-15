when not declared CPLIB_GRAPH_REVERSE_EDGE:
    const CPLIB_GRAPH_REVERSE_EDGE* = 1
    import cplib/graph/graph, std/math
    proc reverse_edge*[T](G: WeightedDirectedGraph[T]): WeightedDirectedGraph[T] =
        result = WeightedDirectedGraph[T](edges: newSeq[seq[(int32, T)]](G.len), len: G.len)
        for i in 0..<G.len:
            for (j, c) in G[i]:
                result.add_edge(j, i, c)
    proc reverse_edge*(G: UnWeightedDirectedGraph): UnWeightedDirectedGraph =
        result = UnWeightedDirectedGraph(edges: newSeq[seq[(int32, int)]](G.len), len: G.len)
        for i in 0..<G.len:
            for j in G[i]:
                result.add_edge(j, i)

    #FIXME: optimize for CSR graph
    proc reverse_edge*[T](G: WeightedDirectedStaticGraph[T]): WeightedDirectedStaticGraph[T] =
        result = WeightedDirectedStaticGraph[T](
            src: G.dst,
            dst: G.src,
            cost: G.cost,
            elist: newSeq[(int32, T)](0),
            start: newSeq[int32](0),
            len: G.len
        )
        result.build

    proc reverse_edge*(G: UnWeightedDirectedStaticGraph): UnWeightedDirectedStaticGraph =
        result = UnWeightedDirectedStaticGraph(
            src: G.dst,
            dst: G.src,
            cost: G.cost,
            elist: newSeq[(int32, int)](0),
            start: newSeq[int32](0),
            len: G.len
        )
        result.build
