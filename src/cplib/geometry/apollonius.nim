when not declared CPLIB_GEOMETRY_APOLLONIUS:
    const CPLIB_GEOMETRY_APOLLONIUS* = 1
    import math
    import cplib/geometry/base
    import cplib/geometry/circle

    type
        ApolloniusLocusKind* = enum
            apolloniusCircle, apolloniusLine, apolloniusPlane
        ApolloniusLocus* = object
            case kind*: ApolloniusLocusKind
            of apolloniusCircle:
                circle*: typeof(initCircle(initPoint(0.0, 0.0), 0.0))
            of apolloniusLine:
                linePoint*, lineDirection*: Point[float]
            of apolloniusPlane:
                discard

    proc apolloniusCheck(p: Point[float]) =
        ##座標と中間値が有限であることを検査する。O(1)。
        if p.x != p.x or p.y != p.y or abs(p.x) == system.Inf or abs(p.y) == system.Inf:
            raise newException(ValueError, "軌跡の座標と中間値は有限である必要があります")

    proc apollonius_locus*[T, U, R: SomeNumber](a: Point[T], b: Point[U], ratio: R): ApolloniusLocus =
        ##距離(P,a)=ratio*距離(P,b)の軌跡を円・直線・全平面で返す。時間・追加空間O(1)。
        ##半径0の円は一点。比1と同一点はfloat64変換後に厳密比較し、EPSを使わない。
        ##直線はlinePoint+t*lineDirection（tは任意の実数）、方向は単位ベクトル。
        ##有限座標・非負有限比、表現可能な差・距離・中間値・出力を前提とする。
        ##比が1に近い場合や極端な尺度差では精度を失う。詳細はapollonius.mdを参照。
        let p = initPoint(float(a.x), float(a.y))
        let q = initPoint(float(b.x), float(b.y))
        let r = float(ratio)
        apolloniusCheck(p)
        apolloniusCheck(q)
        if r != r or abs(r) == system.Inf or r < 0:
            raise newException(ValueError, "距離比は非負かつ有限である必要があります")
        if p.x == q.x and p.y == q.y:
            if r == 1: return ApolloniusLocus(kind: apolloniusPlane)
            return ApolloniusLocus(kind: apolloniusCircle, circle: initCircle(p, 0))
        if r == 0:
            return ApolloniusLocus(kind: apolloniusCircle, circle: initCircle(p, 0))
        let v = q - p
        apolloniusCheck(v)
        let scale = max(abs(v.x), abs(v.y))
        let scaled = initPoint(v.x / scale, v.y / scale)
        let unitLength = sqrt(scaled.x * scaled.x + scaled.y * scaled.y)
        if r == 1:
            let midpoint = p + v * 0.5
            apolloniusCheck(midpoint)
            return ApolloniusLocus(kind: apolloniusLine, linePoint: midpoint,
                lineDirection: initPoint(-scaled.y / unitLength, scaled.x / unitLength))
        let distance = scale * unitLength
        if distance == system.Inf:
            raise newException(ValueError, "距離はfloat64で表現可能である必要があります")
        var c: Point[float]
        var radius: float
        if r < 1:
            c = p - (v * r) * (1 / (1 + r)) * (r / (1 - r))
            radius = (distance * (r / (1 + r))) / (1 - r)
        else:
            let inverse = 1 / r
            c = q + (v * inverse) * (1 / (1 + inverse)) * (1 / (r - 1))
            radius = (distance / (1 + inverse)) / (r - 1)
        apolloniusCheck(c)
        if radius == 0:
            raise newException(ValueError, "正の半径はfloat64で表現可能である必要があります")
        result = ApolloniusLocus(kind: apolloniusCircle, circle: initCircle(c, radius))
