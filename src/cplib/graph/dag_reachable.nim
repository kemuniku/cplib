when not declared CPLIB_GRAPH_DAG_REACHABLE:
    const CPLIB_GRAPH_DAG_REACHABLE* = 1
    import cplib/graph/graph
    import cplib/graph/topologicalsort

    proc dag_reachable*(g: DirectedGraph, queries: openArray[(int, int)]): seq[bool] =
        ## DAG 上の (始点, 終点) の到達可能性を入力順に返す。0 辺の到達を含む。
        ## 時間 O(N+M+(N+M)ceil(Q/64)+Q)、追加空間 O(N+Q)。重みは無視する。
        ## 頂点番号は 0..<N。循環・範囲外クエリ・未 build の静的グラフは ValueError。
        when g is StaticGraphTypes:
            if g.start.len != g.len + 1:
                raise newException(ValueError, "静的グラフは build が必要です")
        for (a, b) in queries:
            if a < 0 or a >= g.len or b < 0 or b >= g.len:
                raise newException(ValueError, "クエリの頂点番号が範囲外です")
        let order = g.topologicalsort()
        if order.len != g.len:
            raise newException(ValueError, "入力グラフは DAG である必要があります")
        result = newSeq[bool](queries.len)
        if queries.len == 0: return
        var reachable = newSeq[uint64](g.len)
        var first = 0
        while first < queries.len:
            let count = min(64, queries.len - first)
            for v in 0..<g.len: reachable[v] = 0
            for bit in 0..<count:
                reachable[queries[first + bit][1]] =
                    reachable[queries[first + bit][1]] or (1'u64 shl bit)
            for i in countdown(order.len - 1, 0):
                let v = order[i]
                for (to, _) in g.to_and_id(v):
                    reachable[v] = reachable[v] or reachable[to]
            for bit in 0..<count:
                result[first + bit] = (reachable[queries[first + bit][0]] and
                    (1'u64 shl bit)) != 0
            first += count
