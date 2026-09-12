when not declared CPLIB_COLLECTIONS_PRIVATE_CONVEX_HULL_TRICK_IMPL:
    const CPLIB_COLLECTIONS_PRIVATE_CONVEX_HULL_TRICK_IMPL* = 1
    import deques
    import cplib/math/int128

    type
        CHTLine* = object
            a*, b*: int
            start*: Int128
        CHTMonotoneHull* = object
            lines*: Deque[CHTLine]
            slopeIncreasing: bool
            hasSlope: bool
            lastSlope: int

    proc `<`*(l, r: CHTLine): bool =
        ## 傾きの降順で比較します。
        l.a > r.a

    proc `<=`*(l, r: CHTLine): bool =
        ## 傾きの降順で比較します。
        l.a >= r.a

    proc chtValue*(line: CHTLine, x: int): Int128 =
        ## 直線の値を128bit整数で計算します。O(1)。
        to_Int128(line.a) * to_Int128(x) + to_Int128(line.b)

    proc chtAnswer*(value: Int128): int =
        ## 最小値をintに変換します。O(1)。
        assert to_Int128(low(int)) <= value and value <= to_Int128(high(int)),
            "CHT: minimum does not fit in int"
        value.to_int

    proc chtStart*(l, r: CHTLine): Int128 =
        ## 傾きの小さいrがl以下になる最初の整数座標を返します。O(1)。
        let numerator = to_Int128(r.b) - to_Int128(l.b)
        let denominator = to_Int128(l.a) - to_Int128(r.a)
        assert denominator > 0
        result = numerator div denominator
        if numerator mod denominator > 0:
            result += 1

    proc chtRedundant*(l, m, r: CHTLine): bool =
        ## 傾きが降順の3直線について、中央の直線が不要か判定します。O(1)。
        chtStart(l, m) >= chtStart(m, r)

    proc initCHTMonotoneHull*(slopeIncreasing: bool = false): CHTMonotoneHull =
        ## 傾きが単調な最小値CHTを初期化します。既定は広義単調減少。O(1)。
        result.lines = initDeque[CHTLine]()
        result.slopeIncreasing = slopeIncreasing

    proc chtAddLine*(self: var CHTMonotoneHull, a, b: int) =
        ## ax+bを追加します。傾きは指定した向きに単調である必要があります。償却O(1)。
        if self.hasSlope:
            assert (if self.slopeIncreasing: self.lastSlope <= a else: a <= self.lastSlope),
                "CHT: slopes must be monotone"
        self.hasSlope = true
        self.lastSlope = a
        let line = CHTLine(a: a, b: b)
        if self.slopeIncreasing:
            if self.lines.len > 0 and self.lines[0].a == a:
                if self.lines[0].b <= b: return
                discard self.lines.popFirst()
            while self.lines.len >= 2 and chtRedundant(line, self.lines[0], self.lines[1]):
                discard self.lines.popFirst()
            self.lines.addFirst(line)
        else:
            if self.lines.len > 0 and self.lines[^1].a == a:
                if self.lines[^1].b <= b: return
                discard self.lines.popLast()
            while self.lines.len >= 2 and chtRedundant(self.lines[^2], self.lines[^1], line):
                discard self.lines.popLast()
            self.lines.addLast(line)

