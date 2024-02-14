when not declared CPLIB_TREE_TREE:
    const CPLIB_TREE_TREE* = 1
    include cplib/graph/graph

    type WeightedTree*[T] = ref object of DynamicGraph[T]
    type UnWeightedTree* = ref object of DynamicGraph[int]
    type WeightedStaticTree*[T] = ref object of StaticGraph[T]
    type UnWeightedStaticTree* = ref object of StaticGraph[int]

    type TreeTypes* = WeightedTree or UnWeightedTree or WeightedStaticTree or UnWeightedStaticTree
    type DynamicTree* = WeightedTree or UnWeightedTree
    type StaticTree* = WeightedStaticTree or UnWeightedStaticTree

    proc add_edge_impl[T](g: DynamicTree, u, v: int, cost: T) =
        g.edges[u].add((v, cost))
        g.edges[v].add((u, cost))

    proc add_edge_impl[T](g: StaticTree, u, v: int, cost: T) =
        g.src.add(u)
        g.dst.add(v)
        g.cost.add(cost)
        g.src.add(v)
        g.dst.add(u)
        g.cost.add(cost)

    proc initWeightedTree*(N: int, edgetype: typedesc = int): WeightedTree[edgetype] =
        result = WeightedTree[edgetype](edges: newSeq[seq[(int, edgetype)]](N))
    proc add_edge*[T](g: var WeightedTree[T], u, v: int, cost: T) =
        g.add_edge_impl(u, v, cost)

    proc initUnWeightedTree*(N: int): UnWeightedTree =
        result = UnWeightedTree(edges: newSeq[seq[(int, int)]](N))
    proc add_edge*(g: var UnWeightedTree, u, v: int) =
        g.add_edge_impl(u, v, 1)
    proc initUnWeightedTree*(parents: seq[int]): UnWeightedTree =
        result = initUnWeightedTree(parents.len + 1)
        for i in 0..<parents.len:
            result.add_edge(i+1, parents[i])

    proc initWeightedStaticTree*(N: int, edgetype: typedesc = int): WeightedStaticTree[edgetype] =
        var capacity = (N - 1) * 2
        result = WeightedStaticTree[edgetype](
            src: newSeqOfCap[int](capacity*2),
            dst: newSeqOfCap[int](capacity*2),
            cost: newSeqOfCap[int](capacity*2),
            elist: newSeq[(int, int)](0),
            start: newSeq[int](0),
            N: N
        )
    proc add_edge*[T](g: var WeightedStaticTree[T], u, v: int, cost: T) = g.add_edge_impl(u, v, cost)

    proc initUnWeightedStaticTree*(N: int): UnWeightedStaticTree =
        var capacity = (N - 1) * 2
        result = UnWeightedStaticTree(
            src: newSeqOfCap[int](capacity*2),
            dst: newSeqOfCap[int](capacity*2),
            cost: newSeqOfCap[int](capacity*2),
            elist: newSeq[(int, int)](0),
            start: newSeq[int](0),
            N: N
        )
    proc add_edge*(g: var UnWeightedStaticTree, u, v: int) =
        g.add_edge_impl(u, v, 1)
    proc initUnWeightedStaticTree*(parents: seq[int]): UnWeightedStaticTree =
        result = initUnWeightedStaticTree(parents.len + 1)
        for i in 0..<parents.len:
            result.add_edge(i+1, parents[i])

    iterator `[]`*[T](g: WeightedTree[T], x: int): (int, T) =
        for e in g.edges[x]: yield e
    iterator `[]`*(g: UnWeightedTree, x: int): int =
        for e in g.edges[x]: yield e[0]
    iterator `[]`*[T](g: WeightedStaticTree[T], x: int): (int, T) =
        for i in g.start[x]..<g.start[x+1]: yield g.elist[i]
    iterator `[]`*(g: UnWeightedStaticTree, x: int): int =
        for i in g.start[x]..<g.start[x+1]: yield g.elist[i][0]

    iterator to_and_cost*[T](g: WeightedTree[T] or WeightedStaticTree[T], x: int): (int, T) =
        for (i, c) in g[x]: yield (i, c)
    iterator to_and_cost*(g: UnWeightedTree or UnWeightedStaticTree, x: int): (int, int) =
        for i in g[x]: yield (i, 1)
    proc len*(g: TreeTypes): int = g.N
