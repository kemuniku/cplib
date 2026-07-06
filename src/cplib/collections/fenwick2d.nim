when not declared CPLIB_COLLECTIONS_FENWICK2D:
    const CPLIB_COLLECTIONS_FENWICK2D* = 1
    import algorithm
    import sequtils


    type Fenwick2D = ref object
        n: int
        ys: seq[seq[int]]
        bit: seq[seq[int]]

    proc initFenwick2D*(posVals: seq[seq[int]]): Fenwick2D =
        let n = posVals.len
        var ys = newSeq[seq[int]](n + 1)
        for p in 0..<n:
            var i = p + 1
            while i <= n:
                ys[i].add(posVals[p])
                i += i and -i
        var bit = newSeq[seq[int]](n + 1)
        for i in 1..n:
            ys[i].sort()
            ys[i] = ys[i].deduplicate(true)
            bit[i] = newSeq[int](ys[i].len + 1)
        Fenwick2D(n: n, ys: ys, bit: bit)

    proc add*(self: Fenwick2D, p, y, delta: int) =
        var i = p + 1
        while i <= self.n:
            var k = self.ys[i].lowerBound(y) + 1
            while k < self.bit[i].len:
                self.bit[i][k] += delta
                k += k and -k
            i += i and -i

    proc prefix*(self: Fenwick2D, r, yUpper: int): int =
        var i = r
        while i > 0:
            var k = self.ys[i].lowerBound(yUpper)
            while k > 0:
                result += self.bit[i][k]
                k -= k and -k
            i -= i and -i

    proc getLess*(self: Fenwick2D, l, r, yUpper: int): int =
        self.prefix(r, yUpper) - self.prefix(l, yUpper)

    proc get*(self: Fenwick2D, l, r, yLower, yUpper: int): int =
        ## 長方形領域 x in [l,r), y in [yLower,yUpper) の和を返します。
        self.getLess(l, r, yUpper) - self.getLess(l, r, yLower)
