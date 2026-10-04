when not declared CPLIB_COLLECTIONS_XOR_SEGTREE:
    const CPLIB_COLLECTIONS_XOR_SEGTREE* = 1

    type
        XORSegmentTree*[T] = ref object
            length: int
            data: seq[T]
            merge: proc(x, y: T): T
            default: T
        StaticXORSegmentTree*[T] = ref object
            length: int
            levels: seq[seq[T]]
            merge: proc(x, y: T): T
            default: T

    proc checkXORLength(n: int) =
        ## 正の2冪かつ内部添字をintで表せる長さか検査します。
        if n <= 0 or (n and (n - 1)) != 0 or n > high(int) div 2:
            raise newException(ValueError, "長さは正の2冪で、2*Nがintの範囲内である必要があります")

    proc checkXORRange(n, l, r, mask: int) =
        ## 半開区間と添字XORのmaskを検査します。
        if l < 0 or l > r or r > n or mask < 0 or mask >= n:
            raise newException(ValueError, "0 <= l <= r <= N, 0 <= mask < Nが必要です")

    proc initXORSegmentTree*[T](v: openArray[T], merge: proc(x, y: T): T,
                              default: T): XORSegmentTree[T] =
        ## 可換モノイドの添字XORセグ木を構築します。時間・領域O(N)、Nは正の2冪。
        checkXORLength(v.len)
        result = XORSegmentTree[T](length: v.len, merge: merge, default: default,
                                   data: newSeq[T](2 * v.len))
        for i in 0..<v.len:
            result.data[v.len + i] = v[i]
        for i in countdown(v.len - 1, 1):
            result.data[i] = merge(result.data[2 * i], result.data[2 * i + 1])

    proc initXORSegmentTree*[T](n: int, merge: proc(x, y: T): T,
                              default: T): XORSegmentTree[T] =
        ## N個の単位元で可換版を構築します。時間・領域O(N)、Nは正の2冪。
        checkXORLength(n)
        var v = newSeq[T](n)
        for x in v.mitems: x = default
        result = initXORSegmentTree(v, merge, default)

    proc initStaticXORSegmentTree*[T](v: openArray[T], merge: proc(x, y: T): T,
                                    default: T): StaticXORSegmentTree[T] =
        ## 非可換モノイドの静的添字XORセグ木を構築します。時間・領域O(N log N)。
        checkXORLength(v.len)
        result = StaticXORSegmentTree[T](length: v.len, merge: merge,
                                        default: default, levels: @[@v])
        var size = 2
        while size <= v.len:
            let half = size shr 1
            let previous = result.levels.high
            var current = newSeq[T](v.len)
            var base = 0
            while base < v.len:
                for mask in 0..<half:
                    let left = result.levels[previous][base + mask]
                    let right = result.levels[previous][base + half + mask]
                    current[base + mask] = merge(left, right)
                    current[base + half + mask] = merge(right, left)
                base += size
            result.levels.add(current)
            size *= 2

    proc len*[T](self: XORSegmentTree[T] or StaticXORSegmentTree[T]): int =
        ## 元の配列の長さをO(1)で返します。
        self.length

    proc `[]`*[T](self: XORSegmentTree[T] or StaticXORSegmentTree[T], i: int): T =
        ## 元の添字iの値をO(1)で返します。
        checkXORRange(self.length, i, i, 0)
        if i == self.length:
            raise newException(ValueError, "添字はN未満である必要があります")
        when self is XORSegmentTree[T]:
            self.data[self.length + i]
        else:
            self.levels[0][i]

    proc update*[T](self: XORSegmentTree[T], i: int, value: T) =
        ## 元の添字iをvalueに置き換えます。O(log N)、可換版のみ。
        checkXORRange(self.length, i, i, 0)
        if i == self.length:
            raise newException(ValueError, "添字はN未満である必要があります")
        var node = self.length + i
        self.data[node] = value
        while node > 1:
            node = node shr 1
            self.data[node] = self.merge(self.data[2 * node], self.data[2 * node + 1])

    proc `[]=`*[T](self: XORSegmentTree[T], i: int, value: T) =
        ## 元の添字iをvalueに置き換えます。O(log N)。
        self.update(i, value)

    proc get*[T](self: XORSegmentTree[T] or StaticXORSegmentTree[T],
                 l, r: int, mask: int = 0): T =
        ## a[l xor mask], ..., a[(r-1) xor mask]の順の積をO(log N)で返します。
        checkXORRange(self.length, l, r, mask)
        var left = l + self.length
        var right = r + self.length
        var level = 0
        var leftResult = self.default
        var rightResult = self.default
        template value(node: int): T =
            block:
                let mapped = node xor (mask shr level)
                when self is XORSegmentTree[T]:
                    self.data[mapped]
                else:
                    let base = (mapped - (self.length shr level)) shl level
                    self.levels[level][base + (mask and ((1 shl level) - 1))]
        while left < right:
            if (left and 1) != 0:
                leftResult = self.merge(leftResult, value(left))
                inc left
            if (right and 1) != 0:
                dec right
                rightResult = self.merge(value(right), rightResult)
            left = left shr 1
            right = right shr 1
            inc level
        self.merge(leftResult, rightResult)

    proc get_all*[T](self: XORSegmentTree[T] or StaticXORSegmentTree[T],
                     mask: int = 0): T =
        ## 添字XOR後の全区間の積をO(1)で返します。
        checkXORRange(self.length, 0, self.length, mask)
        when self is XORSegmentTree[T]:
            self.data[1]
        else:
            self.levels[^1][mask]
