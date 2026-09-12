when not declared CPLIB_GRAPH_COUNT_TOPOLOGICALSORT:
    const CPLIB_GRAPH_COUNT_TOPOLOGICALSORT* = 1
    import cplib/graph/graph
    import cplib/graph/topologicalsort

    proc count_topologicalsort*(G: DirectedGraph): int64 =
        ## トポロジカル順序の個数を返す。時間 O(V * 2^V + E)、空間 O(2^V + V)。
        ## 空グラフは1、閉路を含む場合は0。多重辺は同じ制約として扱い、重みは無視する。
        ## 静的グラフは事前にbuildが必要。頂点数は20程度までを想定する。
        ## V < sizeof(int) * 8 - 1 かつ答えがint64に収まることが必要（V <= 20なら収まる）。
        let n = G.len
        assert n < sizeof(int) * 8 - 1
        if not G.isDAG():
            return 0
        var predecessors = newSeq[int](n)
        for u in 0..<n:
            for (v, _) in G.to_and_cost(u):
                predecessors[v] = predecessors[v] or (1 shl u)
        let size = 1 shl n
        var dp = newSeq[int64](size)
        dp[0] = 1
        for mask in 0..<size:
            if dp[mask] == 0:
                continue
            for v in 0..<n:
                let bit = 1 shl v
                if (mask and bit) == 0 and (mask and predecessors[v]) == predecessors[v]:
                    dp[mask or bit] += dp[mask]
        return dp[^1]
