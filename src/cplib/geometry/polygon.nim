when not declared CPLIB_GEOMETRY_POLYGON:
    const CPLIB_GEOMETRY_POLYGON* = 1
    import cplib/geometry/base
    import cplib/geometry/ccw
    import cplib/math/fractions
    import algorithm
    type Polygon*[T] = object
        v*: seq[Point[T]]
    proc len*[T](poly: Polygon[T]): int = poly.v.len
    iterator items*[T](poly: Polygon[T]): Point[T] =
        for item in poly.v: yield item

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

    proc convex_hull*[T](poly: Polygon[T], strict: bool = true): Polygon[T] =
        var n = poly.v.len
        if n < 3: return poly
        var s = poly.v.sorted
        var v = s[0..1]
        for i in 2..<n:
            if strict:
                while v.len >= 2 and ccw(v[^2], v[^1], s[i]) != COUNTER_CLOCKWISE: discard v.pop
            else:
                while v.len >= 2 and ccw(v[^2], v[^1], s[i]) == CLOCKWISE: discard v.pop
            v.add(s[i])
        var lower_size = v.len
        for i in countdown(n-2, 0):
            if strict:
                while v.len > lower_size and ccw(v[^2], v[^1], s[i]) != COUNTER_CLOCKWISE: discard v.pop
            else:
                while v.len > lower_size and ccw(v[^2], v[^1], s[i]) == CLOCKWISE: discard v.pop
            v.add(s[i])
        v.delete(0)
        return Polygon[T](v: v)
