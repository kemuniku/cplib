when not declared CPLIB_COLLECTIONS_DYNAMIC_QUATERNARY_WAVELETMATRIX_SUM:
    const CPLIB_COLLECTIONS_DYNAMIC_QUATERNARY_WAVELETMATRIX_SUM* = 1
    import bitops, options
    import cplib/collections/dynamic_quaternary_vector
    import cplib/collections/dynamic_bplus_kernels
    import cplib/collections/dynamic_bplus_sum
    ## 64bit intの固定幅列。添字・kは0始まり、位置と値の区間は半開。空列・重複可。
    ## Q=ceil(H/2)、C=32W、h=O(log_B(N/C+1)+1)とすると通常問合せO(Q(Bh+W))。
    ## 4値列の更新は償却O((B+W)h)。Dは以下でこの4値列の操作上界を表す。
    ## 各段の分割前の値を累積和付きB+木にも保持する。和のための追加領域はO(NQ)。
    ## Sを和用B+木の操作上界とすると、総和・上位k個の和はO(Q(D+S))、更新も償却O(Q(D+S))。
    ## 保持する全ての累積和、途中の和・差・積はintに収まる必要がある。標準のoverflowChecksに従う。
    ## with_sumフラグは不要。H=0は全要素0なので和用の木を持たない。
    ## 同一区間の先頭6分岐段を固定容量でキャッシュする。更新・区間変更時に無効化する。
    ## キャッシュによる漸近計算量の変更はない。問合せも内部キャッシュを書き換える。
    const quadSumCacheDepth {.intdefine.} = 6
    const quadSumWords {.intdefine.} = 192
    const quadSumPrefix {.intdefine.} = 8
    static: assert 0 <= quadSumCacheDepth and quadSumCacheDepth <= 8
    const sumCacheNodes = ((1 shl (2*quadSumCacheDepth))-1) div 3
    type SumQueryCacheNode = object
        left, right, sums, counts: array[4, int]
        groups: array[8, int]
        sumMask, groupMask: uint8
    type DynamicQuadWaveletMatrixSum*[QV] = ref object
        levels: seq[QV]
        sums: seq[DynamicBPlusSum]
        offsets: seq[array[4, int]]
        uniform: seq[int8]
        n, height: int
        signedValues: bool
        cachedL, cachedR: int
        cacheValid: array[(sumCacheNodes+63) div 64, uint64]
        cache: array[sumCacheNodes, SumQueryCacheNode]
    proc clearSumCache[QV](t: DynamicQuadWaveletMatrixSum[QV]) {.inline.} =
        ## 更新後の古い問合せキャッシュを固定個数のbitで無効化する。
        for word in t.cacheValid.mitems: word = 0
    proc refreshUniform[QV](t: DynamicQuadWaveletMatrixSum[QV], h: int) {.inline.} =
        ## 層全体が同じdigitならその値、それ以外は-1を保存する。
        let offsets = t.offsets[h]
        t.uniform[h] = -1
        for d in 0..3:
            let last = if d == 3: t.n else: offsets[d+1]
            if last-offsets[d] == t.n:
                t.uniform[h] = int8(d)
                break
    proc limits[QV](t: DynamicQuadWaveletMatrixSum[QV]): tuple[low, high: int] =
        ## 固定ビット幅の値域を返す。signedはH=1..64、非負はH=0..63。
        if t.signedValues:
            if t.height == sizeof(int)*8: return (int.low, int.high)
            let half = 1 shl (t.height-1)
            (-half, half-1)
        elif t.height == sizeof(int)*8-1: (0, int.high)
        else: (0, (1 shl t.height)-1)
    proc fits[QV](t: DynamicQuadWaveletMatrixSum[QV], x: int): bool {.inline.} =
        ## 値が固定幅に収まるか判定する。
        let bounds = t.limits()
        bounds.low <= x and x <= bounds.high
    proc encode[QV](t: DynamicQuadWaveletMatrixSum[QV], x: int): uint64 {.inline.} =
        ## signed値をHbitの昇順キーへ写像する。
        result = cast[uint64](x)
        if t.height < 64: result = result and ((1'u64 shl t.height)-1)
        if t.signedValues: result = result xor (1'u64 shl (t.height-1))
    proc decode[QV](t: DynamicQuadWaveletMatrixSum[QV], key: uint64): int {.inline.} =
        ## 昇順キーを符号拡張して元のintへ戻す。
        var value = key
        if t.signedValues:
            let sign = 1'u64 shl (t.height-1)
            value = value xor sign
            if t.height < 64 and (value and sign) != 0: value = value or not ((1'u64 shl t.height)-1)
        cast[int](value)
    proc checkRange[QV](t: DynamicQuadWaveletMatrixSum[QV], l, r: int) {.inline.} =
        ## 半開区間の境界を検査する。
        assert 0 <= l and l <= r and r <= t.n
    proc initDynamicQuadWaveletMatrixSum*[QV](values: openArray[int], T: typedesc[QV], H = -1, signedValues = false, kernel = bpkAuto): DynamicQuadWaveletMatrixSum[QV] =
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
        result = DynamicQuadWaveletMatrixSum[QV](n: values.len, height: height, signedValues: signedValues, levels: newSeq[QV](digits), sums: newSeq[DynamicBPlusSum](digits), offsets: newSeq[array[4, int]](digits), uniform: newSeq[int8](digits))
        var current = newSeq[uint64](values.len)
        var next = newSeq[uint64](values.len)
        var valuesAtLevel = newSeq[int](values.len)
        var weightsAtLevel = newSeq[int](values.len)
        for i, x in values:
            assert result.fits(x)
            current[i] = result.encode(x)
        for h in countdown(digits-1, 0):
            var counts: array[4, int]
            for i, x in current:
                let d = int((x shr (2*h)) and 3)
                valuesAtLevel[i] = d
                weightsAtLevel[i] = result.decode(x)
                inc counts[d]
            for d in 1..3: result.offsets[h][d] = result.offsets[h][d-1]+counts[d-1]
            result.refreshUniform(h)
            result.levels[h] = initQuadVector(T, valuesAtLevel, kernel)
            result.sums[h] = initDynamicBPlusSum(weightsAtLevel)
            var positions = result.offsets[h]
            for i, x in current:
                let d = valuesAtLevel[i]
                next[positions[d]] = x
                inc positions[d]
            swap(current, next)
    proc initDynamicQuadWaveletMatrixSum*(values: openArray[int], H = -1, signedValues = false, kernel = bpkAuto): DynamicQuadWaveletMatrixSum[QuadVector[16, 64]] =
        ## 既定B16・2048桁（4096bit）葉で構築する。
        initDynamicQuadWaveletMatrixSum(values, QuadVector[16, 64], H, signedValues, kernel)
    proc len*[QV](t: DynamicQuadWaveletMatrixSum[QV]): int =
        ## 要素数をO(1)で返す。
        t.n
    proc bitWidth*[QV](t: DynamicQuadWaveletMatrixSum[QV]): int =
        ## 固定ビット幅を返す。
        t.height
    proc activeKernel*[QV](t: DynamicQuadWaveletMatrixSum[QV]): BPlusKernel =
        ## 実際に使用するISAを返す。H0ではscalar。
        mixin activeKernel
        if t.levels.len == 0: bpkScalar else: t.levels[0].activeKernel()
    proc storageBytes*[QV](t: DynamicQuadWaveletMatrixSum[QV]): int =
        ## 各poolの論理確保量を合計する。capacityとallocatorは含まない。
        mixin storageBytes
        result = t.offsets.len*sizeof(array[4, int])+t.uniform.len+sizeof(t.cache)+sizeof(t.cacheValid)
        for level in t.levels: result+=level.storageBytes()
        for sums in t.sums: result+=sums.storageBytes()
    proc `[]`*[QV](t: DynamicQuadWaveletMatrixSum[QV], i: int): int =
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
    proc access*[QV](t: DynamicQuadWaveletMatrixSum[QV], i: int): int =
        ## []の別名。
        t[i]
    proc insert*[QV](t: DynamicQuadWaveletMatrixSum[QV], i, x: int) =
        ## 挿入前rankとdigit別offsetで次層へ写像する。償却O(ceil(H/2)(D+S))。
        mixin insert
        assert 0 <= i and i <= t.n and t.n < int32.high.int and t.fits(x)
        t.clearSumCache()
        let key = t.encode(x)
        var p = i
        for h in countdown(t.levels.len-1, 0):
            let d = int((key shr (2*h)) and 3)
            t.sums[h].insert(p, x)
            let before = t.levels[h].insert(p, d)
            p = t.offsets[h][d]+before
            for other in d+1..3: inc t.offsets[h][other]
        inc t.n
        for h in 0..<t.levels.len: t.refreshUniform(h)
    proc erase*[QV](t: DynamicQuadWaveletMatrixSum[QV], i: int): int {.discardable.} =
        ## 削除前rankで次層へ写像し、元の値を返す。償却O(ceil(H/2)(D+S))。
        mixin erase
        assert 0 <= i and i < t.n
        t.clearSumCache()
        var p = i
        var key = 0'u64
        for h in countdown(t.levels.len-1, 0):
            discard t.sums[h].erase(p)
            let a = t.levels[h].erase(p)
            p = t.offsets[h][a.digit]+a.rank
            key = key or (uint64(a.digit) shl (2*h))
            for other in a.digit+1..3: dec t.offsets[h][other]
        dec t.n
        for h in 0..<t.levels.len: t.refreshUniform(h)
        t.decode(key)
    proc `[]=`*[QV](t: DynamicQuadWaveletMatrixSum[QV], i, x: int) =
        ## 共通上位digitでは和だけ更新し、差が出た層以下を移動する。償却O(ceil(H/2)(D+S))。
        mixin rankAccess, replaceRank, erase, insert
        assert 0 <= i and i < t.n and t.fits(x)
        t.clearSumCache()
        let key = t.encode(x)
        var p = i
        for h in countdown(t.levels.len-1, 0):
            let d = int((key shr (2*h)) and 3)
            let oldValue = t.sums[h].replace(p, x)
            if h == t.levels.len-1 and oldValue == x: return
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
            var oldSumPositions {.noinit.}: array[32, int]
            for lower in countdown(h-1, 0):
                oldSumPositions[lower] = oldPos
                let removed = t.levels[lower].erase(oldPos)
                oldPos = t.offsets[lower][removed.digit]+removed.rank
                for other in removed.digit+1..3: dec t.offsets[lower][other]
            for lower in countdown(h-1, 0):
                let digit = int((key shr (2*lower)) and 3)
                t.sums[lower].moveReplace(oldSumPositions[lower], newPos, x)
                let rank = t.levels[lower].insert(newPos, digit)
                newPos = t.offsets[lower][digit]+rank
                for other in digit+1..3: inc t.offsets[lower][other]
            for lower in 0..h: t.refreshUniform(lower)
            return
    proc update*[QV](t: DynamicQuadWaveletMatrixSum[QV], i, x: int) =
        ## 一点変更の別名。
        t[i] = x
    proc set*[QV](t: DynamicQuadWaveletMatrixSum[QV], i, x: int) =
        ## 一点変更の別名。
        t[i] = x
    proc children[QV](t: DynamicQuadWaveletMatrixSum[QV], h, l, r: int): tuple[left, right: array[4, int]] =
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
    proc accessSuffix[QV](t: DynamicQuadWaveletMatrixSum[QV], h, p: int, prefix: uint64): int =
        ## 上位桁が確定した一要素の下位桁を復元する。O((h+1) D)。
        mixin rankAccess
        var p = p
        var key = prefix
        for lower in countdown(h, 0):
            let a = t.levels[lower].rankAccess(p)
            key = key or (uint64(a.digit) shl (2*lower))
            p = t.offsets[lower][a.digit]+a.rank
        t.decode(key)
    proc extremeValue[QV](t: DynamicQuadWaveletMatrixSum[QV], h, l, r: int, prefix: uint64, largest: static bool): int =
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
    proc kth_smallest*[QV](t: DynamicQuadWaveletMatrixSum[QV], l, r, k: int): int =
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
    proc kth_largest*[QV](t: DynamicQuadWaveletMatrixSum[QV], l, r, k: int): int =
        ## 大きい順のk番目を返す。O(ceil(H/2) D)。
        t.checkRange(l, r)
        assert 0 <= k and k < r-l
        if k == 0: t.extremeValue(t.levels.len-1, l, r, 0'u64, true)
        else: t.kth_smallest(l, r, r-l-1-k)
    proc range_lowerbound*[QV](t: DynamicQuadWaveletMatrixSum[QV], l, r, x: int): int =
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
    proc range_upperbound*[QV](t: DynamicQuadWaveletMatrixSum[QV], l, r, x: int): int =
        ## x以下の個数。int.highで加算しない。
        t.checkRange(l, r)
        if x == int.high: r-l else: t.range_lowerbound(l, r, x+1)
    proc range_freq*[QV](t: DynamicQuadWaveletMatrixSum[QV], l, r, low, high: int): int =
        ## 値が[low,high)の個数。low>=highなら0。
        t.checkRange(l, r)
        if low >= high: return 0
        t.range_lowerbound(l, r, high)-t.range_lowerbound(l, r, low)
    proc count*[QV](t: DynamicQuadWaveletMatrixSum[QV], l, r, x: int): int =
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
    proc rank*[QV](t: DynamicQuadWaveletMatrixSum[QV], r, x: int): int =
        ## [0,r)のxの個数。引数順はr,x。
        t.count(0, r, x)
    proc select*[QV](t: DynamicQuadWaveletMatrixSum[QV], k, x: int): int =
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
    proc adjacentValue[QV](t: DynamicQuadWaveletMatrixSum[QV], l, r, x: int, successor: static bool): Option[int] =
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
    proc prev_value*[QV](t: DynamicQuadWaveletMatrixSum[QV], l, r, x: int): Option[int] =
        ## x未満の最大値。未存在はnone。O(ceil(H/2) D)。
        t.adjacentValue(l, r, x, false)
    proc next_value*[QV](t: DynamicQuadWaveletMatrixSum[QV], l, r, x: int): Option[int] =
        ## x以上の最小値。未存在はnone。O(ceil(H/2) D)。
        t.adjacentValue(l, r, x, true)
    proc validate*[QV](t: DynamicQuadWaveletMatrixSum[QV]) =
        ## 各層の木・offset・最上位の未使用digitを検証する。
        mixin validate, total, len
        for h, level in t.levels:
            level.validate()
            t.sums[h].validate()
            assert t.sums[h].len == t.n
            if t.uniform[h] >= 0:
                assert level.total(int(t.uniform[h])) == t.n
            assert level.len == t.n
            var offset = 0
            for d in 0..3:
                assert t.offsets[h][d] == offset
                offset+=level.total(d)
            assert offset == t.n
        if t.height mod 2 == 1:
            assert t.levels[^1].total(2) == 0 and t.levels[^1].total(3) == 0
    proc get_children*[QV](t: DynamicQuadWaveletMatrixSum[QV], h, l, r: int): tuple[left, right: array[4, int]] =
        ## 桁層hの4子区間を返す。h=0は最下位2bit。
        t.checkRange(l, r)
        assert 0 <= h and h < t.levels.len
        t.children(h, l, r)
    proc subtreeSum[QV](t: DynamicQuadWaveletMatrixSum[QV], h, l, r: int, prefix: uint64): int {.inline.} =
        ## 部分木の和を保持したB+木から取得する。末端は同じ値の個数との積。
        if l == r: return 0
        if h < 0: t.decode(prefix)*(r-l)
        else: t.sums[h].range_sum(l, r)

    proc sumVisit[QV](t: DynamicQuadWaveletMatrixSum[QV], h, l, r: int, prefix, low, high: uint64): tuple[sum, count: int] =
        ## 値域の境界だけ降下し、完全に含まれる部分木は保持した和で打ち切る。
        if l == r: return
        let mask = if h >= 31: uint64.high else: (1'u64 shl (2*(h+1)))-1
        let last = prefix or mask
        if last < low or prefix > high: return
        if low <= prefix and last <= high:
            return (t.subtreeSum(h, l, r, prefix), r-l)
        let c = t.children(h, l, r)
        for d in 0..3:
            let part = t.sumVisit(h-1, c.left[d], c.right[d], prefix or (uint64(d) shl (2*h)), low, high)
            result.sum += part.sum
            result.count += part.count

    proc range_sum*[QV](t: DynamicQuadWaveletMatrixSum[QV], l, r: int): int =
        ## [l,r)全体の和をO(S)で返す。
        t.checkRange(l, r)
        t.subtreeSum(t.levels.len-1, l, r, 0'u64)

    proc sum_upperbound_with_count*[QV](t: DynamicQuadWaveletMatrixSum[QV], l, r, x: int): tuple[sum, count: int] =
        ## x以下の和と個数を同時にO(ceil(H/2)(D+S))で返す。
        t.checkRange(l, r)
        let bounds = t.limits()
        if x < bounds.low: return
        if x >= bounds.high: return (t.range_sum(l, r), r-l)
        t.sumVisit(t.levels.len-1, l, r, 0'u64, 0'u64, t.encode(x))

    proc sum_lowerbound_with_count*[QV](t: DynamicQuadWaveletMatrixSum[QV], l, r, x: int): tuple[sum, count: int] =
        ## x未満の和と個数を同時にO(ceil(H/2)(D+S))で返す。
        t.checkRange(l, r)
        if x <= t.limits().low: return
        t.sum_upperbound_with_count(l, r, x-1)

    proc range_sum_with_count*[QV](t: DynamicQuadWaveletMatrixSum[QV], l, r, low, high: int): tuple[sum, count: int] =
        ## [low,high)の和と個数をO(ceil(H/2)(D+S))で返す。範囲外の和は計算しない。
        t.checkRange(l, r)
        let bounds = t.limits()
        if low >= high or high <= bounds.low or low > bounds.high: return
        t.sumVisit(t.levels.len-1, l, r, 0'u64, t.encode(max(low, bounds.low)), t.encode(min(high-1, bounds.high)))

    proc sum_upperbound*[QV](t: DynamicQuadWaveletMatrixSum[QV], l, r, x: int): int =
        ## x以下の和をO(ceil(H/2)(D+S))で返す。
        t.sum_upperbound_with_count(l, r, x).sum

    proc sum_lowerbound*[QV](t: DynamicQuadWaveletMatrixSum[QV], l, r, x: int): int =
        ## x未満の和をO(ceil(H/2)(D+S))で返す。
        t.sum_lowerbound_with_count(l, r, x).sum

    proc range_sum*[QV](t: DynamicQuadWaveletMatrixSum[QV], l, r, low, high: int): int =
        ## 値が[low,high)の和をO(ceil(H/2)(D+S))で返す。
        t.range_sum_with_count(l, r, low, high).sum

    proc sumK[QV](t: DynamicQuadWaveletMatrixSum[QV], l, r, k: int, largest: static bool): int =
        ## 必要な子だけ降下する。同一区間の先頭固定段だけ再利用し、計算量はO(H(D+S))のまま。
        t.checkRange(l, r)
        assert 0 <= k and k <= r-l
        if k == 0: return 0
        if k == r-l: return t.range_sum(l, r)
        when quadSumCacheDepth > 0:
            if l != t.cachedL or r != t.cachedR:
                t.clearSumCache()
                t.cachedL = l
                t.cachedR = r
        var l = l
        var r = r
        var k = k
        var key = 0'u64
        var cacheIndex = 0
        var cacheDepth = 0
        for h in countdown(t.levels.len-1, 0):
            if t.uniform[h] >= 0:
                key = key or (uint64(t.uniform[h]) shl (2*h))
                continue
            var c: tuple[left, right: array[4, int]]
            let cached = cacheDepth < quadSumCacheDepth
            inc cacheDepth
            if cached:
                let bit = 1'u64 shl (cacheIndex and 63)
                if (t.cacheValid[cacheIndex shr 6] and bit) == 0:
                    c = t.children(h, l, r)
                    t.cache[cacheIndex].left = c.left
                    t.cache[cacheIndex].right = c.right
                    t.cache[cacheIndex].sumMask = 0
                    t.cache[cacheIndex].groupMask = 0
                    var count = 0
                    for d in 0..3:
                        count += c.right[d]-c.left[d]
                        t.cache[cacheIndex].counts[d] = count
                    t.cacheValid[cacheIndex shr 6] = t.cacheValid[cacheIndex shr 6] or bit
                let node = addr t.cache[cacheIndex]
                let rank = (when largest: r-l-k else: k-1)
                let d = if rank < node.counts[1]: int(rank >= node.counts[0])
                    else: 2+int(rank >= node.counts[2])
                let group = d+(when largest: 4 else: 0)
                let groupBit = 1'u8 shl group
                if (node.groupMask and groupBit) == 0:
                    var total = 0
                    for order in 0..3:
                        let digit = (when largest: 3-order else: order)
                        if digit == d: break
                        let sumBit = 1'u8 shl digit
                        if (node.sumMask and sumBit) == 0:
                            node.sums[digit] = t.subtreeSum(h-1, node.left[digit], node.right[digit], key or (uint64(digit) shl (2*h)))
                            node.sumMask = node.sumMask or sumBit
                        total += node.sums[digit]
                    node.groups[group] = total
                    node.groupMask = node.groupMask or groupBit
                result += node.groups[group]
                when largest: k -= r-l-node.counts[d]
                else:
                    if d > 0: k -= node.counts[d-1]
                key = key or (uint64(d) shl (2*h))
                l = node.left[d]
                r = node.right[d]
                if k == r-l:
                    let sumBit = 1'u8 shl d
                    if (node.sumMask and sumBit) == 0:
                        node.sums[d] = t.subtreeSum(h-1, l, r, key)
                        node.sumMask = node.sumMask or sumBit
                    result += node.sums[d]
                    return
                cacheIndex = cacheIndex*4+1+d
                continue
            c = t.children(h, l, r)
            for order in 0..3:
                let d = (when largest: 3-order else: order)
                let count = c.right[d]-c.left[d]
                if count == 0: continue
                let prefix = key or (uint64(d) shl (2*h))
                if k < count:
                    key = prefix
                    l = c.left[d]
                    r = c.right[d]
                    break
                result += t.subtreeSum(h-1, c.left[d], c.right[d], prefix)
                k -= count
                if k == 0: return
        result += t.decode(key)*k

    proc sum_smallest*[QV](t: DynamicQuadWaveletMatrixSum[QV], l, r, k: int): int =
        ## 小さいk個の和を1回の降下、O(ceil(H/2)(D+S))で返す。
        t.checkRange(l, r)
        assert 0 <= k and k <= r-l
        if not t.signedValues and k > (r-l) div 2:
            t.range_sum(l, r)-t.sumK(l, r, r-l-k, true)
        else: t.sumK(l, r, k, false)

    proc sum_largest*[QV](t: DynamicQuadWaveletMatrixSum[QV], l, r, k: int): int =
        ## 大きいk個の和を1回の降下、O(ceil(H/2)(D+S))で返す。
        t.checkRange(l, r)
        assert 0 <= k and k <= r-l
        if not t.signedValues and k > (r-l) div 2:
            t.range_sum(l, r)-t.sumK(l, r, r-l-k, false)
        else: t.sumK(l, r, k, true)

    proc countForSum[QV](t: DynamicQuadWaveletMatrixSum[QV], l, r, target: int, largest: static bool): int =
        ## 指定順の累積和がtarget以上になる最小個数を1回の降下、O(ceil(H/2)(D+S))で返す。
        t.checkRange(l, r)
        assert not t.signedValues
        if target <= 0: return 0
        if t.range_sum(l, r) < target: return -1
        var l = l
        var r = r
        var remaining = target
        var key = 0'u64
        for h in countdown(t.levels.len-1, 0):
            if r-l == 1: return result+1
            if t.uniform[h] >= 0:
                key = key or (uint64(t.uniform[h]) shl (2*h))
                continue
            let c = t.children(h, l, r)
            for order in 0..3:
                let d = (when largest: 3-order else: order)
                let count = c.right[d]-c.left[d]
                if count == 0: continue
                let prefix = key or (uint64(d) shl (2*h))
                let sum = t.subtreeSum(h-1, c.left[d], c.right[d], prefix)
                if sum < remaining:
                    remaining -= sum
                    result += count
                else:
                    key = prefix
                    l = c.left[d]
                    r = c.right[d]
                    break
        let value = t.decode(key)
        result += (remaining-1) div value+1

    proc min_count_smallest_for_sum*[QV](t: DynamicQuadWaveletMatrixSum[QV], l, r, target: int): int =
        ## [l,r)を小さい順に足し、和がtarget以上になる最小個数。O(ceil(H/2)(D+S))。
        ## signedValues=false専用。target<=0は0、区間全体の和が不足する場合は-1。先頭の0も個数に含む。
        t.countForSum(l, r, target, false)

    proc min_count_largest_for_sum*[QV](t: DynamicQuadWaveletMatrixSum[QV], l, r, target: int): int =
        ## [l,r)を大きい順に足し、和がtarget以上になる最小個数。O(ceil(H/2)(D+S))。
        ## signedValues=false専用。target<=0は0、区間全体の和が不足する場合は-1。
        t.countForSum(l, r, target, true)

    proc min_count_for_sum*[QV](t: DynamicQuadWaveletMatrixSum[QV], l, r, target: int): int =
        ## min_count_largest_for_sumの別名。和がtarget以上になるよう選ぶ最小個数を返す。
        t.min_count_largest_for_sum(l, r, target)

    proc sum_smallest_with_count*[QV](t: DynamicQuadWaveletMatrixSum[QV], l, r, k: int): tuple[sum, count: int] =
        ## 小さいk個の和と個数を返す。
        (t.sum_smallest(l, r, k), k)

    proc sum_largest_with_count*[QV](t: DynamicQuadWaveletMatrixSum[QV], l, r, k: int): tuple[sum, count: int] =
        ## 大きいk個の和と個数を返す。
        (t.sum_largest(l, r, k), k)

    proc initDynamicQuadWaveletMatrixSumFast*(values: openArray[int], H = -1, signedValues = false, kernel = bpkAuto): DynamicQuadWaveletMatrixSum[QuadVector[32, quadSumWords, quadSumPrefix, 63]] =
        ## 総和問合せ向けに調整したB32・6144桁葉・8ワードprefixと六最適化で構築する。
        ## CLI設定は不要。H・符号・ISAの契約は通常コンストラクタと同じ。
        initDynamicQuadWaveletMatrixSum(values, QuadVector[32, quadSumWords, quadSumPrefix, 63], H, signedValues, kernel)
