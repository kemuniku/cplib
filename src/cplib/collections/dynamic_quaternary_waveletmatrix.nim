when not declared CPLIB_COLLECTIONS_DYNAMIC_QUATERNARY_WAVELETMATRIX:
    const CPLIB_COLLECTIONS_DYNAMIC_QUATERNARY_WAVELETMATRIX* = 1
    import bitops, options
    import cplib/collections/dynamic_quaternary_vector
    import cplib/collections/dynamic_bplus_kernels
    ## 64bit intの固定幅列。添字・kは0始まり、位置と値の区間は半開。空列・重複可。
    ## Q=ceil(H/2)、C=32W、h=O(log_B(N/C+1)+1)とすると通常問合せO(Q(Bh+W))。
    ## 更新はプール再確保を含め償却O(Q(B+W)h)。Dは以下でこの4値列の上界を表す。
    ## sumのdは問い合わせ区間の異なる値の数。追加の和配列は持たず、最悪O(dQD)。
    ## 和は中間積・中間和もint内が必要。標準のoverflowChecksを切ると検査されない。
    type DynamicQuadWaveletMatrix*[QV] = ref object
        levels: seq[QV]
        offsets: seq[array[4, int]]
        n, height: int
        signedValues, withSum: bool
    proc limits[QV](t: DynamicQuadWaveletMatrix[QV]): tuple[low, high: int] =
        ## 固定ビット幅の値域を返す。signedはH=1..64、非負はH=0..63。
        if t.signedValues:
            if t.height == sizeof(int)*8: return (int.low, int.high)
            let half = 1 shl (t.height-1)
            (-half, half-1)
        elif t.height == sizeof(int)*8-1: (0, int.high)
        else: (0, (1 shl t.height)-1)
    proc fits[QV](t: DynamicQuadWaveletMatrix[QV], x: int): bool {.inline.} =
        ## 値が固定幅に収まるか判定する。
        let bounds = t.limits()
        bounds.low <= x and x <= bounds.high
    proc encode[QV](t: DynamicQuadWaveletMatrix[QV], x: int): uint64 {.inline.} =
        ## signed値をHbitの昇順キーへ写像する。
        result = cast[uint64](x)
        if t.height < 64: result = result and ((1'u64 shl t.height)-1)
        if t.signedValues: result = result xor (1'u64 shl (t.height-1))
    proc decode[QV](t: DynamicQuadWaveletMatrix[QV], key: uint64): int {.inline.} =
        ## 昇順キーを符号拡張して元のintへ戻す。
        var value = key
        if t.signedValues:
            let sign = 1'u64 shl (t.height-1)
            value = value xor sign
            if t.height < 64 and (value and sign) != 0: value = value or not ((1'u64 shl t.height)-1)
        cast[int](value)
    proc checkRange[QV](t: DynamicQuadWaveletMatrix[QV], l, r: int) {.inline.} =
        ## 半開区間の境界を検査する。
        assert 0 <= l and l <= r and r <= t.n
    proc initDynamicQuadWaveletMatrix*[QV](values: openArray[int], T: typedesc[QV], H = -1, signedValues = false, kernel = bpkAuto, with_sum = false): DynamicQuadWaveletMatrix[QV] =
        ## 4値の0,1,2,3順に安定分割して構築。O(N ceil(H/2))、N<=int32.high。
        ## Hは固定。奇数Hの最上位層は1bit。signedのH=-1はint全幅、非負は初期最大から推論。
        mixin initQuadVector
        assert sizeof(int) == 8
        var height = H
        if height == -1:
            if signedValues: height = 64
            else:
                var maximum = 0
                for x in values:
                    assert x >= 0
                    maximum = max(maximum, x)
                height = if maximum == 0: 1 else: fastLog2(maximum)+1
        assert height >= (if signedValues: 1 else: 0) and height <= (if signedValues: 64 else: 63)
        assert values.len <= int32.high.int
        let digits = (height+1) div 2
        result = DynamicQuadWaveletMatrix[QV](n: values.len, height: height, signedValues: signedValues, withSum: with_sum, levels: newSeq[QV](digits), offsets: newSeq[array[4, int]](digits))
        var current = newSeq[uint64](values.len)
        var next = newSeq[uint64](values.len)
        var valuesAtLevel = newSeq[int](values.len)
        for i, x in values:
            assert result.fits(x)
            current[i] = result.encode(x)
        for h in countdown(digits-1, 0):
            var counts: array[4, int]
            for i, x in current:
                let d = int((x shr (2*h)) and 3)
                valuesAtLevel[i] = d
                inc counts[d]
            for d in 1..3: result.offsets[h][d] = result.offsets[h][d-1]+counts[d-1]
            result.levels[h] = initQuadVector(T, valuesAtLevel, kernel)
            var positions = result.offsets[h]
            for i, x in current:
                let d = valuesAtLevel[i]
                next[positions[d]] = x
                inc positions[d]
            swap(current, next)
    proc initDynamicQuadWaveletMatrix*(values: openArray[int], H = -1, signedValues = false, kernel = bpkAuto, with_sum = false): DynamicQuadWaveletMatrix[QuadVector[16, 64]] =
        ## 既定B16・2048桁（4096bit）葉で構築する。
        initDynamicQuadWaveletMatrix(values, QuadVector[16, 64], H, signedValues, kernel, with_sum)
    proc len*[QV](t: DynamicQuadWaveletMatrix[QV]): int =
        ## 要素数をO(1)で返す。
        t.n
    proc bitWidth*[QV](t: DynamicQuadWaveletMatrix[QV]): int =
        ## 固定ビット幅を返す。
        t.height
    proc activeKernel*[QV](t: DynamicQuadWaveletMatrix[QV]): BPlusKernel =
        ## 実際に使用するISAを返す。H0ではscalar。
        mixin activeKernel
        if t.levels.len == 0: bpkScalar else: t.levels[0].activeKernel()
    proc storageBytes*[QV](t: DynamicQuadWaveletMatrix[QV]): int =
        ## 各poolの論理確保量を合計する。capacityとallocatorは含まない。
        mixin storageBytes
        result = t.offsets.len*sizeof(array[4, int])
        for level in t.levels: result+=level.storageBytes()
    proc `[]`*[QV](t: DynamicQuadWaveletMatrix[QV], i: int): int =
        ## 要素をO(ceil(H/2) D)で取得する。Dは4値列のrank/update計算量。
        mixin rankAccess
        assert 0 <= i and i < t.n
        var p = i
        var key = 0'u64
        for h in countdown(t.levels.len-1, 0):
            let a = t.levels[h].rankAccess(p)
            key = key or (uint64(a.digit) shl (2*h))
            p = t.offsets[h][a.digit]+a.rank
        t.decode(key)
    proc access*[QV](t: DynamicQuadWaveletMatrix[QV], i: int): int =
        ## []の別名。
        t[i]
    proc insert*[QV](t: DynamicQuadWaveletMatrix[QV], i, x: int) =
        ## 挿入前rankとdigit別offsetで次層へ写像する。償却O(ceil(H/2) D)。
        mixin insert
        assert 0 <= i and i <= t.n and t.n < int32.high.int and t.fits(x)
        let key = t.encode(x)
        var p = i
        for h in countdown(t.levels.len-1, 0):
            let d = int((key shr (2*h)) and 3)
            let before = t.levels[h].insert(p, d)
            p = t.offsets[h][d]+before
            for other in d+1..3: inc t.offsets[h][other]
        inc t.n
    proc erase*[QV](t: DynamicQuadWaveletMatrix[QV], i: int): int {.discardable.} =
        ## 削除前rankで次層へ写像し、元の値を返す。償却O(ceil(H/2) D)。
        mixin erase
        assert 0 <= i and i < t.n
        var p = i
        var key = 0'u64
        for h in countdown(t.levels.len-1, 0):
            let a = t.levels[h].erase(p)
            p = t.offsets[h][a.digit]+a.rank
            key = key or (uint64(a.digit) shl (2*h))
            for other in a.digit+1..3: dec t.offsets[h][other]
        dec t.n
        t.decode(key)
    proc `[]=`*[QV](t: DynamicQuadWaveletMatrix[QV], i, x: int) =
        ## 共通上位digitの層は変更せず、差が出た層以下を更新する。償却O(ceil(H/2) D)。
        mixin rankAccess, replaceRank, erase, insert
        assert 0 <= i and i < t.n and t.fits(x)
        let key = t.encode(x)
        var p = i
        for h in countdown(t.levels.len-1, 0):
            let d = int((key shr (2*h)) and 3)
            var oldPos, newPos: int
            when compiles(t.levels[h].replaceRank(p, d)):
                let a = t.levels[h].replaceRank(p, d)
                if a.oldDigit == d:
                    p = t.offsets[h][d]+a.oldRank
                    continue
                oldPos = t.offsets[h][a.oldDigit]+a.oldRank
                for other in a.oldDigit+1..3: dec t.offsets[h][other]
                newPos = t.offsets[h][d]+a.newRank
                for other in d+1..3: inc t.offsets[h][other]
            else:
                let a = t.levels[h].rankAccess(p)
                if a.digit == d:
                    p = t.offsets[h][d]+a.rank
                    continue
                oldPos = t.offsets[h][a.digit]+a.rank
                discard t.levels[h].erase(p)
                for other in a.digit+1..3: dec t.offsets[h][other]
                let before = t.levels[h].insert(p, d)
                newPos = t.offsets[h][d]+before
                for other in d+1..3: inc t.offsets[h][other]
            for lower in countdown(h-1, 0):
                let removed = t.levels[lower].erase(oldPos)
                oldPos = t.offsets[lower][removed.digit]+removed.rank
                for other in removed.digit+1..3: dec t.offsets[lower][other]
            for lower in countdown(h-1, 0):
                let digit = int((key shr (2*lower)) and 3)
                let rank = t.levels[lower].insert(newPos, digit)
                newPos = t.offsets[lower][digit]+rank
                for other in digit+1..3: inc t.offsets[lower][other]
            return
    proc update*[QV](t: DynamicQuadWaveletMatrix[QV], i, x: int) =
        ## 一点変更の別名。
        t[i] = x
    proc set*[QV](t: DynamicQuadWaveletMatrix[QV], i, x: int) =
        ## 一点変更の別名。
        t[i] = x
    proc children[QV](t: DynamicQuadWaveletMatrix[QV], h, l, r: int): tuple[left, right: array[4, int]] =
        ## 各digitの子区間を0,1,2,3順で返す。
        mixin ranks, ranksPair
        when compiles(t.levels[h].ranksPair(l, r)):
            let a = t.levels[h].ranksPair(l, r)
            result = a
        else:
            result.left = t.levels[h].ranks(l)
            result.right = t.levels[h].ranks(r)
        for d in 0..3:
            result.left[d]+=t.offsets[h][d]
            result.right[d]+=t.offsets[h][d]
    proc accessSuffix[QV](t: DynamicQuadWaveletMatrix[QV], h, p: int, prefix: uint64): int =
        ## 上位桁が確定した一要素の下位桁を復元する。O((h+1) D)。
        mixin rankAccess
        var p = p
        var key = prefix
        for lower in countdown(h, 0):
            let a = t.levels[lower].rankAccess(p)
            key = key or (uint64(a.digit) shl (2*lower))
            p = t.offsets[lower][a.digit]+a.rank
        t.decode(key)
    proc extremeValue[QV](t: DynamicQuadWaveletMatrix[QV], h, l, r: int, prefix: uint64, largest: static bool): int =
        ## 上位桁が確定した非空区間の最小値・最大値を返す。O((h+1) D)。
        var l = l
        var r = r
        var key = prefix
        for lower in countdown(h, 0):
            if r-l == 1: return t.accessSuffix(lower, l, key)
            let c = t.children(lower, l, r)
            var d = (if largest: 3 else: 0)
            while c.left[d] == c.right[d]:
                when largest: dec d
                else: inc d
            key = key or (uint64(d) shl (2*lower))
            l = c.left[d]
            r = c.right[d]
        t.decode(key)
    proc kth_smallest*[QV](t: DynamicQuadWaveletMatrix[QV], l, r, k: int): int =
        ## 小さい順にk番目を返す。0始まり、O(ceil(H/2) D)。
        t.checkRange(l, r)
        assert 0 <= k and k < r-l
        var l = l
        var r = r
        var k = k
        var key = 0'u64
        for h in countdown(t.levels.len-1, 0):
            if r-l == 1: return t.accessSuffix(h, l, key)
            let c = t.children(h, l, r)
            for d in 0..3:
                let n = c.right[d]-c.left[d]
                if k < n:
                    key = key or (uint64(d) shl (2*h))
                    l = c.left[d]
                    r = c.right[d]
                    break
                k-=n
        t.decode(key)
    proc kth_largest*[QV](t: DynamicQuadWaveletMatrix[QV], l, r, k: int): int =
        ## 大きい順のk番目を返す。O(ceil(H/2) D)。
        t.checkRange(l, r)
        assert 0 <= k and k < r-l
        if k == 0: t.extremeValue(t.levels.len-1, l, r, 0'u64, true)
        else: t.kth_smallest(l, r, r-l-1-k)
    proc range_lowerbound*[QV](t: DynamicQuadWaveletMatrix[QV], l, r, x: int): int =
        ## [l,r)のx未満の個数。しきい値は固定値域外でもよい。O(ceil(H/2) D)。
        t.checkRange(l, r)
        let bounds = t.limits()
        if x <= bounds.low: return 0
        if x > bounds.high: return r-l
        let key = t.encode(x)
        var l = l
        var r = r
        for h in countdown(t.levels.len-1, 0):
            if l == r: break
            let d = int((key shr (2*h)) and 3)
            let c = t.children(h, l, r)
            for smaller in 0..<d: result+=c.right[smaller]-c.left[smaller]
            l = c.left[d]
            r = c.right[d]
    proc range_upperbound*[QV](t: DynamicQuadWaveletMatrix[QV], l, r, x: int): int =
        ## x以下の個数。int.highで加算しない。
        t.checkRange(l, r)
        if x == int.high: r-l else: t.range_lowerbound(l, r, x+1)
    proc range_freq*[QV](t: DynamicQuadWaveletMatrix[QV], l, r, low, high: int): int =
        ## 値が[low,high)の個数。low>=highなら0。
        t.checkRange(l, r)
        if low >= high: return 0
        t.range_lowerbound(l, r, high)-t.range_lowerbound(l, r, low)
    proc count*[QV](t: DynamicQuadWaveletMatrix[QV], l, r, x: int): int =
        ## [l,r)内のxの個数。O(ceil(H/2) D)。
        mixin rankPair
        t.checkRange(l, r)
        if not t.fits(x): return 0
        let key = t.encode(x)
        var l = l
        var r = r
        for h in countdown(t.levels.len-1, 0):
            if l == r: return 0
            let d = int((key shr (2*h)) and 3)
            let a = t.levels[h].rankPair(l, r, d)
            l = t.offsets[h][d]+a.left
            r = t.offsets[h][d]+a.right
        r-l
    proc rank*[QV](t: DynamicQuadWaveletMatrix[QV], r, x: int): int =
        ## [0,r)のxの個数。引数順はr,x。
        t.count(0, r, x)
    proc select*[QV](t: DynamicQuadWaveletMatrix[QV], k, x: int): int =
        ## xのk番目の元位置。引数順k,x。未存在なら-1。
        mixin rankPair, select
        if k < 0 or not t.fits(x): return -1
        let key = t.encode(x)
        var l = 0
        var r = t.n
        for h in countdown(t.levels.len-1, 0):
            if k >= r-l: return -1
            let d = int((key shr (2*h)) and 3)
            let a = t.levels[h].rankPair(l, r, d)
            l = t.offsets[h][d]+a.left
            r = t.offsets[h][d]+a.right
        if k >= r-l: return -1
        result = l+k
        for h in 0..<t.levels.len:
            let d = int((key shr (2*h)) and 3)
            result = t.levels[h].select(d, result-t.offsets[h][d])
    proc adjacentValue[QV](t: DynamicQuadWaveletMatrix[QV], l, r, x: int, successor: static bool): Option[int] =
        ## しきい値との共通上位桁を再利用して隣接値を探す。O(ceil(H/2) D)。
        t.checkRange(l, r)
        if l == r: return none(int)
        let bounds = t.limits()
        when successor:
            if x > bounds.high: return none(int)
            if x <= bounds.low: return some(t.extremeValue(t.levels.len-1, l, r, 0'u64, false))
        else:
            if x <= bounds.low: return none(int)
            if x > bounds.high: return some(t.extremeValue(t.levels.len-1, l, r, 0'u64, true))
        let key = t.encode(x)
        var l = l
        var r = r
        var prefix = 0'u64
        var candidateH = -2
        var candidateL, candidateR: int
        var candidateKey: uint64
        for h in countdown(t.levels.len-1, 0):
            if l == r: break
            if r-l == 1:
                let value = t.accessSuffix(h, l, prefix)
                when successor:
                    if value >= x: return some(value)
                else:
                    if value < x: return some(value)
                l = r
                break
            let d = int((key shr (2*h)) and 3)
            let c = t.children(h, l, r)
            var sibling = d+(if successor: 1 else: -1)
            while 0 <= sibling and sibling <= 3:
                if c.left[sibling] < c.right[sibling]:
                    candidateH = h-1
                    candidateL = c.left[sibling]
                    candidateR = c.right[sibling]
                    candidateKey = prefix or (uint64(sibling) shl (2*h))
                    break
                when successor: inc sibling
                else: dec sibling
            prefix = prefix or (uint64(d) shl (2*h))
            l = c.left[d]
            r = c.right[d]
        when successor:
            if l < r: return some(x)
        if candidateH == -2: return none(int)
        some(t.extremeValue(candidateH, candidateL, candidateR, candidateKey, not successor))
    proc prev_value*[QV](t: DynamicQuadWaveletMatrix[QV], l, r, x: int): Option[int] =
        ## x未満の最大値。未存在はnone。O(ceil(H/2) D)。
        t.adjacentValue(l, r, x, false)
    proc next_value*[QV](t: DynamicQuadWaveletMatrix[QV], l, r, x: int): Option[int] =
        ## x以上の最小値。未存在はnone。O(ceil(H/2) D)。
        t.adjacentValue(l, r, x, true)
    proc validate*[QV](t: DynamicQuadWaveletMatrix[QV]) =
        ## 各層の木・offset・最上位の未使用digitを検証する。
        mixin validate, total, len
        for h, level in t.levels:
            level.validate()
            assert level.len == t.n
            var offset = 0
            for d in 0..3:
                assert t.offsets[h][d] == offset
                offset+=level.total(d)
            assert offset == t.n
        if t.height mod 2 == 1:
            assert t.levels[^1].total(2) == 0 and t.levels[^1].total(3) == 0
    proc get_children*[QV](t: DynamicQuadWaveletMatrix[QV], h, l, r: int): tuple[left, right: array[4, int]] =
        ## 桁層hの4子区間を返す。h=0は最下位2bit。
        t.checkRange(l, r)
        assert 0 <= h and h < t.levels.len
        t.children(h, l, r)
    proc sumVisit[QV](t: DynamicQuadWaveletMatrix[QV], h, l, r: int, prefix, low, high: uint64): int =
        ## 符号変換済みキー区間を巡回する。和用の追加配列は持たない。
        if l == r: return 0
        let mask = if h >= 31: uint64.high else: (1'u64 shl (2*(h+1)))-1
        if (prefix or mask) < low or prefix > high: return 0
        if h < 0: return t.decode(prefix)*(r-l)
        let c = t.children(h, l, r)
        for d in 0..3: result+=t.sumVisit(h-1, c.left[d], c.right[d], prefix or (uint64(d) shl (2*h)), low, high)
    proc sum_upperbound*[QV](t: DynamicQuadWaveletMatrix[QV], l, r, x: int): int =
        ## x以下の和。with_sum=true、最悪O(d ceil(H/2) D)。中間積/和もint内であること。
        t.checkRange(l, r)
        assert t.withSum
        let bounds = t.limits()
        if x < bounds.low: return 0
        t.sumVisit(t.levels.len-1, l, r, 0'u64, 0'u64, t.encode(min(x, bounds.high)))
    proc sum_lowerbound*[QV](t: DynamicQuadWaveletMatrix[QV], l, r, x: int): int =
        ## x未満の和。with_sum=true、最悪O(d ceil(H/2) D)。
        t.checkRange(l, r)
        assert t.withSum
        if x <= t.limits().low: return 0
        t.sum_upperbound(l, r, x-1)
    proc range_sum*[QV](t: DynamicQuadWaveletMatrix[QV], l, r, low, high: int): int =
        ## 値が[low,high)の和。with_sum=true、最悪O(d ceil(H/2) D)。
        t.checkRange(l, r)
        assert t.withSum
        let bounds = t.limits()
        if low >= high or high <= bounds.low or low > bounds.high: return 0
        t.sumVisit(t.levels.len-1, l, r, 0'u64, t.encode(max(low, bounds.low)), t.encode(min(high-1, bounds.high)))
    proc sum_smallest*[QV](t: DynamicQuadWaveletMatrix[QV], l, r, k: int): int =
        ## 小さい方からk個の和。with_sum=true、0<=k<=r-l。
        t.checkRange(l, r)
        assert t.withSum and 0 <= k and k <= r-l
        if k == 0: return 0
        let x = t.kth_smallest(l, r, k-1)
        t.sum_lowerbound(l, r, x)+(k-t.range_lowerbound(l, r, x))*x
    proc sum_smallest_with_count*[QV](t: DynamicQuadWaveletMatrix[QV], l, r, k: int): tuple[sum, count: int] =
        ## 小さいk個の和と個数を返す。
        (t.sum_smallest(l, r, k), k)
    proc sum_lowerbound_with_count*[QV](t: DynamicQuadWaveletMatrix[QV], l, r, x: int): tuple[sum, count: int] =
        ## x未満の和と個数を返す。
        (t.sum_lowerbound(l, r, x), t.range_lowerbound(l, r, x))
    proc sum_upperbound_with_count*[QV](t: DynamicQuadWaveletMatrix[QV], l, r, x: int): tuple[sum, count: int] =
        ## x以下の和と個数を返す。
        (t.sum_upperbound(l, r, x), t.range_upperbound(l, r, x))
    proc range_sum_with_count*[QV](t: DynamicQuadWaveletMatrix[QV], l, r, low, high: int): tuple[sum, count: int] =
        ## [low,high)の和と個数を返す。
        (t.range_sum(l, r, low, high), t.range_freq(l, r, low, high))
