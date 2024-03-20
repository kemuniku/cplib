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

    proc initPolygon*[T](v: seq[Point[T]]): Polygon[T] =
        ## 頂点列 v の多角形型を初期化
        Polygon[T](v: v)
    proc area*(p: Polygon[int]): int =
        ## 多角形の面積の2倍、頂点列が時計回りの場合負の数が返る
        for i in 0..<p.v.len: result += cross(p.v[i], p.v[(i+1) mod p.v.len])
    proc area*[T](p: Polygon[Fraction[T]]): Fraction[T] =
        ## 多角形の面積、頂点列が時計回りの場合負の数が返る
        result = initFraction(0)
        for i in 0..<p.v.len: result += cross(p.v[i], p.v[(i+1) mod p.v.len]) / 2
    proc area*(p: Polygon[float]): float =
        ## 多角形の面積、頂点列が時計回りの場合負の数が返る
        for i in 0..<p.v.len: result += cross(p.v[i], p.v[(i+1) mod p.v.len]) / 2.0

    proc is_convex_ccw*[T](poly: Polygon[T], strict: bool = true): bool =
        ## 頂点列が反時計回りの多角形に対して、凸かどうかを判定
        for i in 0..<poly.len:
            var ccwi = ccw(poly.v[i], poly.v[(i+1) mod poly.len], poly.v[(i+2) mod poly.len])
            if strict and ccwi != COUNTER_CLOCKWISE: return false
            if (not strict) and ccwi == CLOCKWISE: return false
        return true
    proc is_convex*[T](poly: Polygon[T], strict: bool = true): bool =
        ## 多角形が凸かどうかを判定、ちょうど 180 度の内角を許容する場合は strict = false を設定
        if is_convex_ccw(poly, strict): return true
        var pn = Polygon[T](v: poly.v.reversed)
        return is_convex_ccw(pn, strict)

    proc on_edge*[T](poly: Polygon[T], p: Point[T]): bool =
        ## 点 p が多角形 poly の辺上にあるかどうかを判定
        for i in 0..<poly.len:
            if ccw(poly.v[i], poly.v[(i+1) mod poly.len], p) == ON_SEGMENT: return true
        return false
    proc contains*[T](poly: Polygon[T], p: Point[T], strict: bool = false): bool =
        ## 自己交差のない多角形 poly 内に点 p が存在するかを判定、辺上にある場合を含めない場合は strict = true を設定
        if on_edge(poly, p):
            if strict: return false
            else: return true
        result = false
        for i in 0..<poly.len:
            var a = poly.v[i] - p
            var b = poly.v[(i+1) mod poly.len] - p
            if a.y > b.y: swap(a, b)
            if geometry_le(a.y, 0) and geometry_gt(b.y, 0) and geometry_lt(cross(a, b), 0):
                result = not result

    proc convex_hull*[T](v: seq[Point[T]], strict: bool = true): Polygon[T] =
        ## 点群 v の凸包
        var n = v.len
        if n < 3: return Polygon[T](v: v)
        var s = v.sorted
        var vi = s[0..1]
        for i in 2..<n:
            if strict:
                while vi.len >= 2 and ccw(vi[^2], vi[^1], s[i]) != COUNTER_CLOCKWISE: discard vi.pop
            else:
                while vi.len >= 2 and ccw(vi[^2], vi[^1], s[i]) == CLOCKWISE: discard vi.pop
            vi.add(s[i])
        var lower_size = vi.len
        for i in countdown(n-2, 0):
            if strict:
                while vi.len > lower_size and ccw(vi[^2], vi[^1], s[i]) != COUNTER_CLOCKWISE: discard vi.pop
            else:
                while vi.len > lower_size and ccw(vi[^2], vi[^1], s[i]) == CLOCKWISE: discard vi.pop
            vi.add(s[i])
        vi.delete(0)
        return Polygon[T](v: vi)
