when not declared CPLIB_COLLECTIONS_COMPRESSED_SEGTREE:
    const CPLIB_COLLECTIONS_COMPRESSED_SEGTREE* = 1
    import algorithm
    import cplib/collections/segtree

    include cplib/collections/compressed_coordinates_internal

    type CompressedSegmentTree*[K, T] = ref object
        coords: seq[K]
        tree: SegmentTree[T]
        default: T
        merge: proc(x, y: T): T
        indexSlots: seq[int]
        updateImpl: proc(self: CompressedSegmentTree[K, T], i: int, value: T)
        rangeImpl: proc(self: CompressedSegmentTree[K, T], l, r: K, inclusive: bool): T

    proc initCompressedSegmentTree*[K, T](coords: openArray[K],
            merge: proc(x, y: T): T, default: T,
            initial: proc(x: K): T = nil): CompressedSegmentTree[K, T] =
        ## 座標をソート・重複除去してO(N log N)時間・O(N)空間で生成します。
        ## 整数座標は基数ソートとO(N)空間の添字索引を用います（小さい入力を除く）。
        ## 登録した点だけを保持し、各点をinitial(x)（省略時は単位元）で初期化します。
        ## 構築後の座標追加はできません。Kには一貫した < と == が必要です。
        var xs = @coords
        sortCompressedCoordinates(xs)
        var count = 0
        for i in 0..<xs.len:
            if count == 0 or xs[count - 1] != xs[i]:
                if count != i: xs[count] = xs[i]
                inc count
        xs.setLen(count)
        var tree: SegmentTree[T]
        if initial == nil:
            tree = initSegmentTree(count, merge, default)
        else:
            var values = newSeq[T](count)
            for i, x in xs: values[i] = initial(x)
            tree = initSegmentTree(values, merge, default)
        result = CompressedSegmentTree[K, T](coords: xs, default: default,
            merge: merge, tree: tree)
        result.indexSlots = initCompressedCoordinateIndex(xs)

    proc coordinateIndex[K, T](self: CompressedSegmentTree[K, T], x: K): int =
        ## 登録済みの添字を返し、未登録なら-1を返します。最悪O(log N)。
        findCompressedCoordinate(self.coords, self.indexSlots, x)

    proc update*[K, T](self: CompressedSegmentTree[K, T], x: K, value: T) =
        ## 登録済みの座標xの値をO(log N)で上書きします。
        let i = self.coordinateIndex(x)
        assert i >= 0, "更新する座標は事前登録してください"
        if self.updateImpl == nil: self.tree.update(i, value)
        else: self.updateImpl(self, i, value)

    proc `[]`*[K, T](self: CompressedSegmentTree[K, T], x: K): T =
        ## 座標xの値をO(log N)で返します。未登録の座標では単位元を返します。
        let i = self.coordinateIndex(x)
        if i >= 0: self.tree[i]
        else: self.default

    proc `[]=`*[K, T](self: CompressedSegmentTree[K, T], x: K, value: T) =
        ## 登録済みの座標xの値をO(log N)で上書きします。
        self.update(x, value)

    proc compressedData[K, T](self: CompressedSegmentTree[K, T]): var seq[T] {.inline.} =
        ## 特殊化した処理から木の配列を参照します。
        self.tree.arr

    proc compressedCoordinates[K, T](self: CompressedSegmentTree[K, T]): lent seq[K] {.inline.} =
        ## 特殊化した処理から座標をコピーせず参照します。
        self.coords

    proc compressedIdentity[K, T](self: CompressedSegmentTree[K, T]): T {.inline.} =
        ## 特殊化した処理から単位元を取得します。
        self.default

    proc setCompressedOperations[K, T](self: CompressedSegmentTree[K, T],
            updateOp: proc(self: CompressedSegmentTree[K, T], i: int, value: T),
            rangeOp: proc(self: CompressedSegmentTree[K, T], l, r: K, inclusive: bool): T) =
        ## 型を変えず、マージを直接呼ぶ更新・取得処理を登録します。
        self.updateImpl = updateOp
        self.rangeImpl = rangeOp

    template rangeProductBody[K, T](self: CompressedSegmentTree[K, T], l, r: K,
            inclusive: static[bool], mergeOp: untyped): untyped =
        ## 座標の探索と部分木の積の取得を同時に行い、O(log N)で区間積を返します。
        template beforeEnd(x: K): bool =
            ## 座標が区間の右端より手前にあるかを判定します。
            when inclusive: not (r < x)
            else: x < r
        let n = compressedCoordinates(self).len
        if n == 0: return compressedIdentity(self)
        if compressedCoordinates(self)[n - 1] < l or not beforeEnd(compressedCoordinates(self)[0]):
            return compressedIdentity(self)
        if not (compressedCoordinates(self)[0] < l) and beforeEnd(compressedCoordinates(self)[n - 1]):
            return compressedData(self)[1]
        var node = 1
        var a = 0
        var b = compressedData(self).len div 2
        while b - a > 1:
            let m = (a + b) shr 1
            if m >= n or not beforeEnd(compressedCoordinates(self)[m]):
                node = node shl 1
                b = m
            elif compressedCoordinates(self)[m] < l:
                node = (node shl 1) or 1
                a = m
            else:
                # 左端と右端が別の子に分かれたら、それぞれの境界だけをたどります。
                var left = compressedIdentity(self)
                var right = compressedIdentity(self)
                var ln = node shl 1
                var la = a
                var lb = m
                # 左側は右の部分木を前に足し、座標順を保ちます。
                while lb - la > 1:
                    let mid = (la + lb) shr 1
                    if compressedCoordinates(self)[mid] < l:
                        ln = (ln shl 1) or 1
                        la = mid
                    else:
                        left = mergeOp(compressedData(self)[(ln shl 1) or 1], left)
                        ln = ln shl 1
                        lb = mid
                if not (compressedCoordinates(self)[la] < l):
                    left = mergeOp(compressedData(self)[ln], left)
                var rn = (node shl 1) or 1
                var ra = m
                var rb = b
                # 右側は左の部分木を後ろに足し、未使用の葉を避けます。
                while rb - ra > 1:
                    let mid = (ra + rb) shr 1
                    if mid >= n or not beforeEnd(compressedCoordinates(self)[mid]):
                        rn = rn shl 1
                        rb = mid
                    else:
                        right = mergeOp(right, compressedData(self)[rn shl 1])
                        rn = (rn shl 1) or 1
                        ra = mid
                if beforeEnd(compressedCoordinates(self)[ra]):
                    right = mergeOp(right, compressedData(self)[rn])
                return mergeOp(left, right)
        if not (compressedCoordinates(self)[a] < l) and beforeEnd(compressedCoordinates(self)[a]):
            compressedData(self)[node]
        else:
            compressedIdentity(self)

    proc rangeProduct[K, T](self: CompressedSegmentTree[K, T], l, r: K,
            inclusive: static[bool]): T =
        ## 指定されたマージ関数でO(log N)の区間積を求めます。
        self.rangeProductBody(l, r, inclusive, self.merge)

    proc get*[K, T](self: CompressedSegmentTree[K, T], l, r: K): T =
        ## 半開区間[l,r)内の登録点の積を座標順にO(log N)で返します。両端は未登録でも構いません。
        assert not (r < l), "l <= rを満たす必要があります"
        if self.rangeImpl == nil: self.rangeProduct(l, r, false)
        else: self.rangeImpl(self, l, r, false)

    proc get*[K, T](self: CompressedSegmentTree[K, T], segment: HSlice[K, K]): T =
        ## 閉区間内の登録点の積をO(log N)で返します。逆順の区間では単位元を返します。
        if segment.b < segment.a: return self.default
        if self.rangeImpl == nil: self.rangeProduct(segment.a, segment.b, true)
        else: self.rangeImpl(self, segment.a, segment.b, true)

    proc `[]`*[K, T](self: CompressedSegmentTree[K, T], segment: HSlice[K, K]): T =
        ## スライス内の登録点の積をO(log N)で返します。
        self.get(segment)

    proc get_all*[K, T](self: CompressedSegmentTree[K, T]): T =
        ## 全登録点の積をO(1)で返します。
        self.tree.get_all()

    proc len*[K, T](self: CompressedSegmentTree[K, T]): int =
        ## 重複除去後の登録点数をO(1)で返します。
        self.coords.len

    proc `$`*[K, T](self: CompressedSegmentTree[K, T]): string =
        ## 座標順の葉の値を空白区切りでO(N)時間で文字列化します。
        $self.tree

    template newCompressedSegWith*(coords, merge, default: untyped,
            initial: untyped = nil): untyped =
        ## 式中のl, rを使ってマージを指定し、O(N log N)で木を構築します。
        block:
            proc compressedMerge(l {.inject.}, r {.inject.}: typeof(default)):
                    typeof(default) {.gensym.} =
                ## 指定した式で二つの値をマージします。
                merge
            let compressedTree = initCompressedSegmentTree(coords,
                proc(x, y: typeof(default)): typeof(default) = compressedMerge(x, y),
                default, initial)
            let updateOp = proc(self: typeof(compressedTree), i: int,
                    value: typeof(default)) =
                ## マージを直接呼び出してO(log N)で更新します。
                var node = i + compressedData(self).len div 2
                compressedData(self)[node] = value
                while node > 1:
                    node = node shr 1
                    compressedData(self)[node] = compressedMerge(compressedData(self)[node shl 1],
                        compressedData(self)[(node shl 1) or 1])
            let rangeOp = proc(self: typeof(compressedTree), a, b: typeof(coords[0]),
                    inclusive: bool): typeof(default) =
                ## マージを直接呼び出してO(log N)で区間積を求めます。
                if inclusive: self.rangeProductBody(a, b, true, compressedMerge)
                else: self.rangeProductBody(a, b, false, compressedMerge)
            setCompressedOperations(compressedTree, updateOp, rangeOp)
            compressedTree
