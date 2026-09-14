when not declared CPLIB_COLLECTIONS_COMPRESSED_LAZYSEGTREE:
    const CPLIB_COLLECTIONS_COMPRESSED_LAZYSEGTREE* = 1
    import algorithm
    import cplib/collections/lazysegtree

    type CompressedLazySegmentTree*[K, S, F] = ref object
        coords: seq[K]
        tree: LazySegmentTree[S, F]
        default: S
        intervals: bool

    proc compressedLazyCoordinates[K](coords: openArray[K]): seq[K] =
        ## 座標をO(N log N)でソート・重複除去します。
        var xs = @coords
        xs.sort()
        result = @[]
        for x in xs:
            if result.len == 0 or result[^1] != x:
                result.add(x)

    proc initCompressedLazySegmentTree*[K, S, F](coords: openArray[K],
            merge: proc(x, y: S): S, default: S, mapping: proc(f: F, x: S): S,
            composition: proc(f, g: F): F, id: F,
            initial: proc(x: K): S = nil): CompressedLazySegmentTree[K, S, F] =
        ## 登録点だけを保持する木をO(N log N)時間・O(N)空間で生成します。
        ## 各点をinitial(x)（省略時は単位元）で初期化します。構築後の座標追加はできません。
        ## composition(f,g)はgの後にfを適用します。Kには一貫した < と == が必要です。
        let xs = compressedLazyCoordinates(coords)
        var values = newSeq[S](xs.len)
        for i, x in xs:
            values[i] = if initial == nil: default else: initial(x)
        CompressedLazySegmentTree[K, S, F](coords: xs, default: default,
            tree: initLazySegmentTree(values, merge, default, mapping, composition, id))

    proc initCompressedLazySegmentTree*[K, S, F](coords: openArray[K],
            merge: proc(x, y: S): S, default: S, mapping: proc(f: F, x: S): S,
            composition: proc(f, g: F): F, id: F,
            initial: proc(l, r: K): S): CompressedLazySegmentTree[K, S, F] =
        ## 隣接する登録座標間を葉とする木をO(N log N)時間・O(N)空間で生成します。
        ## 各葉[x[i],x[i+1])をinitial(x[i],x[i+1])で初期化します。コールバックはO(1)を想定します。
        ## 区間操作の両端は事前登録が必要です。区間和ではSに圧縮前の区間長を含めてください。
        ## composition(f,g)はgの後にfを適用します。構築後の座標追加はできません。
        assert initial != nil, "区間の初期値を指定してください"
        let xs = compressedLazyCoordinates(coords)
        var values = newSeq[S](max(0, xs.len - 1))
        for i in 0..<values.len:
            values[i] = initial(xs[i], xs[i + 1])
        CompressedLazySegmentTree[K, S, F](coords: xs, default: default, intervals: true,
            tree: initLazySegmentTree(values, merge, default, mapping, composition, id))

    proc boundary[K, S, F](self: CompressedLazySegmentTree[K, S, F], x: K): int =
        ## 区間端を圧縮後の添字にO(log N)で変換し、区間を葉とする場合は登録を確認します。
        result = self.coords.lowerBound(x)
        if self.intervals:
            assert result < self.coords.len and self.coords[result] == x, "区間の両端は事前登録してください"

    proc get*[K, S, F](self: CompressedLazySegmentTree[K, S, F], l, r: K): S =
        ## 半開区間[l,r)の積をO(log N)で返します。登録点を保持する場合は両端が未登録でも構いません。
        assert not (r < l), "l <= rを満たす必要があります"
        let a = self.boundary(l)
        let b = self.boundary(r)
        self.tree.get(a, b)

    proc apply*[K, S, F](self: CompressedLazySegmentTree[K, S, F], l, r: K, f: F) =
        ## 半開区間[l,r)へO(log N)で作用させます。登録点を保持する場合は未登録点には作用しません。
        assert not (r < l), "l <= rを満たす必要があります"
        let a = self.boundary(l)
        let b = self.boundary(r)
        self.tree.apply(a, b, f)

    proc update*[K, S, F](self: CompressedLazySegmentTree[K, S, F], x: K, value: S) =
        ## 登録点xの値をO(log N)で上書きします。区間を葉とする場合は[x,次の登録座標)全体を上書きします。
        let i = self.coords.lowerBound(x)
        assert i < self.coords.len and self.coords[i] == x, "更新する座標は事前登録してください"
        assert not self.intervals or i + 1 < self.coords.len, "最後の境界には対応する葉がありません"
        self.tree.update(i, value)

    proc `[]`*[K, S, F](self: CompressedLazySegmentTree[K, S, F], x: K): S =
        ## 登録点xの値をO(log N)で返します。区間を葉とする場合は[x,次の登録座標)の積を返します。
        ## 登録点を保持する場合、未登録点の値は単位元です。区間を葉とする場合は未登録座標を許しません。
        let i = self.coords.lowerBound(x)
        if self.intervals:
            assert i + 1 < self.coords.len and self.coords[i] == x, "葉の左端となる登録座標を指定してください"
        elif i == self.coords.len or self.coords[i] != x:
            return self.default
        self.tree[i]

    proc `[]=`*[K, S, F](self: CompressedLazySegmentTree[K, S, F], x: K, value: S) =
        ## 座標xに対応する葉をO(log N)で上書きします。
        self.update(x, value)

    proc get_all*[K, S, F](self: CompressedLazySegmentTree[K, S, F]): S =
        ## 全体の積をO(1)で返します。空の場合は単位元を返します。
        self.tree.get_all()

    proc len*[K, S, F](self: CompressedLazySegmentTree[K, S, F]): int =
        ## 葉の数（登録点数、または登録座標間の区間数）をO(1)で返します。
        if self.intervals: max(0, self.coords.len - 1) else: self.coords.len
