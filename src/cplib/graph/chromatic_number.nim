when not declared CPLIB_GRAPH_CHROMATIC_NUMBER:
    const CPLIB_GRAPH_CHROMATIC_NUMBER* = 1
    import bitops
    import cplib/graph/graph

    const MaxChromaticNumberVertices* = 18

    # 固定2素数の包除。非零の被覆数が両方で0になると彩色数を過大評価する。
    # 固定入力に対する衝突確率の数値保証はない。
    type ChromaticResidues = array[2, uint32]
    const ChromaticMod1 = 1000000007'u32
    const ChromaticMod2 = 1000000009'u32

    proc multiply(value: var ChromaticResidues, factor: uint32) {.inline.} =
        ## 独立集合数を掛け、2素数で剰余を取る。
        value[0] = (value[0].uint64 * factor.uint64 mod ChromaticMod1.uint64).uint32
        value[1] = (value[1].uint64 * factor.uint64 mod ChromaticMod2.uint64).uint32

    proc subtract(value: var ChromaticResidues, other: ChromaticResidues) {.inline.} =
        ## 2素数で剰余の減算を行う。
        value[0] = if value[0] >= other[0]: value[0] - other[0] else: value[0] + ChromaticMod1 - other[0]
        value[1] = if value[1] >= other[1]: value[1] - other[1] else: value[1] + ChromaticMod2 - other[1]

    proc nonzero(value: ChromaticResidues): bool {.inline.} =
        ## いずれかの剰余が非零かを返す。
        value[0] != 0 or value[1] != 0

    proc independent_counts(adjacent: seq[int]): seq[uint32] =
        ## 各誘導部分グラフの空集合を含む独立集合数。O(2^N) 時間・領域。
        result = newSeq[uint32](1 shl adjacent.len)
        result[0] = 1
        for mask in 1..<result.len:
            let bit = mask and -mask
            let rest = mask xor bit
            result[mask] = result[rest] + result[rest and not adjacent[countTrailingZeroBits(bit)]]

    proc chromatic_number_impl(g: UnDirectedGraph, restore: bool): tuple[chromaticNumber: int, colors: seq[int]] =
        ## 独立集合数 DP と2素数の包除で求める。復元込み O(N 2^N + E) 算術演算、O(2^N + N) 領域。
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
        if counts[^1] == (1'u32 shl n):
            return (1, if restore: newSeq[int](n) else: @[])
        if counts[^1] == n.uint32 + 1:
            var colors: seq[int]
            if restore:
                colors = newSeq[int](n)
                for v in 0..<n: colors[v] = v
            return (n, colors)
        var powers = newSeq[ChromaticResidues](counts.len)
        for mask in 0..<counts.len: powers[mask] = [counts[mask], counts[mask]]
        result.chromaticNumber = n
        for k in 2..<n:
            var covers: array[2, int64]
            for mask in 0..<counts.len:
                powers[mask].multiply(counts[mask])
                if ((n - countSetBits(mask)) and 1) == 0:
                    covers[0] += powers[mask][0].int64
                    covers[1] += powers[mask][1].int64
                else:
                    covers[0] -= powers[mask][0].int64
                    covers[1] -= powers[mask][1].int64
            # 各項はmod未満、項数は2^18以下なので和はint64に収まる。
            if covers[0] mod ChromaticMod1.int64 != 0 or covers[1] mod ChromaticMod2.int64 != 0:
                result.chromaticNumber = k
                break

        if restore:
            result.colors = newSeq[int](n)
            var vertices = newSeq[int](n)
            for v in 0..<n: vertices[v] = v
            var k = result.chromaticNumber
            var color = 0
            while vertices.len != 0:
                if k == vertices.len:
                    for i, v in vertices: result.colors[v] = color + i
                    break
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
                powers.setLen(counts.len)
                for mask in 0..<counts.len:
                    powers[mask] = [1'u32, 1'u32]
                    for exponent in 0..<k - 1:
                        powers[mask].multiply(counts[mask])
                # 非空の独立集合を毎回除くため、復元の総和 sum_m m 2^m も O(N 2^N)。
                # subset Möbius 変換で全誘導部分グラフの (k-1) 色の被覆数を求める。
                for v in 0..<m:
                    let bit = 1 shl v
                    for base in countup(0, counts.len - 1, bit shl 1):
                        for offset in 0..<bit:
                            powers[base + bit + offset].subtract(powers[base + offset])
                let full = counts.len - 1
                var chosen = 0
                for mask in countup(1, counts.len - 1, 2):
                    let cardinality = countSetBits(mask)
                    if cardinality <= m - k + 1 and
                            counts[mask] == (1'u32 shl cardinality) and
                            powers[full xor mask].nonzero():
                        chosen = mask
                        break
                if chosen == 0:
                    # 偽0で復元候補を失った場合も、不正な色列を返したり再試行し続けたりしない。
                    raise newException(ValueError, "mod包除の零判定により彩色を復元できません")
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
        ## 0 <= N <= 18 の無向グラフの彩色数を求める。O(N 2^N + E) 算術演算、O(2^N + N) 領域。
        ## 空は0、自己ループありは-1。多重辺を許容し、重みは無視する。静的グラフはbuildが必要。
        ## 固定2素数の偽0で過大評価する可能性がある。確率の数値保証はない。
        ## 頂点数の範囲外はValueError。入力は変更しない。
        chromatic_number_impl(g, false).chromaticNumber

    proc chromatic_number_with_coloring*(g: UnDirectedGraph): tuple[chromaticNumber: int, colors: seq[int]] =
        ## 彩色数と頂点順の0始まりの合法な色列を返す。O(N 2^N + E) 算術演算、O(2^N + N) 領域。
        ## 契約はchromatic_numberと同じ。自己ループありは(-1, @[])、空は(0, @[])。
        ## 偽0で復元候補がなくなる場合はValueError。返した色列は報告した全色を使用する。
        chromatic_number_impl(g, true)
