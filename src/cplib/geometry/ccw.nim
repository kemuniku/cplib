when not declared CPLIB_GEOMETRY_CCW:
    const CPLIB_GEOMETRY_CCW* = 1
    import cplib/geometry/base
    const
        COUNTER_CLOCKWISE* = 2
        CLOCKWISE* = -2
        ON_SEGMENT* = 0
        ONLINE_BACK* = 1
        ONLINE_FRONT* = -1

    proc ccw*[T](l: Line[T], p: Point[T], strict: bool = false): int =
        ##直線と点の位置関係を整数で返す. COUNTER_CLOCKWISE: 2, CLOCKWISE: -2, ON_SEGMENT: 0, ONLINE_BACK: 1, ONLINE_FRONT: -1
        var crs = cross(l.vector, p - l.s)
        if geometry_lt(crs, 0): return CLOCKWISE
        if geometry_gt(crs, 0): return COUNTER_CLOCKWISE
        var d = dot(l.vector, p - l.s)
        if strict:
            if geometry_le(d, 0): return ONLINE_BACK
            if geometry_ge(d, l.vector.norm): return ONLINE_FRONT
        else:
            if geometry_lt(d, 0): return ONLINE_BACK
            if geometry_gt(d, l.vector.norm): return ONLINE_FRONT
        return ON_SEGMENT

    proc ccw*[T](p1, p2, p3: Point[T], strict: bool = false): int =
        ##3点の位置関係を整数で返す. COUNTER_CLOCKWISE: 2, CLOCKWISE: -2, ON_SEGMENT: 0, ONLINE_BACK: 1, ONLINE_FRONT: -1
        ccw(initLine(p1, p2), p3)
    proc online*[T](l: Line[T], p: Point[T]): bool =
        ##点pが直線l上にあるかどうかを判定
        ccw(l, p) in -1..1
    proc online*[T](p1, p2, p3: Point[T]): bool =
        ##点p3が p1, p2 を通る直線上にあるかどうかを判定
        ccw(p1, p2, p3) in -1..1
