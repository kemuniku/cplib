when not declared CPLIB_COLLECTIONS_COMPRESSED_LAZYSEGTREE:
    const CPLIB_COLLECTIONS_COMPRESSED_LAZYSEGTREE* = 1
    import algorithm, bitops
    import cplib/collections/lazysegtree
    include cplib/collections/compressed_coordinates_internal

    type CompressedLazySegmentTree*[K, S, F] = ref object
        coords: seq[K]
        tree: LazySegmentTree[S, F]
        default: S
        intervals: bool
        indexSlots: seq[int]
        actionIdentity: F
        getImpl: proc(tree: LazySegmentTree[S, F], l, r: int): S
        applyImpl: proc(tree: LazySegmentTree[S, F], l, r: int, f: F)
        updateImpl: proc(tree: LazySegmentTree[S, F], i: int, value: S)
        pointImpl: proc(tree: LazySegmentTree[S, F], i: int): S

    proc compressedLazyCoordinates[K](coords: openArray[K]): seq[K] =
        ## 座標をO(N log N)でソート・重複除去します。
        result = @coords
        sortCompressedCoordinates(result)
        var count = 0
        for i in 0..<result.len:
            if count == 0 or result[count - 1] != result[i]:
                if count != i: result[count] = result[i]
                inc count
        result.setLen(count)

    proc initCompressedLazySegmentTree*[K, S, F](coords: openArray[K],
            merge: proc(x, y: S): S, default: S, mapping: proc(f: F, x: S): S,
            composition: proc(f, g: F): F, id: F,
            initial: proc(x: K): S = nil): CompressedLazySegmentTree[K, S, F] =
        ## 登録点だけを保持する木をO(N log N)時間・O(N)空間で生成します。
        ## 整数座標は基数ソートとO(N)空間の添字索引を用います（小さい入力を除く）。
        ## 各点をinitial(x)（省略時は単位元）で初期化します。構築後の座標追加はできません。
        ## composition(f,g)はgの後にfを適用します。Kには一貫した < と == が必要です。
        let xs = compressedLazyCoordinates(coords)
        var tree: LazySegmentTree[S, F]
        if initial == nil:
            tree = initLazySegmentTree(xs.len, merge, default, mapping, composition, id)
        else:
            var values = newSeq[S](xs.len)
            for i, x in xs: values[i] = initial(x)
            tree = initLazySegmentTree(values, merge, default, mapping, composition, id)
        CompressedLazySegmentTree[K, S, F](coords: xs, default: default, tree: tree,
            actionIdentity: id, indexSlots: initCompressedCoordinateIndex(xs))

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
            actionIdentity: id, indexSlots: initCompressedCoordinateIndex(xs),
            tree: initLazySegmentTree(values, merge, default, mapping, composition, id))

    proc boundary[K, S, F](self: CompressedLazySegmentTree[K, S, F], x: K): int =
        ## 区間端を圧縮後の添字にO(log N)で変換し、区間を葉とする場合は登録を確認します。
        if self.intervals:
            result = findCompressedCoordinate(self.coords, self.indexSlots, x)
            assert result >= 0, "区間の両端は事前登録してください"
        else:
            result = self.coords.lowerBound(x)

    proc get*[K, S, F](self: CompressedLazySegmentTree[K, S, F], l, r: K): S =
        ## 半開区間[l,r)の積をO(log N)で返します。登録点を保持する場合は両端が未登録でも構いません。
        assert not (r < l), "l <= rを満たす必要があります"
        let a = self.boundary(l)
        let b = self.boundary(r)
        if self.getImpl == nil: self.tree.get(a, b)
        else: self.getImpl(self.tree, a, b)

    proc apply*[K, S, F](self: CompressedLazySegmentTree[K, S, F], l, r: K, f: F) =
        ## 半開区間[l,r)へO(log N)で作用させます。登録点を保持する場合は未登録点には作用しません。
        assert not (r < l), "l <= rを満たす必要があります"
        let a = self.boundary(l)
        let b = self.boundary(r)
        if self.applyImpl == nil: self.tree.apply(a, b, f)
        else: self.applyImpl(self.tree, a, b, f)

    proc update*[K, S, F](self: CompressedLazySegmentTree[K, S, F], x: K, value: S) =
        ## 登録点xの値をO(log N)で上書きします。区間を葉とする場合は[x,次の登録座標)全体を上書きします。
        let i = findCompressedCoordinate(self.coords, self.indexSlots, x)
        assert i >= 0, "更新する座標は事前登録してください"
        assert not self.intervals or i + 1 < self.coords.len, "最後の境界には対応する葉がありません"
        if self.updateImpl == nil: self.tree.update(i, value)
        else: self.updateImpl(self.tree, i, value)

    proc `[]`*[K, S, F](self: CompressedLazySegmentTree[K, S, F], x: K): S =
        ## 登録点xの値をO(log N)で返します。区間を葉とする場合は[x,次の登録座標)の積を返します。
        ## 登録点を保持する場合、未登録点の値は単位元です。区間を葉とする場合は未登録座標を許しません。
        let i = findCompressedCoordinate(self.coords, self.indexSlots, x)
        if self.intervals:
            assert i >= 0 and i + 1 < self.coords.len, "葉の左端となる登録座標を指定してください"
        elif i < 0:
            return self.default
        if self.pointImpl == nil: self.tree[i]
        else: self.pointImpl(self.tree, i)

    proc `[]=`*[K, S, F](self: CompressedLazySegmentTree[K, S, F], x: K, value: S) =
        ## 座標xに対応する葉をO(log N)で上書きします。
        self.update(x, value)

    proc get_all*[K, S, F](self: CompressedLazySegmentTree[K, S, F]): S =
        ## 全体の積をO(1)で返します。空の場合は単位元を返します。
        self.tree.get_all()

    proc len*[K, S, F](self: CompressedLazySegmentTree[K, S, F]): int =
        ## 葉の数（登録点数、または登録座標間の区間数）をO(1)で返します。
        if self.intervals: max(0, self.coords.len - 1) else: self.coords.len

    proc sliceBounds[K, S, F](self: CompressedLazySegmentTree[K, S, F],
            segment: HSlice[K, K]): tuple[a, b: int] =
        ## 閉区間をO(log N)で変換します。区間モードでは順序型の右端の次の座標を登録してください。
        if segment.b < segment.a: return (0, 0)
        if self.intervals:
            when K is Ordinal:
                assert segment.b < high(K), "右端の次の座標が必要です"
                return (self.boundary(segment.a), self.boundary(succ(segment.b)))
            else:
                assert false, "区間モードのスライスには順序型の座標が必要です。get(l, r)またはapply(l, r, f)を使用してください"
        (self.coords.lowerBound(segment.a), self.coords.upperBound(segment.b))

    proc get*[K, S, F](self: CompressedLazySegmentTree[K, S, F],
            segment: HSlice[K, K]): S =
        ## 閉区間の積をO(log N)で返します。逆順の区間では単位元を返します。
        ## 区間モードではKは順序型とし、左端と右端の次の座標を事前登録してください。
        let (a, b) = self.sliceBounds(segment)
        if self.getImpl == nil: self.tree.get(a, b)
        else: self.getImpl(self.tree, a, b)

    proc `[]`*[K, S, F](self: CompressedLazySegmentTree[K, S, F],
            segment: HSlice[K, K]): S =
        ## スライス内の積をO(log N)で返します。
        self.get(segment)

    proc apply*[K, S, F](self: CompressedLazySegmentTree[K, S, F],
            segment: HSlice[K, K], f: F) =
        ## 閉区間へO(log N)で作用させます。逆順の区間では何もしません。
        ## 区間モードではKは順序型とし、左端と右端の次の座標を事前登録してください。
        let (a, b) = self.sliceBounds(segment)
        if self.applyImpl == nil: self.tree.apply(a, b, f)
        else: self.applyImpl(self.tree, a, b, f)

    proc `$`*[K, S, F](self: CompressedLazySegmentTree[K, S, F]): string =
        ## 座標順の葉の値を空白区切りでO(N log N)時間で文字列化します。
        $self.tree

    proc compressedLazyDefaults[K, S, F](self: CompressedLazySegmentTree[K, S, F]):
            tuple[value: S, action: F] =
        ## 特殊化した処理が使用する単位元を取得します。
        (self.default, self.actionIdentity)

    proc setCompressedLazyOperations[K, S, F](self: CompressedLazySegmentTree[K, S, F],
            getOp: proc(tree: LazySegmentTree[S, F], l, r: int): S,
            applyOp: proc(tree: LazySegmentTree[S, F], l, r: int, f: F),
            updateOp: proc(tree: LazySegmentTree[S, F], i: int, value: S),
            pointOp: proc(tree: LazySegmentTree[S, F], i: int): S) =
        ## 型を変えず、演算を直接呼ぶ取得・作用・更新処理を登録します。
        self.getImpl = getOp
        self.applyImpl = applyOp
        self.updateImpl = updateOp
        self.pointImpl = pointOp

    template newCompressedLazySegWith*(coords, merge, default, mapping,
            composition, id, initial: untyped): untyped =
        ## l, r / f, x / f, gを使って演算を指定し、O(N log N)で木を構築します。
        block:
            type Tree = LazySegmentTree[typeof(default), typeof(id)]
            proc mergeOp(l {.inject.}, r {.inject.}: typeof(default)): typeof(default) {.gensym.} =
                ## 指定した式で二つの値をマージします。
                merge
            proc mappingOp(f {.inject.}: typeof(id), x {.inject.}: typeof(default)): typeof(default) {.gensym.} =
                ## 指定した式で値に作用させます。
                mapping
            proc compositionOp(f {.inject.}, g {.inject.}: typeof(id)): typeof(id) {.gensym.} =
                ## 指定した式で作用を合成します。
                composition
            let compressedTree = initCompressedLazySegmentTree(coords, mergeOp, default,
                mappingOp, compositionOp, id, initial)
            let defaults = compressedLazyDefaults(compressedTree)
            proc applyNode(tree: Tree, node: int, action: typeof(id)) {.gensym.} =
                ## 一つの部分木に作用を適用します。
                tree.arr[node] = mappingOp(action, tree.arr[node])
                if node < tree.lazy.len:
                    tree.lazy[node] = compositionOp(action, tree.lazy[node])
            proc pushNode(tree: Tree, node: int) {.gensym.} =
                ## 遅延作用を子に伝播します。
                applyNode(tree, node shl 1, tree.lazy[node])
                applyNode(tree, (node shl 1) or 1, tree.lazy[node])
                tree.lazy[node] = defaults.action
            proc pushBoundary(tree: Tree, left, right: int) {.gensym.} =
                ## 区間の両端に必要な伝播を行い、共通の祖先は一度だけ処理します。
                let leftZeros = countTrailingZeroBits(left)
                let rightZeros = countTrailingZeroBits(right)
                for level in countdown(countTrailingZeroBits(tree.lazy.len), 1):
                    let lp = left shr level
                    let rp = (right - 1) shr level
                    if level > leftZeros: pushNode(tree, lp)
                    if level > rightZeros and (level <= leftZeros or lp != rp):
                        pushNode(tree, rp)
            let getOp = proc(tree: Tree, a, b: int): typeof(default) =
                ## 演算を直接呼び出してO(log N)で区間積を取得します。
                if a == b: return defaults.value
                var left = a + tree.lazy.len
                var right = b + tree.lazy.len
                pushBoundary(tree, left, right)
                var lres = defaults.value
                var rres = defaults.value
                while left < right:
                    if (left and 1) != 0:
                        lres = mergeOp(lres, tree.arr[left])
                        inc left
                    if (right and 1) != 0:
                        dec right
                        rres = mergeOp(tree.arr[right], rres)
                    left = left shr 1
                    right = right shr 1
                mergeOp(lres, rres)
            let applyOp = proc(tree: Tree, a, b: int, action: typeof(id)) =
                ## 演算を直接呼び出してO(log N)で区間へ作用させます。
                if a == b: return
                let first = a + tree.lazy.len
                let last = b + tree.lazy.len
                pushBoundary(tree, first, last)
                var left = first
                var right = last
                while left < right:
                    if (left and 1) != 0:
                        applyNode(tree, left, action)
                        inc left
                    if (right and 1) != 0:
                        dec right
                        applyNode(tree, right, action)
                    left = left shr 1
                    right = right shr 1
                let leftZeros = countTrailingZeroBits(first)
                let rightZeros = countTrailingZeroBits(last)
                for level in 1..countTrailingZeroBits(tree.lazy.len):
                    let lp = first shr level
                    let rp = (last - 1) shr level
                    if level > leftZeros:
                        tree.arr[lp] = mergeOp(tree.arr[lp shl 1], tree.arr[(lp shl 1) or 1])
                    if level > rightZeros and (level <= leftZeros or lp != rp):
                        tree.arr[rp] = mergeOp(tree.arr[rp shl 1], tree.arr[(rp shl 1) or 1])
            let updateOp = proc(tree: Tree, i: int, value: typeof(default)) =
                ## 演算を直接呼び出してO(log N)で一点を更新します。
                var node = i + tree.lazy.len
                for level in countdown(countTrailingZeroBits(tree.lazy.len), 1):
                    pushNode(tree, node shr level)
                tree.arr[node] = value
                while node > 1:
                    node = node shr 1
                    tree.arr[node] = mergeOp(tree.arr[node shl 1], tree.arr[(node shl 1) or 1])
            let pointOp = proc(tree: Tree, i: int): typeof(default) =
                ## 演算を直接呼び出してO(log N)で一点を取得します。
                let node = i + tree.lazy.len
                for level in countdown(countTrailingZeroBits(tree.lazy.len), 1):
                    pushNode(tree, node shr level)
                tree.arr[node]
            setCompressedLazyOperations(compressedTree, getOp, applyOp, updateOp, pointOp)
            compressedTree

    template newCompressedLazySegWith*(coords, merge, default, mapping,
            composition, id: untyped): untyped =
        ## 初期値を単位元とし、式で演算を指定してO(N log N)で木を構築します。
        newCompressedLazySegWith(coords, merge, default, mapping, composition, id,
            (proc(x: typeof(coords[0])): typeof(default))(nil))
