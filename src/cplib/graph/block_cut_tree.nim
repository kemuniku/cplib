when not declared CPLIB_GRAPH_BLOCK_CUT_TREE:
    const CPLIB_GRAPH_BLOCK_CUT_TREE* = 1

    import cplib/graph/graph
    import cplib/graph/biconnected_components
    import sequtils

    type BlockCutTree* = object
        ## tree の [0, groups.len) が block node、それ以降が関節点 node。
        ## 非連結グラフに対しては forest になる。
        tree*: UnWeightedUnDirectedGraph
        groups*: seq[seq[int]]
        vertexNode*: seq[int]       # 非関節点は所属 block、関節点は関節点 node
        articulationNode*: seq[int] # 元頂点 -> 関節点 node。非関節点なら -1

    proc initBlockCutTree*(G: UnWeightedUnDirectedGraph or
                                UnWeightedUnDirectedStaticGraph): BlockCutTree =
        let bcc = initBiconnectedComponents(G)
        result.groups = bcc.groups
        result.vertexNode = newSeqWith(len(G), -1)
        result.articulationNode = newSeqWith(len(G), -1)

        for i, v in bcc.articulationPoints:
            result.articulationNode[v] = bcc.groups.len + i
            result.vertexNode[v] = bcc.groups.len + i

        result.tree = initUnWeightedUnDirectedGraph(
            bcc.groups.len + bcc.articulationPoints.len)
        for bid, componentVertices in bcc.groups:
            for v in componentVertices:
                if result.articulationNode[v] != -1:
                    result.tree.add_edge(bid, result.articulationNode[v])
                else:
                    result.vertexNode[v] = bid

    proc blockCutTree*(G: UnWeightedUnDirectedGraph or
                           UnWeightedUnDirectedStaticGraph): BlockCutTree =
        ## `initBlockCutTree` の別名。
        initBlockCutTree(G)
