when not declared CPLIB_COLLECTIONS_FENWICK_TREE:
    const CPLIB_COLLECTIONS_FENWICK_TREE* = 1

    type FenwickTree*[T] = ref object
        bit: seq[T]
        length: int

    proc initFenwickTree*[T](n: Natural): FenwickTree[T] =
        ## 長さ n の Fenwick Tree を生成します。
        ## 各要素は T のデフォルト値で初期化されます。
        FenwickTree[T](bit: newSeq[T](n + 1), length: n)

    proc initFenwickTree*[T](v: openArray[T]): FenwickTree[T] =
        ## v の各要素を初期値とする Fenwick Tree を O(n) で生成します。
        result = initFenwickTree[T](v.len)
        for i, x in v:
            result.bit[i + 1] += x
            let parent = (i + 1) + ((i + 1) and -(i + 1))
            if parent <= v.len:
                result.bit[parent] += result.bit[i + 1]

    proc len*[T](self: FenwickTree[T]): int =
        self.length

    proc add*[T](self: FenwickTree[T], p: Natural, delta: T) =
        ## p 番目の要素に delta を加算します。
        assert p < self.length
        var i = p + 1
        while i <= self.length:
            self.bit[i] += delta
            i += i and -i

    proc prefix*[T](self: FenwickTree[T], r: Natural): T =
        ## 半開区間 [0, r) の和を返します。
        assert r <= self.length
        var i = int(r)
        while i > 0:
            result += self.bit[i]
            i -= i and -i

    proc get*[T](self: FenwickTree[T], l, r: Natural): T =
        ## 半開区間 [l, r) の和を返します。
        assert l <= r and r <= self.length
        self.prefix(r) - self.prefix(l)

    proc get*[T](self: FenwickTree[T], segment: HSlice[int, int]): T =
        ## 閉区間 segment の和を返します。
        assert 0 <= segment.a and segment.a <= segment.b + 1 and
            segment.b + 1 <= self.length
        self.get(segment.a, segment.b + 1)

    proc `[]`*[T](self: FenwickTree[T], p: Natural): T =
        ## p 番目の要素を返します。
        assert p < self.length
        self.get(p, p + 1)

    proc `[]`*[T](self: FenwickTree[T], segment: HSlice[int, int]): T =
        self.get(segment)

    proc `[]=`*[T](self: FenwickTree[T], p: Natural, value: T) =
        ## p 番目の要素を value に変更します。
        assert p < self.length
        self.add(p, value - self[p])
