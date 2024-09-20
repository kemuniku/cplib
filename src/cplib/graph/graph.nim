when not declared CPLIB_GRAPH_GRAPH:
    const CPLIB_GRAPH_GRAPH* = 1

    import sequtils, math
    type DynamicGraph*[T] = ref object of RootObj
        edges*: seq[seq[(int32, T)]]
        len*: int
    type StaticGraph*[T] = ref object of RootObj
        src*, dst*: seq[int32]
        cost*: seq[T]
        elist*: seq[(int32, T)]
        start*: seq[int32]
        len*: int

    type WeightedDirectedGraph*[T] = ref object of DynamicGraph[T]
    type WeightedUnDirectedGraph*[T] = ref object of DynamicGraph[T]
    type UnWeightedDirectedGraph* = ref object of DynamicGraph[int]
    type UnWeightedUnDirectedGraph* = ref object of DynamicGraph[int]
    type WeightedDirectedStaticGraph*[T] = ref object of StaticGraph[T]
    type WeightedUnDirectedStaticGraph*[T] = ref object of StaticGraph[T]
    type UnWeightedDirectedStaticGraph* = ref object of StaticGraph[int]
    type UnWeightedUnDirectedStaticGraph* = ref object of StaticGraph[int]

    type GraphTypes*[T] = DynamicGraph[T] or StaticGraph[T]
    type DirectedGraph* = WeightedDirectedGraph or UnWeightedDirectedGraph or WeightedDirectedStaticGraph or UnWeightedDirectedStaticGraph
    type UnDirectedGraph* = WeightedUnDirectedGraph or UnWeightedUnDirectedGraph or WeightedUnDirectedStaticGraph or UnWeightedUnDirectedStaticGraph
    type WeightedGraph*[T] = WeightedDirectedGraph[T] or WeightedUnDirectedGraph[T] or WeightedDirectedStaticGraph[T] or WeightedUnDirectedStaticGraph[T]
    type UnWeightedGraph* = UnWeightedDirectedGraph or UnWeightedUnDirectedGraph or UnWeightedDirectedStaticGraph or UnWeightedUnDirectedStaticGraph
    type DynamicGraphTypes* = WeightedDirectedGraph or UnWeightedDirectedGraph or WeightedUnDirectedGraph or UnWeightedUnDirectedGraph
    type StaticGraphTypes* = WeightedDirectedStaticGraph or UnWeightedDirectedStaticGraph or WeightedUnDirectedStaticGraph or UnWeightedUnDirectedStaticGraph

    proc add_edge_dynamic_impl*[T](g: DynamicGraph[T], u, v: int, cost: T, directed: bool) =
        g.edges[u].add((v.int32, cost))
        if not directed: g.edges[v].add((u.int32, cost))

    proc initWeightedDirectedGraph*(N: int, edgetype: typedesc = int): WeightedDirectedGraph[edgetype] =
        result = WeightedDirectedGraph[edgetype](edges: newSeq[seq[(int32, edgetype)]](N), len: N)
    proc add_edge*[T](g: var WeightedDirectedGraph[T], u, v: int, cost: T) =
        g.add_edge_dynamic_impl(u, v, cost, true)

    proc initWeightedUnDirectedGraph*(N: int, edgetype: typedesc = int): WeightedUnDirectedGraph[edgetype] =
        result = WeightedUnDirectedGraph[edgetype](edges: newSeq[seq[(int32, edgetype)]](N), len: N)
    proc add_edge*[T](g: var WeightedUnDirectedGraph[T], u, v: int, cost: T) =
        g.add_edge_dynamic_impl(u, v, cost, false)

    proc initUnWeightedDirectedGraph*(N: int): UnWeightedDirectedGraph =
        result = UnWeightedDirectedGraph(edges: newSeq[seq[(int32, int)]](N), len: N)
    proc add_edge*(g: var UnWeightedDirectedGraph, u, v: int) =
        g.add_edge_dynamic_impl(u, v, 1, true)

    proc initUnWeightedUnDirectedGraph*(N: int): UnWeightedUnDirectedGraph =
        result = UnWeightedUnDirectedGraph(edges: newSeq[seq[(int32, int)]](N), len: N)
    proc add_edge*(g: var UnWeightedUnDirectedGraph, u, v: int) =
        g.add_edge_dynamic_impl(u, v, 1, false)

    proc len*[T](G: WeightedGraph[T]): int = G.len
    proc len*(G: UnWeightedGraph): int = G.len

    iterator `[]`*[T](g: WeightedDirectedGraph[T] or WeightedUnDirectedGraph[T], x: int): (int, T) =
        for e in g.edges[x]: yield (e[0].int, e[1])
    iterator `[]`*(g: UnWeightedDirectedGraph or UnWeightedUnDirectedGraph, x: int): int =
        for e in g.edges[x]: yield e[0].int

    proc add_edge_static_impl*[T](g: StaticGraph[T], u, v: int, cost: T, directed: bool) =
        g.src.add(u.int32)
        g.dst.add(v.int32)
        g.cost.add(cost)
        if not directed:
            g.src.add(v.int32)
            g.dst.add(u.int32)
            g.cost.add(cost)

    proc build_impl*[T](g: StaticGraph[T]) =
        g.start = newSeqWith(g.len + 1, 0.int32)
        for i in 0..<g.src.len:
            g.start[g.src[i]] += 1
        g.start.cumsum
        g.elist = newSeq[(int32, T)](g.start[^1])
        for i in countdown(g.src.len - 1, 0):
            var u = g.src[i]
            var v = g.dst[i]
            g.start[u] -= 1
            g.elist[g.start[u]] = (v, g.cost[i])
    proc build*(g: StaticGraphTypes) = g.build_impl()

    proc initWeightedDirectedStaticGraph*(N: int, edgetype: typedesc = int, capacity: int = 0): WeightedDirectedStaticGraph[edgetype] =
        result = WeightedDirectedStaticGraph[edgetype](
            src: newSeqOfCap[int32](capacity),
            dst: newSeqOfCap[int32](capacity),
            cost: newSeqOfCap[edgetype](capacity),
            elist: newSeq[(int32, edgetype)](0),
            start: newSeq[int32](0),
            len: N
        )
    proc add_edge*[T](g: var WeightedDirectedStaticGraph[T], u, v: int, cost: T) =
        g.add_edge_static_impl(u, v, cost, true)

    proc initWeightedUnDirectedStaticGraph*(N: int, edgetype: typedesc = int, capacity: int = 0): WeightedUnDirectedStaticGraph[edgetype] =
        result = WeightedUnDirectedStaticGraph[edgetype](
            src: newSeqOfCap[int32](capacity*2),
            dst: newSeqOfCap[int32](capacity*2),
            cost: newSeqOfCap[edgetype](capacity*2),
            elist: newSeq[(int32, edgetype)](0),
            start: newSeq[int32](0),
            len: N
        )
    proc add_edge*[T](g: var WeightedUnDirectedStaticGraph[T], u, v: int, cost: T) =
        g.add_edge_static_impl(u, v, cost, false)

    proc initUnWeightedDirectedStaticGraph*(N: int, capacity: int = 0): UnWeightedDirectedStaticGraph =
        result = UnWeightedDirectedStaticGraph(
            src: newSeqOfCap[int32](capacity),
            dst: newSeqOfCap[int32](capacity),
            cost: newSeqOfCap[int](capacity),
            elist: newSeq[(int32, int)](0),
            start: newSeq[int32](0),
            len: N
        )
    proc add_edge*(g: var UnWeightedDirectedStaticGraph, u, v: int) =
        g.add_edge_static_impl(u, v, 1, true)

    proc initUnWeightedUnDirectedStaticGraph*(N: int, capacity: int = 0): UnWeightedUnDirectedStaticGraph =
        result = UnWeightedUnDirectedStaticGraph(
            src: newSeqOfCap[int32](capacity*2),
            dst: newSeqOfCap[int32](capacity*2),
            cost: newSeqOfCap[int](capacity*2),
            elist: newSeq[(int32, int)](0),
            start: newSeq[int32](0),
            len: N
        )
    proc add_edge*(g: var UnWeightedUnDirectedStaticGraph, u, v: int) =
        g.add_edge_static_impl(u, v, 1, false)

    proc static_graph_initialized_check*[T](g: StaticGraph[T]) = assert g.start.len > 0, "Static Graph must be initialized before use."

    iterator `[]`*[T](g: WeightedDirectedStaticGraph[T] or WeightedUnDirectedStaticGraph[T], x: int): (int, T) =
        g.static_graph_initialized_check()
        for i in g.start[x]..<g.start[x+1]: yield (g.elist[i][0].int, g.elist[i][1])
    iterator `[]`*(g: UnWeightedDirectedStaticGraph or UnWeightedUnDirectedStaticGraph, x: int): int =
        g.static_graph_initialized_check()
        for i in g.start[x]..<g.start[x+1]: yield g.elist[i][0].int

    iterator to_and_cost*[T](g: DynamicGraph[T], x: int): (int, T) =
        for e in g.edges[x]: yield (e[0].int, e[1])
    iterator to_and_cost*[T](g: StaticGraph[T], x: int): (int, T) =
        g.static_graph_initialized_check()
        for i in g.start[x]..<g.start[x+1]: yield (g.elist[i][0].int, g.elist[i][1])
    
    import tables

    type UnWeightedUnDirectedTableGraph*[T] = object 
        toi* : Table[T,int]
        v* : seq[T]
        graph* : UnWeightedUnDirectedGraph

    type UnWeightedDirectedTableGraph*[T] = object 
        toi* : Table[T,int]
        v* : seq[T]
        graph* : UnWeightedDirectedGraph

    type WeightedUnDirectedTableGraph*[T,S] = object 
        toi* : Table[T,int]
        v* : seq[T]
        graph* : WeightedUnDirectedGraph[S]

    type WeightedDirectedTableGraph*[T,S] = object 
        toi* : Table[T,int]
        v* : seq[T]
        graph* : WeightedDirectedGraph[S]

    type UnWeightedTableGraph*[T] = UnWeightedUnDirectedTableGraph[T] or UnWeightedDirectedTableGraph[T]
    type WeightedTableGraph*[T,S] = WeightedUnDirectedTableGraph[T,S] or WeightedDirectedTableGraph[T,S]

    proc initUnWeightedUnDirectedTableGraph*[T](V:seq[T]):UnWeightedUnDirectedTableGraph[T]=
        for i in 0..<len(V):
            result.toi[V[i]] = i
        result.graph = initUnWeightedUnDirectedGraph(len(V))
        result.v = V

    proc initUnWeightedDirectedTableGraph*[T](V:seq[T]):UnWeightedDirectedTableGraph[T]=
        for i in 0..<len(V):
            result.toi[V[i]] = i
        result.graph = initUnWeightedDirectedGraph(len(V))
        result.v = V

    proc initWeightedUnDirectedTableGraph*[T](V:seq[T],S:typedesc = int):WeightedUnDirectedTableGraph[T,S]=
        for i in 0..<len(V):
            result.toi[V[i]] = i
        result.graph = initUnWeightedUnDirectedGraph[S](len(V))
        result.v = V

    proc initWeightedDirectedTableGraph*[T](V:seq[T],S:typedesc = int):WeightedDirectedTableGraph[T,S]=
        for i in 0..<len(V):
            result.toi[V[i]] = i
        result.graph = initWeightedDirectedGraph[S](len(V))
        result.v = V

    proc add_edge*[T](g: var UnWeightedTableGraph[T],u,v:int)=
        g.graph.add_edge(g.toi[u],g.toi[v])

    proc add_edge*[T,S](g: var WeightedTableGraph[T,S],u,v:int,cost:S)=
        g.graph.add_edge(g.toi[u],g.toi[v],cost)

    iterator `[]`*[T,S](g: WeightedDirectedTableGraph[T,S] or WeightedUnDirectedTableGraph[T,S], x: T): (T, S) = 
        for (x,y) in g.graph[g.toi[x]]:
            yield (g.v[x],y)
    iterator `[]`*[T](g: UnWeightedDirectedTableGraph[T] or UnWeightedUnDirectedTableGraph[T], x: T): T = 
        for x in g.graph[g.toi[x]]:
            yield g.v[x]

