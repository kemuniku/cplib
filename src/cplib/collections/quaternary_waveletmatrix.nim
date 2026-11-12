when not declared CPLIB_COLLECTIONS_QUATERNARY_WAVELETMATRIX:
    const CPLIB_COLLECTIONS_QUATERNARY_WAVELETMATRIX* = 1
    import bitops, options

    when (defined(amd64) or defined(i386)) and (defined(gcc) or defined(clang)):
        {.passC: "-mpopcnt".}

    when defined(release) and not defined(debug):
        {.push boundChecks: off, overflowChecks: off.}

    const quadScanLimit = 64

    type
        QuadRankBlock = object
            low, high: uint64
            prefix: array[3, int]
        QuadWaveletLevel = object
            blocks: seq[QuadRankBlock]
            offsets: array[4, int]
            prefix_sum: seq[int]
        QuadWaveletMatrix* = ref object
            dat: seq[QuadWaveletLevel]
            H, N: int
            with_sum: bool
            prefix_sum: seq[int]
            scan_h: int
            scan_values: seq[int]

    proc rank_less[b: static int](word: QuadRankBlock, mask: uint64): int {.inline.} =
        ## 64要素の途中までの、桁が b 未満の累積個数を O(1) で返す。
        let bits = when b == 1: not (word.low or word.high)
                   elif b == 2: not word.high
                   else: not (word.low and word.high)
        word.prefix[b-1] + popcount(bits and mask)

    proc ranks(word: QuadRankBlock, p: int): array[4, int] {.inline.} =
        ## [0,p) の各桁の個数を O(1) で返す。
        let mask = (1'u64 shl (p and 63)) - 1
        let a = rank_less[1](word, mask)
        let b = rank_less[2](word, mask)
        let c = rank_less[3](word, mask)
        [a, b-a, c-b, p-c]

    proc digit_rank(word: QuadRankBlock, p, d: int): tuple[less, equal: int] {.inline.} =
        ## [0,p) の d 未満・d と等しい桁の個数を O(1) で返す。
        let mask = (1'u64 shl (p and 63)) - 1
        case d
        of 0:
            result.equal = rank_less[1](word, mask)
        of 1:
            result.less = rank_less[1](word, mask)
            result.equal = rank_less[2](word, mask) - result.less
        of 2:
            result.less = rank_less[2](word, mask)
            result.equal = rank_less[3](word, mask) - result.less
        else:
            result.less = rank_less[3](word, mask)
            result.equal = p - result.less

    proc rank_equal(word: QuadRankBlock, p, d: int): int {.inline.} =
        ## [0,p) の d と等しい桁の個数を1回のpopcountで O(1) で返す。
        let mask = (1'u64 shl (p and 63))-1
        case d
        of 0:
            result = word.prefix[0] + popcount(not (word.low or word.high) and mask)
        of 1:
            result = word.prefix[1]-word.prefix[0] + popcount(word.low and not word.high and mask)
        of 2:
            result = word.prefix[2]-word.prefix[1] + popcount(not word.low and word.high and mask)
        else:
            result = (p and not 63)-word.prefix[2] + popcount(word.low and word.high and mask)

    proc initQuadWaveletMatrix*(v: openArray[int], H: int = -1, with_sum: bool = false): QuadWaveletMatrix =
        ## 非負整数列から O(N ceil(H/2)) 時間で4分岐版を構築する。H はビット数で、-1 なら自動設定する。
        ## 各層は64要素あたり2個のuint64と3個のintを保持し、短縮用に最大 O(N) 個のintを保存する。
        ## with_sum=true なら O(N ceil(H/2)) 個のintを追加する。総和はintに収まる必要がある。
        var maximum = 0
        for x in v:
            assert x >= 0, "要素は非負整数である必要があります"
            maximum = max(maximum, x)
        let height = if H != -1: H
                     elif v.len == 0: 0
                     elif maximum == 0: 1
                     else: fastLog2(maximum)+1
        assert 0 <= height and height <= sizeof(int)*8, "Hはintのビット数以下である必要があります"
        assert height == sizeof(int)*8 or (maximum shr height) == 0, "要素がHビットに収まりません"
        let digits = (height+1) div 2
        result = QuadWaveletMatrix(dat: newSeq[QuadWaveletLevel](digits), H: height,
                                   N: v.len, with_sum: with_sum, scan_h: -1)
        if with_sum:
            result.prefix_sum = newSeq[int](v.len+1)
            for i, x in v:
                result.prefix_sum[i+1] = result.prefix_sum[i] + x
        var width = v.len
        var depth = 0
        while width > quadScanLimit:
            width = (width shr 2) + int((width and 3) != 0)
            inc depth
        if digits-depth-1 >= 3:
            result.scan_h = digits-depth-1
        var current = @v
        var next = newSeq[int](v.len)
        for h in countdown(digits-1, 0):
            if h == result.scan_h:
                result.scan_values = newSeq[int](v.len)
                for i, x in current:
                    result.scan_values[i] = x
            var level = addr result.dat[h]
            level.blocks = newSeq[QuadRankBlock]((v.len shr 6)+1)
            var counts: array[4, int]
            for b in 0..<level.blocks.len:
                var word = QuadRankBlock(prefix: [counts[0], counts[0]+counts[1], counts[0]+counts[1]+counts[2]])
                for i in (b shl 6)..<min(v.len, (b+1) shl 6):
                    let d = (current[i] shr (2*h)) and 3
                    inc counts[d]
                    word.low = word.low or (uint64(d and 1) shl (i and 63))
                    word.high = word.high or (uint64(d shr 1) shl (i and 63))
                level.blocks[b] = word
            for d in 1..3:
                level.offsets[d] = level.offsets[d-1] + counts[d-1]
            var positions = level.offsets
            for x in current:
                let d = (x shr (2*h)) and 3
                next[positions[d]] = x
                inc positions[d]
            if with_sum:
                level.prefix_sum = newSeq[int](v.len+1)
                for i, x in next:
                    level.prefix_sum[i+1] = level.prefix_sum[i] + x
            swap(current, next)

    proc get_child*(self: QuadWaveletMatrix, h, l, r: int): tuple[left, right: array[4, int]] {.inline.} =
        ## 下から h 番目（0-indexed）の2ビット層の [l,r) に対応する4個の子区間を O(1) で返す。
        let level = addr self.dat[h]
        result.left = ranks(level.blocks[l shr 6], l)
        result.right = ranks(level.blocks[r shr 6], r)
        for d in 0..3:
            result.left[d] += level.offsets[d]
            result.right[d] += level.offsets[d]

    proc kth_smallest*(self: QuadWaveletMatrix, l, r, k: int): int =
        ## [l,r) 内で小さい順に k 番目の値を O(ceil(H/2)) で返す。k は0-indexed。
        assert 0 <= l and l <= r and r <= self.N
        assert 0 <= k and k < r-l
        var l = l
        var r = r
        var k = k
        for h in countdown(self.dat.len-1, 0):
            let level = addr self.dat[h]
            let left = addr level.blocks[l shr 6]
            let right = addr level.blocks[r shr 6]
            let lm = (1'u64 shl (l and 63))-1
            let rm = (1'u64 shl (r and 63))-1
            let l2 = rank_less[2](left[], lm)
            let r2 = rank_less[2](right[], rm)
            var d: int
            if k < r2-l2:
                let l1 = rank_less[1](left[], lm)
                let r1 = rank_less[1](right[], rm)
                if k < r1-l1:
                    l = l1
                    r = r1
                else:
                    d = 1
                    k -= r1-l1
                    l = l2-l1
                    r = r2-r1
            else:
                let l3 = rank_less[3](left[], lm)
                let r3 = rank_less[3](right[], rm)
                if k < r3-l3:
                    d = 2
                    k -= r2-l2
                    l = l3-l2
                    r = r3-r2
                else:
                    d = 3
                    k -= r3-l3
                    l -= l3
                    r -= r3
            l += level.offsets[d]
            r += level.offsets[d]
            result = result or (d shl (2*h))

    proc bound_from[withSum, withCount, inclusive: static bool](self: QuadWaveletMatrix, l, r, x, start_h: int): tuple[sum, count: int] =
        ## 上位桁を処理済みの区間で x 未満（inclusive=true なら以下）を O(start_h+1) で集計する。
        var l = l
        var r = r
        for h in countdown(start_h, 0):
            if l == r:
                return
            if h == self.scan_h and r-l <= quadScanLimit:
                for i in l..<r:
                    let value = self.scan_values[i]
                    let take = when inclusive: value <= x else: value < x
                    if take:
                        when withSum: result.sum += value
                        when withCount: inc result.count
                return
            let d = (x shr (2*h)) and 3
            let level = addr self.dat[h]
            when withSum:
                let child = self.get_child(h, l, r)
                for digit in 0..<d:
                    result.sum += level.prefix_sum[child.right[digit]] - level.prefix_sum[child.left[digit]]
                    when withCount: result.count += child.right[digit]-child.left[digit]
                l = child.left[d]
                r = child.right[d]
            else:
                let left = digit_rank(level.blocks[l shr 6], l, d)
                let right = digit_rank(level.blocks[r shr 6], r, d)
                when withCount: result.count += right.less-left.less
                l = level.offsets[d]+left.equal
                r = level.offsets[d]+right.equal
        when inclusive:
            when withSum: result.sum += (r-l)*x
            when withCount: result.count += r-l

    proc bound_query[withSum, withCount, inclusive: static bool](self: QuadWaveletMatrix, l, r, x: int): tuple[sum, count: int] =
        ## 値域外も含めて x 未満または以下を O(ceil(H/2)) で集計する。
        when withSum:
            assert self.with_sum, "和を取得するにはwith_sumを有効にしてください"
        assert 0 <= l and l <= r and r <= self.N
        if x < 0 or (not inclusive and x == 0):
            return
        if self.H < sizeof(int)*8 and (x shr self.H) != 0:
            when withSum: result.sum = self.prefix_sum[r]-self.prefix_sum[l]
            when withCount: result.count = r-l
            return
        bound_from[withSum, withCount, inclusive](self, l, r, x, self.dat.len-1)

    proc range_lowerbound*(self: QuadWaveletMatrix, l, r, x: int): int =
        ## [l,r) 内の x 未満の要素数を O(ceil(H/2)) で返す。
        bound_query[false, true, false](self, l, r, x).count

    proc range_upperbound*(self: QuadWaveletMatrix, l, r, x: int): int =
        ## [l,r) 内の x 以下の要素数を O(ceil(H/2)) で返す。
        bound_query[false, true, true](self, l, r, x).count

    proc count*(self: QuadWaveletMatrix, l, r, x: int): int =
        ## [l,r) 内の x の出現回数を O(ceil(H/2)) で返す。
        assert 0 <= l and l <= r and r <= self.N
        if x < 0 or (self.H < sizeof(int)*8 and (x shr self.H) != 0):
            return 0
        var l = l
        var r = r
        for h in countdown(self.dat.len-1, 0):
            if l == r:
                return 0
            if h == self.scan_h and r-l <= quadScanLimit:
                for i in l..<r:
                    if self.scan_values[i] == x: inc result
                return
            let d = (x shr (2*h)) and 3
            let level = addr self.dat[h]
            l = level.offsets[d] + rank_equal(level.blocks[l shr 6], l, d)
            r = level.offsets[d] + rank_equal(level.blocks[r shr 6], r, d)
        r-l

    proc kth_largest*(self: QuadWaveletMatrix, l, r, k: int): int =
        ## [l,r) 内で大きい順に k 番目の値を O(ceil(H/2)) で返す。k は0-indexed。
        self.kth_smallest(l, r, r-l-1-k)

    proc prev_value*(self: QuadWaveletMatrix, l, r, x: int): Option[int] =
        ## [l,r) 内の x 未満の最大値を O(ceil(H/2)) で返す。存在しなければ none(int)。
        let c = self.range_lowerbound(l, r, x)
        if c == 0: none(int) else: some(self.kth_smallest(l, r, c-1))

    proc next_value*(self: QuadWaveletMatrix, l, r, x: int): Option[int] =
        ## [l,r) 内の x 以上の最小値を O(ceil(H/2)) で返す。存在しなければ none(int)。
        let c = self.range_lowerbound(l, r, x)
        if c == r-l: none(int) else: some(self.kth_smallest(l, r, c))

    proc sum_smallest*(self: QuadWaveletMatrix, l, r, k: int): int =
        ## [l,r) 内の小さい方から k 個の総和を O(ceil(H/2)) で返す。with_sum=true が必要。
        assert self.with_sum, "和を取得するにはwith_sumを有効にしてください"
        assert 0 <= l and l <= r and r <= self.N
        assert 0 <= k and k <= r-l
        if k == r-l:
            return self.prefix_sum[r]-self.prefix_sum[l]
        var l = l
        var r = r
        var k = k
        var value = 0
        for h in countdown(self.dat.len-1, 0):
            if k == 0:
                return
            let child = self.get_child(h, l, r)
            let level = addr self.dat[h]
            var d = 0
            while d < 3 and k >= child.right[d]-child.left[d]:
                result += level.prefix_sum[child.right[d]] - level.prefix_sum[child.left[d]]
                k -= child.right[d]-child.left[d]
                inc d
            l = child.left[d]
            r = child.right[d]
            value = value or (d shl (2*h))
        result += k*value

    proc sum_largest*(self: QuadWaveletMatrix, l, r, k: int): int =
        ## [l,r) 内の大きい方から k 個の総和を O(ceil(H/2)) で返す。with_sum=true が必要。
        assert self.with_sum, "和を取得するにはwith_sumを有効にしてください"
        assert 0 <= l and l <= r and r <= self.N
        assert 0 <= k and k <= r-l
        self.prefix_sum[r]-self.prefix_sum[l] - self.sum_smallest(l, r, r-l-k)

    proc sum_lowerbound*(self: QuadWaveletMatrix, l, r, x: int): int =
        ## [l,r) 内の x 未満の総和を O(ceil(H/2)) で返す。with_sum=true が必要。
        bound_query[true, false, false](self, l, r, x).sum

    proc sum_upperbound*(self: QuadWaveletMatrix, l, r, x: int): int =
        ## [l,r) 内の x 以下の総和を O(ceil(H/2)) で返す。with_sum=true が必要。
        bound_query[true, false, true](self, l, r, x).sum

    proc sum_smallest_with_count*(self: QuadWaveletMatrix, l, r, k: int): tuple[sum, count: int] =
        ## [l,r) 内の小さい方から k 個の総和と個数を O(ceil(H/2)) で返す。with_sum=true が必要。
        (sum: self.sum_smallest(l, r, k), count: k)

    proc sum_largest_with_count*(self: QuadWaveletMatrix, l, r, k: int): tuple[sum, count: int] =
        ## [l,r) 内の大きい方から k 個の総和と個数を O(ceil(H/2)) で返す。with_sum=true が必要。
        (sum: self.sum_largest(l, r, k), count: k)

    proc sum_lowerbound_with_count*(self: QuadWaveletMatrix, l, r, x: int): tuple[sum, count: int] =
        ## [l,r) 内の x 未満の総和と個数を同じ探索で O(ceil(H/2)) で返す。with_sum=true が必要。
        bound_query[true, true, false](self, l, r, x)

    proc sum_upperbound_with_count*(self: QuadWaveletMatrix, l, r, x: int): tuple[sum, count: int] =
        ## [l,r) 内の x 以下の総和と個数を同じ探索で O(ceil(H/2)) で返す。with_sum=true が必要。
        bound_query[true, true, true](self, l, r, x)

    proc range_query[withSum, withCount: static bool](self: QuadWaveletMatrix, l, r, low, high: int): tuple[sum, count: int] =
        ## [low,high) の共通上位桁をまとめ、総和・個数を O(ceil(H/2)) で集計する。
        when withSum:
            assert self.with_sum, "和を取得するにはwith_sumを有効にしてください"
        assert 0 <= l and l <= r and r <= self.N
        if low >= high or high <= 0 or l == r:
            return
        let lower = max(low, 0)
        var upper = high-1
        if self.H < sizeof(int)*8-1:
            upper = min(upper, (1 shl self.H)-1)
        if lower > upper:
            return
        if lower == 0 or ((lower xor upper) shr max(self.H-4, 0)) != 0:
            let a = bound_query[withSum, withCount, true](self, l, r, upper)
            let b = bound_query[withSum, withCount, false](self, l, r, lower)
            return (sum: a.sum-b.sum, count: a.count-b.count)
        var l = l
        var r = r
        for h in countdown(self.dat.len-1, 0):
            if l == r:
                return
            if h == self.scan_h and r-l <= quadScanLimit:
                for i in l..<r:
                    let value = self.scan_values[i]
                    if lower <= value and value <= upper:
                        when withSum: result.sum += value
                        when withCount: inc result.count
                return
            let ld = (lower shr (2*h)) and 3
            let rd = (upper shr (2*h)) and 3
            let level = addr self.dat[h]
            if ld == rd:
                l = level.offsets[ld] + rank_equal(level.blocks[l shr 6], l, ld)
                r = level.offsets[ld] + rank_equal(level.blocks[r shr 6], r, ld)
            else:
                let child = self.get_child(h, l, r)
                let a = bound_from[withSum, withCount, false](self, child.left[ld], child.right[ld], lower, h-1)
                let b = bound_from[withSum, withCount, true](self, child.left[rd], child.right[rd], upper, h-1)
                for d in ld..<rd:
                    when withSum: result.sum += level.prefix_sum[child.right[d]]-level.prefix_sum[child.left[d]]
                    when withCount: result.count += child.right[d]-child.left[d]
                when withSum: result.sum += b.sum-a.sum
                when withCount: result.count += b.count-a.count
                return
        when withSum: result.sum = (r-l)*lower
        when withCount: result.count = r-l

    proc range_freq*(self: QuadWaveletMatrix, l, r, low, high: int): int =
        ## [l,r) 内で値が [low,high) に入る要素数を O(ceil(H/2)) で返す。low >= high なら0。
        range_query[false, true](self, l, r, low, high).count

    proc range_sum*(self: QuadWaveletMatrix, l, r, low, high: int): int =
        ## [l,r) 内で値が [low,high) に入る総和を O(ceil(H/2)) で返す。with_sum=true が必要。
        range_query[true, false](self, l, r, low, high).sum

    proc range_sum_with_count*(self: QuadWaveletMatrix, l, r, low, high: int): tuple[sum, count: int] =
        ## [l,r) 内で値が [low,high) に入る総和と個数を O(ceil(H/2)) で返す。with_sum=true が必要。
        range_query[true, true](self, l, r, low, high)

    when defined(release) and not defined(debug):
        {.pop.}
