when not declared CPLIB_GEOMETRY_CONVEX_POLYGON:
    const CPLIB_GEOMETRY_CONVEX_POLYGON* = 1
    import cplib/geometry/base
    import cplib/geometry/polygon
    import cplib/math/fractions
    import algorithm, options

    type ConvexPolygon*[T] = object
        vertices: seq[Point[T]]
    type ConvexDiameter*[T] = object
        distance_sq*: T
        endpoints*: array[2, Point[T]]

    proc convexExactEqual[T](a, b: Point[T]): bool =
        ## 座標をEPSなしで比較する。
        a.x == b.x and a.y == b.y
    proc convexLexLess[T](a, b: Point[T]): bool =
        ## 座標の辞書順をEPSなしで比較する。
        a.x < b.x or (a.x == b.x and a.y < b.y)
    proc convexTurn[T](a, b, c: Point[T]): T =
        ## 3点の符号付き外積を求める。
        cross(b - a, c - a)
    proc convexSign[T](x: T): int =
        ## 既存の幾何比較に従って符号を求める。
        let zero = x - x
        if geometry_lt(x, zero): -1
        elif geometry_gt(x, zero): 1
        else: 0
    proc convexOnSegment[T](a, b, p: Point[T]): bool =
        ## 零長も許す線分上の包含を判定する。
        if convexExactEqual(a, b): return p == a
        convexSign(convexTurn(a, b, p)) == 0 and
            geometry_le(dot(p - a, p - b), a.x - a.x)

    proc initConvexPolygon*[T](v: openArray[Point[T]]): ConvexPolygon[T] =
        ## 凸多角形の周回順の頂点列をO(N)で前処理する。共線入力も許す。
        var points: seq[Point[T]]
        for p in v:
            if points.len == 0 or not convexExactEqual(points[^1], p): points.add(p)
        if points.len > 1 and convexExactEqual(points[0], points[^1]):
            discard points.pop()
        if points.len <= 1:
            return ConvexPolygon[T](vertices: points)
        var lo = 0
        var hi = 0
        for i in 1..<points.len:
            if convexLexLess(points[i], points[lo]): lo = i
            if convexLexLess(points[hi], points[i]): hi = i
        let zero = points[0].x - points[0].x
        var collinear = true
        for p in points:
            if convexTurn(points[lo], points[hi], p) != zero:
                collinear = false
                break
        if collinear:
            return ConvexPolygon[T](vertices: @[points[lo], points[hi]])
        for i in 0..<points.len:
            let turn = convexTurn(points[i], points[(i+1) mod points.len], points[(i+2) mod points.len])
            if turn != zero:
                if turn < zero:
                    points.reverse()
                    lo = points.len - 1 - lo
                break
        var normalized: seq[Point[T]]
        for i in 0..<points.len:
            let p = points[(lo+i) mod points.len]
            while normalized.len >= 2 and convexTurn(normalized[^2], normalized[^1], p) == zero:
                discard normalized.pop()
            normalized.add(p)
        while normalized.len >= 3 and convexTurn(normalized[^2], normalized[^1], normalized[0]) == zero:
            discard normalized.pop()
        result.vertices = normalized

    proc initConvexPolygon*[T](poly: Polygon[T]): ConvexPolygon[T] =
        ## Polygonの頂点列をO(N)でコピーして前処理する。
        initConvexPolygon(poly.v)
    proc len*[T](poly: ConvexPolygon[T]): int =
        ## 正規化後の頂点数をO(1)で返す。
        poly.vertices.len
    iterator items*[T](poly: ConvexPolygon[T]): Point[T] =
        ## 正規化後の頂点を反時計回りに列挙する。
        for p in poly.vertices: yield p
    proc toPolygon*[T](poly: ConvexPolygon[T]): Polygon[T] =
        ## 独立した頂点列を持つPolygonをO(N)で返す。
        result.v = newSeq[Point[T]](poly.len)
        for i, p in poly.vertices: result.v[i] = p

    proc convexLocation[T](poly: ConvexPolygon[T], p: Point[T]): int =
        ## 点の位置を外部=-1、境界=0、内部=1でO(log N)で返す。
        let n = poly.len
        if n == 0: return -1
        if n == 1: return (if p == poly.vertices[0]: 0 else: -1)
        if n == 2:
            return (if convexOnSegment(poly.vertices[0], poly.vertices[1], p): 0 else: -1)
        let origin = poly.vertices[0]
        let first = convexSign(convexTurn(origin, poly.vertices[1], p))
        let last = convexSign(convexTurn(origin, poly.vertices[^1], p))
        if first < 0 or last > 0: return -1
        if first == 0:
            return (if convexOnSegment(origin, poly.vertices[1], p): 0 else: -1)
        if last == 0:
            return (if convexOnSegment(origin, poly.vertices[^1], p): 0 else: -1)
        var lo = 1
        var hi = n - 1
        let zero = origin.x - origin.x
        while hi - lo > 1:
            let mid = (lo + hi) div 2
            if convexTurn(origin, poly.vertices[mid], p) >= zero: lo = mid
            else: hi = mid
        let side = convexSign(convexTurn(poly.vertices[lo], poly.vertices[hi], p))
        if side == 0 and not convexOnSegment(poly.vertices[lo], poly.vertices[hi], p): return -1
        side

    proc contains*[T](poly: ConvexPolygon[T], p: Point[T], strict: bool = false): bool =
        ## O(log N)で包含を判定する。strict=trueでは境界を除き、2頂点以下は常にfalse。
        let location = convexLocation(poly, p)
        if strict: location > 0
        else: location >= 0
    proc on_edge*[T](poly: ConvexPolygon[T], p: Point[T]): bool =
        ## O(log N)で境界上か判定する。1頂点はその点、2頂点は線分を境界とする。
        convexLocation(poly, p) == 0

    proc diameter*[T](poly: ConvexPolygon[T]): Option[ConvexDiameter[T]] =
        ## 回転calipersで二乗直径と端点をO(N)で返す。空はnone、1頂点は距離0。
        let n = poly.len
        if n == 0: return none(ConvexDiameter[T])
        var best = ConvexDiameter[T](distance_sq: norm(poly.vertices[0] - poly.vertices[0]),
            endpoints: [poly.vertices[0], poly.vertices[0]])
        template consider(i, j: int) =
            let distance = norm(poly.vertices[i] - poly.vertices[j])
            if distance > best.distance_sq:
                best = ConvexDiameter[T](distance_sq: distance,
                    endpoints: [poly.vertices[i], poly.vertices[j]])
        if n == 2:
            consider(0, 1)
        elif n >= 3:
            var j = 1
            for i in 0..<n:
                let next = (i+1) mod n
                while convexTurn(poly.vertices[i], poly.vertices[next], poly.vertices[(j+1) mod n]) >
                        convexTurn(poly.vertices[i], poly.vertices[next], poly.vertices[j]):
                    j = (j+1) mod n
                consider(i, j)
                consider(next, j)
                if convexTurn(poly.vertices[i], poly.vertices[next], poly.vertices[(j+1) mod n]) ==
                        convexTurn(poly.vertices[i], poly.vertices[next], poly.vertices[j]):
                    consider(i, (j+1) mod n)
                    consider(next, (j+1) mod n)
        some(best)
    proc diameter*[T](poly: Polygon[T]): Option[ConvexDiameter[T]] =
        ## 凸PolygonをO(N)で前処理して二乗直径と端点を返す。
        diameter(initConvexPolygon(poly))

    proc convex_cut*[T](poly: Polygon[T], line: Line[T]): Polygon[T] =
        ## 凸多角形をO(N)で切断し、有向直線の左側と境界を返す。float/Fraction専用。
        when T isnot SomeFloat and T isnot Fraction:
            {.error: "convex_cutにはfloatまたはFractionの座標を使用してください".}
        else:
            assert line.s != line.t, "切断直線の始点と終点は異なる必要があります"
            template append(p: Point[T]) =
                let point = p
                if result.v.len == 0 or result.v[^1] != point: result.v.add(point)
            for i in 0..<poly.len:
                let a = poly.v[i]
                let b = poly.v[(i+1) mod poly.len]
                let ca = cross(line.vector, a - line.s)
                let cb = cross(line.vector, b - line.s)
                let sa = convexSign(ca)
                let sb = convexSign(cb)
                if sa >= 0: append(a)
                if sa * sb < 0: append(a + (b - a) * (ca / (ca - cb)))
            if result.v.len > 1 and result.v[0] == result.v[^1]: discard result.v.pop()
    proc convex_cut*[T](poly: ConvexPolygon[T], line: Line[T]): Polygon[T] =
        ## 前処理済み凸多角形をO(N)で切断し、左側と境界のPolygonを返す。
        convex_cut(Polygon[T](v: poly.vertices), line)
