when not declared CPLIB_COLLECTIONS_DYNAMIC_BPLUS_WAVELETMATRIX:
    const CPLIB_COLLECTIONS_DYNAMIC_BPLUS_WAVELETMATRIX* = 1
    import bitops, options
    import cplib/collections/dynamic_bplus_bitvector
    import cplib/collections/dynamic_bplus_kernels

    type DynamicBPlusWaveletMatrix*[BV] = ref object
        levels: seq[BV]
        zeros: seq[int]
        n, height: int
        withSum: bool

    proc fits[BV](t: DynamicBPlusWaveletMatrix[BV], x: int): bool {.inline.} =
        ## 固定ビット幅の非負値域に収まるか O(1) で判定する。
        x >= 0 and (t.height == sizeof(int)*8-1 or (x shr t.height) == 0)

    proc checkRange[BV](t: DynamicBPlusWaveletMatrix[BV], l, r: int) {.inline.} =
        ## 半開区間 [l,r) の境界を確認する。
        assert 0 <= l and l <= r and r <= t.n

    proc initDynamicBPlusWaveletMatrix*[BV](values: openArray[int], bitVector: typedesc[BV],
            H: int = -1, with_sum: bool = false, kernel: BPlusKernel = bpkAuto): DynamicBPlusWaveletMatrix[BV] =
        ## 非負 int 列を O(NH) で構築する。H=-1 は初期値から決める固定幅（空列も最低 1）。
        ## 0 <= H <= int の符号ビット位置。後の挿入値もこの幅に収める。N <= int32.high。
        ## 添字と kth は 0 始まり、区間は半開。重複可。H=0 の値域は {0}。
        ## with_sum=true は値域木を巡回する和 API を有効にする（追加 O(NH) の和配列は持たない）。
        mixin initBitVector
        var height = H
        var maximum = 0
        for x in values:
            assert x >= 0
            maximum = max(maximum, x)
        if height == -1: height = if maximum == 0: 1 else: fastLog2(maximum)+1
        assert height >= 0 and height <= sizeof(int)*8-1
        assert values.len <= int32.high.int
        result = DynamicBPlusWaveletMatrix[BV](n: values.len, height: height, withSum: with_sum,
            levels: newSeq[BV](height), zeros: newSeq[int](height))
        assert result.fits(maximum)
        var current = @values
        var next = newSeq[int](values.len)
        var bits = newSeq[bool](values.len)
        for h in countdown(height-1, 0):
            var zero = 0
            for i, x in current:
                bits[i] = ((x shr h) and 1) != 0
                zero += int(not bits[i])
            result.zeros[h] = zero
            result.levels[h] = initBitVector(bitVector, bits, kernel)
            var a = 0
            var b = zero
            for i, x in current:
                if bits[i]:
                    next[b] = x
                    inc b
                else:
                    next[a] = x
                    inc a
            swap(current, next)

    proc initDynamicBPlusWaveletMatrix*(values: openArray[int], H: int = -1,
            with_sum: bool = false, kernel: BPlusKernel = bpkAuto): DynamicBPlusWaveletMatrix[BPlusBitVector[32, 64]] =
        ## 既定の分岐数 32・4096 bit 葉の B+ 木で構築する。明示型で別構造を選択可能。
        initDynamicBPlusWaveletMatrix(values, BPlusBitVector[32, 64], H, with_sum, kernel)

    proc activeKernel*[BV](t: DynamicBPlusWaveletMatrix[BV]): BPlusKernel =
        ## 実際に使用する kernel を返す。H=0 の場合は scalar。
        mixin activeKernel
        if t.height == 0: bpkScalar else: t.levels[0].activeKernel()

    proc len*[BV](t: DynamicBPlusWaveletMatrix[BV]): int =
        ## 現在の要素数を O(1) で返す。
        t.n

    proc bitWidth*[BV](t: DynamicBPlusWaveletMatrix[BV]): int =
        ## 構築時に固定されたビット幅を O(1) で返す。
        t.height

    proc storageBytes*[BV](t: DynamicBPlusWaveletMatrix[BV]): int =
        ## 各ビットベクトルの論理確保量を合算する。余剰 capacity と管理領域は含まない。
        mixin storageBytes
        for level in t.levels: result += level.storageBytes()
        result += t.zeros.len*sizeof(int)

    proc get_child*[BV](t: DynamicBPlusWaveletMatrix[BV], h, l, r: int): tuple[l0, r0, l1, r1: int] =
        ## 層 h の子区間を返す。以降 D はビットベクトルの rank/update の計算量とする。
        mixin rank, rankPair
        t.checkRange(l, r)
        assert 0 <= h and h < t.height
        let (a, b) = when compiles(t.levels[h].rankPair(l, r)):
            t.levels[h].rankPair(l, r)
        else:
            (t.levels[h].rank(l), t.levels[h].rank(r))
        (l-a, r-b, t.zeros[h]+a, t.zeros[h]+b)

    proc `[]`*[BV](t: DynamicBPlusWaveletMatrix[BV], i: int): int =
        ## i の値を O(HD) で返す。
        mixin rankAccess
        assert 0 <= i and i < t.n
        var p = i
        for h in countdown(t.height-1, 0):
            let a = t.levels[h].rankAccess(p)
            if a.bit:
                result = result or (1 shl h)
                p = t.zeros[h]+a.rank
            else:
                p -= a.rank

    proc insert*[BV](t: DynamicBPlusWaveletMatrix[BV], i, x: int) =
        ## 0 <= i <= len の位置に x を挿入する。O(HD)。ビット幅は拡張しない。
        mixin insert
        assert 0 <= i and i <= t.n and t.n < int32.high.int
        assert t.fits(x)
        var p = i
        for h in countdown(t.height-1, 0):
            let bit = ((x shr h) and 1) != 0
            let before = t.levels[h].insert(p, bit)
            if bit:
                p = t.zeros[h]+before
            else:
                inc t.zeros[h]
                p -= before
        inc t.n

    proc erase*[BV](t: DynamicBPlusWaveletMatrix[BV], i: int): int {.discardable.} =
        ## i を削除して元の値を返す。O(HD)。
        mixin erase
        assert 0 <= i and i < t.n
        var p = i
        for h in countdown(t.height-1, 0):
            let a = t.levels[h].erase(p)
            if a.bit:
                result = result or (1 shl h)
                p = t.zeros[h]+a.rank
            else:
                dec t.zeros[h]
                p -= a.rank
        dec t.n

    proc `[]=`*[BV](t: DynamicBPlusWaveletMatrix[BV], i, x: int) =
        ## 一点変更を O(HD) で行う。共通する上位ビットの層は変更しない。
        mixin rankAccess, erase, insert
        assert 0 <= i and i < t.n and t.fits(x)
        var p = i
        for h in countdown(t.height-1, 0):
            let a = t.levels[h].rankAccess(p)
            let bit = ((x shr h) and 1) != 0
            if a.bit == bit:
                p = if bit: t.zeros[h]+a.rank else: p-a.rank
                continue
            var oldPos = if a.bit: t.zeros[h]+a.rank else: p-a.rank
            discard t.levels[h].erase(p)
            if not a.bit: dec t.zeros[h]
            let before = t.levels[h].insert(p, bit)
            var newPos = if bit: t.zeros[h]+before else: p-before
            if not bit: inc t.zeros[h]
            for lower in countdown(h-1, 0):
                let removed = t.levels[lower].erase(oldPos)
                if removed.bit:
                    oldPos = t.zeros[lower]+removed.rank
                else:
                    dec t.zeros[lower]
                    oldPos -= removed.rank
            for lower in countdown(h-1, 0):
                let b = ((x shr lower) and 1) != 0
                let rank = t.levels[lower].insert(newPos, b)
                if b:
                    newPos = t.zeros[lower]+rank
                else:
                    inc t.zeros[lower]
                    newPos -= rank
            return

    proc set*[BV](t: DynamicBPlusWaveletMatrix[BV], i, x: int) =
        ## []= と同じ一点変更を行う。O(HD)。
        t[i] = x

    proc access*[BV](t: DynamicBPlusWaveletMatrix[BV], i: int): int =
        ## i番目の値を返す。[]と同じ。O(HD)。
        t[i]

    proc update*[BV](t: DynamicBPlusWaveletMatrix[BV], i, x: int) =
        ## 一点変更。[]=と同じ。O(HD)。
        t[i] = x

    proc kth_smallest*[BV](t: DynamicBPlusWaveletMatrix[BV], l, r, k: int): int =
        ## [l,r) 内で小さい順に k 番目 (0 始まり) を O(HD) で返す。
        t.checkRange(l, r)
        assert 0 <= k and k < r-l
        var l = l
        var r = r
        var k = k
        for h in countdown(t.height-1, 0):
            let (a, b, c, d) = t.get_child(h, l, r)
            if k < b-a:
                l = a
                r = b
            else:
                k -= b-a
                l = c
                r = d
                result = result or (1 shl h)

    proc kth_largest*[BV](t: DynamicBPlusWaveletMatrix[BV], l, r, k: int): int =
        ## [l,r) 内で大きい順に k 番目を O(HD) で返す。
        t.checkRange(l, r)
        assert 0 <= k and k < r-l
        t.kth_smallest(l, r, r-l-1-k)

    proc range_lowerbound*[BV](t: DynamicBPlusWaveletMatrix[BV], l, r, x: int): int =
        ## [l,r) の x 未満の個数を O(HD) で返す。値域外のしきい値も利用可能。
        t.checkRange(l, r)
        if x <= 0: return 0
        if not t.fits(x): return r-l
        var l = l
        var r = r
        for h in countdown(t.height-1, 0):
            if l == r: break
            let (a, b, c, d) = t.get_child(h, l, r)
            if ((x shr h) and 1) != 0:
                result += b-a
                l = c
                r = d
            else:
                l = a
                r = b

    proc count*[BV](t: DynamicBPlusWaveletMatrix[BV], l, r, x: int): int =
        ## [l,r) の x の出現回数を O(HD) で返す。
        t.checkRange(l, r)
        if not t.fits(x): return 0
        var l = l
        var r = r
        for h in countdown(t.height-1, 0):
            if l == r: return 0
            let (a, b, c, d) = t.get_child(h, l, r)
            if ((x shr h) and 1) != 0:
                l = c
                r = d
            else:
                l = a
                r = b
        r-l

    proc rank*[BV](t: DynamicBPlusWaveletMatrix[BV], r, x: int): int =
        ## [0,r) の x の出現回数。引数順は rank(r,x)。O(HD)。
        t.count(0, r, x)

    proc range_upperbound*[BV](t: DynamicBPlusWaveletMatrix[BV], l, r, x: int): int =
        ## [l,r) の x 以下の個数を O(HD) で返す。int.high でも加算しない。
        if x == int.high:
            t.checkRange(l, r)
            return r-l
        t.range_lowerbound(l, r, x+1)

    proc range_freq*[BV](t: DynamicBPlusWaveletMatrix[BV], l, r, low, high: int): int =
        ## [l,r) で値が [low,high) の個数を O(HD) で返す。low>=high なら 0。
        t.checkRange(l, r)
        if low >= high: return 0
        t.range_lowerbound(l, r, high)-t.range_lowerbound(l, r, low)

    proc prev_value*[BV](t: DynamicBPlusWaveletMatrix[BV], l, r, x: int): Option[int] =
        ## x 未満の最大値を O(HD) で返す。存在しなければ none(int)。
        let k = t.range_lowerbound(l, r, x)
        if k == 0: none(int) else: some(t.kth_smallest(l, r, k-1))

    proc next_value*[BV](t: DynamicBPlusWaveletMatrix[BV], l, r, x: int): Option[int] =
        ## x 以上の最小値を O(HD) で返す。存在しなければ none(int)。
        let k = t.range_lowerbound(l, r, x)
        if k == r-l: none(int) else: some(t.kth_smallest(l, r, k))

    proc select*[BV](t: DynamicBPlusWaveletMatrix[BV], k, x: int): int =
        ## x の k 番目の出現位置。引数順は(k,x)。O(HD)、存在しなければ-1。
        mixin select
        if k < 0 or not t.fits(x): return -1
        var l = 0
        var r = t.n
        for h in countdown(t.height-1, 0):
            if k >= r-l: return -1
            let (a, b, c, d) = t.get_child(h, l, r)
            if ((x shr h) and 1) != 0:
                l = c
                r = d
            else:
                l = a
                r = b
        if k >= r-l: return -1
        result = l+k
        for h in 0..<t.height:
            let bit = ((x shr h) and 1) != 0
            result = t.levels[h].select(bit, result-(if bit: t.zeros[h] else: 0))

    proc sumVisit[BV](t: DynamicBPlusWaveletMatrix[BV], h, l, r, prefix, low, high: int): int =
        ## 値域木の非空部分を走査する。low/high は閉区間で上限オーバーフローを避ける。
        if l == r: return 0
        let maximum = prefix or (if h == sizeof(int)*8-2: int.high else: (1 shl (h+1))-1)
        if maximum < low or prefix > high: return 0
        if h < 0: return prefix*(r-l)
        let (a, b, c, d) = t.get_child(h, l, r)
        result = t.sumVisit(h-1, a, b, prefix, low, high)
        result += t.sumVisit(h-1, c, d, prefix or (1 shl h), low, high)

    proc sum_upperbound*[BV](t: DynamicBPlusWaveletMatrix[BV], l, r, x: int): int =
        ## x 以下の和を返す。with_sum=true が必要。最悪 O(dHD)、d は区間内の異なる値数。
        ## 和は int に収まる必要がある。和用配列を持たないため更新時の追加コストはない。
        t.checkRange(l, r)
        assert t.withSum
        if x < 0: return 0
        t.sumVisit(t.height-1, l, r, 0, 0, x)

    proc sum_lowerbound*[BV](t: DynamicBPlusWaveletMatrix[BV], l, r, x: int): int =
        ## x 未満の和。最悪 O(dHD)、with_sum=true が必要。
        t.checkRange(l, r)
        assert t.withSum
        if x <= 0: return 0
        t.sum_upperbound(l, r, x-1)

    proc range_sum*[BV](t: DynamicBPlusWaveletMatrix[BV], l, r, low, high: int): int =
        ## 値が [low,high) の和。最悪 O(dHD)、with_sum=true が必要。
        t.checkRange(l, r)
        assert t.withSum
        if low >= high or high <= 0: return 0
        t.sumVisit(t.height-1, l, r, 0, max(0, low), high-1)

    proc sum_smallest*[BV](t: DynamicBPlusWaveletMatrix[BV], l, r, k: int): int =
        ## 小さい方から k 個の和。最悪 O(dHD)、with_sum=true、0<=k<=r-l。
        t.checkRange(l, r)
        assert t.withSum and 0 <= k and k <= r-l
        if k == 0: return 0
        let x = t.kth_smallest(l, r, k-1)
        t.sum_lowerbound(l, r, x)+(k-t.range_lowerbound(l, r, x))*x

    proc sum_largest*[BV](t: DynamicBPlusWaveletMatrix[BV], l, r, k: int): int =
        ## [l,r) 内の大きい方から k 個の和。最悪 O(dHD)、with_sum=true、0<=k<=r-l。
        t.checkRange(l, r)
        assert t.withSum and 0 <= k and k <= r-l
        if k == 0: return 0
        let x = t.kth_largest(l, r, k-1)
        if x == int.high: return k*x
        let greater = r-l-t.range_upperbound(l, r, x)
        t.sumVisit(t.height-1, l, r, 0, x+1, int.high)+(k-greater)*x

    proc sum_smallest_with_count*[BV](t: DynamicBPlusWaveletMatrix[BV], l, r, k: int): tuple[sum, count: int] =
        ## 小さい k 個の和と個数。最悪 O(dHD)。
        (t.sum_smallest(l, r, k), k)

    proc sum_largest_with_count*[BV](t: DynamicBPlusWaveletMatrix[BV], l, r, k: int): tuple[sum, count: int] =
        ## 大きい k 個の和と個数。最悪 O(dHD)、with_sum=true が必要。
        (t.sum_largest(l, r, k), k)

    proc sum_lowerbound_with_count*[BV](t: DynamicBPlusWaveletMatrix[BV], l, r, x: int): tuple[sum, count: int] =
        ## x 未満の和と個数。最悪 O(dHD)。
        (t.sum_lowerbound(l, r, x), t.range_lowerbound(l, r, x))

    proc sum_upperbound_with_count*[BV](t: DynamicBPlusWaveletMatrix[BV], l, r, x: int): tuple[sum, count: int] =
        ## x 以下の和と個数。最悪 O(dHD)。
        (t.sum_upperbound(l, r, x), t.range_upperbound(l, r, x))

    proc range_sum_with_count*[BV](t: DynamicBPlusWaveletMatrix[BV], l, r, low, high: int): tuple[sum, count: int] =
        ## 値が [low,high) の和と個数。最悪 O(dHD)。
        (t.range_sum(l, r, low, high), t.range_freq(l, r, low, high))

    proc validate*[BV](t: DynamicBPlusWaveletMatrix[BV]) =
        ## 検証用に全層の木と zero_count を O(NH) で確認する。
        mixin validate, len, ones
        for h, level in t.levels:
            level.validate()
            assert level.len == t.n and t.zeros[h] == t.n-level.ones
