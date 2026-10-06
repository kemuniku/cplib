when not declared CPLIB_GEOMETRY_EXACT_CIRCLE:
    const CPLIB_GEOMETRY_EXACT_CIRCLE* = 1
    import math, strutils
    import cplib/geometry/base
    import cplib/geometry/circle
    import cplib/math/fractions

    ## 指定型Tの3点と正の共通尺度を保持する。実際の3点はpoints / point_scale。
    ## 通常の構築は尺度1、2点直径円は尺度2。支持2点へ表現を切り替えない。
    ## 符号付き整数、Int128、BigInt、それらを基底とする有限Fractionに対応する。
    ## 自動昇格は行わない。固定幅型では差・積・符号反転・分数の中間値も型に収まることが前提。
    ## 中心＋通過点・2円関係は同じ座標型を用いる。符号なし整数の暗黙昇格も行わない。
    ## 中心と半径二乗は整数TならFraction[T]、Fraction[U]ならFraction[U]。
    ## *_approxのみfloat64を使う。整数・分数の判定中にはfloatを使わない。
    ## default(ExactCircle[T])は未初期化。全点一致は点円、その他の共線3点はValueError。
    type
        ExactCircle*[T] = object
            definingPoints: array[3, Point[T]]
            commonScale: T
            initialized: bool
        ExactCircleFraction*[T] = Fraction[T]
        CircleExactScalar[T] = object
            num, den: T
        CirclePointLocation* = enum
            circleOutside, circleBoundary, circleInside

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
            result = circleValueLike(witness, x.num)

    proc toExactPoint*[T](p: Point[T]): auto =
        ## 整数TならFraction[T]、Fraction[U]ならFraction[U]の点を返す。
        circleStoredPoint(circleExactPoint(p))

    proc points*[T](c: ExactCircle[T]): array[3, Point[T]] =
        ## 保持する3点の分子座標を返す。実際の点はpoint_scaleで割る。通常構築は尺度1。
        if not c.initialized: raise newException(ValueError, "厳密円は初期化されていません")
        c.definingPoints

    proc point_scale*[T](c: ExactCircle[T]): T =
        ## 保持3点の共通尺度を返す。直径円は2、その他の構築は1。
        discard c.points
        c.commonScale

    proc points_exact*[T](c: ExactCircle[T]): auto =
        ## 共通尺度で割った実際の3点を同じ基底型のFractionで返す。
        let stored = c.points
        let scale = circleFraction(c.commonScale)
        type P = typeof(circleStoredPoint(circleExactPoint(stored[0])))
        var output: array[3, P]
        for i, p in stored: output[i] = circleStoredPoint(circleExactPoint(p) * (circleLike(scale, 1) / scale))
        output

    proc initExactCircle*[T](a, b, c: Point[T]): ExactCircle[T] =
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
        ExactCircle[T](definingPoints: [a, b, c], commonScale: one, initialized: true)

    proc initExactCircle*[T, R](center: Point[T], radius: R): ExactCircle[T] =
        ## 中心と非負整数半径から同じ型Tの3点を生成する。尺度は1、自動昇格なし。
        let p = circleExactPoint(center)
        let r = circleFraction(circleValueLike(p.x.num, radius))
        if circleSign(r.num) < 0: raise newException(ValueError, "円の半径は非負である必要があります")
        let a = initPoint(circleStoredLike(center.x, p.x + r), center.y)
        let b = initPoint(center.x, circleStoredLike(center.y, p.y + r))
        let c = initPoint(circleStoredLike(center.x, p.x - r), center.y)
        initExactCircle(a, b, c)

    proc initExactCircle*[T](center, through: Point[T]): ExactCircle[T] =
        ## 中心と通過点から同じ型Tの3点を生成する。一致時は点円、尺度は1。
        let p = circleExactPoint(center)
        let q = circleExactPoint(through)
        let v = q - p
        let b = p + initPoint(-v.y, v.x)
        let c = p - v
        initExactCircle(through, initPoint(circleStoredLike(center.x, b.x), circleStoredLike(center.y, b.y)),
                        initPoint(circleStoredLike(center.x, c.x), circleStoredLike(center.y, c.y)))

    proc initExactDiameterCircle*[T](a, b: Point[T]): ExactCircle[T] =
        ## 2点直径円を同じ型Tの3点と共通尺度2で保持する。一致時は点円。
        let p = circleExactPoint(a)
        let q = circleExactPoint(b)
        let sum = p + q
        let v = p - q
        let middle = sum + initPoint(-v.y, v.x)
        let twice = circleLike(p.x, 2)
        let first = p * twice
        let last = q * twice
        result = initExactCircle(initPoint(circleStoredLike(a.x, first.x), circleStoredLike(a.y, first.y)),
                                 initPoint(circleStoredLike(a.x, middle.x), circleStoredLike(a.y, middle.y)),
                                 initPoint(circleStoredLike(a.x, last.x), circleStoredLike(a.y, last.y)))
        result.commonScale = circleStoredLike(a.x, twice)

    proc circleExactData[T](c: ExactCircle[T]): auto =
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

    proc center_exact*[T](c: ExactCircle[T]): auto =
        ## 有理数の中心を厳密に返す。
        circleStoredPoint(circleExactData(c).center)

    proc radius_squared_exact*[T](c: ExactCircle[T]): auto =
        ## 有理数の半径二乗を厳密に返す。半径自体は無理数となりうる。
        let r = circleExactData(c).radiusSquared
        Fraction[typeof(r.num)](num: r.num, den: r.den)

    proc classify*[T, S](c: ExactCircle[T], p: Point[S]): CirclePointLocation =
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

    proc contains*[T, S](c: ExactCircle[T], p: Point[S]): bool =
        ## 境界を含む円盤の点包含を厳密に判定する。
        c.classify(p) != circleOutside

    proc on_circle*[T, S](c: ExactCircle[T], p: Point[S]): bool =
        ## 円周上かを厳密に判定する。
        c.classify(p) == circleBoundary

    proc `==`*[T](a, b: ExactCircle[T]): bool =
        ## 同じ座標型の2円を点の順序によらず同じ円かを厳密に判定する。
        let x = circleExactData(a)
        let y = circleExactData(b)
        x.center == y.center and x.radiusSquared == y.radiusSquared

    proc circleLineData[T, S](c: ExactCircle[T], l: Line[S]): auto =
        ## 直線パラメータの二次方程式を円の基底型で求める。退化直線はValueError。
        let data = circleExactData(c)
        let s = circlePointLike(data.center, l.s)
        let v = circlePointLike(data.center, l.t) - s
        let a = norm(v)
        if circleSign(a.num) == 0: raise newException(ValueError, "直線は非退化である必要があります")
        let w = s - data.center
        let b = dot(w, v) * 2
        (s: s, v: v, a: a, b: b, discriminant: b * b - a * (norm(w) - data.radiusSquared) * 4)

    proc intersection_count*[T, S](c: ExactCircle[T], l: Line[S]): int =
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

    proc intersection_count*[T, S](c: ExactCircle[T], s: Segment[S]): int =
        ## 円周と閉線分の交点数を厳密に返す。退化線分も許す。
        let a = circleExactPoint(s.s)
        let b = circleExactPoint(s.t)
        if a == b: return ord(c.on_circle(s.s))
        let data = circleLineData(c, Line[S](s: s.s, t: s.t))
        if circleSign(data.discriminant.num) < 0: return 0
        for sign in [-1, 1]:
            if sign == 1 and (circleSign(data.discriminant.num) == 0): continue
            if circleRadicalSign(-data.b, sign, data.discriminant) >= 0 and
                    circleRadicalSign(-data.b - data.a * 2, sign, data.discriminant) <= 0:
                inc result

    proc circlePairData[T](a, b: ExactCircle[T]): auto =
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

    proc intersection_count*[T](a, b: ExactCircle[T]): int =
        ## 2円周の交点数を厳密に返す。同一正半径円は-1（無限個）、同一点円は1。
        let data = circlePairData(a, b)
        if (circleSign(data.distanceSquared.num) == 0):
            if a != b: return 0
            return if (circleSign(a.radius_squared_exact.num) == 0): 1 else: -1
        let sign = circleSign(data.heightSquared.num)
        if sign < 0: 0 elif sign == 0: 1 else: 2

    proc tangent_count*[T, S](c: ExactCircle[T], p: Point[S]): int =
        ## 点からの接線数を厳密に返す。点円自身は-1（無限個）、他点からは1。
        let location = c.classify(p)
        if (circleSign(c.radius_squared_exact.num) == 0):
            return if location == circleBoundary: -1 else: 1
        case location
        of circleOutside: 2
        of circleBoundary: 1
        of circleInside: 0

    proc common_tangent_count*[T](a, b: ExactCircle[T]): int =
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
        mixin `$`, `-`
        let s = $(if circleSign(x) < 0: -x else: x)
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

    proc center_approx*[T](c: ExactCircle[T]): Point[float] =
        ## 中心をfloat64で近似する。厳密な中心はcenter_exactで取得する。
        circlePointApprox(circleExactData(c).center)

    proc radius_approx*[T](c: ExactCircle[T]): float =
        ## 半径をfloat64で近似する。平方根を取る前の厳密値はradius_squared_exact。
        circleFractionApprox(circleExactData(c).radiusSquared, true)

    proc toFloatCircle*[T](c: ExactCircle[T]): Circle =
        ## 明示的に既存float円へ近似変換する。変換後の述語は厳密ではない。
        initCircle(c.center_approx, c.radius_approx)

    proc circleOffsetApprox[T](v: Point[CircleExactScalar[T]], squaredFactor: CircleExactScalar[T]): Point[float] =
        ## v * sqrt(squaredFactor)を各成分の平方から近似し、中間float積を避ける。
        initPoint(float(circleSign(v.x.num)) * circleFractionApprox(v.x * v.x * squaredFactor, true),
                  float(circleSign(v.y.num)) * circleFractionApprox(v.y * v.y * squaredFactor, true))

    proc cross_points_approx*[T, S](c: ExactCircle[T], l: Line[S]): CircleIntersections =
        ## 円周と直線の交点を近似出力する。交点数はfloat化前に厳密判定する。
        let data = circleLineData(c, l)
        if circleSign(data.discriminant.num) < 0: return
        let foot = circlePointApprox(data.s - data.v * (data.b / (data.a * 2)))
        if (circleSign(data.discriminant.num) == 0): result.points = @[foot]
        else:
            let offset = circleOffsetApprox(data.v, data.discriminant / (data.a * data.a * 4))
            result.points = @[foot - offset, foot + offset]
        for p in result.points: exactCircleCheckPoint(p)

    proc cross_points_approx*[T](a, b: ExactCircle[T]): CircleIntersections =
        ## 2円周の交点を近似出力する。点円・同一円の分類も厳密に行う。
        let count = intersection_count(a, b)
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

    proc tangent_lines_approx*[T, S](c: ExactCircle[T], p: Point[S]): CircleTangents =
        ## 点から円への接線を近似出力する。接線数はfloat化前に厳密判定する。
        let count = tangent_count(c, p)
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

    proc cross_points_approx*[T, S](c: ExactCircle[T], s: Segment[S]): CircleIntersections =
        ## 円周と閉線分の交点を近似出力する。端点の採否は平方根を取らず厳密判定する。
        if circleExactPoint(s.s) == circleExactPoint(s.t):
            if c.on_circle(s.s): result.points = @[circlePointApprox(circleExactPoint(s.s))]
            return
        let data = circleLineData(c, Line[S](s: s.s, t: s.t))
        if circleSign(data.discriminant.num) < 0: return
        let intersections = cross_points_approx(c, Line[S](s: s.s, t: s.t))
        var index = 0
        for sign in [-1, 1]:
            if sign == 1 and (circleSign(data.discriminant.num) == 0): continue
            if circleRadicalSign(-data.b, sign, data.discriminant) >= 0 and
                    circleRadicalSign(-data.b - data.a * 2, sign, data.discriminant) <= 0:
                result.points.add(intersections.points[index])
            inc index
