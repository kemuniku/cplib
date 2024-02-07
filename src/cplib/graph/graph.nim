when not declared CPLIB_GRAPH_GRAPH:
    const CPLIB_GRAPH_GRAPH* = 1

    import sequtils
    type Graph*[T] = ref object of RootObj
        edges*: seq[seq[(int, T)]]
        N*: int

    type WeightedDirectedGraph*[T] = ref object of Graph[T]
    type WeightedUnDirectedGraph*[T] = ref object of Graph[T]
    type UnWeightedDirectedGraph* = ref object of Graph[int]
    type UnWeightedUnDirectedGraph* = ref object of Graph[int]

    type GraphTypes* = Graph or WeightedDirectedGraph or WeightedUnDirectedGraph or UnWeightedDirectedGraph or UnWeightedUnDirectedGraph
    type DirectedGraph* = WeightedDirectedGraph or UnWeightedDirectedGraph
    type UnDirectedGraph* = WeightedUnDirectedGraph or UnWeightedUnDirectedGraph
    type WeightedGraph*[T] = WeightedDirectedGraph[T] or WeightedUnDirectedGraph[T]
    type UnWeightedGraph* = UnWeightedDirectedGraph or UnWeightedUnDirectedGraph
    proc add_edge_impl[T](g: GraphTypes, u, v: int, cost: T, directed: bool) =
        g.edges[u].add((v, cost))
        if not directed: g.edges[v].add((u, cost))

    #WeightedDirectedGraph
    proc initWeightedDirectedGraph*(N: int, edgetype: typedesc = int): WeightedDirectedGraph[edgetype] =
        result = WeightedDirectedGraph[edgetype](edges: newSeq[seq[(int, edgetype)]](N), N: N)
    proc add_edge*[T](g: var WeightedDirectedGraph[T], u, v: int, cost: T) =
        g.add_edge_impl(u, v, cost, true)

    #WeightedUnDirectedGraph
    proc initWeightedUnDirectedGraph*(N: int, edgetype: typedesc = int): WeightedUnDirectedGraph[edgetype] =
        result = WeightedUnDirectedGraph[edgetype](edges: newSeq[seq[(int, edgetype)]](N), N: N)
    proc add_edge*[T](g: var WeightedUnDirectedGraph[T], u, v: int, cost: T) =
        g.add_edge_impl(u, v, cost, false)

    #UnWeightedDirectedGraph
    proc initUnWeightedDirectedGraph*(N: int): UnWeightedDirectedGraph =
        result = UnWeightedDirectedGraph(edges: newSeq[seq[(int, int)]](N), N: N)
    proc add_edge*(g: var UnWeightedDirectedGraph, u, v: int) =
        g.add_edge_impl(u, v, 1, true)

    #UnWeightedUnDirectedGraph
    proc initUnWeightedUnDirectedGraph*(N: int): UnWeightedUnDirectedGraph =
        result = UnWeightedUnDirectedGraph(edges: newSeq[seq[(int, int)]](N), N: N)
    proc add_edge*(g: var UnWeightedUnDirectedGraph, u, v: int) =
        g.add_edge_impl(u, v, 1, false)


    proc len*(G: GraphTypes): int = G.N

    proc `[]`*[T](g: WeightedGraph[T], x: int): seq[(int, T)] = return g.edges[x]
    proc `[]`*(g: UnWeightedGraph, x: int): seq[int] = return g.edges[x].mapIt(it[0])
