when not declared CPLIB_TREE_CENTER:
    const CPLIB_TREE_CENTER* = 1
    import cplib/graph/graph
    import cplib/tree/diameter

    proc tree_center*(g: UnWeightedUnDirectedGraph or UnWeightedUnDirectedStaticGraph): tuple[centers: seq[int], radius: int] =
        ## 無重み無向木の中心頂点（昇順で1〜2個）と半径を返す。時間・空間 O(N)。
        ## 入力は連結かつ閉路のない木に限る。静的グラフは build 済みであること。
        ## 空木は (@[], 0)、単点は (@[0], 0)。重み付き木や辺上の連続中心は対象外。
        when g is UnWeightedUnDirectedStaticGraph:
            g.static_graph_initialized_check()
        if g.len == 0: return (@[], 0)
        let (d, path) = g.diameter_path()
        result.radius = (d + 1) div 2
        result.centers = @[path[d div 2]]
        if d mod 2 == 1:
            result.centers.add(path[d div 2 + 1])
            if result.centers[0] > result.centers[1]:
                swap(result.centers[0], result.centers[1])
