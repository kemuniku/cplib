when not declared CPLIB_GRAPH_DIRECTED_REACHABLE:
    const CPLIB_GRAPH_DIRECTED_REACHABLE * = 1
    import cplib/graph/graph
    import cplib/graph/SCC
    import cplib/graph/dag_reachable

    proc directed_reachable*(g: UnWeightedDirectedGraph or
            UnWeightedDirectedStaticGraph, queries: openArray[(int, int)]): seq[bool] =
        ## 一般有向グラフの到達クエリを SCC 縮約後の DAG で解く。0 辺の到達を含む。
        ## 時間 O(N+M+(K+L)ceil(Q/64)+Q)、追加空間 O(N+M+Q)。K,L は縮約後の頂点・辺数。
        ## SCC の再帰 DFS を使用するため、深いグラフでは実行環境のスタック上限に注意。
        when g is UnWeightedDirectedStaticGraph:
            if g.start.len != g.len + 1:
                raise newException(ValueError, "静的グラフは build が必要です")
        for (a, b) in queries:
            if a < 0 or a >= g.len or b < 0 or b >= g.len:
                raise newException(ValueError, "クエリの頂点番号が範囲外です")
        let (dag, component, _) = g.SCCG()
        var mapped = newSeq[(int, int)](queries.len)
        for i, q in queries: mapped[i] = (component[q[0]], component[q[1]])
        result = dag.dag_reachable(mapped)
