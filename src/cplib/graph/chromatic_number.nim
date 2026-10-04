when not declared CPLIB_GRAPH_CHROMATIC_NUMBER:
    const CPLIB_GRAPH_CHROMATIC_NUMBER* = 1
    import bitops
    import cplib/graph/graph

    const MaxChromaticNumberVertices* = 18

    proc chromatic_number_impl(g: UnDirectedGraph, restore: bool): tuple[chromaticNumber: int, colors: seq[int]] =
        ## 独立集合への分割を部分集合 DP で厳密に求める。O(3^N + E) 時間、O(2^N + N) 領域。
        let n = g.len
        if n < 0 or n > MaxChromaticNumberVertices:
            raise newException(ValueError, "彩色数の頂点数は0以上18以下である必要があります")
        when g is StaticGraphTypes:
            g.static_graph_initialized_check()
        if n == 0: return (0, @[])
        var adjacent = newSeq[int](n)
        for u in 0..<n:
            for (v, _) in g.to_and_cost(u):
                if u == v: return (-1, @[])
                adjacent[u] = adjacent[u] or (1 shl v)

        let size = 1 shl n
        var independent = newSeq[bool](size)
        independent[0] = true
        for mask in 1..<size:
            let bit = mask and -mask
            let rest = mask xor bit
            independent[mask] = independent[rest] and
                (adjacent[countTrailingZeroBits(bit)] and rest) == 0

        var dp = newSeq[uint8](size)
        var chosen: seq[int32]
        if restore: chosen = newSeq[int32](size)
        for mask in 1..<size:
            if independent[mask]:
                dp[mask] = 1
                if restore: chosen[mask] = mask.int32
                continue
            let bit = mask and -mask
            let rest = mask xor bit
            dp[mask] = dp[rest] + 1
            if restore: chosen[mask] = bit.int32
            let candidates = rest and not adjacent[countTrailingZeroBits(bit)]
            var subset = candidates
            while subset != 0:
                let colorClass = subset or bit
                if independent[colorClass]:
                    let value = dp[mask xor colorClass] + 1
                    if value < dp[mask]:
                        dp[mask] = value
                        if restore: chosen[mask] = colorClass.int32
                        if value == 2: break
                subset = (subset - 1) and candidates
        result.chromaticNumber = dp[^1].int
        if restore:
            result.colors = newSeq[int](n)
            var remaining = size - 1
            var color = 0
            while remaining != 0:
                let colorClass = chosen[remaining].int
                var vertices = colorClass
                while vertices != 0:
                    let bit = vertices and -vertices
                    result.colors[countTrailingZeroBits(bit)] = color
                    vertices = vertices xor bit
                remaining = remaining xor colorClass
                inc color

    proc chromatic_number*(g: UnDirectedGraph): int =
        ## 0 <= N <= 18 の無向グラフの厳密彩色数を返す。O(3^N + E) 時間、O(2^N + N) 領域。
        ## 空は0、自己ループありは-1。多重辺を許容し、重みは無視する。静的グラフはbuildが必要。
        ## 頂点数の範囲外はValueError。入力は変更しない。
        chromatic_number_impl(g, false).chromaticNumber

    proc chromatic_number_with_coloring*(g: UnDirectedGraph): tuple[chromaticNumber: int, colors: seq[int]] =
        ## 厳密彩色数と頂点順の0始まりの色列を返す。O(3^N + E) 時間、O(2^N + N) 領域。
        ## 契約はchromatic_numberと同じ。自己ループありは(-1, @[])、空は(0, @[])。
        chromatic_number_impl(g, true)
