when not declared CPLIB_GEOMETRY_CIRCLE_INTEGER_IMPL:
    const CPLIB_GEOMETRY_CIRCLE_INTEGER_IMPL = 1
    import strutils
    import cplib/math/fractions
    type CircleExactScalar[T] = object
        num, den: T
    proc circleValueLike[T, S](witness: T, x: S): T =
        ## 演算対象の型へ値を合わせる。多倍長化はせず、表現可能性は呼び出し側の前提。
        mixin toBigInt, to_Int128
        when T is SomeFloat or T is SomeUnsignedInt:
            {.error: "厳密円の基底は符号付き整数にしてください".}
        elif T is SomeSignedInt and S is SomeSignedInt:
            result = T(x)
        else:
            result = x

    proc circleConst[T](witness: T, value: int): T =
        ## 小さな定数を指定された基底型で作る。
        circleValueLike(witness, value)

    proc circleSign[T](x: T): int =
        ## 指定された基底型の符号を返す。
        mixin `<`, `==`
        let zero = circleConst(x, 0)
        if x == zero: 0 elif x < zero: -1 else: 1

    proc circleGcd[T](x, y: T): T =
        ## 指定された基底型だけで非負のgcdを計算する。
        mixin `-`, `mod`
        var a = if circleSign(x) < 0: -x else: x
        var b = if circleSign(y) < 0: -y else: y
        while circleSign(b) != 0:
            let r = a mod b
            a = b
            b = r
        a

    proc circleRational[T](numerator, denominator: T): CircleExactScalar[T] =
        ## 有限分数を指定型のgcdで正規化する。分子・分母・中間値の型を変えない。
        mixin `div`, `-`
        if circleSign(denominator) == 0:
            raise newException(ValueError, "厳密円の分母は非零である必要があります")
        let g = circleGcd(numerator, denominator)
        result = CircleExactScalar[T](num: numerator div g, den: denominator div g)
        if circleSign(result.den) < 0:
            result.num = -result.num
            result.den = -result.den

    proc circleFraction[T](x: T): CircleExactScalar[T] =
        ## 整数を同じ基底型の分数として扱う。自動昇格は行わない。
        CircleExactScalar[T](num: x, den: circleConst(x, 1))

    proc circleFraction[T](x: Fraction[T]): CircleExactScalar[T] =
        ## 有限分数をその基底型のまま正規化する。
        circleRational(x.num, x.den)

    proc circleFraction[T](x: CircleExactScalar[T]): CircleExactScalar[T] =
        ## 内部の正規化済み分数を保持する。
        x

    proc circleLike[T](witness: CircleExactScalar[T], value: int): CircleExactScalar[T] =
        ## 定数を分数と同じ基底型で作る。
        circleFraction(circleConst(witness.num, value))

    proc `+`[T](x, y: CircleExactScalar[T]): CircleExactScalar[T] =
        ## 分母のgcdを先に取り、指定型で有限分数を加える。
        mixin `+`, `*`, `div`
        let g = circleGcd(x.den, y.den)
        let a = x.den div g
        let b = y.den div g
        circleRational(x.num * b + y.num * a, a * y.den)

    proc `-`[T](x: CircleExactScalar[T]): CircleExactScalar[T] =
        ## 指定型で分数の符号を反転する。
        mixin `-`
        CircleExactScalar[T](num: -x.num, den: x.den)

    proc `-`[T](x, y: CircleExactScalar[T]): CircleExactScalar[T] =
        ## 指定型で有限分数を引く。
        x + (-y)

    proc `*`[T](x, y: CircleExactScalar[T]): CircleExactScalar[T] =
        ## 分子・分母を交差約分してから指定型で掛ける。
        mixin `*`, `div`
        let a = circleGcd(x.num, y.den)
        let b = circleGcd(y.num, x.den)
        circleRational((x.num div a) * (y.num div b), (x.den div b) * (y.den div a))

    proc `*`[T](x: CircleExactScalar[T], y: int): CircleExactScalar[T] =
        ## 基底型を変えずに分数を小さな整数倍する。
        x * circleLike(x, y)

    proc `/`[T](x, y: CircleExactScalar[T]): CircleExactScalar[T] =
        ## 指定型で有限分数を割る。
        x * circleRational(y.den, y.num)

    proc `==`[T](x, y: CircleExactScalar[T]): bool =
        ## 正規化済み分数の一致を判定する。
        mixin `==`
        x.num == y.num and x.den == y.den

    proc `+`[T](p, q: Point[CircleExactScalar[T]]): Point[CircleExactScalar[T]] =
        ## 同じ基底型の厳密座標を加える。
        initPoint(p.x + q.x, p.y + q.y)

    proc `-`[T](p, q: Point[CircleExactScalar[T]]): Point[CircleExactScalar[T]] =
        ## 同じ基底型の厳密座標の差を求める。
        initPoint(p.x - q.x, p.y - q.y)

    proc `*`[T](p: Point[CircleExactScalar[T]], x: CircleExactScalar[T]): Point[CircleExactScalar[T]] =
        ## 同じ基底型の厳密座標を分数倍する。
        initPoint(p.x * x, p.y * x)

    proc dot[T](p, q: Point[CircleExactScalar[T]]): CircleExactScalar[T] =
        ## 同じ基底型の厳密座標の内積を求める。
        p.x * q.x + p.y * q.y

    proc cross[T](p, q: Point[CircleExactScalar[T]]): CircleExactScalar[T] =
        ## 同じ基底型の厳密座標の外積を求める。
        p.x * q.y - p.y * q.x

    proc norm[T](p: Point[CircleExactScalar[T]]): CircleExactScalar[T] =
        ## 同じ基底型の厳密座標のノルム二乗を求める。
        dot(p, p)

    proc `==`[T](p, q: Point[CircleExactScalar[T]]): bool =
        ## 厳密座標の一致を判定する。
        p.x == q.x and p.y == q.y

    proc circleExactPoint[T](p: Point[T]): auto =
        ## 点を同じ基底型の内部有理座標として扱う。
        initPoint(circleFraction(p.x), circleFraction(p.y))

    proc circlePointLike[T, S](witness: Point[CircleExactScalar[T]], p: Point[S]): Point[CircleExactScalar[T]] =
        ## 点の分子・分母を円の基底型へ合わせる。円の型は昇格しない。
        let q = circleExactPoint(p)
        initPoint(circleRational(circleValueLike(witness.x.num, q.x.num), circleValueLike(witness.x.num, q.x.den)),
                  circleRational(circleValueLike(witness.y.num, q.y.num), circleValueLike(witness.y.num, q.y.den)))

    proc circleStoredPoint[T](p: Point[CircleExactScalar[T]]): Point[Fraction[T]] =
        ## 同じ基底型のFractionとして厳密座標を公開する。
        initPoint(Fraction[T](num: p.x.num, den: p.x.den), Fraction[T](num: p.y.num, den: p.y.den))

    proc circleStoredLike[T, S](witness: T, x: CircleExactScalar[S]): T =
        ## 生成した座標を入力と同じ型で格納する。
        when T is Fraction:
            result = T(num: x.num, den: x.den)
        else:
            if circleSign((x.den - circleConst(x.den, 1))) != 0:
                raise newException(ValueError, "整数座標の3点として表現できない値です")
            result = circleValueLike(witness, x.num)

    proc toExactPoint*[T](p: Point[T]): auto =
        ## 整数TならFraction[T]、Fraction[U]ならFraction[U]の点を返す。
        circleStoredPoint(circleExactPoint(p))

    proc points*[T](c: Circle[T]): array[3, Point[T]] =
        ## 保持する3点の分子座標を返す。実際の点はpoint_scaleで割る。通常構築は尺度1。
        if not c.initialized: raise newException(ValueError, "厳密円は初期化されていません")
        c.definingPoints

    proc point_scale*[T](c: Circle[T]): T =
        ## 保持3点の共通尺度を返す。直径円は2、その他の構築は1。
        discard c.points
        c.commonScale

    proc points_exact*[T](c: Circle[T]): auto =
        ## 共通尺度で割った実際の3点を同じ基底型のFractionで返す。
        let stored = c.points
        let scale = circleFraction(c.commonScale)
        type P = typeof(circleStoredPoint(circleExactPoint(stored[0])))
        var output: array[3, P]
        for i, p in stored: output[i] = circleStoredPoint(circleExactPoint(p) * (circleLike(scale, 1) / scale))
        output

    proc initCircleInteger[T](a, b, c: Point[T]): Circle[T] =
        ## 元の3点を尺度1で保持する。全点一致以外の共線3点はValueError。
        mixin `-`, `*`, `==`
        let sample = circleFraction(a.x)
        when T is Fraction:
            let p = circleExactPoint(a)
            let q = circleExactPoint(b)
            let r = circleExactPoint(c)
            if circleSign(cross(q - p, r - p).num) == 0 and not (p == q and p == r):
                raise newException(ValueError, "円の3点は非共線または全点一致である必要があります")
        else:
            let determinant = (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)
            if circleSign(determinant) == 0 and not (a.x == b.x and a.y == b.y and a.x == c.x and a.y == c.y):
                raise newException(ValueError, "円の3点は非共線または全点一致である必要があります")
        let one = circleStoredLike(a.x, circleLike(sample, 1))
        Circle[T](definingPoints: [a, b, c], commonScale: one, initialized: true)

    proc initCircleInteger[T, R](center: Point[T], radius: R): Circle[T] =
        ## 中心と非負整数半径から同じ型Tの3点を生成する。尺度は1、自動昇格なし。
        let p = circleExactPoint(center)
        let supplied = circleFraction(radius)
        let r = circleRational(circleValueLike(p.x.num, supplied.num), circleValueLike(p.x.num, supplied.den))
        if circleSign(r.num) < 0: raise newException(ValueError, "円の半径は非負である必要があります")
        let a = initPoint(circleStoredLike(center.x, p.x + r), center.y)
        let b = initPoint(center.x, circleStoredLike(center.y, p.y + r))
        let c = initPoint(circleStoredLike(center.x, p.x - r), center.y)
        initCircleInteger(a, b, c)

    proc initCircleInteger[T](center, through: Point[T]): Circle[T] =
        ## 中心と通過点から同じ型Tの3点を生成する。一致時は点円、尺度は1。
        let p = circleExactPoint(center)
        let q = circleExactPoint(through)
        let v = q - p
        let b = p + initPoint(-v.y, v.x)
        let c = p - v
        initCircleInteger(through, initPoint(circleStoredLike(center.x, b.x), circleStoredLike(center.y, b.y)),
                        initPoint(circleStoredLike(center.x, c.x), circleStoredLike(center.y, c.y)))

    proc initDiameterCircleInteger[T](a, b: Point[T]): Circle[T] =
        ## 2点直径円を同じ型Tの3点と共通尺度2で保持する。一致時は点円。
        let p = circleExactPoint(a)
        let q = circleExactPoint(b)
        let sum = p + q
        let v = p - q
        let middle = sum + initPoint(-v.y, v.x)
        let twice = circleLike(p.x, 2)
        let first = p * twice
        let last = q * twice
        result = initCircleInteger(initPoint(circleStoredLike(a.x, first.x), circleStoredLike(a.y, first.y)),
                                 initPoint(circleStoredLike(a.x, middle.x), circleStoredLike(a.y, middle.y)),
                                 initPoint(circleStoredLike(a.x, last.x), circleStoredLike(a.y, last.y)))
        result.commonScale = circleStoredLike(a.x, twice)

    proc circleExactData[T](c: Circle[T]): auto =
        ## 保持3点と共通尺度から同じ基底型で中心・半径二乗を求める。
        let stored = c.points
        let a = circleExactPoint(stored[0])
        let b = circleExactPoint(stored[1])
        let d = circleExactPoint(stored[2])
        let scale = circleFraction(c.commonScale)
        if a == b and a == d:
            return (center: a * (circleLike(scale, 1) / scale), radiusSquared: circleLike(a.x, 0))
        let u = b - a
        let v = d - a
        let determinant = cross(u, v) * 2
        let offset = initPoint((v.y * norm(u) - u.y * norm(v)) / determinant,
                               (u.x * norm(v) - v.x * norm(u)) / determinant)
        (center: (a + offset) * (circleLike(scale, 1) / scale), radiusSquared: norm(offset) / (scale * scale))

    proc exactCircleCheckPoint(p: Point[float]) =
        ## 近似出力が有限座標であることを検査する。
        if p.x != p.x or p.y != p.y or abs(p.x) == system.Inf or abs(p.y) == system.Inf:
            raise newException(ValueError, "厳密円の近似出力は有限である必要があります")

    proc exactCirclePerpendicular(p: Point[float]): Point[float] =
        ## 近似ベクトルを90度回転する。
        initPoint(-p.y, p.x)

    proc center_exact*[T](c: Circle[T]): auto =
        ## 有理数の中心を厳密に返す。
        circleStoredPoint(circleExactData(c).center)

    proc radius_squared_exact*[T](c: Circle[T]): auto =
        ## 有理数の半径二乗を厳密に返す。半径自体は無理数となりうる。
        let r = circleExactData(c).radiusSquared
        Fraction[typeof(r.num)](num: r.num, den: r.den)

    proc circleIntegerClassify[T, S](c: Circle[T], p: Point[S]): CirclePointLocation =
        ## 円盤の外・境界・内部を指定型で厳密分類する。整数は共通尺度付きincircle行列式。
        mixin `-`, `*`, `+`, `==`
        when T isnot Fraction and S isnot Fraction:
            let a = c.points
            let scale = c.commonScale
            let x = circleValueLike(a[0].x, p.x) * scale
            let y = circleValueLike(a[0].y, p.y) * scale
            if a[0].x == a[1].x and a[0].y == a[1].y and a[0].x == a[2].x and a[0].y == a[2].y:
                return if x == a[0].x and y == a[0].y: circleBoundary else: circleOutside
            let orientation = circleSign((a[1].x - a[0].x) * (a[2].y - a[0].y) - (a[1].y - a[0].y) * (a[2].x - a[0].x))
            let ax = a[0].x - x
            let ay = a[0].y - y
            let bx = a[1].x - x
            let by = a[1].y - y
            let dx = a[2].x - x
            let dy = a[2].y - y
            let sign = circleSign((ax * ax + ay * ay) * (bx * dy - by * dx) -
                                  (bx * bx + by * by) * (ax * dy - ay * dx) +
                                  (dx * dx + dy * dy) * (ax * by - ay * bx)) * orientation
            if sign < 0: circleOutside elif sign > 0: circleInside else: circleBoundary
        else:
            let data = circleExactData(c)
            let difference = norm(circlePointLike(data.center, p) - data.center) - data.radiusSquared
            if circleSign(difference.num) > 0: circleOutside
            elif circleSign(difference.num) < 0: circleInside
            else: circleBoundary

    proc circleIntegerContains[T, S](c: Circle[T], p: Point[S]): bool =
        ## 境界を含む円盤の点包含を厳密に判定する。
        circleIntegerClassify(c, p) != circleOutside

    proc circleIntegerOnCircle[T, S](c: Circle[T], p: Point[S]): bool =
        ## 円周上かを厳密に判定する。
        circleIntegerClassify(c, p) == circleBoundary

    proc `==`*[T](a, b: Circle[T]): bool =
        ## 同じ座標型の2円を点の順序によらず同じ円かを厳密に判定する。
        when T is SomeFloat:
            a.centerValue.x == b.centerValue.x and a.centerValue.y == b.centerValue.y and a.radiusValue == b.radiusValue
        else:
            let x = circleExactData(a)
            let y = circleExactData(b)
            x.center == y.center and x.radiusSquared == y.radiusSquared

    proc circleLineData[T, S](c: Circle[T], l: Line[S]): auto =
        ## 直線パラメータの二次方程式を円の基底型で求める。退化直線はValueError。
        let data = circleExactData(c)
        let s = circlePointLike(data.center, l.s)
        let v = circlePointLike(data.center, l.t) - s
        let a = norm(v)
        if circleSign(a.num) == 0: raise newException(ValueError, "直線は非退化である必要があります")
        let w = s - data.center
        let b = dot(w, v) * 2
        (s: s, v: v, a: a, b: b, discriminant: b * b - a * (norm(w) - data.radiusSquared) * 4)

    proc circleIntegerIntersectionCount[T, S](c: Circle[T], l: Line[S]): int =
        ## 円周と直線の交点数0〜2を厳密に返す。
        let sign = circleSign(circleLineData(c, l).discriminant.num)
        if sign < 0: 0 elif sign == 0: 1 else: 2

    proc circleRadicalSign[T](x: CircleExactScalar[T], sign: int, radicand: CircleExactScalar[T]): int =
        ## x + sign * sqrt(radicand)の符号を平方の厳密比較で返す。
        let xs = circleSign(x.num)
        if (circleSign(radicand.num) == 0): return xs
        if xs == 0 or xs == sign: return sign
        let comparison = circleSign((x * x - radicand).num)
        if comparison == 0: 0 elif comparison > 0: xs else: sign

    proc circleIntegerIntersectionCount[T, S](c: Circle[T], s: Segment[S]): int =
        ## 円周と閉線分の交点数を厳密に返す。退化線分も許す。
        let a = circleExactPoint(s.s)
        let b = circleExactPoint(s.t)
        if a == b: return ord(c.circleIntegerOnCircle(s.s))
        let data = circleLineData(c, Line[S](s: s.s, t: s.t))
        if circleSign(data.discriminant.num) < 0: return 0
        for sign in [-1, 1]:
            if sign == 1 and (circleSign(data.discriminant.num) == 0): continue
            if circleRadicalSign(-data.b, sign, data.discriminant) >= 0 and
                    circleRadicalSign(-data.b - data.a * 2, sign, data.discriminant) <= 0:
                inc result

    proc circlePairData[T](a, b: Circle[T]): auto =
        ## 同じ座標型の2円の共通弦を厳密に求める。
        let x = circleExactData(a)
        let y = circleExactData(b)
        let v = y.center - x.center
        let distanceSquared = norm(v)
        var factor = circleLike(distanceSquared, 0)
        var heightSquared = factor
        if circleSign(distanceSquared.num) != 0:
            factor = (distanceSquared + x.radiusSquared - y.radiusSquared) / (distanceSquared * 2)
            heightSquared = x.radiusSquared - distanceSquared * factor * factor
        (center: x.center, v: v, distanceSquared: distanceSquared, factor: factor, heightSquared: heightSquared)

    proc circleIntegerIntersectionCount[T](a, b: Circle[T]): int =
        ## 2円周の交点数を厳密に返す。同一正半径円は-1（無限個）、同一点円は1。
        let data = circlePairData(a, b)
        if (circleSign(data.distanceSquared.num) == 0):
            if a != b: return 0
            return if (circleSign(a.radius_squared_exact.num) == 0): 1 else: -1
        let sign = circleSign(data.heightSquared.num)
        if sign < 0: 0 elif sign == 0: 1 else: 2

    proc circleIntegerTangentCount[T, S](c: Circle[T], p: Point[S]): int =
        ## 点からの接線数を厳密に返す。点円自身は-1（無限個）、他点からは1。
        let location = circleIntegerClassify(c, p)
        if (circleSign(c.radius_squared_exact.num) == 0):
            return if location == circleBoundary: -1 else: 1
        case location
        of circleOutside: 2
        of circleBoundary: 1
        of circleInside: 0

    proc circleIntegerCommonTangentCount[T](a, b: Circle[T]): int =
        ## 共通接線数0〜4を厳密に返す。同一円は-1（無限個）。点円も扱う。
        let x = circleExactData(a)
        let y = circleExactData(b)
        let d = norm(y.center - x.center)
        if (circleSign(d.num) == 0): return if a == b: -1 else: 0
        if (circleSign(x.radiusSquared.num) == 0) and (circleSign(y.radiusSquared.num) == 0): return 1
        if (circleSign(x.radiusSquared.num) == 0) or (circleSign(y.radiusSquared.num) == 0):
            let sign = circleSign((d - x.radiusSquared - y.radiusSquared).num)
            return if sign < 0: 0 elif sign == 0: 1 else: 2
        let difference = d - x.radiusSquared - y.radiusSquared
        let comparison = circleSign((difference * difference - x.radiusSquared * y.radiusSquared * 4).num)
        if comparison < 0: 2
        elif comparison == 0: (if circleSign(difference.num) > 0: 3 else: 1)
        else: (if circleSign(difference.num) > 0: 4 else: 0)

    proc circleDecimalHead[T](x: T): tuple[value: float, exponent: int] =
        ## 指定された整数の先頭17桁と10進指数を近似出力のために求める。O(桁数)。
        mixin `$`
        let text = $x
        let s = if text[0] == '-': text[1..^1] else: text
        let length = min(s.len, 17)
        (parseFloat(s[0..<length]) / pow(10.0, float(length - 1)), s.len - 1)

    proc circleFractionApprox[T](x: CircleExactScalar[T], squareRoot = false): float =
        ## 分子・分母を別々にfloat化せず、指数を合わせて近似する。範囲外はValueError。
        if (circleSign(x.num) == 0): return 0
        let n = circleDecimalHead(x.num)
        let d = circleDecimalHead(x.den)
        var exponent = n.exponent - d.exponent
        var mantissa = n.value / d.value
        if squareRoot:
            if circleSign(x.num) < 0: raise newException(ValueError, "負数の平方根は取得できません")
            if (exponent mod 2) != 0:
                mantissa *= 10
                dec exponent
            mantissa = sqrt(mantissa)
            exponent = exponent div 2
        while mantissa < 1:
            mantissa *= 10
            dec exponent
        while mantissa >= 10:
            mantissa /= 10
            inc exponent
        if exponent < -324 or exponent > 308:
            raise newException(ValueError, "厳密円の近似出力はfloat64の範囲外です")
        if exponent < -308:
            result = (mantissa * 1e-308) * pow(10.0, float(exponent + 308))
        else:
            result = mantissa * pow(10.0, float(exponent))
        result *= float(circleSign(x.num))
        if result != result or abs(result) == system.Inf or result == 0:
            raise newException(ValueError, "厳密円の近似出力は非零の有限float64で表現できません")

    proc circlePointApprox[T](p: Point[CircleExactScalar[T]]): Point[float] =
        ## 厳密座標を最後にfloat64へ近似する。
        initPoint(circleFractionApprox(p.x), circleFractionApprox(p.y))

    proc center_approx*[T](c: Circle[T]): Point[float] =
        ## 中心をfloat64で近似する。厳密な中心はcenter_exactで取得する。
        when T is SomeFloat: c.centerValue
        else: circlePointApprox(circleExactData(c).center)

    proc radius_approx*[T](c: Circle[T]): float =
        ## 半径をfloat64で近似する。平方根を取る前の厳密値はradius_squared_exact。
        when T is SomeFloat: c.radiusValue
        else: circleFractionApprox(circleExactData(c).radiusSquared, true)

    proc toFloatCircle*[T](c: Circle[T]): Circle[float] =
        ## 明示的に既存float円へ近似変換する。変換後の述語は厳密ではない。
        circleFloatInit(c.center_approx, c.radius_approx)

    proc circleOffsetApprox[T](v: Point[CircleExactScalar[T]], squaredFactor: CircleExactScalar[T]): Point[float] =
        ## v * sqrt(squaredFactor)を各成分の平方から近似し、中間float積を避ける。
        initPoint(float(circleSign(v.x.num)) * circleFractionApprox(v.x * v.x * squaredFactor, true),
                  float(circleSign(v.y.num)) * circleFractionApprox(v.y * v.y * squaredFactor, true))

    proc circleIntegerCrossPoints[T, S](c: Circle[T], l: Line[S]): CircleIntersections =
        ## 円周と直線の交点を近似出力する。交点数はfloat化前に厳密判定する。
        let data = circleLineData(c, l)
        if circleSign(data.discriminant.num) < 0: return
        let foot = circlePointApprox(data.s - data.v * (data.b / (data.a * 2)))
        if (circleSign(data.discriminant.num) == 0): result.points = @[foot]
        else:
            let offset = circleOffsetApprox(data.v, data.discriminant / (data.a * data.a * 4))
            result.points = @[foot - offset, foot + offset]
        for p in result.points: exactCircleCheckPoint(p)

    proc circleIntegerCrossPoints[T](a, b: Circle[T]): CircleIntersections =
        ## 2円周の交点を近似出力する。点円・同一円の分類も厳密に行う。
        let count = circleIntegerIntersectionCount(a, b)
        if count == -1:
            result.kind = circleInfinite
            return
        if count == 0: return
        let data = circlePairData(a, b)
        if (circleSign(data.distanceSquared.num) == 0):
            result.points = @[a.center_approx]
            return
        let foot = circlePointApprox(data.center + data.v * data.factor)
        if count == 1: result.points = @[foot]
        else:
            let offset = circleOffsetApprox(initPoint(-data.v.y, data.v.x), data.heightSquared / data.distanceSquared)
            result.points = @[foot - offset, foot + offset]
        for p in result.points: exactCircleCheckPoint(p)

    proc circleIntegerTangentLines[T, S](c: Circle[T], p: Point[S]): CircleTangents =
        ## 点から円への接線を近似出力する。接線数はfloat化前に厳密判定する。
        let count = circleIntegerTangentCount(c, p)
        if count == -1:
            result.kind = circleInfinite
            return
        if count == 0: return
        let data = circleExactData(c)
        let q = circlePointLike(data.center, p)
        let v = q - data.center
        let dsq = norm(v)
        if (circleSign(data.radiusSquared.num) == 0):
            result.tangents = @[CircleTangent(first: circlePointApprox(data.center), second: circlePointApprox(q),
                direction: circleOffsetApprox(v, circleLike(dsq, 1) / dsq))]
            return
        let foot = data.center + v * (data.radiusSquared / dsq)
        let squaredFactor = data.radiusSquared * (dsq - data.radiusSquared) / (dsq * dsq)
        let offset = circleOffsetApprox(initPoint(-v.y, v.x), squaredFactor)
        let normalBase = circleOffsetApprox(v, data.radiusSquared / (dsq * dsq))
        let normalOffset = circleOffsetApprox(initPoint(-v.y, v.x), (dsq - data.radiusSquared) / (dsq * dsq))
        for sign in [-1.0, 1.0]:
            if count == 1 and sign > 0: continue
            let normal = normalBase + normalOffset * sign
            let contact = circlePointApprox(foot) + offset * sign
            exactCircleCheckPoint(contact)
            result.tangents.add(CircleTangent(first: contact, second: circlePointApprox(q), direction: exactCirclePerpendicular(normal)))

    proc circleIntegerCrossPoints[T, S](c: Circle[T], s: Segment[S]): CircleIntersections =
        ## 円周と閉線分の交点を近似出力する。端点の採否は平方根を取らず厳密判定する。
        if circleExactPoint(s.s) == circleExactPoint(s.t):
            if c.circleIntegerOnCircle(s.s): result.points = @[circlePointApprox(circleExactPoint(s.s))]
            return
        let data = circleLineData(c, Line[S](s: s.s, t: s.t))
        if circleSign(data.discriminant.num) < 0: return
        var accepted: seq[int]
        var index = 0
        for sign in [-1, 1]:
            if sign == 1 and circleSign(data.discriminant.num) == 0: continue
            if circleRadicalSign(-data.b, sign, data.discriminant) >= 0 and
                    circleRadicalSign(-data.b - data.a * 2, sign, data.discriminant) <= 0:
                accepted.add(index)
            inc index
        if accepted.len == 0: return
        let intersections = circleIntegerCrossPoints(c, Line[S](s: s.s, t: s.t))
        for index in accepted: result.points.add(intersections.points[index])

    proc circleIntegerCommonTangents[T](a, b: Circle[T]): CircleTangents =
        ## 共通接線を近似出力する。各接線族の存在と重複はfloat化前に厳密判定する。
        let x = circleExactData(a)
        let y = circleExactData(b)
        let v = y.center - x.center
        let d = norm(v)
        if circleSign(d.num) == 0:
            if a == b: result.kind = circleInfinite
            return
        let firstZero = circleSign(x.radiusSquared.num) == 0
        let secondZero = circleSign(y.radiusSquared.num) == 0
        var families: seq[tuple[side, existence, contactSign: int]]
        if not (firstZero and secondZero):
            let difference = d - x.radiusSquared - y.radiusSquared
            let radicand = x.radiusSquared * y.radiusSquared * 4
            for side in [1, -1]:
                if side < 0 and (firstZero or secondZero): continue
                let existence = circleRadicalSign(difference, side, radicand)
                if existence < 0: continue
                let contactSign = if side > 0 and circleSign((x.radiusSquared - y.radiusSquared).num) < 0: -1 else: 1
                families.add((side, existence, contactSign))
            if families.len == 0: return
        let unit = circleOffsetApprox(v, circleLike(d, 1) / d)
        let firstCenter = circlePointApprox(x.center)
        let secondCenter = circlePointApprox(y.center)
        if firstZero and secondZero:
            result.tangents = @[CircleTangent(first: firstCenter, second: secondCenter, direction: unit)]
            return
        let firstRadius = circleFractionApprox(x.radiusSquared, true)
        let secondRadius = circleFractionApprox(y.radiusSquared, true)
        for family in families:
            let ratio = circleFractionApprox(x.radiusSquared / d, true) - float(family.side) * circleFractionApprox(y.radiusSquared / d, true)
            let cosine = if family.existence == 0: float(family.contactSign) else: max(-1.0, min(1.0, ratio))
            let sine = if family.existence == 0: 0.0 else: sqrt(max(0.0, (1 - cosine) * (1 + cosine)))
            for sign in [-1.0, 1.0]:
                if sign > 0 and family.existence == 0: continue
                let normal = unit * cosine + exactCirclePerpendicular(unit) * (sine * sign)
                let first = firstCenter + normal * firstRadius
                let second = secondCenter + normal * (float(family.side) * secondRadius)
                let direction = exactCirclePerpendicular(normal)
                exactCircleCheckPoint(first)
                exactCircleCheckPoint(second)
                exactCircleCheckPoint(direction)
                result.tangents.add(CircleTangent(first: first, second: second, direction: direction))

    proc circleFloatCoordinate[T](x: T): float =
        ## 明示float構築の座標をfloat64へ変換する。
        mixin `$`
        when T is SomeNumber: float(x)
        elif T is Fraction:
            if circleSign(x.den) == 0: raise newException(ValueError, "float円の分数座標は有限である必要があります")
            circleFractionApprox(CircleExactScalar[typeof(x.num)](num: x.num, den: x.den)) * float(circleSign(x.den))
        else: circleFractionApprox(circleFraction(x))

    proc circleFloatPoint[T](p: Point[T]): Point[float] =
        ## 明示float構築の点をfloat64へ変換する。
        initPoint(circleFloatCoordinate(p.x), circleFloatCoordinate(p.y))

    proc initCircle*[T, R](center: Point[T], radius: R): auto =
        ## 中心と非負半径で構築する。明示floatがあればfloat64、それ以外は入力座標型を保持する。
        when T is SomeFloat or R is SomeFloat:
            circleFloatInit(circleFloatPoint(center), circleFloatCoordinate(radius))
        else: initCircleInteger(center, radius)

    proc initCircle*[T, S](center: Point[T], through: Point[S]): auto =
        ## 中心と通過点で構築する。明示floatはfloat64、整数・Fractionは同じ座標型を使う。
        when T is SomeFloat or S is SomeFloat:
            let p = circleFloatPoint(center)
            let q = circleFloatPoint(through)
            circleFloatInit(p, circleLength(q - p))
        else:
            when T isnot S: {.error: "整数・Fractionの中心と通過点は同じ座標型にしてください".}
            initCircleInteger(center, through)

    proc initCircle*[T, S, U](a: Point[T], b: Point[S], c: Point[U]): auto =
        ## 3点で構築する。整数・Fractionは元の3点を保持し、floatは尺度を正規化して外接円を求める。
        when T is SomeFloat or S is SomeFloat or U is SomeFloat:
            let p = circleFloatPoint(a)
            let q = circleFloatPoint(b)
            let r = circleFloatPoint(c)
            for point in [p, q, r]: circleCheckPoint(point)
            let u = q - p
            let v = r - p
            let scale = max(max(abs(u.x), abs(u.y)), max(abs(v.x), abs(v.y)))
            if scale == 0: return circleFloatInit(p, 0.0)
            let un = u / scale
            let vn = v / scale
            let determinant = 2 * cross(un, vn)
            if determinant == 0: raise newException(ValueError, "円の3点は非共線または全点一致である必要があります")
            let offset = initPoint((vn.y * norm(un) - un.y * norm(vn)) / determinant * scale,
                                  (un.x * norm(vn) - vn.x * norm(un)) / determinant * scale)
            let center = p + offset
            circleFloatInit(center, max(circleLength(p - center), max(circleLength(q - center), circleLength(r - center))))
        else:
            when T isnot S or T isnot U: {.error: "整数・Fractionの3点は同じ座標型にしてください".}
            initCircleInteger(a, b, c)

    proc initDiameterCircle*[T](a, b: Point[T]): auto =
        ## 2点直径円。整数・Fractionは同じ型の3点と尺度2、floatはfloat64の中心・半径で保持する。
        when T is SomeFloat:
            let p = circleFloatPoint(a)
            let q = circleFloatPoint(b)
            let center = p + (q - p) * 0.5
            circleFloatInit(center, max(circleLength(p - center), circleLength(q - center)))
        else: initDiameterCircleInteger(a, b)

    proc center*[T](c: Circle[T]): auto =
        ## 中心を返す。整数TはPoint[Fraction[T]]、Fraction[U]はPoint[Fraction[U]]、floatはPoint[float]。
        when T is SomeFloat: c.centerValue
        else: c.center_exact

    proc radius*[T](c: Circle[T]): float =
        ## 半径をfloat64で返す。整数・Fractionの厳密値はradius_squared_exactで取得する。
        c.radius_approx

    proc contains*[T, S](c: Circle[T], p: Point[S], tolerance: float = 1e-10): bool =
        ## 境界を含む円盤の包含。floatは相対許容誤差、それ以外は指定型の厳密判定。
        when T is SomeFloat: circleFloatContains(toFloatCircle(c), circleFloatPoint(p), tolerance)
        else: circleIntegerContains(c, p)

    proc classify*[T, S](c: Circle[T], p: Point[S], tolerance: float = 1e-10): CirclePointLocation =
        ## 内外・境界を分類する。floatの境界は相対許容誤差、それ以外は厳密。
        when T is SomeFloat:
            circleCheckTolerance(tolerance)
            let distance = circleLength(circleFloatPoint(p) - c.centerValue)
            if abs(distance - c.radiusValue) <= tolerance * max(distance, c.radiusValue): circleBoundary
            elif distance < c.radiusValue: circleInside
            else: circleOutside
        else: circleIntegerClassify(c, p)

    proc cross_points*[T, S](c: Circle[T], l: Line[S], tolerance: float = 1e-10): CircleIntersections =
        ## 交点座標はfloat64の近似値。整数・Fractionでは採否を先に厳密判定する。
        when T is SomeFloat: circleFloatCrossPoints(toFloatCircle(c), Line[float](s: circleFloatPoint(l.s), t: circleFloatPoint(l.t)), tolerance)
        else: circleIntegerCrossPoints(c, l)

    proc cross_points*[T, S](c: Circle[T], s: Segment[S], tolerance: float = 1e-10): CircleIntersections =
        ## 閉線分との交点座標はfloat64の近似値。整数・Fractionでは端点の採否も厳密。
        when T is SomeFloat: circleFloatCrossPoints(toFloatCircle(c), Segment[float](s: circleFloatPoint(s.s), t: circleFloatPoint(s.t)), tolerance)
        else: circleIntegerCrossPoints(c, s)

    proc cross_points*[T](a, b: Circle[T], tolerance: float = 1e-10): CircleIntersections =
        ## 2円の交点を近似出力する。整数・Fractionの交点数は厳密。
        when T is SomeFloat: circleFloatCrossPoints(toFloatCircle(a), toFloatCircle(b), tolerance)
        else: circleIntegerCrossPoints(a, b)

    proc common_tangents*[T](a, b: Circle[T], tolerance: float = 1e-10): CircleTangents =
        ## 共通接線を近似出力する。floatは許容誤差、整数・Fractionは存在・本数を先に厳密判定する。
        when T is SomeFloat: circleFloatCommonTangents(toFloatCircle(a), toFloatCircle(b), tolerance)
        else: circleIntegerCommonTangents(a, b)

    proc tangent_lines*[T, S](c: Circle[T], p: Point[S], tolerance: float = 1e-10): CircleTangents =
        ## 点からの接線を近似出力する。整数・Fractionでは本数を先に厳密判定する。
        when T is SomeFloat: circleFloatTangentLines(toFloatCircle(c), circleFloatPoint(p), tolerance)
        else: circleIntegerTangentLines(c, p)

    proc on_circle*[T, S](c: Circle[T], p: Point[S], tolerance: float = 1e-10): bool =
        ## 円周上かを判定する。floatは許容誤差、それ以外は厳密。
        when T is SomeFloat: c.classify(p, tolerance) == circleBoundary
        else: circleIntegerOnCircle(c, p)

    proc intersection_count*[T, S](c: Circle[T], l: Line[S], tolerance: float = 1e-10): int =
        ## 直線との交点数。floatは許容誤差、それ以外は厳密。
        when T is SomeFloat: cross_points(c, l, tolerance).points.len
        else: circleIntegerIntersectionCount(c, l)

    proc intersection_count*[T, S](c: Circle[T], s: Segment[S], tolerance: float = 1e-10): int =
        ## 閉線分との交点数。floatは許容誤差、それ以外は厳密。
        when T is SomeFloat: cross_points(c, s, tolerance).points.len
        else: circleIntegerIntersectionCount(c, s)

    proc intersection_count*[T](a, b: Circle[T], tolerance: float = 1e-10): int =
        ## 2円の交点数。無限個は-1、floatは許容誤差、それ以外は厳密。
        when T is SomeFloat:
            let points = cross_points(a, b, tolerance)
            if points.kind == circleInfinite: -1 else: points.points.len
        else: circleIntegerIntersectionCount(a, b)

    proc tangent_count*[T, S](c: Circle[T], p: Point[S], tolerance: float = 1e-10): int =
        ## 点からの接線数。無限個は-1、floatは許容誤差、それ以外は厳密。
        when T is SomeFloat:
            let lines = tangent_lines(c, p, tolerance)
            if lines.kind == circleInfinite: -1 else: lines.tangents.len
        else: circleIntegerTangentCount(c, p)

    proc common_tangent_count*[T](a, b: Circle[T], tolerance: float = 1e-10): int =
        ## 共通接線数。無限個は-1、floatは許容誤差、それ以外は厳密。
        when T is SomeFloat:
            let lines = common_tangents(a, b, tolerance)
            if lines.kind == circleInfinite: -1 else: lines.tangents.len
        else: circleIntegerCommonTangentCount(a, b)

    proc cross_points_approx*[T, S](c: Circle[T], l: Line[S]): CircleIntersections =
        ## 直線との交点をfloat64で近似出力する。整数・Fractionの交点数は厳密。
        cross_points(c, l)

    proc cross_points_approx*[T, S](c: Circle[T], s: Segment[S]): CircleIntersections =
        ## 閉線分との交点をfloat64で近似出力する。整数・Fractionの端点採否は厳密。
        cross_points(c, s)

    proc cross_points_approx*[T](a, b: Circle[T]): CircleIntersections =
        ## 2円の交点をfloat64で近似出力する。整数・Fractionの交点数は厳密。
        cross_points(a, b)

    proc tangent_lines_approx*[T, S](c: Circle[T], p: Point[S]): CircleTangents =
        ## 点からの接線をfloat64で近似出力する。整数・Fractionの本数は厳密。
        tangent_lines(c, p)
