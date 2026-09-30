when not declared CPLIB_GEOMETRY_INTERSECT:
    const CPLIB_GEOMETRY_INTERSECT* = 1
    import cplib/geometry/base
    import cplib/geometry/ccw
    import cplib/geometry/angle
    proc intersect*[T](s1, s2: Segment[T], strict: bool = false): bool =
        ##線分 s1, s2 が交わるかどうかを判定、端点のみで交わる場合を含まない場合は strict = true を設定
        if strict:
            if online(s1, s2.s) and online(s1, s2.t) and
                    online(s2, s1.s) and online(s2, s1.t):
                let x1 = (min(s1.s.x, s1.t.x), max(s1.s.x, s1.t.x))
                let x2 = (min(s2.s.x, s2.t.x), max(s2.s.x, s2.t.x))
                let y1 = (min(s1.s.y, s1.t.y), max(s1.s.y, s1.t.y))
                let y2 = (min(s2.s.y, s2.t.y), max(s2.s.y, s2.t.y))
                # 両線分で共通の座標軸に射影し、EPS付き辞書順による端点順の逆転を避ける
                if max(x1[1], x2[1]) - min(x1[0], x2[0]) >
                        max(y1[1], y2[1]) - min(y1[0], y2[0]):
                    return geometry_lt(max(x1[0], x2[0]), min(x1[1], x2[1]))
                return geometry_lt(max(y1[0], y2[0]), min(y1[1], y2[1]))
            return (ccw(s1, s2.s) * ccw(s1, s2.t) < 0) and (ccw(s2, s1.s) * ccw(s2, s1.t) < 0)
        return (ccw(s1, s2.s) * ccw(s1, s2.t) <= 0) and (ccw(s2, s1.s) * ccw(s2, s1.t) <= 0)

    proc intersect*[T](l1, l2: Line[T]): bool =
        ## 直線 l1, l2 が交わるかどうかを判定
        if not is_parallel(l1, l2): return true
        return online(l1, l2.s)

    proc cross_point*(l1, l2: Line[int]): Point[int] = assert false, "交点の計算にはintではなくfloatまたはFractionを使用してください"
    proc cross_point*[T](l1, l2: Line[T]): Point[T] =
        ## 2直線 l1, l2 の交点
        assert(intersect(l1, l2), "交点を求める2直線は交わる必要があります")
        if is_parallel(l1, l2): return l1.s
        var d1 = cross(l1.vector, l2.vector)
        var d2 = cross(l1.vector, l1.t - l2.s)
        return l2.s + l2.vector * (d2 / d1)
