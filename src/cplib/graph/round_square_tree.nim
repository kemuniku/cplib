when not declared CPLIB_GRAPH_ROUND_SQUARE_TREE:
    const CPLIB_GRAPH_ROUND_SQUARE_TREE* = 1
    import cplib/graph/graph
    import cplib/graph/biconnected_components

    proc initRoundSquareTree*(bc: BiconnectedComponents): UnWeightedUnDirectedGraph =
        ## RoundSquareTreeを構築 O(V) 森を返す
        ## グラフ上にあった頂点の番号はそのまま、roundノードはn始まり
        ## 隣接するのは必ず四角と丸ノード
        let n = bc.belong.len
        result = initUnWeightedUnDirectedGraph(n + bc.groups.len)
        for i, group in bc.groups:
            for v in group:
                result.add_edge(v, n + i)

    proc initRoundSquareTree*(g: UnDirectedGraph): UnWeightedUnDirectedGraph =
        ## 無向グラフの円方木をO(V+E)時間・領域で構築します。自己ループと重みは無視します。
        ## 静的グラフはbuild済みとします。成分分解は非再帰です。
        result = initRoundSquareTree(initBiconnectedComponents(g))
