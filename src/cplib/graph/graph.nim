when not declared CPLIB_GRAPH_GRAPH:
    const CPLIB_GRAPH_GRAPH* = 1

    import sequtils
    type DynamicGraph*[T] = ref object of RootObj
        edges*: seq[seq[(int, T)]]
        N*: int
    type StaticGraph*[T] = ref object of RootObj
        src*, dst*: seq[int]
        cost*: seq[T]
        elist*: seq[(int, T)]
        start*: seq[int]
        N*: int

    type WeightedDirectedGraph*[T] = ref object of DynamicGraph[T]
    type WeightedUnDirectedGraph*[T] = ref object of DynamicGraph[T]
    type UnWeightedDirectedGraph* = ref object of DynamicGraph[int]
    type UnWeightedUnDirectedGraph* = ref object of DynamicGraph[int]
    type WeightedDirectedStaticGraph*[T] = ref object of StaticGraph[T]
    type WeightedUnDirectedStaticGraph*[T] = ref object of StaticGraph[T]
    type UnWeightedDirectedStaticGraph* = ref object of StaticGraph[int]
    type UnWeightedUnDirectedStaticGraph* = ref object of StaticGraph[int]

    type DynamicGraphs*[T] = DynamicGraph[T] or WeightedDirectedGraph[T] or WeightedUnDirectedGraph[T] or UnWeightedDirectedGraph or UnWeightedUnDirectedGraph
    type StaticGraphs*[T] = StaticGraph[T] or WeightedDirectedStaticGraph[T] or WeightedUnDirectedStaticGraph[T] or UnWeightedDirectedStaticGraph or UnWeightedUnDirectedStaticGraph
    type GraphTypes*[T] = DynamicGraphs[T] or StaticGraphs[T]
    type DirectedGraph*[T] = WeightedDirectedGraph[T] or UnWeightedDirectedGraph or WeightedDirectedStaticGraph[T] or UnWeightedDirectedStaticGraph
    type UnDirectedGraph*[T] = WeightedUnDirectedGraph[T] or UnWeightedUnDirectedGraph or WeightedUnDirectedStaticGraph[T] or UnWeightedUnDirectedStaticGraph
    type WeightedGraph*[T] = WeightedDirectedGraph[T] or WeightedUnDirectedGraph[T] or WeightedDirectedStaticGraph[T] or WeightedUnDirectedStaticGraph[T]
    type UnWeightedGraph* = UnWeightedDirectedGraph or UnWeightedUnDirectedGraph or UnWeightedDirectedStaticGraph or UnWeightedUnDirectedStaticGraph

    proc add_edge_dynamic_impl[T](g: DynamicGraphs, u, v: int, cost: T, directed: bool) =
        g.edges[u].add((v, cost))
        if not directed: g.edges[v].add((u, cost))

    proc initWeightedDirectedGraph*(N: int, edgetype: typedesc = int): WeightedDirectedGraph[edgetype] =
        result = WeightedDirectedGraph[edgetype](edges: newSeq[seq[(int, edgetype)]](N), N: N)
    proc add_edge*[T](g: var WeightedDirectedGraph[T], u, v: int, cost: T) =
        g.add_edge_dynamic_impl(u, v, cost, true)

    proc initWeightedUnDirectedGraph*(N: int, edgetype: typedesc = int): WeightedUnDirectedGraph[edgetype] =
        result = WeightedUnDirectedGraph[edgetype](edges: newSeq[seq[(int, edgetype)]](N), N: N)
    proc add_edge*[T](g: var WeightedUnDirectedGraph[T], u, v: int, cost: T) =
        g.add_edge_dynamic_impl(u, v, cost, false)

    proc initUnWeightedDirectedGraph*(N: int): UnWeightedDirectedGraph =
        result = UnWeightedDirectedGraph(edges: newSeq[seq[(int, int)]](N), N: N)
    proc add_edge*(g: var UnWeightedDirectedGraph, u, v: int) =
        g.add_edge_dynamic_impl(u, v, 1, true)

    proc initUnWeightedUnDirectedGraph*(N: int): UnWeightedUnDirectedGraph =
        result = UnWeightedUnDirectedGraph(edges: newSeq[seq[(int, int)]](N), N: N)
    proc add_edge*(g: var UnWeightedUnDirectedGraph, u, v: int) =
        g.add_edge_dynamic_impl(u, v, 1, false)

    proc len*(G: GraphTypes): int = G.N

    iterator `[]`*[T](g: WeightedDirectedGraph[T] or WeightedUnDirectedGraph[T], x: int): (int, T) =
        for e in g.edges[x]: yield e
    iterator `[]`*(g: UnWeightedDirectedGraph or UnWeightedUnDirectedGraph, x: int): seq[int] =
        for e in g.edges[x]: yield e[0]

    proc add_edge_static_impl[T](g: StaticGraphs, u, v: int, cost: T, directed: bool) =
        g.src.add(u)
        g.dst.add(v)
        g.cost.add(cost)
        if not directed:
            g.src.add(u)
            g.dst.add(v)
            g.cost.add(cost)
    proc build*[T](g: var StaticGraphs[T]) =
        g.start = newSeqWith(g.N+1, 0)
        for i in 0..<g.src.len:
            g.start[g.src[i]] += 1
        g.start.cumsum
        g.elist = newSeq[(int, T)](g.start[^1])
        for i in countdown(g.src.len - 1, 0):
            var u = g.src[i]
            var v = g.dst[i]
            g.start[u] -= 1
            g.elist[g.start[u]] = (v, g.cost[i])

    proc initWeightedDirectedStaticGraph*(N: int, edgetype: typedesc = int, capacity: int = 0): WeightedDirectedStaticGraph[edgetype] =
        result = WeightedDirectedStaticGraph[edgetype](
            src: newSeqOfCap[int](capacity),
            dst: newSeqOfCap[int](capacity),
            cost: newSeqOfCap[edgetype](capacity),
            elist: newSeq[(int, edgetype)](0),
            start: newSeq[int](0),
            N: N
        )
    proc add_edge*[T](g: var WeightedDirectedStaticGraph[T], u, v: int, cost: T) =
        g.add_edge_static_impl(u, v, cost, true)

    proc initWeightedUnDirectedStaticGraph*(N: int, edgetype: typedesc = int, capacity: int = 0): WeightedUnDirectedStaticGraph[edgetype] =
        result = WeightedUnDirectedStaticGraph[edgetype](
            src: newSeqOfCap[int](capacity*2),
            dst: newSeqOfCap[int](capacity*2),
            cost: newSeqOfCap[edgetype](capacity*2),
            elist: newSeq[(int, edgetype)](0),
            start: newSeq[int](0),
            N: N
        )
    proc add_edge*[T](g: var WeightedUnDirectedStaticGraph[T], u, v: int, cost: T) =
        g.add_edge_static_impl(u, v, cost, false)

    proc initUnWeightedDirectedStaticGraph*(N: int, capacity: int = 0): UnWeightedDirectedStaticGraph =
        result = UnWeightedDirectedStaticGraph(
            src: newSeqOfCap[int](capacity),
            dst: newSeqOfCap[int](capacity),
            cost: newSeqOfCap[int](capacity),
            elist: newSeq[(int, int)](0),
            start: newSeq[int](0),
            N: N
        )
    proc add_edge*(g: var UnWeightedDirectedStaticGraph, u, v: int) =
        g.add_edge_static_impl(u, v, 1, true)

    proc initUnWeightedUnDirectedStaticGraph*(N: int, capacity: int = 0): UnWeightedUnDirectedStaticGraph =
        result = UnWeightedUnDirectedStaticGraph(
            src: newSeqOfCap[int](capacity*2),
            dst: newSeqOfCap[int](capacity*2),
            cost: newSeqOfCap[int](capacity*2),
            elist: newSeq[(int, int)](0),
            start: newSeq[int](0),
            N: N
        )
    proc add_edge*(g: var UnWeightedUnDirectedStaticGraph, u, v: int) =
        g.add_edge_static_impl(u, v, 1, false)

    iterator `[]`*[T](g: WeightedDirectedStaticGraph[T] or WeightedUnDirectedStaticGraph[T], x: int): (int, T) =
        for i in g.start[x]..<g.start[x+1]: yield g.elist[i]
    iterator `[]`*(g: UnWeightedDirectedStaticGraph or UnWeightedUnDirectedStaticGraph, x: int): int =
        for i in g.start[x]..<g.start[x+1]: yield g.elist[i][0]
