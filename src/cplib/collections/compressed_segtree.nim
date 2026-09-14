when not declared CPLIB_COLLECTIONS_COMPRESSED_SEGTREE:
    const CPLIB_COLLECTIONS_COMPRESSED_SEGTREE* = 1
    import algorithm
    import cplib/collections/segtree

    type CompressedSegmentTree*[K, T] = ref object
        coords: seq[K]
        tree: SegmentTree[T]
        default: T

    proc initCompressedSegmentTree*[K, T](coords: openArray[K],
            merge: proc(x, y: T): T, default: T,
            initial: proc(x: K): T = nil): CompressedSegmentTree[K, T] =
        ## 座標をソート・重複除去してO(N log N)時間・O(N)空間で生成します。
        ## 登録した点だけを保持し、各点をinitial(x)（省略時は単位元）で初期化します。
        ## 構築後の座標追加はできません。Kには一貫した < と == が必要です。
        var xs = @coords
        xs.sort()
        var unique: seq[K] = @[]
        for x in xs:
            if unique.len == 0 or unique[^1] != x:
                unique.add(x)
        var values = newSeq[T](unique.len)
        for i, x in unique:
            values[i] = if initial == nil: default else: initial(x)
        CompressedSegmentTree[K, T](coords: unique, default: default,
            tree: initSegmentTree(values, merge, default))

    proc update*[K, T](self: CompressedSegmentTree[K, T], x: K, value: T) =
        ## 登録済みの座標xの値をO(log N)で上書きします。
        let i = self.coords.lowerBound(x)
        assert i < self.coords.len and self.coords[i] == x, "更新する座標は事前登録してください"
        self.tree.update(i, value)

    proc `[]`*[K, T](self: CompressedSegmentTree[K, T], x: K): T =
        ## 座標xの値をO(log N)で返します。未登録の座標では単位元を返します。
        let i = self.coords.lowerBound(x)
        if i < self.coords.len and self.coords[i] == x: self.tree[i]
        else: self.default

    proc `[]=`*[K, T](self: CompressedSegmentTree[K, T], x: K, value: T) =
        ## 登録済みの座標xの値をO(log N)で上書きします。
        self.update(x, value)

    proc get*[K, T](self: CompressedSegmentTree[K, T], l, r: K): T =
        ## 半開区間[l,r)内の登録点の積を座標順にO(log N)で返します。両端は未登録でも構いません。
        assert not (r < l), "l <= rを満たす必要があります"
        self.tree.get(self.coords.lowerBound(l), self.coords.lowerBound(r))

    proc get*[K, T](self: CompressedSegmentTree[K, T], segment: HSlice[K, K]): T =
        ## 閉区間内の登録点の積をO(log N)で返します。逆順の区間では単位元を返します。
        if segment.b < segment.a: return self.default
        self.tree.get(self.coords.lowerBound(segment.a), self.coords.upperBound(segment.b))

    proc `[]`*[K, T](self: CompressedSegmentTree[K, T], segment: HSlice[K, K]): T =
        ## スライス内の登録点の積をO(log N)で返します。
        self.get(segment)

    proc get_all*[K, T](self: CompressedSegmentTree[K, T]): T =
        ## 全登録点の積をO(1)で返します。
        self.tree.get_all()

    proc len*[K, T](self: CompressedSegmentTree[K, T]): int =
        ## 重複除去後の登録点数をO(1)で返します。
        self.coords.len
