when not declared CPLIB_GEOMETRY_EXACT_CIRCLE:
    const CPLIB_GEOMETRY_EXACT_CIRCLE* = 1
    import math, strutils
    import cplib/geometry/base
    import cplib/geometry/circle
    import cplib/math/bigint
    import cplib/math/int128
    import cplib/math/fractions

    proc exactCircleCheckPoint(p: Point[float]) =
        ## 近似出力が有限座標であることを検査する。
        if p.x != p.x or p.y != p.y or abs(p.x) == Inf or abs(p.y) == Inf:
            raise newException(ValueError, "厳密円の近似出力は有限である必要があります")

    proc exactCirclePerpendicular(p: Point[float]): Point[float] =
        ## 近似ベクトルを90度回転する。
        initPoint(-p.y, p.x)

    ## 厳密円の本体は入力3点。全点一致は点円、それ以外の重複・共線入力は拒否する。
    ## 組み込み整数・BigInt・Int128・それらを要素とする有限Fractionに対応する。
    ## 述語は差を取る前に多倍長整数／多倍長分子・分母へ変換し、EPSもfloatも使わない。
    ## 中心＋半径／通過点からの生成座標はBigIntまたはFraction[BigInt]へ拡張する。
    ## 固定幅整数では各操作O(1)。一般の多倍長では乗除算とgcdの桁数に依存する。
    ## *_approxとtoFloatCircleは近似出力であり、丸めや悪条件で座標が一致しうる。
    ## default(ExactCircle[T])は未初期化。構築関数を通さない円の操作はValueError。
    type
        ExactCircle*[T] = object
            definingPoints: array[3, Point[T]]
            initialized: bool
        ExactCircleFraction* = Fraction[BigInt]
        CircleExactScalar = object
            num, den: BigInt
        CirclePointLocation* = enum
            circleOutside, circleBoundary, circleInside

    proc circleRational(numerator, denominator: BigInt): CircleExactScalar =
        ## 有限の分数を多倍長gcdで正規化する。既存Fractionの固定幅演算は呼ばない。
        if denominator.isZero:
            raise newException(ValueError, "厳密円の分母は非零である必要があります")
        let g = gcd(numerator, denominator)
        result = CircleExactScalar(num: numerator div g, den: denominator div g)
        if result.den.sgn < 0:
            result.num = -result.num
            result.den = -result.den

    proc `+`(x, y: CircleExactScalar): CircleExactScalar =
        ## 有限分数の和を多倍長整数だけで求める。
        circleRational(x.num * y.den + y.num * x.den, x.den * y.den)

    proc `-`(x, y: CircleExactScalar): CircleExactScalar =
        ## 有限分数の差を多倍長整数だけで求める。
        circleRational(x.num * y.den - y.num * x.den, x.den * y.den)

    proc `-`(x: CircleExactScalar): CircleExactScalar =
        ## 有限分数の符号を反転する。
        CircleExactScalar(num: -x.num, den: x.den)

    proc `*`(x, y: CircleExactScalar): CircleExactScalar =
        ## 有限分数の積を多倍長整数だけで求める。
        circleRational(x.num * y.num, x.den * y.den)

    proc `*`(x: CircleExactScalar, y: BigInt): CircleExactScalar =
        ## 有限分数の整数倍を多倍長整数だけで求める。
        circleRational(x.num * y, x.den)

    proc `/`(x, y: CircleExactScalar): CircleExactScalar =
        ## 有限分数の商を多倍長整数だけで求める。
        circleRational(x.num * y.den, x.den * y.num)

    proc `==`(x, y: CircleExactScalar): bool =
        ## 正規化済みの有限分数の一致を判定する。
        x.num == y.num and x.den == y.den

    proc `+`(p, q: Point[CircleExactScalar]): Point[CircleExactScalar] =
        ## 厳密座標を加える。要素型の演算はこのモジュールで解決する。
        initPoint(p.x + q.x, p.y + q.y)

    proc `-`(p, q: Point[CircleExactScalar]): Point[CircleExactScalar] =
        ## 厳密座標の差を求める。
        initPoint(p.x - q.x, p.y - q.y)

    proc `*`(p: Point[CircleExactScalar], x: CircleExactScalar): Point[CircleExactScalar] =
        ## 厳密座標を分数倍する。
        initPoint(p.x * x, p.y * x)

    proc dot(p, q: Point[CircleExactScalar]): CircleExactScalar =
        ## 厳密座標の内積を求める。
        p.x * q.x + p.y * q.y

    proc cross(p, q: Point[CircleExactScalar]): CircleExactScalar =
        ## 厳密座標の外積を求める。
        p.x * q.y - p.y * q.x

    proc norm(p: Point[CircleExactScalar]): CircleExactScalar =
        ## 厳密座標のノルム二乗を求める。
        dot(p, p)

    proc `==`(p, q: Point[CircleExactScalar]): bool =
        ## 厳密座標の一致を判定する。
        p.x == q.x and p.y == q.y

    proc `-`(p, q: Point[BigInt]): Point[BigInt] =
        ## 多倍長整数座標の差を求める。
        initPoint(p.x - q.x, p.y - q.y)

    proc cross(p, q: Point[BigInt]): BigInt =
        ## 多倍長整数座標の外積を求める。
        p.x * q.y - p.y * q.x

    proc norm(p: Point[BigInt]): BigInt =
        ## 多倍長整数座標のノルム二乗を求める。
        p.x * p.x + p.y * p.y

    proc `==`(p, q: Point[BigInt]): bool =
        ## 多倍長整数座標の一致を判定する。
        p.x == q.x and p.y == q.y

    proc circleInteger[T: SomeInteger](x: T): BigInt =
        ## 組み込み整数を差・積の計算前に拡張する。
        initBigInt(x)

    proc circleInteger(x: BigInt): BigInt =
        ## 多倍長整数を保持する。
        x

    proc circleInteger(x: Int128): BigInt =
        ## 128bit整数を情報を落とさず拡張する。O(桁数)。
        parseBigInt($x)

    proc circleFraction[T: SomeInteger | BigInt | Int128](x: T): CircleExactScalar =
        ## 整数を厳密な分数に変換する。
        CircleExactScalar(num: circleInteger(x), den: initBigInt(1))

    proc circleFraction[T](x: Fraction[T]): CircleExactScalar =
        ## 有限分数の分子・分母を演算前に拡張し、正規化する。
        let n = circleInteger(x.num)
        let d = circleInteger(x.den)
        if d.isZero:
            raise newException(ValueError, "厳密円の座標は有限である必要があります")
        circleRational(n, d)

    proc circleFraction(x: CircleExactScalar): CircleExactScalar =
        ## 内部の正規化済み分数を保持する。
        x

    proc circleStoredPoint(p: Point[CircleExactScalar]): Point[ExactCircleFraction] =
        ## 内部座標を公開用Fraction[BigInt]へ情報を落とさず変換する。
        initPoint(Fraction[BigInt](num: p.x.num, den: p.x.den), Fraction[BigInt](num: p.y.num, den: p.y.den))

    proc circleExactPoint[T](p: Point[T]): Point[CircleExactScalar] =
        ## 座標を拡張してから点を構築する。
        initPoint(circleFraction(p.x), circleFraction(p.y))

    proc points*[T](c: ExactCircle[T]): array[3, Point[T]] =
        ## 円を定義する元の3点を入力順で返す。
        if not c.initialized:
            raise newException(ValueError, "厳密円は初期化されていません")
        c.definingPoints

    proc initExactCircle*[T](a, b, c: Point[T]): ExactCircle[T] =
        ## 3点を通る円を構築する。全点一致のみ点円として許し、他の共線入力はValueError。
        let p = circleExactPoint(a)
        let q = circleExactPoint(b)
        let r = circleExactPoint(c)
        if cross(q - p, r - p).num.isZero and not (p == q and p == r):
            raise newException(ValueError, "円の3点は非共線または全点一致である必要があります")
        ExactCircle[T](definingPoints: [a, b, c], initialized: true)

    proc initExactCircle*[T; R: SomeInteger | BigInt | Int128](center: Point[T], radius: R): auto =
        ## 中心と非負整数半径から軸方向の3点を生成する。生成前に座標型を拡張する。
        let p = circleExactPoint(center)
        let r = circleFraction(radius)
        if r.num.sgn < 0:
            raise newException(ValueError, "円の半径は非負である必要があります")
        when T is Fraction:
            initExactCircle(circleStoredPoint(initPoint(p.x + r, p.y)), circleStoredPoint(initPoint(p.x, p.y + r)), circleStoredPoint(initPoint(p.x - r, p.y)))
        else:
            initExactCircle(initPoint(p.x.num + r.num, p.y.num),
                            initPoint(p.x.num, p.y.num + r.num),
                            initPoint(p.x.num - r.num, p.y.num))

    proc initExactCircle*[T, S](center: Point[T], through: Point[S]): auto =
        ## 中心と通過点から0・90・180度回転した3点を生成する。一致時は点円。
        let p = circleExactPoint(center)
        let q = circleExactPoint(through)
        let v = q - p
        let b = p + initPoint(-v.y, v.x)
        let c = p - v
        when T is Fraction or S is Fraction:
            initExactCircle(circleStoredPoint(q), circleStoredPoint(b), circleStoredPoint(c))
        else:
            initExactCircle(initPoint(q.x.num, q.y.num), initPoint(b.x.num, b.y.num), initPoint(c.x.num, c.y.num))

    proc circleExactData[T](c: ExactCircle[T]): tuple[center: Point[CircleExactScalar], radiusSquared: CircleExactScalar] =
        ## 3点から厳密な中心と半径の二乗を求める。
        let points = c.points
        let a = circleExactPoint(points[0])
        let b = circleExactPoint(points[1])
        let d = circleExactPoint(points[2])
        if a == b and a == d:
            return (a, circleFraction(0))
        let u = b - a
        let v = d - a
        let determinant = cross(u, v) * initBigInt(2)
        let offset = initPoint((v.y * norm(u) - u.y * norm(v)) / determinant,
                               (u.x * norm(v) - v.x * norm(u)) / determinant)
        (a + offset, norm(offset))

    proc center_exact*[T](c: ExactCircle[T]): Point[ExactCircleFraction] =
        ## 有理数の中心を厳密に返す。
        circleStoredPoint(circleExactData(c).center)

    proc radius_squared_exact*[T](c: ExactCircle[T]): ExactCircleFraction =
        ## 有理数の半径二乗を厳密に返す。半径自体は無理数となりうる。
        let r = circleExactData(c).radiusSquared
        Fraction[BigInt](num: r.num, den: r.den)

    proc classify*[T, S](c: ExactCircle[T], p: Point[S]): CirclePointLocation =
        ## 円盤の外・境界・内部を厳密に分類する。点円には内部点がない。
        when (T is SomeInteger or T is BigInt or T is Int128) and
                (S is SomeInteger or S is BigInt or S is Int128):
            let points = c.points
            var defining: array[3, Point[BigInt]]
            for i in 0..<3:
                defining[i] = initPoint(circleInteger(points[i].x), circleInteger(points[i].y))
            let query = initPoint(circleInteger(p.x), circleInteger(p.y))
            if defining[0] == defining[1] and defining[0] == defining[2]:
                return if query == defining[0]: circleBoundary else: circleOutside
            let orientation = cross(defining[1] - defining[0], defining[2] - defining[0]).sgn
            let a = defining[0] - query
            let b = defining[1] - query
            let d = defining[2] - query
            let sign = (norm(a) * cross(b, d) - norm(b) * cross(a, d) + norm(d) * cross(a, b)).sgn * orientation
            if sign < 0: circleOutside
            elif sign > 0: circleInside
            else: circleBoundary
        else:
            let data = circleExactData(c)
            let difference = norm(circleExactPoint(p) - data.center) - data.radiusSquared
            if difference.num.sgn > 0: circleOutside
            elif difference.num.sgn < 0: circleInside
            else: circleBoundary

    proc contains*[T, S](c: ExactCircle[T], p: Point[S]): bool =
        ## 境界を含む円盤の点包含を厳密に判定する。
        c.classify(p) != circleOutside

    proc on_circle*[T, S](c: ExactCircle[T], p: Point[S]): bool =
        ## 円周上かを厳密に判定する。
        c.classify(p) == circleBoundary

    proc `==`*[T, S](a: ExactCircle[T], b: ExactCircle[S]): bool =
        ## 点の順序や座標型によらず同じ円かを厳密に判定する。
        let x = circleExactData(a)
        let y = circleExactData(b)
        x.center == y.center and x.radiusSquared == y.radiusSquared

    proc circleLineData[T, S](c: ExactCircle[T], l: Line[S]): tuple[s, v: Point[CircleExactScalar], a, b, discriminant: CircleExactScalar] =
        ## 直線パラメータの二次方程式を厳密に求める。退化直線はValueError。
        let data = circleExactData(c)
        result.s = circleExactPoint(l.s)
        result.v = circleExactPoint(l.t) - result.s
        result.a = norm(result.v)
        if result.a.num.isZero:
            raise newException(ValueError, "直線は非退化である必要があります")
        let w = result.s - data.center
        result.b = dot(w, result.v) * initBigInt(2)
        result.discriminant = result.b * result.b - result.a * (norm(w) - data.radiusSquared) * initBigInt(4)

    proc intersection_count*[T, S](c: ExactCircle[T], l: Line[S]): int =
        ## 円周と直線の交点数0〜2を厳密に返す。
        let sign = circleLineData(c, l).discriminant.num.sgn
        if sign < 0: 0 elif sign == 0: 1 else: 2

    proc circleRadicalSign(x: CircleExactScalar, sign: int, radicand: CircleExactScalar): int =
        ## x + sign * sqrt(radicand)の符号を平方の厳密比較で返す。
        let xs = x.num.sgn
        if radicand.num.isZero: return xs
        if xs == 0 or xs == sign: return sign
        let comparison = (x * x - radicand).num.sgn
        if comparison == 0: 0 elif comparison > 0: xs else: sign

    proc intersection_count*[T, S](c: ExactCircle[T], s: Segment[S]): int =
        ## 円周と閉線分の交点数を厳密に返す。退化線分も許す。
        let a = circleExactPoint(s.s)
        let b = circleExactPoint(s.t)
        if a == b: return ord(c.on_circle(s.s))
        let data = circleLineData(c, Line[S](s: s.s, t: s.t))
        if data.discriminant.num.sgn < 0: return 0
        for sign in [-1, 1]:
            if sign == 1 and data.discriminant.num.isZero: continue
            if circleRadicalSign(-data.b, sign, data.discriminant) >= 0 and
                    circleRadicalSign(-data.b - data.a * initBigInt(2), sign, data.discriminant) <= 0:
                inc result

    proc circlePairData[T, S](a: ExactCircle[T], b: ExactCircle[S]): tuple[center, v: Point[CircleExactScalar], distanceSquared, factor, heightSquared: CircleExactScalar] =
        ## 2円の共通弦の中点と高さ二乗を厳密に求める。
        let x = circleExactData(a)
        let y = circleExactData(b)
        result.center = x.center
        result.v = y.center - x.center
        result.distanceSquared = norm(result.v)
        if result.distanceSquared.num.isZero: return
        result.factor = (result.distanceSquared + x.radiusSquared - y.radiusSquared) / (result.distanceSquared * initBigInt(2))
        result.heightSquared = x.radiusSquared - result.distanceSquared * result.factor * result.factor

    proc intersection_count*[T, S](a: ExactCircle[T], b: ExactCircle[S]): int =
        ## 2円周の交点数を厳密に返す。同一正半径円は-1（無限個）、同一点円は1。
        let data = circlePairData(a, b)
        if data.distanceSquared.num.isZero:
            if a != b: return 0
            return if a.radius_squared_exact.num.isZero: 1 else: -1
        let sign = data.heightSquared.num.sgn
        if sign < 0: 0 elif sign == 0: 1 else: 2

    proc tangent_count*[T, S](c: ExactCircle[T], p: Point[S]): int =
        ## 点からの接線数を厳密に返す。点円自身は-1（無限個）、他点からは1。
        let location = c.classify(p)
        if c.radius_squared_exact.num.isZero:
            return if location == circleBoundary: -1 else: 1
        case location
        of circleOutside: 2
        of circleBoundary: 1
        of circleInside: 0

    proc common_tangent_count*[T, S](a: ExactCircle[T], b: ExactCircle[S]): int =
        ## 共通接線数0〜4を厳密に返す。同一円は-1（無限個）。点円も扱う。
        let x = circleExactData(a)
        let y = circleExactData(b)
        let d = norm(y.center - x.center)
        if d.num.isZero: return if a == b: -1 else: 0
        if x.radiusSquared.num.isZero and y.radiusSquared.num.isZero: return 1
        if x.radiusSquared.num.isZero or y.radiusSquared.num.isZero:
            let sign = (d - x.radiusSquared - y.radiusSquared).num.sgn
            return if sign < 0: 0 elif sign == 0: 1 else: 2
        let difference = d - x.radiusSquared - y.radiusSquared
        let comparison = (difference * difference - x.radiusSquared * y.radiusSquared * initBigInt(4)).num.sgn
        if comparison < 0: 2
        elif comparison == 0: (if difference.num.sgn > 0: 3 else: 1)
        else: (if difference.num.sgn > 0: 4 else: 0)

    proc circleDecimalHead(x: BigInt): tuple[value: float, exponent: int] =
        ## 多倍長整数の先頭17桁と10進指数を近似出力のために求める。O(桁数)。
        let s = $abs(x)
        let length = min(s.len, 17)
        (parseFloat(s[0..<length]) / pow(10.0, float(length - 1)), s.len - 1)

    proc circleFractionApprox(x: CircleExactScalar, squareRoot = false): float =
        ## 分子・分母を別々にfloat化せず、指数を合わせて近似する。範囲外はValueError。
        if x.num.isZero: return 0
        let n = circleDecimalHead(x.num)
        let d = circleDecimalHead(x.den)
        var exponent = n.exponent - d.exponent
        var mantissa = n.value / d.value
        if squareRoot:
            if x.num.sgn < 0: raise newException(ValueError, "負数の平方根は取得できません")
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
        result *= float(x.num.sgn)
        if result != result or abs(result) == Inf or result == 0:
            raise newException(ValueError, "厳密円の近似出力は非零の有限float64で表現できません")

    proc circlePointApprox(p: Point[CircleExactScalar]): Point[float] =
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

    proc circleOffsetApprox(v: Point[CircleExactScalar], squaredFactor: CircleExactScalar): Point[float] =
        ## v * sqrt(squaredFactor)を各成分の平方から近似し、中間float積を避ける。
        initPoint(float(v.x.num.sgn) * circleFractionApprox(v.x * v.x * squaredFactor, true),
                  float(v.y.num.sgn) * circleFractionApprox(v.y * v.y * squaredFactor, true))

    proc cross_points_approx*[T, S](c: ExactCircle[T], l: Line[S]): CircleIntersections =
        ## 円周と直線の交点を近似出力する。交点数はfloat化前に厳密判定する。
        let data = circleLineData(c, l)
        if data.discriminant.num.sgn < 0: return
        let foot = circlePointApprox(data.s - data.v * (data.b / (data.a * initBigInt(2))))
        if data.discriminant.num.isZero: result.points = @[foot]
        else:
            let offset = circleOffsetApprox(data.v, data.discriminant / (data.a * data.a * initBigInt(4)))
            result.points = @[foot - offset, foot + offset]
        for p in result.points: exactCircleCheckPoint(p)

    proc cross_points_approx*[T, S](a: ExactCircle[T], b: ExactCircle[S]): CircleIntersections =
        ## 2円周の交点を近似出力する。点円・同一円の分類も厳密に行う。
        let count = intersection_count(a, b)
        if count == -1:
            result.kind = circleInfinite
            return
        if count == 0: return
        let data = circlePairData(a, b)
        if data.distanceSquared.num.isZero:
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
        let q = circleExactPoint(p)
        let v = q - data.center
        let dsq = norm(v)
        if data.radiusSquared.num.isZero:
            result.tangents = @[CircleTangent(first: circlePointApprox(data.center), second: circlePointApprox(q),
                direction: circleOffsetApprox(v, circleFraction(1) / dsq))]
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
        if data.discriminant.num.sgn < 0: return
        let intersections = cross_points_approx(c, Line[S](s: s.s, t: s.t))
        var index = 0
        for sign in [-1, 1]:
            if sign == 1 and data.discriminant.num.isZero: continue
            if circleRadicalSign(-data.b, sign, data.discriminant) >= 0 and
                    circleRadicalSign(-data.b - data.a * initBigInt(2), sign, data.discriminant) <= 0:
                result.points.add(intersections.points[index])
            inc index
