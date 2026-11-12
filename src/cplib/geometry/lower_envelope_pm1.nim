when not declared CPLIB_GEOMETRY_LOWER_ENVELOPE_PM1:
    const CPLIB_GEOMETRY_LOWER_ENVELOPE_PM1* = 1
    import options
    import cplib/geometry/base
    import cplib/math/fractions
    import cplib/math/int128

    type
        EnvelopePm1Frac = Fraction[Int128]
        EnvelopeCurve*[T] = object
            s, t: Point[T]
        EnvelopeDiagram*[T] = object
            xs*: seq[T]
            point_sources*, interval_sources*: seq[int]
        UnitFunction = object
            slope: int8
            intercept: Int128
        Envelope*[T] = object
            diagram*: EnvelopeDiagram[T]
            functions: seq[UnitFunction]

    proc initEnvelopeRay*(s, t: Point[EnvelopePm1Frac]): EnvelopeCurve[EnvelopePm1Frac] =
        ## 始点を含む傾き±1の半直線を作る。座標と傾きは包絡線構築時に検査する。O(1)。
        if s.x == t.x and s.y == t.y:
            raise newException(ValueError, "半直線の方向を指定してください")
        EnvelopeCurve[EnvelopePm1Frac](s: s, t: t)

    proc integerCoordinate(x: EnvelopePm1Frac): Int128 =
        ## 整数座標を取り出す。分母0または非整数ならValueError。
        if x.den == 1: return x.num
        if x.den == 0 or x.num mod x.den != 0:
            raise newException(ValueError, "座標は整数で指定してください")
        x.num div x.den

    proc parseRay(c: EnvelopeCurve[EnvelopePm1Frac]): tuple[f: UnitFunction, x, y: Int128, left: bool] =
        ## 整数座標の傾き±1の半直線を内部表現へ変換する。O(1)。
        let sx = integerCoordinate(c.s.x)
        let sy = integerCoordinate(c.s.y)
        let tx = integerCoordinate(c.t.x)
        let ty = integerCoordinate(c.t.y)
        let dx = tx - sx
        let dy = ty - sy
        if dx == 0 or (dy != dx and dy != -dx):
            raise newException(ValueError, "傾きは-1または1を指定してください")
        let slope = if dy == dx: 1'i8 else: -1'i8
        (UnitFunction(slope: slope, intercept: sy - Int128(slope) * sx), sx, sy, dx < 0)

    proc value(f: UnitFunction, x: EnvelopePm1Frac): EnvelopePm1Frac {.inline.} =
        ## 支持直線を厳密な分数で評価する。O(1)。
        initFraction(Int128(f.slope) * x.num + f.intercept * x.den, x.den)

    proc winner(a, b: int, x: EnvelopePm1Frac, functions: seq[UnitFunction],
            upper: static[bool]): int {.inline.} =
        ## 有限のxで優勝する入力番号を返す。同値は小さい番号。O(1)。
        if a < 0: return b
        if b < 0: return a
        let f = functions[a]
        let g = functions[b]
        let delta = Int128(int(f.slope) - int(g.slope)) * x.num +
            (f.intercept - g.intercept) * x.den
        if delta == 0: return min(a, b)
        when upper:
            if delta > 0: a else: b
        else:
            if delta < 0: a else: b

    proc addBoundary(d: var EnvelopeDiagram[EnvelopePm1Frac], x: EnvelopePm1Frac,
            point, right: int) {.inline.} =
        ## 左右の開区間と点の代表が同じ境界を省く。O(1)。
        if d.interval_sources[^1] == point and point == right: return
        d.xs.add(x)
        d.point_sources.add(point)
        d.interval_sources.add(right)

    proc mergeDiagram(a, b: EnvelopeDiagram[EnvelopePm1Frac], functions: seq[UnitFunction],
            bOffset: int, upper: static[bool]): EnvelopeDiagram[EnvelopePm1Frac] =
        ## 2つの包絡図を境界数の合計に比例する時間で合成する。
        result.xs = newSeqOfCap[EnvelopePm1Frac](a.xs.len + b.xs.len)
        result.point_sources = newSeqOfCap[int](a.xs.len + b.xs.len)
        result.interval_sources = newSeqOfCap[int](a.xs.len + b.xs.len + 1)
        var i, j = 0
        var hasLeft = false
        var left: EnvelopePm1Frac
        var point = -1
        while true:
            let hasRight = i < a.xs.len or j < b.xs.len
            var right: EnvelopePm1Frac
            if i < a.xs.len and (j == b.xs.len or a.xs[i] < b.xs[j]):
                right = a.xs[i]
            elif j < b.xs.len:
                right = b.xs[j]
            let u = a.interval_sources[i]
            let bv = b.interval_sources[j]
            let v = if bv < 0: -1 else: bv + bOffset
            var first, second: int
            var split = false
            var crossing: EnvelopePm1Frac
            if u < 0:
                first = v
            elif v < 0:
                first = u
            elif functions[u].slope == functions[v].slope:
                let fu = functions[u]
                let fv = functions[v]
                if fu.intercept == fv.intercept:
                    first = min(u, v)
                else:
                    when upper:
                        first = if fu.intercept > fv.intercept: u else: v
                    else:
                        first = if fu.intercept < fv.intercept: u else: v
            else:
                let fu = functions[u]
                let fv = functions[v]
                crossing = initFraction(fv.intercept - fu.intercept,
                    Int128(int(fu.slope) - int(fv.slope)))
                when upper:
                    let uOnLeft = fu.slope < fv.slope
                else:
                    let uOnLeft = fu.slope > fv.slope
                let before = if uOnLeft: u else: v
                let after = if uOnLeft: v else: u
                if not hasLeft or left < crossing:
                    first = before
                    if not hasRight or crossing < right:
                        split = true
                        second = after
                else:
                    first = after
            if hasLeft:
                addBoundary(result, left, point, first)
            else:
                result.interval_sources.add(first)
            if split:
                addBoundary(result, crossing, min(u, v), second)
            if not hasRight: break
            var atA = u
            var atB = v
            if i < a.xs.len and a.xs[i] == right:
                atA = a.point_sources[i]
                inc i
            if j < b.xs.len and b.xs[j] == right:
                atB = if b.point_sources[j] < 0: -1 else: b.point_sources[j] + bOffset
                inc j
            point = winner(atA, atB, right, functions, upper)
            left = right
            hasLeft = true

    proc build(curves: openArray[EnvelopeCurve[EnvelopePm1Frac]],
            upper: static[bool]): Envelope[EnvelopePm1Frac] =
        ## 傾き±1の半直線列の包絡図を分割統治で構築する。
        if curves.len == 2:
            let a = parseRay(curves[0])
            let b = parseRay(curves[1])
            if a.x == b.x and a.y == b.y and a.left != b.left:
                result.functions = @[a.f, b.f]
                result.diagram.xs = @[initFraction(a.x)]
                result.diagram.point_sources = @[0]
                result.diagram.interval_sources = if a.left: @[0, 1] else: @[1, 0]
                return

        result.functions = newSeqOfCap[UnitFunction](curves.len)
        var starts = newSeq[Int128](curves.len)
        var lefts = newSeq[bool](curves.len)
        for i, c in curves:
            let parsed = parseRay(c)
            result.functions.add(parsed.f)
            starts[i] = parsed.x
            lefts[i] = parsed.left
        let functions = result.functions

        proc solve(first, last: int): EnvelopeDiagram[EnvelopePm1Frac] =
            ## 入力番号の区間を半分ずつ再帰して包絡図を作る。
            if first == last:
                result.interval_sources = @[-1]
            elif last - first == 1:
                result.xs = @[initFraction(starts[first])]
                result.point_sources = @[first]
                result.interval_sources = if lefts[first]: @[first, -1] else: @[-1, first]
            else:
                let middle = first + (last - first) div 2
                result = mergeDiagram(solve(first, middle), solve(middle, last),
                    functions, 0, upper)

        result.diagram = solve(0, curves.len)

    proc combine(a, b: Envelope[EnvelopePm1Frac], upper: static[bool]): Envelope[EnvelopePm1Frac] =
        ## 2つの包絡線を入力番号の順序を保って合成する。O(F+K)。
        result.functions = a.functions & b.functions
        result.diagram = mergeDiagram(a.diagram, b.diagram,
            result.functions, a.functions.len, upper)

    proc lower_envelope*(curves: openArray[EnvelopeCurve[EnvelopePm1Frac]]): Envelope[EnvelopePm1Frac] =
        ## 各xで最小値を残す。傾き±1の整数座標半直線のみ受け付ける。
        build(curves, false)

    proc upper_envelope*(curves: openArray[EnvelopeCurve[EnvelopePm1Frac]]): Envelope[EnvelopePm1Frac] =
        ## 各xで最大値を残す。入力制約と計算量はlower_envelopeと同じ。
        build(curves, true)

    proc lower_envelope*(a, b: Envelope[EnvelopePm1Frac]): Envelope[EnvelopePm1Frac] =
        ## 2つの包絡線の各xで最小値を残す。O(F+K)。
        combine(a, b, false)

    proc upper_envelope*(a, b: Envelope[EnvelopePm1Frac]): Envelope[EnvelopePm1Frac] =
        ## 2つの包絡線の各xで最大値を残す。O(F+K)。
        combine(a, b, true)

    proc source_at*(e: Envelope[EnvelopePm1Frac], x: EnvelopePm1Frac): int =
        ## 有限のxでの代表入力番号を二分探索で返す。定義域外は-1。
        if x.den == 0: raise newException(ValueError, "有限のxを指定してください")
        var l = 0
        var r = e.diagram.xs.len
        while l < r:
            let m = l + (r - l) div 2
            if e.diagram.xs[m] < x: l = m + 1
            else: r = m
        if l < e.diagram.xs.len and e.diagram.xs[l] == x:
            e.diagram.point_sources[l]
        else:
            e.diagram.interval_sources[l]

    proc source_value*(e: Envelope[EnvelopePm1Frac], source: int, x: EnvelopePm1Frac): EnvelopePm1Frac =
        ## 指定入力の支持直線を評価する。O(1)。
        if x.den == 0 or source < 0 or source >= e.functions.len:
            raise newException(ValueError, "xまたは入力番号が不正です")
        value(e.functions[source], x)

    proc value_at*(e: Envelope[EnvelopePm1Frac], x: EnvelopePm1Frac): Option[EnvelopePm1Frac] =
        ## 有限のxで包絡線の値を返す。定義域外はnone(EnvelopePm1Frac)。
        let source = e.source_at(x)
        if source < 0: none(EnvelopePm1Frac)
        else: some(value(e.functions[source], x))
