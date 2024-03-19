when not declared CPLIB_GEOMETRY_DISTANCE:
    const CPLIB_GEOMETRY_DISTANCE* = 1
    import math
    import cplib/geometry/base
    import cplib/geometry/intersect
    proc norm*[T](p1, p2: Point[T]): T = norm(p1 - p2)
    proc norm*[T](p: Point[T], l: Line[T]): T =
        var area_sq = cross(l.vector, p - l.s)
        return area_sq * area_sq / norm(l.vector)
    proc norm*[T](p: Point[T], s: Segment[T]): T =
        if geometry_lt(dot(s.vector, p - s.s), 0): return norm(p - s.s)
        if geometry_lt(dot(-s.vector, p - s.t), 0): return norm(p - s.t)
        return norm(p, initLine(s.s, s.t))
    proc norm*[T](s1, s2: Segment[T]): T =
        if intersect(s1, s2): return 0
        result = norm(s1.s, s2)
        result = min(result, norm(s1.t, s2))
        result = min(result, norm(s2.s, s1))
        result = min(result, norm(s2.t, s1))

    proc distance*(p1, p2: Point[SomeFloat]): float = sqrt(norm(p1, p2))
    proc distance*(p: Point[SomeFloat], l: Line[SomeFloat]): float = sqrt(norm(p, l))
    proc distance*(p: Point[SomeFloat], s: Segment[SomeFloat]): float = sqrt(norm(p, s))
    proc distance*(s1, s2: Segment[SomeFloat]): float = sqrt(norm(s1, s2))

    proc manhattan*[T](p: Point[T]): T = abs(p.x) + abs(p.y)
    proc manhattan*[T](p1, p2: Point[T]): T = manhattan(p1 - p2)
