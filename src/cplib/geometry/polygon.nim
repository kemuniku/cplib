when not declared CPLIB_GEOMETRY_POLYGON:
    const CPLIB_GEOMETRY_POLYGON* = 1
    import cplib/geometry/base
    import cplib/geometry/ccw
    import cplib/math/fractions
    import algorithm
    type Polygon*[T] = object
        v: seq[Point[T]]

    proc initPolygon*[T](v: seq[Point[T]]): Polygon[T] = Polygon[T](v: v)
    proc area*(p: Polygon[int]): int =
        for i in 0..<p.v.len: result += cross(p.v[i], p.v[(i+1) mod p.v.len])
    proc area*[T](p: Polygon[Fraction[T]]): Fraction[T] =
        result = initFraction(0)
        for i in 0..<p.v.len: result += cross(p.v[i], p.v[(i+1) mod p.v.len]) / 2
    proc area*(p: Polygon[float]): float =
        for i in 0..<p.v.len: result += cross(p.v[i], p.v[(i+1) mod p.v.len]) / 2.0

    proc is_convex_ccw*[T](poly: Polygon[T], strict: bool = true): bool =
        for i in 0..<poly.v.len:
            var ccwi = ccw(poly.v[i], poly.v[(i+1) mod poly.v.len], poly.v[(i+2) mod poly.v.len])
            if strict and ccwi != COUNTER_CLOCKWISE: return false
            if (not strict) and ccwi == CLOCKWISE: return false
        return true
    proc is_convex*[T](poly: Polygon[T], strict: bool = true): bool =
        if is_convex_ccw(poly, strict): return true
        var pn = Polygon[T](v: poly.v.reversed)
        return is_convex_ccw(pn, strict)
