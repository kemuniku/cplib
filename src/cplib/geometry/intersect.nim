when not declared CPLIB_GEOMETRY_INTERSECT:
    const CPLIB_GEOMETRY_INTERSECT* = 1
    import cplib/geometry/base
    import cplib/geometry/ccw
    import cplib/geometry/angle
    proc intersect*[T](s1, s2: Segment[T], strict: bool = false): bool =
        ##線分 s1, s2 が交わるかどうかを判定、端点で交わる場合を含む場合は strict = true を設定
        if strict:
            if ccw(s1, s2.s, true) == ON_SEGMENT: return online(s1, s2.t)
            if ccw(s1, s2.t, true) == ON_SEGMENT: return online(s1, s2.s)
            if ccw(s2, s2.s, true) == ON_SEGMENT: return online(s2, s2.t)
            if ccw(s2, s2.t, true) == ON_SEGMENT: return online(s2, s2.s)
            return (ccw(s1, s2.s) * ccw(s1, s2.t) < 0) and (ccw(s2, s1.s) * ccw(s2, s1.t) < 0)
        return (ccw(s1, s2.s) * ccw(s1, s2.t) <= 0) and (ccw(s2, s1.s) * ccw(s2, s1.t) <= 0)

    proc intersect*[T](l1, l2: Line[T]): bool =
        ## 直線 l1, l2 が交わるかどうかを判定
        if not is_parallel(l1, l2): return true
        return online(l1, l2.s)

    proc cross_point*(l1, l2: Line[int]): Point[int] = assert false, "cross point can't be called for int type, please use float or Fraction"
    proc cross_point*[T](l1, l2: Line[T]): Point[T] =
        ## 2直線 l1, l2 の交点
        assert(intersect(l1, l2))
        if is_parallel(l1, l2): return l1.s
        var d1 = cross(l1.vector, l2.vector)
        var d2 = cross(l1.vector, l1.t - l2.s)
        return l2.s + l2.vector * (d2 / d1)
