## a_iを固定し、b_iを更新できる重み付きWavelet Matrixです。
## 値を座標圧縮し、各段の並べ替え後の重みを合計H本のAVX2版BITで管理します。
## H = ceil(log2(max(2, 異なる値の数)))として、更新・区間和はO(H log N)です。
when not declared CPLIB_COLLECTIONS_WAVELETMATRIX_FENWICK:
    const CPLIB_COLLECTIONS_WAVELETMATRIX_FENWICK* = 1
    import algorithm, bitops, sequtils
    import cplib/collections/waveletmatrix
    import cplib/collections/fenwick_avx2

    type WaveletMatrixFenwick* = ref object
        matrix: WaveletMatrix
        keys: seq[int]
        weights: seq[int]
        bits: seq[FenwickTreeAvx2]

    proc initWaveletMatrixFenwick*(values: openArray[(int, int)]): WaveletMatrixFenwick =
        ## (a_i, b_i)からO(N log N + NH)時間・O(NH)領域で構築します。
        result = WaveletMatrixFenwick(weights: newSeq[int](values.len))
        for i, value in values:
            result.keys.add(value[0])
            result.weights[i] = value[1]
        result.keys.sort()
        result.keys = result.keys.deduplicate(true)
        let height = if result.keys.len <= 1: 1 else: fastLog2(result.keys.len - 1) + 1
        var codes = newSeq[int](values.len)
        for i, value in values:
            codes[i] = result.keys.lowerBound(value[0])
        result.matrix = initWaveletMatrix(codes, height)
        result.bits = newSeq[FenwickTreeAvx2](height)
        var weights = result.weights
        var next = newSeq[int](values.len)
        for h in countdown(height - 1, 0):
            for i in 0..<values.len:
                let (l0, r0, l1, _) = result.matrix.get_child(h, i, i + 1)
                let p = if l0 < r0: l0 else: l1
                next[p] = weights[i]
            result.bits[h] = initFenwickTreeAvx2(next)
            swap(weights, next)

    proc len*(self: WaveletMatrixFenwick): int =
        ## 要素数をO(1)で返します。
        self.weights.len

    proc `[]`*(self: WaveletMatrixFenwick, i: int): int =
        ## 現在のb_iをO(1)で返します。
        assert 0 <= i and i < self.len
        self.weights[i]

    proc add*(self: WaveletMatrixFenwick, i, delta: int) =
        ## b_iにdeltaを加えます。O(H log N)です。
        assert 0 <= i and i < self.len
        self.weights[i] += delta
        var p = i
        for h in countdown(self.bits.len - 1, 0):
            let (l0, r0, l1, _) = self.matrix.get_child(h, p, p + 1)
            p = if l0 < r0: l0 else: l1
            self.bits[h].add(p, delta)

    proc `[]=`*(self: WaveletMatrixFenwick, i, value: int) =
        ## b_iをvalueに変更します。O(H log N)です。
        self.add(i, value - self[i])

    proc range_sum*(self: WaveletMatrixFenwick, l, r: int): int =
        ## l <= i < rを満たすb_iの総和をO(log N)で返します。
        assert 0 <= l and l <= r and r <= self.len
        let h = self.bits.len - 1
        let (l0, r0, l1, r1) = self.matrix.get_child(h, l, r)
        self.bits[h].get(l0, r0) + self.bits[h].get(l1, r1)

    proc sum_less_rank(self: WaveletMatrixFenwick, l, r, k: int): int =
        ## [l, r)内の圧縮値がk未満の重み和をO(H log N)で返します。
        assert 0 <= l and l <= r and r <= self.len
        if k == 0 or l == r:
            return 0
        if k == self.keys.len:
            return self.range_sum(l, r)
        var l = l
        var r = r
        for h in countdown(self.bits.len - 1, 0):
            let (l0, r0, l1, r1) = self.matrix.get_child(h, l, r)
            if k.testBit(h):
                result += self.bits[h].get(l0, r0)
                l = l1
                r = r1
            else:
                l = l0
                r = r0

    proc range_sum*(self: WaveletMatrixFenwick, l, r, x: int): int =
        ## l <= i < rかつa_i <= xを満たすb_iの総和をO(H log N)で返します。
        self.sum_less_rank(l, r, self.keys.upperBound(x))

    proc range_sum*(self: WaveletMatrixFenwick, l, r, lower, upper: int): int =
        ## l <= i < rかつlower <= a_i < upperの重み和をO(H log N)で返します。
        assert lower <= upper
        self.sum_less_rank(l, r, self.keys.lowerBound(upper)) -
            self.sum_less_rank(l, r, self.keys.lowerBound(lower))
