when not declared CPLIB_GEOMETRY_MINIMUM_ENCLOSING_CIRCLE:
    const CPLIB_GEOMETRY_MINIMUM_ENCLOSING_CIRCLE* = 1
    import math, options, random
    import cplib/geometry/base
    import cplib/geometry/circle

    ## 固定seedのシャッフルによる最小包含円の増分法。入力の順序は変更しない。
    ## 空入力はnone(Circle)。単点・全重複点は半径0。共線点も許す。
    ## 期待O(n)、最悪O(n^3)、追加空間O(n)。期待値は一様なランダム順序に対するもの。
    ## seedの既定値は0。同じ入力・seed・Nim版では再現可能。版をまたぐ順序の一致は保証しない。
    ## float64の近似計算。既定の相対許容誤差1e-12で包含を判定し、最後に全点の距離で半径を補正する。
    ## 平行移動と尺度の正規化で平方のoverflow/underflowを避けるが、悪条件入力の厳密な最適性は保証しない。
    ## 有限入力、点の差・距離・最終円がfloat64で表現可能であること。整数入力は先にfloatへ変換する。

    proc mecLength(p: Point[float]): float =
        ##平方のオーバーフローを避けてベクトル長を計算する。O(1)。
        if p.x != p.x or p.y != p.y or abs(p.x) == system.Inf or abs(p.y) == system.Inf:
            raise newException(ValueError, "最小包含円の座標と中間値は有限である必要があります")
        let scale = max(abs(p.x), abs(p.y))
        if scale == 0: return 0
        result = scale * sqrt((p.x / scale) * (p.x / scale) + (p.y / scale) * (p.y / scale))
        if result == system.Inf: raise newException(ValueError, "最小包含円の距離は有限である必要があります")

    proc mecDiameter(a, b: Point[float]): Circle =
        ##2点を直径の両端とする円を返す。O(1)。
        let center = a + (b - a) * 0.5
        initCircle(center, max(mecLength(a - center), mecLength(b - center)))

    proc mecThree(a, b, c: Point[float]): Circle =
        ##3境界点の外接円を返す。共線時は最遠点対の直径円。O(1)。
        let u = b - a
        let v = c - a
        let scale = max(max(abs(u.x), abs(u.y)), max(abs(v.x), abs(v.y)))
        if scale == 0: return initCircle(a, 0)
        let un = initPoint(u.x / scale, u.y / scale)
        let vn = initPoint(v.x / scale, v.y / scale)
        let determinant = 2 * cross(un, vn)
        if determinant == 0:
            result = mecDiameter(a, b)
            for candidate in [mecDiameter(a, c), mecDiameter(b, c)]:
                if candidate.radius > result.radius: result = candidate
            return
        let usq = dot(un, un)
        let vsq = dot(vn, vn)
        let offset = initPoint((vn.y * usq - un.y * vsq) / determinant * scale,
                              (un.x * vsq - vn.x * usq) / determinant * scale)
        let center = a + offset
        initCircle(center, max(mecLength(a - center), max(mecLength(b - center), mecLength(c - center))))

    proc minimum_enclosing_circle*[T: SomeNumber](points: openArray[Point[T]], seed: int64 = 0, tolerance: float = 1e-12): Option[Circle] =
        ##点集合の最小包含円を返す。期待O(n)、最悪O(n^3)、空入力はnone。
        if tolerance != tolerance or tolerance < 0 or tolerance >= 1:
            raise newException(ValueError, "相対許容誤差は0以上1未満である必要があります")
        if points.len == 0: return none(Circle)
        var original = newSeq[Point[float]](points.len)
        for i, p in points:
            original[i] = initPoint(float(p.x), float(p.y))
            discard initCircle(original[i], 0)
        let origin = original[0]
        var scale = 0.0
        for p in original: scale = max(scale, mecLength(p - origin))
        if scale == 0: return some(initCircle(origin, 0))
        var shuffled = newSeq[Point[float]](points.len)
        for i, p in original:
            let v = p - origin
            shuffled[i] = initPoint(v.x / scale, v.y / scale)
        var rng = initRand(seed)
        rng.shuffle(shuffled)
        var circle = initCircle(shuffled[0], 0)
        for i, p in shuffled:
            if circle.contains(p, tolerance): continue
            circle = initCircle(p, 0)
            for j in 0..<i:
                let q = shuffled[j]
                if circle.contains(q, tolerance): continue
                circle = mecDiameter(p, q)
                for k in 0..<j:
                    let r = shuffled[k]
                    if not circle.contains(r, tolerance): circle = mecThree(p, q, r)
        let center = origin + circle.center * scale
        var radius = 0.0
        for p in original: radius = max(radius, mecLength(p - center))
        some(initCircle(center, radius))
