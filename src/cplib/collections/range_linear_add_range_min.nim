when not declared CPLIB_COLLECTIONS_RANGE_LINEAR_ADD_RANGE_MIN:
    const CPLIB_COLLECTIONS_RANGE_LINEAR_ADD_RANGE_MIN* = 1
    import cplib/math/int128

    type
        LinearMinPoint = tuple[x, y: int]
        LinearMinNode = object
            left, right: LinearMinPoint
            slope, intercept: int
        RangeLinearAddRangeMin* = ref object
            length: int
            nodes: seq[LinearMinNode]

    proc shifted(p: LinearMinPoint, slope, intercept: int): LinearMinPoint {.inline.} =
        ## 点の高さに slope * x + intercept を加えます。O(1)。
        (p.x, p.y + slope * p.x + intercept)

    proc cross(a, b, c, d: LinearMinPoint): Int128 {.inline.} =
        ## ベクトル b-a と d-c の外積を128bit整数で求めます。O(1)。
        (to_Int128(b.x) - a.x) * (to_Int128(d.y) - c.y) -
            (to_Int128(b.y) - a.y) * (to_Int128(d.x) - c.x)

    proc pull(self: RangeLinearAddRangeMin, k, border: int) =
        ## 左右の下側凸包の共通接線を求めます。O(log N)。
        var
            l = k * 2
            r = k * 2 + 1
            ls = self.nodes[l].slope
            lc = self.nodes[l].intercept
            rs = self.nodes[r].slope
            rc = self.nodes[r].intercept
        while true:
            let
                a = shifted(self.nodes[l].left, ls, lc)
                b = shifted(self.nodes[l].right, ls, lc)
                c = shifted(self.nodes[r].left, rs, rc)
                d = shifted(self.nodes[r].right, rs, rc)
                lLeaf = a.x == b.x
                rLeaf = c.x == d.x
            if lLeaf and rLeaf:
                self.nodes[k].left = a
                self.nodes[k].right = c
                return
            var descendLeft: bool
            var child: int
            if not lLeaf and cross(a, b, a, c) < 0:
                descendLeft = true
                child = l * 2
            elif not rLeaf and cross(b, c, b, d) < 0:
                child = r * 2 + 1
            elif lLeaf:
                child = r * 2
            elif rLeaf:
                descendLeft = true
                child = l * 2 + 1
            else:
                let
                    c1 = cross(a, b, c, d)
                    c2 = cross(a, b, c, b)
                # 接線候補の交点が左右の境界のどちら側にあるかを判定します。
                descendLeft = if c1 == 0 and c2 == 0: c.x < border
                    else: to_Int128(c.x - border) * c1 + to_Int128(d.x - c.x) * c2 < 0
                child = if descendLeft: l * 2 + 1 else: r * 2
            if descendLeft:
                l = child
                ls += self.nodes[l].slope
                lc += self.nodes[l].intercept
            else:
                r = child
                rs += self.nodes[r].slope
                rc += self.nodes[r].intercept

    proc build(self: RangeLinearAddRangeMin, v: openArray[int], k, l, r: int) =
        ## 区間の凸包を再帰的に構築します。O(r-l)。
        if r - l == 1:
            self.nodes[k].left = (l, v[l])
            self.nodes[k].right = (l, v[l])
            return
        let m = (l + r) shr 1
        self.build(v, k * 2, l, m)
        self.build(v, k * 2 + 1, m, r)
        self.pull(k, m)

    proc initRangeLinearAddRangeMin*(v: openArray[int]): RangeLinearAddRangeMin =
        ## 配列から構築します。時間・空間 O(N)。64bit環境のC++バックエンド専用です。
        ## 値・遅延加算の係数とその適用時の中間値は int に収めてください。
        ## 各節点は自身の遅延加算を除いた下側凸包の共通接線を保持します。
        static: doAssert sizeof(int) == 8
        result = RangeLinearAddRangeMin(length: v.len, nodes: newSeq[LinearMinNode](4 * v.len))
        if v.len > 0:
            result.build(v, 1, 0, v.len)

    proc push(self: RangeLinearAddRangeMin, k: int) {.inline.} =
        ## 一次式の遅延加算を子へ伝えます。O(1)。
        for child in k * 2..k * 2 + 1:
            self.nodes[child].slope += self.nodes[k].slope
            self.nodes[child].intercept += self.nodes[k].intercept
        self.nodes[k].slope = 0
        self.nodes[k].intercept = 0

    proc addImpl(self: RangeLinearAddRangeMin, k, l, r, ql, qr, b, c: int) =
        ## 指定区間へ一次式を加算し、境界上の接線を更新します。O(log^2 N)。
        if ql <= l and r <= qr:
            self.nodes[k].slope += b
            self.nodes[k].intercept += c
            return
        self.push(k)
        let m = (l + r) shr 1
        if ql < m:
            self.addImpl(k * 2, l, m, ql, qr, b, c)
        if m < qr:
            self.addImpl(k * 2 + 1, m, r, ql, qr, b, c)
        self.pull(k, m)

    proc add*(self: RangeLinearAddRangeMin, l, r, b, c: int) =
        ## 半開区間 [l,r) の a[i] に b*i+c を加えます。O(log^2 N)。
        assert 0 <= l and l <= r and r <= self.length
        if l < r:
            self.addImpl(1, 0, self.length, l, r, b, c)

    proc add*(self: RangeLinearAddRangeMin, segment: HSlice[int, int], b, c: int) =
        ## 指定区間の a[i] に b*i+c を加えます。添字 i は配列全体での添字です。O(log^2 N)。
        self.add(segment.a, segment.b + 1, b, c)

    proc subtreeMin(self: RangeLinearAddRangeMin, root, slope, intercept: int): int =
        ## 接線の傾きで子を選び、部分木の最小値を求めます。O(log N)。
        var
            k = root
            s = slope
            t = intercept
        while true:
            s += self.nodes[k].slope
            t += self.nodes[k].intercept
            let
                a = shifted(self.nodes[k].left, s, t)
                b = shifted(self.nodes[k].right, s, t)
            if a.x == b.x:
                return a.y
            k = if a.y < b.y: k * 2 else: k * 2 + 1

    proc prodImpl(self: RangeLinearAddRangeMin, k, l, r, ql, qr, slope, intercept: int): int =
        ## 区間を部分木へ分割して最小値を求めます。O(log^2 N)。
        if ql <= l and r <= qr:
            return self.subtreeMin(k, slope, intercept)
        let
            m = (l + r) shr 1
            s = slope + self.nodes[k].slope
            t = intercept + self.nodes[k].intercept
        result = high(int)
        if ql < m:
            result = self.prodImpl(k * 2, l, m, ql, qr, s, t)
        if m < qr:
            result = min(result, self.prodImpl(k * 2 + 1, m, r, ql, qr, s, t))

    proc prod*(self: RangeLinearAddRangeMin, l, r: int): int =
        ## 半開区間 [l,r) の最小値を返します。空区間は high(int)。O(log^2 N)。
        assert 0 <= l and l <= r and r <= self.length
        if l == r: return high(int)
        self.prodImpl(1, 0, self.length, l, r, 0, 0)

    proc prod*(self: RangeLinearAddRangeMin, segment: HSlice[int, int]): int =
        ## 指定区間の最小値を返します。空区間は high(int)。O(log^2 N)。
        self.prod(segment.a, segment.b + 1)

    proc `[]`*(self: RangeLinearAddRangeMin, segment: HSlice[int, int]): int =
        ## 指定区間の最小値を返します。O(log^2 N)。
        self.prod(segment)

    proc `[]`*(self: RangeLinearAddRangeMin, i: int): int =
        ## a[i] を返します。O(log N)。
        assert 0 <= i and i < self.length
        self.prod(i, i + 1)

    proc len*(self: RangeLinearAddRangeMin): int =
        ## 配列の長さを返します。O(1)。
        self.length
