## 一般無向グラフの最大重みマッチング。設計の説明はgeneral_weighted_matching.mdを参照。
when not declared CPLIB_GRAPH_GENERAL_WEIGHTED_MATCHING:
    const CPLIB_GRAPH_GENERAL_WEIGHTED_MATCHING* = 1
    import cplib/graph/graph
    import cplib/graph/internal/weighted_matching_engine

    proc maximum_weight_matching*[T: SomeSignedInt](g: WeightedUnDirectedGraph[T] or WeightedUnDirectedStaticGraph[T]): tuple[weight: int64, matching: seq[tuple[u, v: int]]] =
        ## 最大重みと、それを達成する頂点ペア列（u < v）を返す。時間O(V+E+K^3)、追加領域O(V+K^2)。
        ## Kは正の非ループ辺に接する頂点数、Mは多重辺をまとめた後の正の非ループ辺数。
        ## 辺数の最大化は保証しない。自己ループと重み0以下の辺は無視し、多重辺は最大重みを使う。
        ## 重みは符号付き整数型で、総和はint64。K>0のとき最大正重みWはhigh(int64) div (4*K)以下とする。
        ## 入力は変更しない。静的グラフはbuild()が必要。
        g.independentWeightedMatching(false)
