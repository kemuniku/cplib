when not declared CPLIB_GRAPH_GRAPH:
    const CPLIB_GRAPH_GRAPH* = 1

    import sequtils, math
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

    # type DynamicGraphs* = DynamicGraph or WeightedDirectedGraph or WeightedUnDirectedGraph or UnWeightedDirectedGraph or UnWeightedUnDirectedGraph
    # type StaticGraphs* = StaticGraph or WeightedDirectedStaticGraph or WeightedUnDirectedStaticGraph or UnWeightedDirectedStaticGraph or UnWeightedUnDirectedStaticGraph
    type GraphTypes*[T] = DynamicGraph[T] or StaticGraph[T]
    type DirectedGraph* = WeightedDirectedGraph or UnWeightedDirectedGraph or WeightedDirectedStaticGraph or UnWeightedDirectedStaticGraph
    type UnDirectedGraph* = WeightedUnDirectedGraph or UnWeightedUnDirectedGraph or WeightedUnDirectedStaticGraph or UnWeightedUnDirectedStaticGraph
    type WeightedGraph*[T] = WeightedDirectedGraph[T] or WeightedUnDirectedGraph[T] or WeightedDirectedStaticGraph[T] or WeightedUnDirectedStaticGraph[T]
    type UnWeightedGraph* = UnWeightedDirectedGraph or UnWeightedUnDirectedGraph or UnWeightedDirectedStaticGraph or UnWeightedUnDirectedStaticGraph

    proc add_edge_dynamic_impl[T](g: DynamicGraph[T], u, v: int, cost: T, directed: bool) =
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

    proc len*[T](G: WeightedGraph[T]): int = G.N
    proc len*(G: UnWeightedGraph): int = G.N

    iterator `[]`*[T](g: WeightedDirectedGraph[T] or WeightedUnDirectedGraph[T], x: int): (int, T) =
        for e in g.edges[x]: yield e
    iterator `[]`*(g: UnWeightedDirectedGraph or UnWeightedUnDirectedGraph, x: int): int =
        for e in g.edges[x]: yield e[0]

    proc add_edge_static_impl[T](g: StaticGraph[T], u, v: int, cost: T, directed: bool) =
        g.src.add(u)
        g.dst.add(v)
        g.cost.add(cost)
        if not directed:
            g.src.add(v)
            g.dst.add(u)
            g.cost.add(cost)

    proc build*[T](g: WeightedDirectedStaticGraph[T] or WeightedUnDirectedStaticGraph[T]) =
        g.start = newSeqWith(g.len + 1, 0)
        for i in 0..<g.src.len:
            g.start[g.src[i]] += 1
        g.start.cumsum
        g.elist = newSeq[(int, T)](g.start[^1])
        for i in countdown(g.src.len - 1, 0):
            var u = g.src[i]
            var v = g.dst[i]
            g.start[u] -= 1
            g.elist[g.start[u]] = (v, g.cost[i])

    proc build*(g: UnWeightedDirectedStaticGraph or UnWeightedUnDirectedStaticGraph) =
        g.start = newSeqWith(g.len + 1, 0)
        for i in 0..<g.src.len:
            g.start[g.src[i]] += 1
        g.start.cumsum
        g.elist = newSeq[(int, int)](g.start[^1])
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

    proc static_graph_initialized_check*[T](g: StaticGraph[T]) = assert g.start.len > 0, "Static Graph must be initialized before use."

    iterator `[]`*[T](g: WeightedDirectedStaticGraph[T] or WeightedUnDirectedStaticGraph[T], x: int): (int, T) =
        g.static_graph_initialized_check()
        for i in g.start[x]..<g.start[x+1]: yield g.elist[i]
    iterator `[]`*(g: UnWeightedDirectedStaticGraph or UnWeightedUnDirectedStaticGraph, x: int): int =
        g.static_graph_initialized_check()
        for i in g.start[x]..<g.start[x+1]: yield g.elist[i][0]

    iterator to_and_cost*[T](g: DynamicGraph[T], x: int): (int, T) =
        for e in g.edges[x]: yield e
    iterator to_and_cost*[T](g: StaticGraph[T], x: int): (int, T) =
        g.static_graph_initialized_check()
        for i in g.start[x]..<g.start[x+1]: yield g.elist[i]
