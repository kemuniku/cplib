when not declared CPLIB_GRAPH_TRANSITIVE_CLOSURE:
    const CPLIB_GRAPH_TRANSITIVE_CLOSURE* = 1
    import cplib/graph/graph

    proc transitive_closure*(g: UnWeightedDirectedGraph or UnWeightedDirectedStaticGraph, reflexive: bool = false): UnWeightedDirectedGraph =
        ## 長さ1以上の有向路がある頂点対に辺を張る。reflexiveなら長さ0の路も含める。
        ## 各始点から非再帰DFS。時間 O(N + NM + K)、補助空間 O(N)、出力空間 O(N + K)。
        ## Kは出力辺数で最大N^2。多重辺はまとめ、閉路による自己辺は保持する。
        ## 静的入力はbuild済みとし、入力は変更しない。出力は動的グラフで辺順は未規定。
        ## 頂点番号・辺番号はgraphのint32制約に従い、NとKはint32.high以下とする。
        when g is UnWeightedDirectedStaticGraph:
            g.static_graph_initialized_check()
        result = initUnWeightedDirectedGraph(g.len)
        var seen = newSeq[int](g.len)
        for v in 0..<g.len: seen[v] = -1
        var stack = newSeqOfCap[int](g.len)
        for src in 0..<g.len:
            seen[src] = src
            stack.add(src)
            var selfAdded = reflexive
            if reflexive: result.add_edge(src, src)
            while stack.len > 0:
                let v = stack.pop()
                for dst in g[v]:
                    if dst == src:
                        if not selfAdded:
                            result.add_edge(src, src)
                            selfAdded = true
                    elif seen[dst] != src:
                        seen[dst] = src
                        result.add_edge(src, dst)
                        stack.add(dst)

    proc make_can_move_graph*(g: UnWeightedDirectedGraph or UnWeightedDirectedStaticGraph): UnWeightedDirectedGraph =
        ## 長さ1以上の到達を辺にする。transitive_closure(g)と同じ。時間 O(N + NM + K)。
        g.transitive_closure()
