when not declared CPLIB_GEOMETRY_MINIMUM_ENCLOSING_CIRCLE:
    const CPLIB_GEOMETRY_MINIMUM_ENCLOSING_CIRCLE* = 1
    import math, random
    import cplib/geometry/base
    import cplib/geometry/circle

    ## 局所Randの固定seedによる増分法。入力・グローバル乱数状態は変更しない。
    ## 空入力は制約違反でValueError。単点・全重複は点円、共線点も許す。
    ## 非floatはCircle[T]、float入力はCircle[float]を直接返す。
    ## 非floatは全判定を指定基底型で厳密計算し、自動BigInt化しない。全中間値が型に収まることが前提。
    ## floatは既定相対許容誤差1e-12、平行移動・尺度正規化、最後の半径補正を使用する。
    ## float入力・差・距離・出力は有限かつfloat64で表現可能であること。悪条件入力では精度を失いうる。
    ## 期待O(n)、最悪O(n^3)算術操作、追加空間O(n)。多倍長演算の費用は桁数に依存する。
    ## 同じ入力・seed・Nim版で再現可能。境界3点の選択・順序はseed・版で変わりうる。

    proc mecLength(p: Point[float]): float =
        ##平方のオーバーフローを避けてベクトル長を計算する。O(1)。
        if p.x != p.x or p.y != p.y or abs(p.x) == system.Inf or abs(p.y) == system.Inf:
            raise newException(ValueError, "最小包含円の座標と中間値は有限である必要があります")
        let scale = max(abs(p.x), abs(p.y))
        if scale == 0: return 0
        result = scale * sqrt((p.x / scale) * (p.x / scale) + (p.y / scale) * (p.y / scale))
        if result == system.Inf: raise newException(ValueError, "最小包含円の距離は有限である必要があります")

    proc mecDiameter(a, b: Point[float]): Circle[float] =
        ##2点を直径の両端とする円を返す。O(1)。
        let center = a + (b - a) * 0.5
        initCircle(center, max(mecLength(a - center), mecLength(b - center)))

    proc mecThree(a, b, c: Point[float]): Circle[float] =
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

    proc mecFloatRun[T: SomeFloat](points: openArray[Point[T]], seed: int64 = 0, tolerance: float = 1e-12): Circle[float] =
        ## float点集合の最小包含円を許容誤差付き増分法で求める。
        if tolerance != tolerance or tolerance < 0 or tolerance >= 1:
            raise newException(ValueError, "相対許容誤差は0以上1未満である必要があります")
        if points.len == 0: raise newException(ValueError, "最小包含円の入力は非空である必要があります")
        var original = newSeq[Point[float]](points.len)
        for i, p in points:
            original[i] = initPoint(float(p.x), float(p.y))
            discard initCircle(original[i], 0)
        let origin = original[0]
        var scale = 0.0
        for p in original: scale = max(scale, mecLength(p - origin))
        if scale == 0: return initCircle(origin, 0)
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
        initCircle(center, radius)

    proc mecExactRadiusLess[T](a, b: Circle[T]): bool =
        ## 厳密な半径二乗の大小を指定された基底型の交差積で比較する。
        mixin `*`, `<`
        let x = a.radius_squared_exact
        let y = b.radius_squared_exact
        x.num * y.den < y.num * x.den

    proc mecExactThree[T](a, b, c: Point[T]): Circle[T] =
        ## 3境界点の外接円を返す。共線時は最遠点対の直径円を返す。
        try:
            return initCircle(a, b, c)
        except ValueError:
            result = initDiameterCircle(a, b)
            for candidate in [initDiameterCircle(a, c), initDiameterCircle(b, c)]:
                if mecExactRadiusLess(result, candidate): result = candidate

    proc mecExactRun[T](points: openArray[Point[T]], seed: int64): Circle[T] =
        ## 指定座標型の点集合の最小包含円を増分法で厳密に求める。
        if points.len == 0: raise newException(ValueError, "最小包含円の入力は非空である必要があります")
        var shuffled = newSeq[Point[T]](points.len)
        for i, p in points: shuffled[i] = p
        var rng = initRand(seed)
        rng.shuffle(shuffled)
        var circle = initCircle(shuffled[0], shuffled[0], shuffled[0])
        for i, p in shuffled:
            if circle.contains(p): continue
            circle = initCircle(p, p, p)
            for j in 0..<i:
                let q = shuffled[j]
                if circle.contains(q): continue
                circle = initDiameterCircle(p, q)
                for k in 0..<j:
                    let r = shuffled[k]
                    if not circle.contains(r): circle = mecExactThree(p, q, r)
        circle

    proc minimum_enclosing_circle*[T](points: openArray[Point[T]], seed: int64 = 0, tolerance: float = 1e-12): auto =
        ## 点集合の最小包含円を直接返す。空入力はValueError、float以外の全判定は厳密。
        when T is SomeFloat: mecFloatRun(points, seed, tolerance)
        else: mecExactRun(points, seed)
