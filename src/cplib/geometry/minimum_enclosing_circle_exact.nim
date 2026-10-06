when not declared CPLIB_GEOMETRY_MINIMUM_ENCLOSING_CIRCLE_EXACT:
    const CPLIB_GEOMETRY_MINIMUM_ENCLOSING_CIRCLE_EXACT* = 1
    import random
    import cplib/geometry/base
    import cplib/geometry/exact_circle

    ## 自動型昇格なし。固定幅型はすべての中間計算が収まることが前提。
    ## 固定seedの局所Randによる増分法。入力とグローバル乱数状態は変更しない。
    ## 空入力は制約違反としてValueError、単点・全重複は点円。共線点も許し、2点直径円は同じ型の3点と尺度2で保持する。
    ## 非空入力には入力と同じExactCircle[T]を直接返す。全構築・包含・半径比較が厳密算術。
    ## 期待O(n)、最悪O(n^3)、追加空間O(n)。期待値は一様なランダム順序に対する算術操作数。
    ## 各操作の費用は指定型の乗除算・gcd（多倍長の場合は桁数）に依存し、単位時間とは限らない。
    ## 同じ入力・seed・Nim版では再現可能。異なる版や順序でも最小円の中心・半径二乗は同じ。
    ## 円を表す3点の選択と順序はseed・入力順・Nim版で変わりうる。

    type MinimumExactCircle*[T] = ExactCircle[T]

    proc mecExactRadiusLess[T](a, b: ExactCircle[T]): bool =
        ## 厳密な半径二乗の大小を指定された基底型の交差積で比較する。
        mixin `*`, `<`
        let x = a.radius_squared_exact
        let y = b.radius_squared_exact
        x.num * y.den < y.num * x.den

    proc mecExactThree[T](a, b, c: Point[T]): ExactCircle[T] =
        ## 3境界点の外接円を返す。共線時は最遠点対の直径円を返す。
        try:
            return initExactCircle(a, b, c)
        except ValueError:
            result = initExactDiameterCircle(a, b)
            for candidate in [initExactDiameterCircle(a, c), initExactDiameterCircle(b, c)]:
                if mecExactRadiusLess(result, candidate): result = candidate

    proc mecExactRun[T](points: openArray[Point[T]], seed: int64): ExactCircle[T] =
        ## 指定座標型の点集合の最小包含円を増分法で厳密に求める。
        if points.len == 0: raise newException(ValueError, "最小包含円の入力は非空である必要があります")
        var shuffled = newSeq[Point[T]](points.len)
        for i, p in points: shuffled[i] = p
        var rng = initRand(seed)
        rng.shuffle(shuffled)
        var circle = initExactCircle(shuffled[0], shuffled[0], shuffled[0])
        for i, p in shuffled:
            if circle.contains(p): continue
            circle = initExactCircle(p, p, p)
            for j in 0..<i:
                let q = shuffled[j]
                if circle.contains(q): continue
                circle = initExactDiameterCircle(p, q)
                for k in 0..<j:
                    let r = shuffled[k]
                    if not circle.contains(r): circle = mecExactThree(p, q, r)
        circle

    proc minimum_enclosing_circle_exact*[T](points: openArray[Point[T]], seed: int64 = 0): ExactCircle[T] =
        ## 整数・有限分数の点集合の最小包含円を厳密に返す。空入力はValueError、期待O(n)算術操作。
        mecExactRun(points, seed)
