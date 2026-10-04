when not declared CPLIB_GEOMETRY_TRIANGLE_CENTERS:
    const CPLIB_GEOMETRY_TRIANGLE_CENTERS* = 1
    import math, options
    import cplib/geometry/base

    ## 三頂点の五心を float64 の点として求める。各操作は時間・追加領域 O(1)。
    ## 整数・float32 も演算前に float64 へ変換する（2^53 超の整数は丸めを伴う）。
    ## 有限座標を要求し、重心以外は変換後の全辺の座標差も有限である必要がある。
    ## 不正な座標・座標差・tolerance は ValueError。GEOMETRY_EPS は使用しない。
    ## 最長辺 L と二倍の符号付き面積 D に対し |D| <= tolerance * L^2 を退化とする。
    ## この判定は正規化して行う近似判定で、厳密な述語や正しい丸めは保証しない。
    ## 重心は退化でも定義する。他の中心は退化・計算途中や結果が非有限なら none。
    ## 傍心の微小分母が丸め・underflow で非正になった場合も excenters 全体が none。
    ## 極端な辺長比では正規化時の微小差が消えることもある。悪条件入力は精度低下する。

    const TRIANGLE_CENTERS_TOLERANCE* = 1e-12

    type TriangleCenterFrame = object
        origin, u, v: Point[float64]
        scale, determinant, longestSquared: float64
        indices: array[3, int]

    proc triangleCenterFinite(x: float64): bool =
        ## 有限の float64 かを判定する。
        x == x and abs(x) != Inf

    proc triangleCenterPoint[T: SomeInteger or SomeFloat](p: Point[T]): Point[float64] =
        ## 座標を変換し、非有限入力を拒否する。
        result = initPoint(float64(p.x), float64(p.y))
        if not triangleCenterFinite(result.x) or not triangleCenterFinite(result.y):
            raise newException(ValueError, "三角形の座標は有限である必要があります")

    proc triangleCenterFrame[T: SomeInteger or SomeFloat](a, b, c: Point[T],
            tolerance: float64): TriangleCenterFrame =
        ## 頂点順に依存しない原点と尺度で正規化する。O(1)。
        if not triangleCenterFinite(tolerance) or tolerance < 0.0 or tolerance > 1.0:
            raise newException(ValueError, "tolerance は有限の 0 以上 1 以下である必要があります")
        var points = [triangleCenterPoint(a), triangleCenterPoint(b),
                triangleCenterPoint(c)]
        result.indices = [0, 1, 2]
        for i in 1..2:
            var j = i
            while j > 0 and (points[j].x < points[j-1].x or
                    (points[j].x == points[j-1].x and points[j].y < points[j-1].y)):
                swap(points[j], points[j-1])
                swap(result.indices[j], result.indices[j-1])
                dec j
        result.origin = points[0]
        let u = points[1] - points[0]
        let v = points[2] - points[0]
        let w = points[2] - points[1]
        for p in [u, v, w]:
            if not triangleCenterFinite(p.x) or not triangleCenterFinite(p.y):
                raise newException(ValueError, "三角形の辺の座標差は有限である必要があります")
            result.scale = max(result.scale, max(abs(p.x), abs(p.y)))
        if result.scale == 0.0: return
        result.u = u / result.scale
        result.v = v / result.scale
        let normalizedW = w / result.scale
        result.determinant = cross(result.u, result.v)
        result.longestSquared = max(norm(result.u), max(norm(result.v), norm(normalizedW)))

    proc triangleCenterDegenerate(f: TriangleCenterFrame,
            tolerance: float64): bool =
        ## 最長辺に対する相対面積で退化を判定する。
        abs(f.determinant) <= tolerance * f.longestSquared

    proc is_degenerate_triangle*[T: SomeInteger or SomeFloat](a, b, c: Point[T],
            tolerance: float64 = TRIANGLE_CENTERS_TOLERANCE): bool =
        ## 重複・共線・指定相対面積以下の三角形を退化と判定する。O(1)。
        triangleCenterDegenerate(triangleCenterFrame(a, b, c, tolerance), tolerance)

    proc triangleCenterMean(a, b, c: float64): float64 =
        ## 和のオーバーフローを避けて三座標の平均を求める。
        let scale = max(abs(a), max(abs(b), abs(c)))
        if scale == 0.0: return 0.0
        # 丸めで最大有限値を超えないよう、正規化後の平均を凸包内に収める。
        let average = (a / scale + b / scale + c / scale) / 3.0
        min(1.0, max(-1.0, average)) * scale

    proc centroid*[T: SomeInteger or SomeFloat](a, b, c: Point[T]): Point[float64] =
        ## 重心を返す。重複・共線も許す。有限座標に対して常に定義される。O(1)。
        let p = triangleCenterPoint(a)
        let q = triangleCenterPoint(b)
        let r = triangleCenterPoint(c)
        initPoint(triangleCenterMean(p.x, q.x, r.x), triangleCenterMean(p.y,
                q.y, r.y))

    proc triangleCenterRestore(f: TriangleCenterFrame, p: Point[
            float64]): Option[Point[float64]] =
        ## 元の座標系に戻し、非有限の結果を none にする。
        let q = initPoint(f.origin.x + p.x * f.scale, f.origin.y + p.y * f.scale)
        if triangleCenterFinite(q.x) and triangleCenterFinite(q.y): return some(q)
        none(Point[float64])

    proc triangleCenterCircum(f: TriangleCenterFrame): Point[float64] =
        ## 正規化された二辺の垂直二等分線の連立方程式を解く。
        ## 原点から等距離の条件 2 dot(O,u)=|u|^2, 2 dot(O,v)=|v|^2 を用いる。
        let uu = norm(f.u)
        let vv = norm(f.v)
        initPoint((uu * f.v.y - vv * f.u.y) / (2.0 * f.determinant),
                  (f.u.x * vv - f.v.x * uu) / (2.0 * f.determinant))

    proc circumcenter*[T: SomeInteger or SomeFloat](a, b, c: Point[T],
            tolerance: float64 = TRIANGLE_CENTERS_TOLERANCE): Option[Point[float64]] =
        ## 外心。退化または非有限の結果なら none。O(1)。
        let f = triangleCenterFrame(a, b, c, tolerance)
        if triangleCenterDegenerate(f, tolerance): return none(Point[float64])
        triangleCenterRestore(f, triangleCenterCircum(f))

    proc orthocenter*[T: SomeInteger or SomeFloat](a, b, c: Point[T],
            tolerance: float64 = TRIANGLE_CENTERS_TOLERANCE): Option[Point[float64]] =
        ## 垂心。局所座標で H = A+B+C-2O を使い、退化・非有限なら none。O(1)。
        let f = triangleCenterFrame(a, b, c, tolerance)
        if triangleCenterDegenerate(f, tolerance): return none(Point[float64])
        triangleCenterRestore(f, f.u + f.v - triangleCenterCircum(f) * 2.0)

    proc incenter*[T: SomeInteger or SomeFloat](a, b, c: Point[T],
            tolerance: float64 = TRIANGLE_CENTERS_TOLERANCE): Option[Point[float64]] =
        ## 内心。対辺長の重み付き平均を使い、退化・非有限なら none。O(1)。
        let f = triangleCenterFrame(a, b, c, tolerance)
        if triangleCenterDegenerate(f, tolerance): return none(Point[float64])
        let oppositeA = hypot(f.v.x-f.u.x, f.v.y-f.u.y)
        let oppositeB = hypot(f.v.x, f.v.y)
        let oppositeC = hypot(f.u.x, f.u.y)
        triangleCenterRestore(f, (f.u * oppositeB + f.v * oppositeC) / (
                oppositeA + oppositeB + oppositeC))

    proc triangleCenterExcess(p, q: Point[float64], pLength, qLength,
            determinant, perimeter: float64): float64 =
        ## 二辺長の和から対辺長を引いた量を、鈍角での桁落ちを避けて求める。
        ## (b+c-a)(a+b+c)=2(bc+dot(p,q))、かつ (bc+d)(bc-d)=cross(p,q)^2。
        let product = pLength * qLength
        let d = dot(p, q)
        let sum = if d < 0.0: determinant * determinant / (
                product-d) else: product+d
        2.0 * sum / perimeter

    proc excenters*[T: SomeInteger or SomeFloat](a, b, c: Point[T],
            tolerance: float64 = TRIANGLE_CENTERS_TOLERANCE): Option[array[3,
                    Point[float64]]] =
        ## a,b,c の対辺側の三傍心をこの順で返す。退化・表現不能なら全体が none。O(1)。
        ## 対辺長の符号付き重み (-a,b,c) 等を使う。各傍心の対頂点を基準に計算する。
        let f = triangleCenterFrame(a, b, c, tolerance)
        if triangleCenterDegenerate(f, tolerance): return none(array[3, Point[float64]])
        let w = f.v - f.u
        let lengths = [hypot(w.x, w.y), hypot(f.v.x, f.v.y), hypot(f.u.x, f.u.y)]
        let perimeter = lengths[0] + lengths[1] + lengths[2]
        let denominators = [
            triangleCenterExcess(f.u, f.v, lengths[2], lengths[1],
                    f.determinant, perimeter),
            triangleCenterExcess(-f.u, w, lengths[2], lengths[0], f.determinant,
                    perimeter),
            triangleCenterExcess(-f.v, -w, lengths[1], lengths[0],
                    f.determinant, perimeter)]
        let vertices = [initPoint(0.0, 0.0), f.u, f.v]
        let numerators = [f.u * lengths[1] + f.v * lengths[2],
            -f.u * lengths[0] + w * lengths[2],
            -f.v * lengths[0] - w * lengths[1]]
        var centers: array[3, Point[float64]]
        for i in 0..2:
            if denominators[i] <= 0.0: return none(array[3, Point[float64]])
            let p = triangleCenterRestore(f, vertices[i] + numerators[i] /
                    denominators[i])
            if p.isNone: return none(array[3, Point[float64]])
            centers[f.indices[i]] = p.get
        some(centers)
