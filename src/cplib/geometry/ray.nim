when not declared CPLIB_GEOMETRY_RAY:
    const CPLIB_GEOMETRY_RAY* = 1
    import math
    import cplib/geometry/base

    type
        Ray* = object
            originValue, directionValue: Point[float64]
        RayIntersectionKind* = enum
            rikEmpty, rikPoint, rikSegment, rikRay
        RayIntersection* = object
            case kind*: RayIntersectionKind
            of rikEmpty: discard
            of rikPoint: point*: Point[float64]
            of rikSegment: segment*: Segment[float64]
            of rikRay: ray*: Ray
        RayPrimitive = object
            origin, direction: Point[float64]
            lower, upper: float64

    proc rayFinite(x: float64): float64 =
        ## 非有限値や表現不能な中間値を拒否する。
        if classify(x) in {fcNan, fcInf, fcNegInf}:
            raise newException(ValueError, "Rayの座標・中間値は有限である必要があります")
        x

    proc rayPoint[T: SomeNumber](p: Point[T]): Point[float64] =
        ## 座標を演算前にfloat64へ変換する。
        when T is SomeInteger:
            when T is SomeUnsignedInt:
                if uint64(p.x) > 9007199254740992'u64 or uint64(p.y) > 9007199254740992'u64:
                    raise newException(ValueError, "整数座標・方向の絶対値は2^53以下にしてください")
            else:
                if int64(p.x) < -9007199254740992'i64 or int64(p.x) > 9007199254740992'i64 or int64(p.y) < -9007199254740992'i64 or int64(p.y) > 9007199254740992'i64:
                    raise newException(ValueError, "整数座標・方向の絶対値は2^53以下にしてください")
        initPoint(rayFinite(float64(p.x)), rayFinite(float64(p.y)))

    proc rayDifference(a, b: Point[float64]): Point[float64] =
        ## 有限な座標差を求める。
        initPoint(rayFinite(a.x - b.x), rayFinite(a.y - b.y))

    proc rayDirection(d: Point[float64]): Point[float64] =
        ## 最大絶対成分を1に揃え、非零方向を検査する。
        let scale = max(abs(rayFinite(d.x)), abs(rayFinite(d.y)))
        if scale == 0:
            raise newException(ValueError, "Ray・直線の方向は非零である必要があります")
        result = initPoint(d.x / scale, d.y / scale)
        if (d.x != 0 and result.x == 0) or (d.y != 0 and result.y == 0):
            raise newException(ValueError, "方向の成分比がfloat64の範囲外です")

    proc initRay*[T: SomeNumber, U: SomeNumber](origin: Point[T], direction: Point[U]): Ray =
        ## 原点と非零方向から閉半直線を作る。方向は終点ではない。O(1)。
        result.originValue = rayPoint(origin)
        result.directionValue = rayDirection(rayPoint(direction))

    proc origin*(r: Ray): Point[float64] =
        ## 半直線の原点を返す。O(1)。
        r.originValue

    proc direction*(r: Ray): Point[float64] =
        ## 最大絶対成分が1の方向を返す（単位ベクトルではない）。O(1)。
        r.directionValue

    proc rayPrimitive(r: Ray): RayPrimitive =
        ## 半直線を非負パラメータの区間にする。
        RayPrimitive(origin: rayPoint(r.originValue), direction: rayDirection(r.directionValue), lower: 0, upper: Inf)

    proc rayPrimitive[T: SomeNumber](l: Line[T]): RayPrimitive =
        ## 直線を両方向無限のパラメータ区間にする。
        let a = rayPoint(l.s)
        RayPrimitive(origin: a, direction: rayDirection(rayDifference(rayPoint(l.t), a)), lower: -Inf, upper: Inf)

    proc rayPrimitive[T: SomeNumber](s: Segment[T]): RayPrimitive =
        ## 閉線分を有限区間にする。同一点の両端も許す。
        let a = rayPoint(s.s)
        let d = rayDifference(rayPoint(s.t), a)
        let length = max(abs(d.x), abs(d.y))
        RayPrimitive(origin: a, direction: (if length == 0: initPoint(1.0, 0.0) else: rayDirection(d)), lower: 0, upper: length)

    proc rayAt(p: RayPrimitive, t: float64): Point[float64] =
        ## 有限パラメータの点を復元する。
        initPoint(rayFinite(p.origin.x + rayFinite(p.direction.x * t)), rayFinite(p.origin.y + rayFinite(p.direction.y * t)))

    proc rayParameter(p: RayPrimitive, q: Point[float64]): float64 =
        ## 最大成分の軸で共線点のパラメータを求める。
        let d = rayDifference(q, p.origin)
        if abs(p.direction.x) >= abs(p.direction.y): rayFinite(d.x / p.direction.x)
        else: rayFinite(d.y / p.direction.y)

    proc rayIntersection(a, b: RayPrimitive): RayIntersection =
        ## 支持直線の交点または共線パラメータ区間の共通部分を求める。
        let delta = rayDifference(b.origin, a.origin)
        let denominator = cross(a.direction, b.direction)
        if denominator != 0:
            let t = rayFinite(rayFinite(cross(delta, b.direction)) / denominator)
            let u = rayFinite(rayFinite(cross(delta, a.direction)) / denominator)
            if t < a.lower or t > a.upper or u < b.lower or u > b.upper:
                return RayIntersection(kind: rikEmpty)
            return RayIntersection(kind: rikPoint, point: rayAt(a, t))
        if rayFinite(cross(delta, a.direction)) != 0:
            return RayIntersection(kind: rikEmpty)
        let start = rayParameter(a, b.origin)
        let ratio = if abs(a.direction.x) >= abs(a.direction.y): b.direction.x / a.direction.x else: b.direction.y / a.direction.y
        # 無限端点と零長線分の積を避け、向きに応じて区間端を写す。
        proc mapped(t: float64): float64 =
            if t == Inf: (if ratio > 0: Inf else: -Inf)
            elif t == -Inf: (if ratio > 0: -Inf else: Inf)
            else: rayFinite(start + rayFinite(ratio * t))
        let first = mapped(b.lower)
        let last = mapped(b.upper)
        let lo = max(a.lower, min(first, last))
        let hi = min(a.upper, max(first, last))
        if lo > hi: return RayIntersection(kind: rikEmpty)
        if lo == hi: return RayIntersection(kind: rikPoint, point: rayAt(a, lo))
        if hi == Inf:
            return RayIntersection(kind: rikRay, ray: initRay(rayAt(a, lo), a.direction))
        return RayIntersection(kind: rikSegment, segment: Segment[float64](s: rayAt(a, lo), t: rayAt(a, hi)))

    proc intersection*(a, b: Ray): RayIntersection =
        ## 閉半直線同士の共通部分を空・点・線分・半直線で返す。O(1)。
        rayIntersection(rayPrimitive(a), rayPrimitive(b))

    proc intersection*[T: SomeNumber](r: Ray, l: Line[T]): RayIntersection =
        ## 閉半直線と直線の共通部分を空・点・半直線で返す。O(1)。
        rayIntersection(rayPrimitive(r), rayPrimitive(l))

    proc intersection*[T: SomeNumber](l: Line[T], r: Ray): RayIntersection =
        ## 直線と閉半直線の共通部分を返す。O(1)。
        intersection(r, l)

    proc intersection*[T: SomeNumber](r: Ray, s: Segment[T]): RayIntersection =
        ## 閉半直線と閉線分の共通部分を空・点・線分で返す。O(1)。
        rayIntersection(rayPrimitive(r), rayPrimitive(s))

    proc intersection*[T: SomeNumber](s: Segment[T], r: Ray): RayIntersection =
        ## 閉線分と閉半直線の共通部分を返す。O(1)。
        intersection(r, s)

    proc intersect*(a, b: Ray): bool =
        ## 閉半直線同士が交わるかを返す。O(1)。
        intersection(a, b).kind != rikEmpty

    proc intersect*[T: SomeNumber](r: Ray, l: Line[T]): bool =
        ## 閉半直線と直線が交わるかを返す。O(1)。
        intersection(r, l).kind != rikEmpty

    proc intersect*[T: SomeNumber](l: Line[T], r: Ray): bool =
        ## 直線と閉半直線が交わるかを返す。O(1)。
        intersect(r, l)

    proc intersect*[T: SomeNumber](r: Ray, s: Segment[T]): bool =
        ## 閉半直線と閉線分が交わるかを返す。O(1)。
        intersection(r, s).kind != rikEmpty

    proc intersect*[T: SomeNumber](s: Segment[T], r: Ray): bool =
        ## 閉線分と閉半直線が交わるかを返す。O(1)。
        intersect(r, s)

    proc rayDistance(p: Point[float64], a: RayPrimitive): float64 =
        ## 射影パラメータを区間へ制限して最短距離を求める。
        let d = rayDifference(p, a.origin)
        let t = rayFinite(rayFinite(dot(d, a.direction)) / norm(a.direction))
        if t <= a.lower or t >= a.upper:
            let delta = rayDifference(p, rayAt(a, min(a.upper, max(a.lower, t))))
            return rayFinite(hypot(delta.x, delta.y))
        rayFinite(abs(rayFinite(cross(a.direction, d))) / sqrt(norm(a.direction)))

    proc contains*[T: SomeNumber](r: Ray, p: Point[T], eps: float64 = 0): bool =
        ## 点包含を判定する。eps>0なら閉半直線からの距離eps以下を許す。O(1)。
        if rayFinite(eps) < 0: raise newException(ValueError, "epsは非負である必要があります")
        let a = rayPrimitive(r)
        let q = rayPoint(p)
        if eps == 0:
            let d = rayDifference(q, a.origin)
            return rayFinite(cross(a.direction, d)) == 0 and rayParameter(a, q) >= 0
        rayDistance(q, a) <= eps

    proc distance*[T: SomeNumber](p: Point[T], r: Ray): float64 =
        ## 点と閉半直線のユークリッド距離を返す。O(1)。
        rayDistance(rayPoint(p), rayPrimitive(r))

    proc distance*[T: SomeNumber](r: Ray, p: Point[T]): float64 =
        ## 閉半直線と点のユークリッド距離を返す。O(1)。
        distance(p, r)

    proc distance*(a, b: Ray): float64 =
        ## 閉半直線同士のユークリッド距離を返す。O(1)。
        if intersect(a, b): return 0
        min(distance(a.origin, b), distance(b.origin, a))

    proc distance*[T: SomeNumber](r: Ray, l: Line[T]): float64 =
        ## 閉半直線と直線のユークリッド距離を返す。O(1)。
        if intersect(r, l): return 0
        rayDistance(r.origin, rayPrimitive(l))

    proc distance*[T: SomeNumber](l: Line[T], r: Ray): float64 =
        ## 直線と閉半直線のユークリッド距離を返す。O(1)。
        distance(r, l)

    proc distance*[T: SomeNumber](r: Ray, s: Segment[T]): float64 =
        ## 閉半直線と閉線分のユークリッド距離を返す。O(1)。
        if intersect(r, s): return 0
        min(rayDistance(r.origin, rayPrimitive(s)), min(distance(s.s, r), distance(s.t, r)))

    proc distance*[T: SomeNumber](s: Segment[T], r: Ray): float64 =
        ## 閉線分と閉半直線のユークリッド距離を返す。O(1)。
        distance(r, s)

    proc raySquared(d: float64): float64 =
        ## 距離を二乗し、表現範囲外や非零値のunderflowを拒否する。
        result = rayFinite(d * d)
        if d != 0 and result == 0: raise newException(ValueError, "二乗距離がfloat64の範囲外です")

    proc norm*[T: SomeNumber](p: Point[T], r: Ray): float64 =
        ## 点と閉半直線の二乗距離を返す。O(1)。
        raySquared(distance(p, r))

    proc norm*[T: SomeNumber](r: Ray, p: Point[T]): float64 =
        ## 閉半直線と点の二乗距離を返す。O(1)。
        norm(p, r)

    proc norm*(a, b: Ray): float64 =
        ## 閉半直線同士の二乗距離を返す。O(1)。
        raySquared(distance(a, b))

    proc norm*[T: SomeNumber](r: Ray, l: Line[T]): float64 =
        ## 閉半直線と直線の二乗距離を返す。O(1)。
        raySquared(distance(r, l))

    proc norm*[T: SomeNumber](l: Line[T], r: Ray): float64 =
        ## 直線と閉半直線の二乗距離を返す。O(1)。
        norm(r, l)

    proc norm*[T: SomeNumber](r: Ray, s: Segment[T]): float64 =
        ## 閉半直線と閉線分の二乗距離を返す。O(1)。
        raySquared(distance(r, s))

    proc norm*[T: SomeNumber](s: Segment[T], r: Ray): float64 =
        ## 閉線分と閉半直線の二乗距離を返す。O(1)。
        norm(r, s)
