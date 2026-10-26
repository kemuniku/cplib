when not declared CPLIB_COLLECTIONS_STATIC_RANGE_DISTINCT:
    const CPLIB_COLLECTIONS_STATIC_RANGE_DISTINCT* = 1
    import cplib/collections/waveletmatrix
    import algorithm, tables

    type StaticRangeDistinct* = object
        wm: WaveletMatrix
        N: int

    proc initStaticRangeDistinct*[T](v: openArray[T], cmp: proc(a, b: T): int): StaticRangeDistinct =
        ## 比較関数だけを使い、静的な列の区間種類数を求める構造を O(N log(N+1)) 時間で構築する。
        ## cmp は負・0・正で大小・同値を表す整合した順序を定め、cmp(a, b) == 0 を同じ種類とする。
        ## T の hash と == は不要。比較を O(1) と仮定し、それ以外の比較コストは別途必要。
        ## 保持領域は通常版と同じで、構築中はさらに O(N) 個の値と添字を保持する。
        var ordered = newSeq[tuple[value: T, index: int]](v.len)
        for i, value in v:
            ordered[i] = (value, i)
        ordered.sort(proc(a, b: tuple[value: T, index: int]): int =
            let c = cmp(a.value, b.value)
            if c != 0: c
            else: system.cmp(a.index, b.index)
        )
        var previous = newSeq[int](v.len)
        for i in 1..<ordered.len:
            if cmp(ordered[i - 1].value, ordered[i].value) == 0:
                previous[ordered[i].index] = ordered[i - 1].index + 1
        result.N = v.len
        result.wm = initWaveletMatrix(previous)

    proc initStaticRangeDistinct*[T](v: openArray[T]): StaticRangeDistinct =
        ## 静的な列の区間種類数をオンラインで求める構造を構築する。クエリの事前収集は不要。
        ## T が tables.Table のキーにできる型（整合する hash と ==）ならハッシュを使い、大小比較は不要。
        ## Table が使えない型は cmp による比較版に切り替える。比較関数を第2引数に指定することもできる。
        ## 負数・大きな整数・文字列も扱える。入力値自体を Wavelet Matrix に格納しない。
        ## N = v.len, H = O(log(N+1)) として、ハッシュ版の構築は期待 O(N(H+1)) 時間。
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
        when compiles(block:
            var last = initTable[T, int]()
            last[default(T)] = 1
            discard last.getOrDefault(default(T), 0)
        ):
            var last = initTable[T, int]()
            var previous = newSeq[int](v.len)
            for i, value in v:
                previous[i] = last.getOrDefault(value, 0)
                last[value] = i + 1
            result.N = v.len
            result.wm = initWaveletMatrix(previous)
        else:
            mixin cmp
            result = initStaticRangeDistinct(v, proc(a, b: T): int = cmp(a, b))

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
