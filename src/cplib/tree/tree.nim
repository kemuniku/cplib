when not declared CPLIB_TREE_TREE:
    const CPLIB_TREE_TREE* = 1
    include cplib/graph/graph

    type WeightedTree*[T] = ref object of DynamicGraph[T]
    type UnWeightedTree* = ref object of DynamicGraph[int]
    type WeightedStaticTree*[T] = ref object of StaticGraph[T]
    type UnWeightedStaticTree* = ref object of StaticGraph[int]

    type TreeTypes* = WeightedTree or UnWeightedTree or WeightedStaticTree or UnWeightedStaticTree
    type WeightedTreeTypes*[T] = WeightedTree[T] or WeightedStaticTree[T]
    type UnWeightedTreeTypes* = UnWeightedTree or UnWeightedStaticTree
    type DynamicTree* = WeightedTree or UnWeightedTree
    type StaticTree* = WeightedStaticTree or UnWeightedStaticTree

    proc len*(g: TreeTypes): int = g.len

    proc initWeightedTree*(N: int, edgetype: typedesc = int): WeightedTree[edgetype] =
        result = WeightedTree[edgetype](edges: newSeq[seq[(int32, edgetype)]](N))
    proc add_edge*[T](g: var WeightedTree[T], u, v: int, cost: T) =
        g.add_edge_dynamic_impl(u, v, cost, false)

    proc initUnWeightedTree*(N: int): UnWeightedTree =
        result = UnWeightedTree(edges: newSeq[seq[(int32, int)]](N))
    proc add_edge*(g: var UnWeightedTree, u, v: int) =
        g.add_edge_dynamic_impl(u, v, 1, false)
    proc initUnWeightedTree*(parents: seq[int]): UnWeightedTree =
        result = initUnWeightedTree(parents.len + 1)
        for i in 0..<parents.len:
            result.add_edge(i+1, parents[i])

    proc initWeightedStaticTree*(N: int, edgetype: typedesc = int): WeightedStaticTree[edgetype] =
        var capacity = (N - 1) * 2
        result = WeightedStaticTree[edgetype](
            src: newSeqOfCap[int32](capacity*2),
            dst: newSeqOfCap[int32](capacity*2),
            cost: newSeqOfCap[int](capacity*2),
            elist: newSeq[(int32, int)](0),
            start: newSeq[int32](0),
            len: N
        )
    proc add_edge*[T](g: var WeightedStaticTree[T], u, v: int, cost: T) =
        g.add_edge_static_impl(u, v, cost, false)

    proc initUnWeightedStaticTree*(N: int): UnWeightedStaticTree =
        var capacity = (N - 1) * 2
        result = UnWeightedStaticTree(
            src: newSeqOfCap[int32](capacity*2),
            dst: newSeqOfCap[int32](capacity*2),
            cost: newSeqOfCap[int](capacity*2),
            elist: newSeq[(int32, int)](0),
            start: newSeq[int32](0),
            len: N
        )
    proc add_edge*(g: var UnWeightedStaticTree, u, v: int) =
        g.add_edge_static_impl(u, v, 1, false)
    proc initUnWeightedStaticTree*(parents: seq[int]): UnWeightedStaticTree =
        result = initUnWeightedStaticTree(parents.len + 1)
        for i in 0..<parents.len:
            result.add_edge(i+1, parents[i])
    proc build*(g: StaticTree) = g.build_impl()

    iterator `[]`*[T](g: WeightedTree[T], x: int): (int, T) =
        for e in g.edges[x]: yield e
    iterator `[]`*(g: UnWeightedTree, x: int): int =
        for e in g.edges[x]: yield e[0]
    iterator `[]`*[T](g: WeightedStaticTree[T], x: int): (int, T) =
        g.static_graph_initialized_check()
        for i in g.start[x]..<g.start[x+1]: yield g.elist[i]
    iterator `[]`*(g: UnWeightedStaticTree, x: int): int =
        g.static_graph_initialized_check()
        for i in g.start[x]..<g.start[x+1]: yield g.elist[i][0]
