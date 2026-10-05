when not declared CPLIB_GRAPH_CHROMATIC_NUMBER:
    const CPLIB_GRAPH_CHROMATIC_NUMBER* = 1
    import bitops
    import cplib/graph/graph

    const MaxChromaticNumberVertices* = 18

    # F(k) = sum_S (-1)^(N-|S|) I[S]^k は独立集合 k 個による被覆数。
    # 空集合も含めて数え、F(k) > 0 と k 色での彩色可能性は同値。
    # I[S]^k の符号付き和の絶対値は 2^(N*(k+1)) <= 2^342。
    # 必要な32bit桁だけ使い、法をこの上界より大きく取るので零判定も厳密。
    # 11桁(352bit)で十分。桁数を増やす際も I[S]^k 自体は切り捨てられていない。
    type ChromaticCount = array[11, uint32]

    proc multiply(value: var ChromaticCount, factor: uint32, limbs: int) {.inline.} =
        ## 固定幅整数に独立集合数を掛ける。
        var carry = 0'u64
        for i in 0..<limbs:
            let product = value[i].uint64 * factor.uint64 + carry
            value[i] = (product and 0xffffffff'u64).uint32
            carry = product shr 32

    proc add(value: var ChromaticCount, other: ChromaticCount, limbs: int) {.inline.} =
        ## 固定幅整数の加算。
        var carry = 0'u64
        for i in 0..<limbs:
            let sum = value[i].uint64 + other[i].uint64 + carry
            value[i] = (sum and 0xffffffff'u64).uint32
            carry = sum shr 32

    proc subtract(value: var ChromaticCount, other: ChromaticCount, limbs: int) {.inline.} =
        ## 固定幅整数の減算。
        var borrow = 0'u64
        for i in 0..<limbs:
            let difference = 0x100000000'u64 + value[i].uint64 - other[i].uint64 - borrow
            value[i] = (difference and 0xffffffff'u64).uint32
            borrow = 1'u64 - (difference shr 32)

    proc nonzero(value: ChromaticCount, limbs: int): bool {.inline.} =
        ## 固定幅整数が零でないかを返す。
        for i in 0..<limbs:
            if value[i] != 0: return true

    proc independent_counts(adjacent: seq[int]): seq[uint32] =
        ## 各誘導部分グラフの空集合を含む独立集合数。O(2^N) 時間・領域。
        result = newSeq[uint32](1 shl adjacent.len)
        result[0] = 1
        for mask in 1..<result.len:
            let bit = mask and -mask
            let rest = mask xor bit
            result[mask] = result[rest] + result[rest and not adjacent[countTrailingZeroBits(bit)]]

    proc chromatic_number_impl(g: UnDirectedGraph, restore: bool): tuple[chromaticNumber: int, colors: seq[int]] =
        ## 独立集合数 DP と包除で厳密に求める。復元込み O(N 2^N + E) 算術演算、O(2^N + N) 領域。
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

        var counts = independent_counts(adjacent)
        var powers = newSeq[ChromaticCount](counts.len)
        for value in powers.mitems: value[0] = 1
        let countBits = 32 - countLeadingZeroBits(counts[^1] - 1)
        for k in 1..n:
            let limbs = (n + countBits * k) div 32 + 1
            var covers: ChromaticCount
            for mask in 0..<counts.len:
                powers[mask].multiply(counts[mask], limbs)
                if ((n - countSetBits(mask)) and 1) == 0:
                    covers.add(powers[mask], limbs)
                else:
                    covers.subtract(powers[mask], limbs)
            if covers.nonzero(limbs):
                result.chromaticNumber = k
                break

        if restore:
            result.colors = newSeq[int](n)
            var vertices = newSeq[int](n)
            for v in 0..<n: vertices[v] = v
            var k = result.chromaticNumber
            var color = 0
            while vertices.len != 0:
                if k == 1:
                    for v in vertices: result.colors[v] = color
                    break
                let m = vertices.len
                if m != n:
                    var localAdjacent = newSeq[int](m)
                    for u in 0..<m:
                        for v in 0..<m:
                            if (adjacent[vertices[u]] and (1 shl vertices[v])) != 0:
                                localAdjacent[u] = localAdjacent[u] or (1 shl v)
                    counts = independent_counts(localAdjacent)
                let countBits = 32 - countLeadingZeroBits(counts[^1] - 1)
                let limbs = (m + countBits * (k - 1)) div 32 + 1
                powers.setLen(counts.len)
                for mask in 0..<counts.len:
                    powers[mask] = default(ChromaticCount)
                    powers[mask][0] = 1
                    for exponent in 0..<k - 1:
                        powers[mask].multiply(counts[mask], limbs)
                # 非空の独立集合を毎回除くため、復元の総和 sum_m m 2^m も O(N 2^N)。
                # subset Möbius 変換で全誘導部分グラフの (k-1) 色の被覆数を求める。
                for v in 0..<m:
                    let bit = 1 shl v
                    for base in countup(0, counts.len - 1, bit shl 1):
                        for offset in 0..<bit:
                            powers[base + bit + offset].subtract(powers[base + offset], limbs)
                let full = counts.len - 1
                var chosen = 0
                for mask in 1..<counts.len:
                    if (mask and 1) != 0 and counts[mask] == (1'u32 shl countSetBits(mask)) and
                            powers[full xor mask].nonzero(limbs):
                        chosen = mask
                        break
                if chosen == 0:
                    raise newException(AssertionDefect, "最適彩色の色クラスが見つかりません")
                var remaining: seq[int]
                for i, v in vertices:
                    if (chosen and (1 shl i)) != 0:
                        result.colors[v] = color
                    else:
                        remaining.add(v)
                vertices = remaining
                dec k
                inc color

    proc chromatic_number*(g: UnDirectedGraph): int =
        ## 0 <= N <= 18 の無向グラフの厳密彩色数を返す。O(N 2^N + E) 算術演算、O(2^N + N) 領域。
        ## 空は0、自己ループありは-1。多重辺を許容し、重みは無視する。静的グラフはbuildが必要。
        ## 頂点数の範囲外はValueError。入力は変更しない。
        chromatic_number_impl(g, false).chromaticNumber

    proc chromatic_number_with_coloring*(g: UnDirectedGraph): tuple[chromaticNumber: int, colors: seq[int]] =
        ## 厳密彩色数と頂点順の0始まりの色列を返す。O(N 2^N + E) 算術演算、O(2^N + N) 領域。
        ## 契約はchromatic_numberと同じ。自己ループありは(-1, @[])、空は(0, @[])。
        chromatic_number_impl(g, true)
