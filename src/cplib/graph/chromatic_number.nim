when not declared CPLIB_GRAPH_CHROMATIC_NUMBER:
    const CPLIB_GRAPH_CHROMATIC_NUMBER* = 1

    import std/bitops
    import cplib/graph/graph

    proc chromatic_number_impl[T](G: GraphTypes[T]): int =
        ## 無向グラフの彩色数を部分集合 DP で厳密に求める。
        ## 計算量は O(3^N)、空間計算量は O(2^N)。
        let N = len(G)
        if N == 0:
            return 0
        assert N < sizeof(int) * 8, "too many vertices for bit DP"

        var adjacent = newSeq[int](N)
        for v in 0..<N:
            for (to, _) in G.to_and_cost(v):
                assert v != to, "a graph with a self-loop cannot be properly colored"
                adjacent[v] = adjacent[v] or (1 shl to)
                adjacent[to] = adjacent[to] or (1 shl v)

        let size = 1 shl N
        var independent = newSeq[bool](size)
        independent[0] = true
        for s in 1..<size:
            let vbit = s and -s
            let v = countTrailingZeroBits(vbit)
            independent[s] = independent[s xor vbit] and
                ((adjacent[v] and (s xor vbit)) == 0)

        var dp = newSeq[int](size)
        for s in 1..<size:
            dp[s] = N
            let fixed = s and -s
            var colorClass = s
            while colorClass != 0:
                if (colorClass and fixed) != 0 and independent[colorClass]:
                    dp[s] = min(dp[s], dp[s xor colorClass] + 1)
                colorClass = (colorClass - 1) and s
        result = dp[^1]

    proc chromatic_number*[T](G: WeightedUnDirectedGraph[T] or
            WeightedUnDirectedStaticGraph[T]): int =
        chromatic_number_impl(G)

    proc chromatic_number*(G: UnWeightedUnDirectedGraph or
            UnWeightedUnDirectedStaticGraph): int =
        chromatic_number_impl(G)
