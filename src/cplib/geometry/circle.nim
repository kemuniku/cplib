when not declared CPLIB_GEOMETRY_CIRCLE:
    const CPLIB_GEOMETRY_CIRCLE* = 1
    import math
    import cplib/geometry/base

    ## Circle[T]の円周・円盤。整数・Fractionは指定型の3点と共通尺度、floatは中心・半径で保持する。
    ## 整数・Fractionの全中間計算は指定基底型に収まることが前提。自動BigInt化なし。
    ## 明示floatの構築はfloat64へ変換し、以下の許容誤差付き浮動演算を使用する。
    ## 相対許容誤差の既定値は1e-10。絶対誤差の下限は設けず、GEOMETRY_EPSは使わない。
    ## 許容誤差内の接触は1交点・1接線に丸める。厳密な述語や正しい丸めは保証しない。
    ## 同一円の無限個という分類は中心・半径が厳密に一致する場合だけ行う。
    ## CircleIntersectionsはcircleInfiniteの場合pointsが空、それ以外は0〜2点。
    ## CircleTangentsはcircleInfiniteの場合tangentsが空、それ以外は0〜4本。
    ## 接線はfirstを通りdirectionに平行な直線。first/secondは各円の接点。
    ## 半径0ではその点を通る直線を接線と定義する。同一点同士の接線は無限個。
    ## 入力は有限値、差・距離・出力と正の尺度比もfloat64で表現可能であること。
    ## 極端な尺度差・悪条件の入力では精度を失う。検出できた非有限値はValueError。
    type
        Circle*[T] = object
            when T is SomeFloat:
                centerValue: Point[float]
                radiusValue: float
            else:
                definingPoints: array[3, Point[T]]
                commonScale: T
                initialized: bool
        CirclePointLocation* = enum
            circleOutside, circleBoundary, circleInside
        CircleResultKind* = enum
            circleFinite, circleInfinite
        CircleIntersections* = object
            kind*: CircleResultKind
            points*: seq[Point[float]]
        CircleTangent* = object
            first*, second*: Point[float]
            direction*: Point[float]
        CircleTangents* = object
            kind*: CircleResultKind
            tangents*: seq[CircleTangent]

    proc circleFiniteValue(x: float): bool =
        ##有限の浮動小数点数かを判定する。O(1)。
        x == x and abs(x) != system.Inf

    proc circleCheckPoint(p: Point[float]) =
        ##有限座標であることを検査する。O(1)。
        if not circleFiniteValue(p.x) or not circleFiniteValue(p.y):
            raise newException(ValueError, "円の座標と中間値は有限である必要があります")

    proc circleCheckTolerance(tolerance: float) =
        ##非負で有限の相対許容誤差を検査する。O(1)。
        if not circleFiniteValue(tolerance) or tolerance < 0 or tolerance >= 1:
            raise newException(ValueError, "相対許容誤差は0以上1未満である必要があります")

    proc circleLength(p: Point[float]): float =
        ##平方のオーバーフローを避けてベクトル長を計算する。O(1)。
        circleCheckPoint(p)
        let scale = max(abs(p.x), abs(p.y))
        if scale == 0: return 0
        result = scale * sqrt((p.x / scale) * (p.x / scale) + (p.y / scale) * (p.y / scale))
        if not circleFiniteValue(result):
            raise newException(ValueError, "円の距離はfloat64で表現可能である必要があります")

    proc circleUnit(p: Point[float], length: float): Point[float] =
        ##正の長さを持つベクトルを正規化する。O(1)。
        initPoint(p.x / length, p.y / length)

    proc circlePerpendicular(p: Point[float]): Point[float] =
        ##ベクトルを反時計回りに90度回転する。O(1)。
        initPoint(-p.y, p.x)

    proc circleFloatInit[T: SomeNumber, R: SomeNumber](center: Point[T], radius: R): Circle[float] =
        ##中心と非負半径からfloat64の円を構築する。O(1)。
        let p = initPoint(float(center.x), float(center.y))
        let r = float(radius)
        circleCheckPoint(p)
        if not circleFiniteValue(r) or r < 0:
            raise newException(ValueError, "円の半径は非負かつ有限である必要があります")
        Circle[float](centerValue: p, radiusValue: r)

    proc center*(c: Circle[float]): Point[float] =
        ##円の中心を返す。O(1)。
        c.centerValue

    proc radius*(c: Circle[float]): float =
        ##円の半径を返す。O(1)。
        c.radiusValue

    proc circleFloatContains[T: SomeNumber](c: Circle[float], p: Point[T], tolerance: float = 1e-10): bool =
        ##円盤が点を含むか相対許容誤差で判定する。O(1)。
        circleCheckTolerance(tolerance)
        let d = circleLength(initPoint(float(p.x), float(p.y)) - c.center)
        d <= c.radius or d - c.radius <= tolerance * max(d, c.radius)

    proc circleFloatCrossPoints(c: Circle[float], l: Line[float], tolerance: float = 1e-10): CircleIntersections =
        ##円周と非退化直線の交点を返す。O(1)。
        circleCheckTolerance(tolerance)
        circleCheckPoint(l.s)
        circleCheckPoint(l.t)
        let v = l.t - l.s
        let length = circleLength(v)
        if length == 0: raise newException(ValueError, "直線は非退化である必要があります")
        let u = circleUnit(v, length)
        let w = c.center - l.s
        circleCheckPoint(w)
        let signedDistance = cross(u, w)
        let d = abs(signedDistance)
        if not circleFiniteValue(d): raise newException(ValueError, "直線距離は有限である必要があります")
        let eps = tolerance * max(c.radius, d)
        if d > c.radius and d - c.radius > eps: return
        let foot = c.center - circlePerpendicular(u) * signedDistance
        circleCheckPoint(foot)
        if abs(d - c.radius) <= eps:
            result.points = @[foot]
        else:
            let ratio = d / c.radius
            let h = c.radius * sqrt(max(0.0, (1 - ratio) * (1 + ratio)))
            result.points = @[foot - u * h, foot + u * h]
        for p in result.points: circleCheckPoint(p)

    proc circleFloatCrossPoints(c: Circle[float], s: Segment[float], tolerance: float = 1e-10): CircleIntersections =
        ##円周と閉線分の交点を返す。退化線分も許す。O(1)。
        circleCheckTolerance(tolerance)
        circleCheckPoint(s.s)
        circleCheckPoint(s.t)
        let v = s.t - s.s
        let length = circleLength(v)
        if length == 0:
            let d = circleLength(s.s - c.center)
            if abs(d - c.radius) <= tolerance * max(d, c.radius): result.points = @[s.s]
            return
        let u = circleUnit(v, length)
        let intersections = circleFloatCrossPoints(c, Line[float](s: s.s, t: s.t), tolerance)
        for p in intersections.points:
            let t = dot(p - s.s, u)
            if t >= -tolerance * length and t - length <= tolerance * length:
                result.points.add(p)

    proc circleFloatCrossPoints(a, b: Circle[float], tolerance: float = 1e-10): CircleIntersections =
        ##2円周の交点を返す。同一の正半径円のみ無限個。O(1)。
        circleCheckTolerance(tolerance)
        let v = b.center - a.center
        let d = circleLength(v)
        if d == 0:
            if a.radius == b.radius:
                if a.radius == 0: result.points = @[a.center]
                else: result.kind = circleInfinite
            return
        let scale = max(d, max(a.radius, b.radius))
        let dn = d / scale
        if dn == 0: raise newException(ValueError, "円の尺度比はfloat64で表現可能である必要があります")
        let ra = a.radius / scale
        let rb = b.radius / scale
        let sum = ra + rb
        let difference = abs(ra - rb)
        if dn > sum + tolerance * max(dn, sum) or dn < difference - tolerance * max(dn, difference): return
        let u = circleUnit(v, d)
        let x = (dn + (ra - rb) * (ra + rb) / dn) * 0.5 * scale
        let foot = a.center + u * x
        circleCheckPoint(foot)
        if abs(dn - sum) <= tolerance * max(dn, sum) or abs(dn - difference) <= tolerance * max(dn, difference):
            result.points = @[foot]
        else:
            let h = scale * 0.5 * sqrt(max(0.0, (sum + dn) * (sum - dn))) * sqrt(max(0.0, ((dn + difference) / dn) * ((dn - difference) / dn)))
            let offset = circlePerpendicular(u) * h
            result.points = @[foot - offset, foot + offset]
        for p in result.points: circleCheckPoint(p)

    proc circleFloatCommonTangents(a, b: Circle[float], tolerance: float = 1e-10): CircleTangents =
        ##2円の共通接線を接点と単位方向で返す。同一円は無限個。O(1)。
        circleCheckTolerance(tolerance)
        let v = b.center - a.center
        let d = circleLength(v)
        if d == 0:
            if a.radius == b.radius: result.kind = circleInfinite
            return
        let u = circleUnit(v, d)
        let scale = max(d, max(a.radius, b.radius))
        let dn = d / scale
        if dn == 0: raise newException(ValueError, "円の尺度比はfloat64で表現可能である必要があります")
        for side in [1.0, -1.0]:
            if side < 0 and (a.radius == 0 or b.radius == 0): continue
            let delta = a.radius / scale - side * (b.radius / scale)
            if abs(delta) > dn + tolerance * max(dn, abs(delta)): continue
            let ratio = max(-1.0, min(1.0, delta / dn))
            let h = sqrt(max(0.0, (1 - ratio) * (1 + ratio)))
            let tangent = abs(abs(delta) - dn) <= tolerance * max(dn, abs(delta))
            for sign in [-1.0, 1.0]:
                if sign > 0 and (tangent or (a.radius == 0 and b.radius == 0)): continue
                let normalRatio = if tangent: (if delta < 0: -1.0 else: 1.0) else: ratio
                let n = u * normalRatio + circlePerpendicular(u) * (if tangent: 0.0 else: h * sign)
                let first = a.center + n * a.radius
                let second = b.center + n * (side * b.radius)
                circleCheckPoint(first)
                circleCheckPoint(second)
                result.tangents.add(CircleTangent(first: first, second: second, direction: circlePerpendicular(n)))

    proc circleFloatTangentLines[T: SomeNumber](c: Circle[float], p: Point[T], tolerance: float = 1e-10): CircleTangents =
        ##点から円への接線を返す。半径0の円自身では無限個。O(1)。
        circleFloatCommonTangents(c, circleFloatInit(p, 0), tolerance)

    include cplib/geometry/circle_integer_impl
