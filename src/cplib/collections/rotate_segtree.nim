when not declared CPLIB_COLLECTIONS_ROTATE_SEGTREE:
    const CPLIB_COLLECTIONS_ROTATE_SEGTREE* = 1
    import cplib/collections/segtree
    import cplib/utils/backwards_index
    import strutils

    type RotateSegmentTree*[T] = ref object
        tree: SegmentTree[T]
        offset: int
        merge: proc(x, y: T): T
        default: T

    proc initRotateSegmentTree*[T](v: openArray[T],
            merge: proc(x, y: T): T, default: T): RotateSegmentTree[T] =
        ## 固定長の円環セグメント木をO(N)時間・O(N)空間で生成します。
        ## mergeは結合的でdefaultは両側単位元とします。可換性は不要です。
        ## 計算量はmergeと値のコピーがO(1)の場合です。空の木も生成できます。
        RotateSegmentTree[T](tree: initSegmentTree(v, merge, default),
            merge: merge, default: default)

    proc initRotateSegmentTree*[T](n: int,
            merge: proc(x, y: T): T, default: T): RotateSegmentTree[T] =
        ## 長さnの全要素を単位元としてO(N)時間・O(N)空間で生成します。n >= 0が必要です。
        assert n >= 0, "長さは非負である必要があります"
        RotateSegmentTree[T](tree: initSegmentTree(n, merge, default),
            merge: merge, default: default)

    proc len*[T](self: RotateSegmentTree[T]): int =
        ## 固定された要素数をO(1)で返します。
        self.tree.len

    proc physicalIndex[T](self: RotateSegmentTree[T], index: int): int {.inline.} =
        ## [0,N)の論理添字を、加算のオーバーフローを避けてO(1)で変換します。
        let tail = self.len - self.offset
        if index < tail: self.offset + index
        else: index - tail

    proc rotate*[T](self: RotateSegmentTree[T], shift: int) =
        ## O(1)で左へshift個回転します。新しいa[i]は回転前のa[(i+shift) mod N]です。
        ## 負数は右回転で、intの最小値・最大値も扱えます。空の木では何もしません。
        if self.len == 0: return
        var shift = shift mod self.len
        if shift < 0: shift += self.len
        self.offset = self.physicalIndex(shift)

    proc update*[T](self: RotateSegmentTree[T], index: int, value: T) =
        ## 論理添字indexの値をO(log N)で上書きします。0 <= index < Nが必要です。
        assert 0 <= index and index < self.len, "添字は[0,N)の範囲で指定してください"
        self.tree.update(self.physicalIndex(index), value)

    proc set*[T](self: RotateSegmentTree[T], index: int, value: T) =
        ## 論理添字indexの値をO(log N)で上書きします。updateと同じ操作です。
        self.update(index, value)

    proc get*[T](self: RotateSegmentTree[T], start, count: int): T =
        ## startから円環上でcount個の積を論理順にO(log N)で返します。
        ## 0 <= start <= N、0 <= count <= Nが必要です。start=Nは0と同じ位置です。
        ## count=0は単位元、count=Nはstartから一周の積です。空の木ではget(0,0)のみ有効です。
        assert 0 <= start and start <= self.len, "開始位置は[0,N]の範囲で指定してください"
        assert 0 <= count and count <= self.len, "個数は[0,N]の範囲で指定してください"
        if count == 0: return self.default
        let first = self.physicalIndex(if start == self.len: 0 else: start)
        let tail = self.len - first
        if count <= tail: return self.tree.get(first, first + count)
        self.merge(self.tree.get(first, self.len), self.tree.get(0, count - tail))

    proc get*[T](self: RotateSegmentTree[T], segment: HSlice[int, int]): T =
        ## 論理列内のスライスの積をO(log N)で返します。円環を跨ぐ指定にはget(start,count)を使います。
        assert 0 <= segment.a and segment.a <= self.len, "左端は[0,N]の範囲で指定してください"
        assert segment.a - 1 <= segment.b and segment.b < self.len, "右端は[a-1,N)の範囲で指定してください"
        self.get(segment.a, segment.b - segment.a + 1)

    proc `[]`*[T](self: RotateSegmentTree[T], segment: HSlice[int, int]): T =
        ## 論理列内のスライスの積をO(log N)で返します。
        self.get(segment)

    proc `[]`*[T](self: RotateSegmentTree[T], index: int): T {.backwardsIndex.} =
        ## 論理添字indexの値をO(1)で返します。0 <= index < Nが必要です。
        assert 0 <= index and index < self.len, "添字は[0,N)の範囲で指定してください"
        self.tree[self.physicalIndex(index)]

    proc `[]=`*[T](self: RotateSegmentTree[T], index: int, value: T) {.backwardsIndex.} =
        ## 論理添字indexの値をO(log N)で上書きします。
        self.update(index, value)

    proc get_all*[T](self: RotateSegmentTree[T]): T =
        ## 論理添字0から一周の積をO(log N)で返します。未回転または空ならO(1)です。
        if self.offset == 0: self.tree.get_all()
        else: self.get(0, self.len)

    proc `$`*[T](self: RotateSegmentTree[T]): string =
        ## 論理順の要素を空白区切りで文字列化します。要素の変換と出力の長さに応じた時間・空間を使います。
        var values = newSeq[string](self.len)
        for i in 0..<self.len: values[i] = $self[i]
        values.join(" ")

    template newRotateSegWith*(v, merge, default: untyped): untyped =
        ## 式中のl,rでmergeを指定し、列または長さからO(N)で生成します。
        initRotateSegmentTree[typeof(default)](v,
            proc(l {.inject.}, r {.inject.}: typeof(default)): typeof(default) = merge,
            default)
