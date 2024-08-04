when not declared CPLIB_GRAPH_STEINER_TREE:
    const CPLIB_GRAPH_RESTORE_STEINER_TREE* = 1
    import cplib/graph/graph
    import cplib/utils/constants
    import cplib/utils/bititers
    import sequtils, heapqueue
    proc steiner_tree_dp*[T](g: StaticGraph[T] or DynamicGraph[T], terminal: seq[int], inf: T): seq[seq[T]] =
        ## terminal に含まれる頂点を全て連結にするために必要な最小のコストを出力する。
        ## 計算量 O(n3^t + (n+m)2^tlogn)
        var k = terminal.len
        var n = g.len

        var dp = newSeqWith((1 shl k), newSeqWith(n, inf))
        for i in 0..<k:
            dp[(1 shl i)][terminal[i]] = 0

        for bit in 1..<(1 shl k):
            for u in 0..<n:
                for bn in bitsubset(bit):
                    dp[bit][u] = min(dp[bit][u], dp[bn][u] + dp[bit xor bn][u])
            var q = initHeapQueue[(int, int)]()
            for u in 0..<n:
                q.push((dp[bit][u], u))
            while q.len > 0:
                var (d, u) = q.pop
                if dp[bit][u] != d: continue
                for (v, cost) in g.to_and_cost(u):
                    if dp[bit][v] > d + cost:
                        dp[bit][v] = d + cost
                        q.push((dp[bit][v], v))
        return dp

    proc steiner_tree_mincost_impl[T](g: StaticGraph[T] or DynamicGraph[T], terminal: seq[int], inf: T): T =
        var dp = steiner_tree_dp(g, terminal, inf)
        var k = terminal.len
        return dp[(1 shl k) - 1][terminal[0]]

    proc steiner_tree_mincost*(g: StaticGraph[int] or DynamicGraph[int], terminal: seq[int], inf: int = INF64): int = steiner_tree_mincost_impl(g, terminal, inf)
    proc steiner_tree_mincost*(g: StaticGraph[int32] or DynamicGraph[int32], terminal: seq[int], inf: int32 = INF32): int32 = steiner_tree_mincost_impl(g, terminal, inf)
    proc steiner_tree_mincost*(g: StaticGraph[float] or DynamicGraph[float], terminal: seq[int], inf: float = 1e100): float = steiner_tree_mincost_impl(g, terminal, inf)
    proc steiner_tree_mincost*[T](g: StaticGraph[T] or DynamicGraph[T], terminal: seq[int], inf: T): T = steiner_tree_mincost_impl(g, terminal, inf)
