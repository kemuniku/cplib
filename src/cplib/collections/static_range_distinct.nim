when not declared CPLIB_COLLECTIONS_STATIC_RANGE_DISTINCT:
    const CPLIB_COLLECTIONS_STATIC_RANGE_DISTINCT* = 1
    import cplib/collections/waveletmatrix
    import tables

    type StaticRangeDistinct* = object
        wm: WaveletMatrix
        N: int

    proc initStaticRangeDistinct*[T](v: openArray[T]): StaticRangeDistinct =
        ## 静的な列の区間種類数をオンラインで求める構造を構築する。クエリの事前収集は不要。
        ## T は tables.Table のキーにできる型（整合する hash と ==）であればよく、大小比較は不要。
        ## 負数・大きな整数・文字列も扱える。入力値自体を Wavelet Matrix に格納しない。
        ## N = v.len, H = O(log(N+1)) として、構築は期待 O(N(H+1)) 時間。
        ## hash と == を O(1) と仮定する（文字列などではそのコストが別途必要）。
        ## ハッシュ衝突が集中すると前処理が最悪 O(N^2) 時間になる。
        ## 保持領域は O(N + (ceil(N/64)+1)H) ワード、構築中はさらに O(N) ワード。
        ## キーのコピー・保持に必要な領域は別途必要。構築後に入力列は保持しない。
        ## 一点変更は非対応。更新した列には再構築が必要。
        runnableExamples:
            let d = initStaticRangeDistinct(@[-5, 10, -5, 20, 10])
            assert d.count(0, 5) == 3
            assert d.count(1, 3) == 2
            assert d.count(2, 2) == 0
            let empty = initStaticRangeDistinct(newSeq[int]())
            assert empty.count(0, 0) == 0
        var last = initTable[T, int]()
        var previous = newSeq[int](v.len)
        for i, value in v:
            previous[i] = last.getOrDefault(value, 0)
            last[value] = i + 1
        result.N = v.len
        result.wm = initWaveletMatrix(previous)

    proc len*(self: StaticRangeDistinct): int {.inline.} =
        ## 元の列の長さを O(1) で返す。
        self.N

    proc count*(self: StaticRangeDistinct, l, r: int): int =
        ## 半開区間 [l,r) の種類数を O(log(N+1)) 時間で返す。空区間は O(1) で 0。
        ## 0 <= l <= r <= len が必要。違反は assert で検出する（assertions 無効時は未定義）。
        assert 0 <= l and l <= r and r <= self.N, "区間は 0 <= l <= r <= len を満たす必要があります"
        if l == r:
            return 0
        # 区間内の各値の最初の出現だけが prev < l、すなわち prev+1 < l+1 を満たす。
        self.wm.range_lowerbound(l, r, l + 1)
