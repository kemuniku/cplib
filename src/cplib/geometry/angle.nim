when not declared CPLIB_GEOMETRY_ANGLE:
    const CPLIB_GEOMETRY_ANGLE* = 1
    import cplib/geometry/base
    const ANGLE_0* = 0;
    const ANGLE_0_90* = 1;
    const ANGLE_90* = 2;
    const ANGLE_90_180* = 3;
    const ANGLE_180* = 4;
    const ANGLE_180_270* = -3;
    const ANGLE_270* = -2;
    const ANGLE_270_360* = -1;

    proc angle*[T](p1, p2: Point[T]): int =
        ##p1, p2のなす角を八方位で返す
        proc iszero(p: Point[T]): bool = geometry_eq(p1.x, 0) and geometry_eq(p1.y, 0)
        assert (not iszero(p1)) and (not iszero(p2))
        var d = dot(p1, p2)
        var c = cross(p1, p2)
        if geometry_eq(c, 0):
            if geometry_gt(c, 0): return ANGLE_0
            else: return ANGLE_180
        if geometry_eq(d, 0):
            if geometry_gt(c, 0): return ANGLE_90
            else: return ANGLE_270
        if geometry_gt(d, 0) and geometry_gt(c, 0): return ANGLE_0_90
        if geometry_lt(d, 0) and geometry_gt(c, 0): return ANGLE_90_180
        if geometry_lt(d, 0) and geometry_lt(c, 0): return ANGLE_180_270
        if geometry_gt(d, 0) and geometry_lt(c, 0): return ANGLE_270_360

    proc angle*[T](l1, l2: Line[T]): int = angle(l1.vector, l2.vector)
    type PointOrLine = Point or Line
    proc is_parallel*(p1, p2: PointOrLine): bool =
        ##p1, p2が平行かどうかを判定
        var a = angle(p1, p2)
        return (a == ANGLE_0) or (a == ANGLE_180)
    proc is_orthogonal*(p1, p2: PointOrLine): bool =
        ##p1, p2が直角かどうかを判定
        var a = angle(p1, p2)
        return (a == ANGLE_90) or (a == ANGLE_270)
