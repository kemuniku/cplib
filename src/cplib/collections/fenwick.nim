## 加算と減算を使うFenwick treeです。添字は0始まり、区間は半開区間です。
## Tの初期値を加法単位元とし、加算は可換である必要があります。
when not declared CPLIB_COLLECTIONS_FENWICK:
    const CPLIB_COLLECTIONS_FENWICK* = 1

    type FenwickTree*[T] = object
        size: int
        data: seq[T]

    template fenwickSlot(i: int): int =
        ## 1024要素ごとの余白で、上位ノードのキャッシュ競合を抑えます。
        i + (i shr 10)

    proc initFenwickTree*[T](n: int): FenwickTree[T] =
        ## 長さnの零配列から構築します。O(n)時間・領域です。
        assert n >= 0
        result.size = n
        result.data = newSeq[T](fenwickSlot(n) + 1)

    proc initFenwickTree*[T](values: openArray[T]): FenwickTree[T] =
        ## 配列からO(n)時間・領域で構築します。
        result = initFenwickTree[T](values.len)
        for i in 1..values.len:
            result.data[fenwickSlot(i)] = values[i - 1]
        for i in 1..values.len:
            let parent = i + (i and -i)
            if parent <= values.len:
                result.data[fenwickSlot(parent)] += result.data[fenwickSlot(i)]

    proc len*[T](self: FenwickTree[T]): int {.inline.} =
        ## 要素数をO(1)で返します。
        self.size

    proc add*[T](self: var FenwickTree[T], p: int, delta: T) {.inline.} =
        ## a[p]にdeltaを加えます。O(log n)です。
        assert 0 <= p and p < self.size
        var i = p + 1
        while i <= self.size:
            self.data[fenwickSlot(i)] += delta
            i += i and -i

    proc prefix*[T](self: FenwickTree[T], r: int): T {.inline.} =
        ## [0, r)の和をO(log n)で返します。
        assert 0 <= r and r <= self.size
        var r = r
        while r > 0:
            result += self.data[fenwickSlot(r)]
            r = r and (r - 1)

    proc get*[T](self: FenwickTree[T], l, r: int): T {.inline.} =
        ## [l, r)の和をO(log n)で返します。共通する祖先は走査しません。
        assert 0 <= l and l <= r and r <= self.size
        var l = l
        var r = r
        var left: T
        while r > l:
            result += self.data[fenwickSlot(r)]
            r = r and (r - 1)
        while l > r:
            left += self.data[fenwickSlot(l)]
            l = l and (l - 1)
        result = result - left

    proc `[]`*[T](self: FenwickTree[T], segment: HSlice[int, int]): T {.inline.} =
        ## スライスの和をO(log n)で返します。
        self.get(segment.a, segment.b + 1)

    proc `[]`*[T](self: FenwickTree[T], p: int): T {.inline.} =
        ## a[p]をO(log n)で返します。
        self.get(p, p + 1)

    proc `[]=`*[T](self: var FenwickTree[T], p: int, value: T) {.inline.} =
        ## a[p]をvalueに変更します。O(log n)です。
        self.add(p, value - self[p])
