when not declared CPLIB_GEOMETRY_INTERSECT:
    const CPLIB_GEOMETRY_INTERSECT* = 1
    import cplib/geometry/base
    import cplib/geometry/ccw
    proc intersect*[T](s1, s2: Segment[T], strict: bool = false): bool =
        if strict:
            if ccw(s1, s2.s, true) == ON_SEGMENT: return online(s1, s2.t)
            if ccw(s1, s2.t, true) == ON_SEGMENT: return online(s1, s2.s)
            if ccw(s2, s2.s, true) == ON_SEGMENT: return online(s2, s2.t)
            if ccw(s2, s2.t, true) == ON_SEGMENT: return online(s2, s2.s)
            return (ccw(s1, s2.s) * ccw(s1, s2.t) < 0) and (ccw(s2, s1.s) * ccw(s2, s1.t) < 0)
        return (ccw(s1, s2.s) * ccw(s1, s2.t) <= 0) and (ccw(s2, s1.s) * ccw(s2, s1.t) <= 0)
