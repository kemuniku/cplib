when not declared CPLIB_GEOMETRY_LOWER_ENVELOPE:
    const CPLIB_GEOMETRY_LOWER_ENVELOPE* = 1
    import options
    import cplib/geometry/base
    import cplib/math/fractions

    type
        EnvelopeNumber = concept type T
            T is SomeFloat or T is Fraction
        EnvelopeCurve*[T: EnvelopeNumber] = object
            s, t: Point[T]
            ray: bool
        EnvelopeFunction[T: EnvelopeNumber] = object
            x, y, slope: T
        EnvelopeDiagram*[T: EnvelopeNumber] = object
            ## xsの各点と、その間の開区間の代表入力番号。-1は定義域が空。
            xs*: seq[T]
            point_sources*, interval_sources*: seq[int]
        Envelope*[T: EnvelopeNumber] = object
            diagram*: EnvelopeDiagram[T]
            functions: seq[EnvelopeFunction[T]]

    proc initEnvelopeSegment*[T: EnvelopeNumber](s, t: Point[T]): EnvelopeCurve[T] =
        ## 両端を含む線分を作る。逆順、垂直、長さ0も許す。O(1)。
        EnvelopeCurve[T](s: s, t: t)

    proc initEnvelopeSegment*[T: EnvelopeNumber](s: Segment[T]): EnvelopeCurve[T] =
        ## 既存のSegmentを包絡線用の入力に変換する。O(1)。
        initEnvelopeSegment(s.s, s.t)

    proc initEnvelopeRay*[T: EnvelopeNumber](s, t: Point[T]): EnvelopeCurve[T] =
        ## 始点sを含み、tの方向へ伸びる半直線を作る。s = tはValueError。O(1)。
        if s.x == t.x and s.y == t.y:
            raise newException(ValueError, "半直線の方向を指定してください")
        EnvelopeCurve[T](s: s, t: t, ray: true)

    proc envelopeFinite[T: EnvelopeNumber](x: T) {.inline.} =
        ## NaNと無限大を拒否する。無限端は座標値とは別に管理する。
        when T is SomeFloat:
            if not (x > T(-Inf) and x < T(Inf)):
                raise newException(ValueError, "包絡線の座標・中間計算は有限値である必要があります")
        else:
            if x.den == 0:
                raise newException(ValueError, "包絡線の分数は有限値である必要があります")

    proc envelopeValue[T: EnvelopeNumber](f: EnvelopeFunction[T], x: T): T {.inline.} =
        ## 基準点からの差分で一次関数を評価する。
        result = f.y + f.slope * (x - f.x)
        envelopeFinite(result)

    proc envelopeBuild[T: EnvelopeNumber](curves: openArray[EnvelopeCurve[T]],
            upper: static[bool]): Envelope[T] =
        ## 平衡分割統治と線形マージで上下どちらかの包絡図を構築する。
        let n = curves.len
        var functions = newSeq[EnvelopeFunction[T]](n)
        var domains = newSeq[tuple[left, right: T, leftInfinite, rightInfinite: bool]](n)
        for i, c in curves:
            for v in [c.s.x, c.s.y, c.t.x, c.t.y]:
                envelopeFinite(v)
            if c.s.x == c.t.x:
                var y = c.s.y
                if c.ray:
                    if c.s.y == c.t.y:
                        raise newException(ValueError, "半直線の方向を指定してください")
                    when upper:
                        if c.t.y > c.s.y:
                            raise newException(ValueError, "上向きの垂直半直線には最大値が存在しません")
                    else:
                        if c.t.y < c.s.y:
                            raise newException(ValueError, "下向きの垂直半直線には最小値が存在しません")
                else:
                    when upper: y = max(c.s.y, c.t.y)
                    else: y = min(c.s.y, c.t.y)
                functions[i] = EnvelopeFunction[T](x: c.s.x, y: y, slope: y - y)
                domains[i] = (c.s.x, c.s.x, false, false)
            else:
                let dx = c.t.x - c.s.x
                let dy = c.t.y - c.s.y
                envelopeFinite(dx)
                envelopeFinite(dy)
                let slope = dy / dx
                envelopeFinite(slope)
                functions[i] = EnvelopeFunction[T](x: c.s.x, y: c.s.y, slope: slope)
                if c.ray:
                    domains[i] = (c.s.x, c.s.x, c.t.x < c.s.x, c.t.x > c.s.x)
                else:
                    domains[i] = (min(c.s.x, c.t.x), max(c.s.x, c.t.x), false, false)

        proc winner(a, b: int, x: T): int =
            ## 有限の境界点で比較する。同率なら小さい入力番号を返す。
            if a < 0: return b
            if b < 0: return a
            let ya = envelopeValue(functions[a], x)
            let yb = envelopeValue(functions[b], x)
            if ya == yb: return min(a, b)
            when upper:
                if ya > yb: a else: b
            else:
                if ya < yb: a else: b

        proc addBoundary(d: var EnvelopeDiagram[T], x: T, point, right: int) =
            ## 左開区間・点・右開区間の代表が同じ場合だけ境界を省く。
            if d.interval_sources[^1] == point and point == right: return
            d.xs.add(x)
            d.point_sources.add(point)
            d.interval_sources.add(right)

        proc merge(a, b: EnvelopeDiagram[T]): EnvelopeDiagram[T] =
            ## 2包絡図を同時に走査し、共通開区間内の交点で高々1回分割する。O(|a|+|b|)。
            result.xs = newSeqOfCap[T](a.xs.len + b.xs.len)
            result.point_sources = newSeqOfCap[int](a.xs.len + b.xs.len)
            result.interval_sources = newSeqOfCap[int](a.xs.len + b.xs.len + 1)
            var i, j = 0
            var hasLeft = false
            var left: T
            var point = -1
            while true:
                let hasRight = i < a.xs.len or j < b.xs.len
                var right: T
                if i < a.xs.len and (j == b.xs.len or a.xs[i] < b.xs[j]):
                    right = a.xs[i]
                elif j < b.xs.len:
                    right = b.xs[j]
                let u = a.interval_sources[i]
                let v = b.interval_sources[j]
                var first, second: int
                var split = false
                var crossing: T
                if u < 0:
                    first = v
                elif v < 0:
                    first = u
                elif functions[u].slope == functions[v].slope:
                    first = winner(u, v, functions[u].x)
                else:
                    let f = functions[u]
                    let g = functions[v]
                    let slopeDifference = f.slope - g.slope
                    envelopeFinite(slopeDifference)
                    crossing = f.x + (envelopeValue(g, f.x) - f.y) / slopeDifference
                    envelopeFinite(crossing)
                    when upper:
                        let uOnLeft = f.slope < g.slope
                    else:
                        let uOnLeft = f.slope > g.slope
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
                    atB = b.point_sources[j]
                    inc j
                point = winner(atA, atB, right)
                left = right
                hasLeft = true

        proc solve(first, last: int): EnvelopeDiagram[T] =
            ## 入力番号の区間を半分ずつ再帰する。中間包絡図も線形サイズとは仮定しない。
            if first == last:
                result.interval_sources = @[-1]
            elif last - first == 1:
                let d = domains[first]
                if d.leftInfinite:
                    result.xs = @[d.right]
                    result.point_sources = @[first]
                    result.interval_sources = @[first, -1]
                elif d.rightInfinite:
                    result.xs = @[d.left]
                    result.point_sources = @[first]
                    result.interval_sources = @[-1, first]
                elif d.left == d.right:
                    result.xs = @[d.left]
                    result.point_sources = @[first]
                    result.interval_sources = @[-1, -1]
                else:
                    result.xs = @[d.left, d.right]
                    result.point_sources = @[first, first]
                    result.interval_sources = @[-1, first, -1]
            else:
                let middle = first + (last - first) div 2
                result = merge(solve(first, middle), solve(middle, last))

        result.diagram = solve(0, n)
        result.functions = move(functions)

    proc lower_envelope*[T: EnvelopeNumber](curves: openArray[EnvelopeCurve[T]]): Envelope[T] =
        ## 各xで最小のyを残す。最悪O(N α(N) log N)時間、O(N α(N))領域（算術演算をO(1)とする）。
        ## 入力端点は閉区間。同率は最小入力番号、空区間は-1。下向き垂直半直線はValueError。
        ## floatは近似計算でEPSを使わない。厳密計算はFractionを使い、全中間整数のoverflowを避けること。
        envelopeBuild(curves, false)

    proc upper_envelope*[T: EnvelopeNumber](curves: openArray[EnvelopeCurve[T]]): Envelope[T] =
        ## 各xで最大のyを残す。計算量と数値制約はlower_envelopeと同じ。上向き垂直半直線はValueError。
        envelopeBuild(curves, true)

    proc lower_envelope*[T: EnvelopeNumber](segments: openArray[Segment[T]]): Envelope[T] =
        ## 既存の線分列の下側包絡線。入力順の番号を保つ。計算量と数値制約は曲線列版と同じ。
        var curves = newSeq[EnvelopeCurve[T]](segments.len)
        for i, s in segments: curves[i] = initEnvelopeSegment(s)
        lower_envelope(curves)

    proc upper_envelope*[T: EnvelopeNumber](segments: openArray[Segment[T]]): Envelope[T] =
        ## 既存の線分列の上側包絡線。入力順の番号を保つ。計算量と数値制約は曲線列版と同じ。
        var curves = newSeq[EnvelopeCurve[T]](segments.len)
        for i, s in segments: curves[i] = initEnvelopeSegment(s)
        upper_envelope(curves)

    proc source_at*[T: EnvelopeNumber](e: Envelope[T], x: T): int =
        ## 有限のxでの代表入力番号をO(log(K+1))で返す。定義域外は-1。Kは境界数。
        envelopeFinite(x)
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

    proc value_at*[T: EnvelopeNumber](e: Envelope[T], x: T): Option[T] =
        ## 有限のxでの包絡線の値をO(log(K+1))で返す。定義域外はnone(T)。
        let source = e.source_at(x)
        if source < 0: none(T)
        else: some(envelopeValue(e.functions[source], x))

    proc source_value*[T: EnvelopeNumber](e: Envelope[T], source: int, x: T): T =
        ## 指定入力の支持直線をO(1)で評価する。開端点の片側極限にも使える。定義域は検査しない。
        ## 垂直入力は選択した極値の定数関数として評価する。不正番号・非有限xはValueError。
        envelopeFinite(x)
        if source < 0 or source >= e.functions.len:
            raise newException(ValueError, "包絡線の入力番号が範囲外です")
        envelopeValue(e.functions[source], x)
