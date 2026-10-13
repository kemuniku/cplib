when not declared CPLIB_GEOMETRY_INTERSECT:
    const CPLIB_GEOMETRY_INTERSECT* = 1
    import math
    import cplib/geometry/base
    import cplib/geometry/ccw
    import cplib/geometry/angle
    proc intersect*[T](s1, s2: Segment[T], strict: bool = false): bool =
        ## 線分同士の交差判定。strict=true では端点のみの接触を除く。O(1)。
        ## 浮動小数点では距離 EPS 未満を接触とみなし、strict でも通常判定を満たすことを要求する
        ## strict は端点と相手直線の距離で内側の交差を判定し、全端点が EPS 未満なら近似共線として重なり長を判定する
        ## 近似共線の strict は正の重なり長が GEOMETRY_EPS 以上の場合に限る。EPS 付近では近似判定となる
        ## 座標差が有限に表現できる非退化線分を対象とし、丸め誤差や表現精度を超える平行移動は保証しない
        when T is SomeFloat:
            proc rawLess(a, b: Point[T]): bool =
                ## EPS を使わず端点と方向の選択順を固定する
                a.x < b.x or (a.x == b.x and a.y < b.y)
            proc canonical(s: Segment[T]): Segment[T] =
                ## 端点反転によらず同じ始点を選ぶ
                result = s
                if rawLess(result.t, result.s):
                    swap(result.s, result.t)
            proc length(v: Point[T]): T =
                ## 最大成分で正規化してユークリッド長を求める
                let scale = max(abs(v.x), abs(v.y))
                if scale == 0: return T(0)
                let w = initPoint(v.x / scale, v.y / scale)
                scale * T(sqrt(w.norm))
            proc pointDistance(p: Point[T], s: Segment[T], unit: Point[T]): T =
                ## 点と線分の距離を射影位置に応じて求める
                let offset = p - s.s
                let along = dot(offset, unit)
                if along <= 0: return length(offset)
                if dot(p - s.t, unit) >= 0: return length(p - s.t)
                abs(cross(unit, offset))
            proc near(distance: T): bool =
                ## EPS=0 でも距離ゼロの接触は認める
                distance == 0 or distance < GEOMETRY_EPS
            proc opposite(x, y: T): bool =
                ## 積のアンダーフローを避けて厳密な符号反転を判定する
                (x < 0 and y > 0) or (x > 0 and y < 0)
            proc side(distance: T): int =
                ## 符号付き距離を絶対許容誤差で分類する
                if abs(distance) < GEOMETRY_EPS: return 0
                if distance < 0: return -1
                if distance > 0: return 1
                return 0
            let a = canonical(s1)
            let b = canonical(s2)
            let d1 = a.t - a.s
            let d2 = b.t - b.s
            let scale1 = max(abs(d1.x), abs(d1.y))
            let scale2 = max(abs(d2.x), abs(d2.y))
            if scale1 == 0 or scale2 == 0: return false
            let v1 = initPoint(d1.x / scale1, d1.y / scale1)
            let v2 = initPoint(d2.x / scale2, d2.y / scale2)
            let norm1 = T(sqrt(v1.norm))
            let norm2 = T(sqrt(v2.norm))
            let u1 = initPoint(v1.x / norm1, v1.y / norm1)
            let u2 = initPoint(v2.x / norm2, v2.y / norm2)
            let r1 = cross(u1, b.s - a.s)
            let r2 = cross(u1, b.t - a.s)
            let r3 = cross(u2, a.s - b.s)
            let r4 = cross(u2, a.t - b.s)
            let boxesOverlap =
                max(min(a.s.x, a.t.x), min(b.s.x, b.t.x)) <= min(max(a.s.x, a.t.x), max(b.s.x, b.t.x)) and
                max(min(a.s.y, a.t.y), min(b.s.y, b.t.y)) <= min(max(a.s.y, a.t.y), max(b.s.y, b.t.y))
            let inclusive = (boxesOverlap and opposite(r1, r2) and opposite(r3, r4)) or
                near(pointDistance(a.s, b, u2)) or near(pointDistance(a.t, b, u2)) or
                near(pointDistance(b.s, a, u1)) or near(pointDistance(b.t, a, u1))
            if not strict or not inclusive: return inclusive
            let o1 = side(r1)
            let o2 = side(r2)
            let o3 = side(r3)
            let o4 = side(r4)
            if o1 == 0 and o2 == 0 and o3 == 0 and o4 == 0:
                let useSecond = scale1 < scale2 or
                    (scale1 == scale2 and rawLess(d1, d2))
                let direction = (if useSecond: u2 else: u1)
                let origin = (if rawLess(a.s, b.s): a.s else: b.s)
                let a0 = dot(a.s - origin, direction)
                let a1 = dot(a.t - origin, direction)
                let b0 = dot(b.s - origin, direction)
                let b1 = dot(b.t - origin, direction)
                let overlap = min(max(a0, a1), max(b0, b1)) -
                    max(min(a0, a1), min(b0, b1))
                return overlap > 0 and overlap >= GEOMETRY_EPS
            return o1 * o2 < 0 and o3 * o4 < 0
        else:
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
