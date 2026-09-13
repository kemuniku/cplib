when not declared CPLIB_GRAPH_BLOCK_CUT_TREE:
    const CPLIB_GRAPH_BLOCK_CUT_TREE* = 1
    import cplib/graph/graph
    import cplib/graph/biconnected_components

    type BlockCutTree* = object
        forest*: UnWeightedUnDirectedGraph
        id*: seq[int]
        articulation*: seq[int]
        groups*: seq[seq[int]]

    proc initBlockCutTree*(bc: BiconnectedComponents): BlockCutTree =
        ## 成分ノード[0, groups.len)と関節点ノードからなるblock-cut forestをO(V)で構築します。
        ## id[v]は関節点なら専用ノード、それ以外なら所属成分を指します。
        ## 関節点ノードgroups.len+iはarticulation[i]に対応します。
        result.groups = bc.groups
        result.articulation = bc.articulation
        result.id = newSeq[int](bc.belong.len)
        result.forest = initUnWeightedUnDirectedGraph(bc.groups.len + bc.articulation.len)
        for v in 0..<bc.belong.len:
            result.id[v] = bc.belong[v][0]
        for i, v in bc.articulation:
            let node = bc.groups.len + i
            result.id[v] = node
            for group in bc.belong[v]: result.forest.add_edge(node, group)

    proc initBlockCutTree*(g: UnDirectedGraph): BlockCutTree =
        ## 無向グラフのblock-cut forestをO(V+E)時間・領域で構築します。
        result = initBlockCutTree(initBiconnectedComponents(g))
