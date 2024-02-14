when not declared CPLIB_TREE_TREE:
    const CPLIB_TREE_TREE* = 1
    import cplib/graph/graph

    type WeightedTree*[T] = ref object of DynamicGraph[T]
    type UnWeightedTree* = ref object of DynamicGraph[int]

    type TreeTypes* = WeightedTree or UnWeightedTree

    proc add_edge_impl[T](g: TreeTypes, u, v: int, cost: T) =
        g.edges[u].add((v, cost))
        g.edges[v].add((u, cost))

    #WeightedDirectedGraph
    proc initWeightedTree*(N: int, edgetype: typedesc = int): WeightedTree[edgetype] =
        result = WeightedTree[edgetype](edges: newSeq[seq[(int, edgetype)]](N))
    proc add_edge*[T](g: var WeightedTree[T], u, v: int, cost: T) =
        g.add_edge_impl(u, v, cost)

    #UnWeightedUnDirectedGraph
    proc initUnWeightedTree*(N: int): UnWeightedTree =
        result = UnWeightedTree(edges: newSeq[seq[(int, int)]](N))
    proc add_edge*(g: var UnWeightedTree, u, v: int) =
        g.add_edge_impl(u, v, 1)
    proc initUnWeightedTree*(parents: seq[int]): UnWeightedTree =
        result = initUnWeightedTree(parents.len + 1)
        for i in 0..<parents.len:
            result.add_edge(i+1, parents[i])
