when not declared CPLIB_FPS_BIVARIATE_FORMAL_POWER_SERIES:
    const CPLIB_FPS_BIVARIATE_FORMAL_POWER_SERIES* = 1

    import math, options
    import cplib/convolution/convolution
    import cplib/fps/formal_power_series
    import cplib/math/isprime
    import cplib/modint/modint

    type BivariateFPS*[T] = seq[seq[T]]
        ## f[i][j] に x^i y^j の係数を格納する。省略された係数は零とする。

    proc initBivariateFPS*[T](n, m: int): seq[seq[T]] =
        ## n行m列の零FPSを作る。片方が非正なら空列を返す。O(nm)。
        if n <= 0 or m <= 0: return @[]
        result = newSeq[seq[T]](n)
        for row in result.mitems: row = newSeq[T](m)

    proc shape*[T](f: seq[seq[T]]): tuple[n, m: int] =
        ## 行数と最大の列数を返す。各行の長さは異なっていてもよい。O(n)。
        result.n = f.len
        for row in f: result.m = max(result.m, row.len)

    proc coefficient*[T: BarrettModint or MontgomeryModint](
            f: seq[seq[T]], i, j: int): T =
        ## x^i y^j の係数を返す。範囲外なら零を返す。O(1)。
        if i < 0 or i >= f.len or j < 0 or j >= f[i].len: return init(T, 0)
        result = f[i][j]

    proc prefix*[T](f: seq[seq[T]], n, m: int): seq[seq[T]] =
        ## x^nとy^mで打ち切り、零を補ってn行m列にする。O(nm)。
        result = initBivariateFPS[T](n, m)
        for i in 0..<result.len:
            if i >= f.len: break
            for j in 0..<min(f[i].len, m): result[i][j] = f[i][j]

    proc transpose*[T](f: seq[seq[T]]): seq[seq[T]] =
        ## xとyを交換し、零を補った長方形の係数列を返す。O(nm)。
        let (n, m) = f.shape
        result = initBivariateFPS[T](m, n)
        for i in 0..<n:
            for j in 0..<f[i].len: result[j][i] = f[i][j]

    proc `+`*[T: BarrettModint or MontgomeryModint](
            f, g: seq[seq[T]]): seq[seq[T]] =
        ## 係数ごとの和を求める。O(nm)。
        let a = f.shape
        let b = g.shape
        result = f.prefix(max(a.n, b.n), max(a.m, b.m))
        for i in 0..<g.len:
            for j in 0..<g[i].len: result[i][j] += g[i][j]

    proc `-`*[T: BarrettModint or MontgomeryModint](
            f, g: seq[seq[T]]): seq[seq[T]] =
        ## 係数ごとの差を求める。O(nm)。
        let a = f.shape
        let b = g.shape
        result = f.prefix(max(a.n, b.n), max(a.m, b.m))
        for i in 0..<g.len:
            for j in 0..<g[i].len: result[i][j] -= g[i][j]

    proc `-`*[T: BarrettModint or MontgomeryModint](
            f: seq[seq[T]]): seq[seq[T]] =
        ## 各係数の符号を反転する。O(nm)。
        let (n, m) = f.shape
        result = initBivariateFPS[T](n, m)
        for i in 0..<f.len:
            for j in 0..<f[i].len: result[i][j] = -f[i][j]

    proc `*`*[T: BarrettModint or MontgomeryModint](
            f: seq[seq[T]], c: T): seq[seq[T]] =
        ## 各係数をc倍する。O(nm)。
        let (n, m) = f.shape
        result = initBivariateFPS[T](n, m)
        for i in 0..<f.len:
            for j in 0..<f[i].len: result[i][j] = f[i][j] * c

    proc `*`*[T: BarrettModint or MontgomeryModint](
            c: T, f: seq[seq[T]]): seq[seq[T]] =
        ## 各係数をc倍する。O(nm)。
        f * c

    proc `/`*[T: BarrettModint or MontgomeryModint](
            f: seq[seq[T]], c: T): seq[seq[T]] =
        ## 各係数を可逆なcで割る。O(nm + log mod)。
        assert gcd(c.val, T.umod.int) == 1, "除数は法と互いに素である必要がある"
        f * c.inv

    proc mulPrefix*[T: BarrettModint or MontgomeryModint](
            f, g: seq[seq[T]], n, m: int): seq[seq[T]] =
        ## 積を(x^n, y^m)で打ち切る。O(nm log(nm))時間、O(nm)空間。
        result = initBivariateFPS[T](n, m)
        if result.len == 0: return
        let fn = min(f.len, n)
        let gn = min(g.len, n)
        var fm, gm: int
        for i in 0..<fn: fm = max(fm, min(f[i].len, m))
        for i in 0..<gn: gm = max(gm, min(g[i].len, m))
        if fm == 0 or gm == 0: return
        # yの次数が隣のx係数へ繰り上がらない間隔で平坦化する。
        let stride = fm + gm - 1
        var a = newSeq[T]((fn - 1) * stride + fm)
        var b = newSeq[T]((gn - 1) * stride + gm)
        for i in 0..<fn:
            for j in 0..<min(f[i].len, m): a[i * stride + j] = f[i][j]
        for i in 0..<gn:
            for j in 0..<min(g[i].len, m): b[i * stride + j] = g[i][j]
        let product = convolution(a, b)
        for i in 0..<min(n, fn + gn - 1):
            for j in 0..<min(m, stride): result[i][j] = product[i * stride + j]

    proc `*`*[T: BarrettModint or MontgomeryModint](
            f, g: seq[seq[T]]): seq[seq[T]] =
        ## 打ち切らずに多項式の積を求める。出力がn行m列ならO(nm log(nm))。
        let a = f.shape
        let b = g.shape
        if a.n == 0 or a.m == 0 or b.n == 0 or b.m == 0: return @[]
        f.mulPrefix(g, a.n + b.n - 1, a.m + b.m - 1)

    proc derivativeX*[T: BarrettModint or MontgomeryModint](
            f: seq[seq[T]]): seq[seq[T]] =
        ## xで偏微分する。O(nm)。
        let (n, m) = f.shape
        result = initBivariateFPS[T](n - 1, m)
        for i in 1..<n:
            for j in 0..<f[i].len: result[i - 1][j] = f[i][j] * i

    proc derivativeY*[T: BarrettModint or MontgomeryModint](
            f: seq[seq[T]]): seq[seq[T]] =
        ## yで偏微分する。O(nm)。
        let (n, m) = f.shape
        result = initBivariateFPS[T](n, m - 1)
        for i in 0..<n:
            for j in 1..<f[i].len: result[i][j - 1] = f[i][j] * j

    proc bivariateIndexInverses[T: BarrettModint or MontgomeryModint](n: int): seq[T] =
        ## 素数法で1以上n未満の逆数表をO(n)で作る。
        assert isprime(T.umod.int), "二変数FPSの積分・log・expの法は素数である必要がある"
        assert n <= T.umod.int, "除数となる次数は法未満である必要がある"
        result = newSeq[T](n)
        if n > 1: result[1] = init(T, 1)
        for i in 2..<n: result[i] = -result[T.umod.int mod i] * (T.umod.int div i)

    proc integralX*[T: BarrettModint or MontgomeryModint](
            f: seq[seq[T]]): seq[seq[T]] =
        ## xで積分し、x^0の行を零にする。素数法かつn < modが必要。O(nm)。
        let (n, m) = f.shape
        if n == 0 or m == 0: return @[]
        let inverses = bivariateIndexInverses[T](n + 1)
        result = initBivariateFPS[T](n + 1, m)
        for i in 0..<n:
            for j in 0..<f[i].len: result[i + 1][j] = f[i][j] * inverses[i + 1]

    proc integralY*[T: BarrettModint or MontgomeryModint](
            f: seq[seq[T]]): seq[seq[T]] =
        ## yで積分し、y^0の列を零にする。素数法かつm < modが必要。O(nm)。
        let (n, m) = f.shape
        if n == 0 or m == 0: return @[]
        let inverses = bivariateIndexInverses[T](m + 1)
        result = initBivariateFPS[T](n, m + 1)
        for i in 0..<n:
            for j in 0..<f[i].len: result[i][j + 1] = f[i][j] * inverses[j + 1]

    proc eval*[T: BarrettModint or MontgomeryModint](f: seq[seq[T]], x, y: T): T =
        ## 二重のHorner法でf(x, y)を評価する。O(nm)。
        result = init(T, 0)
        for i in countdown(f.high, 0): result = result * x + f[i].eval(y)

    proc inv*[T: BarrettModint or MontgomeryModint](
            f: seq[seq[T]], n, m: int): seq[seq[T]] =
        ## (x^n, y^m)を法とした乗法逆元をNewton法で求める。O(nm log(nm))。
        if n <= 0 or m <= 0: return @[]
        assert f.coefficient(0, 0).val != 0 and gcd(f.coefficient(0, 0).val, T.umod.int) == 1,
            "二変数FPSの逆元には法と互いに素な定数項が必要"
        result = @[f[0].inv(m)]
        while result.len < n:
            let next = min(result.len * 2, n)
            var error = -f.mulPrefix(result, next, m)
            error[0][0] += 2
            result = result.mulPrefix(error, next, m)

    proc inv*[T: BarrettModint or MontgomeryModint](f: seq[seq[T]]): seq[seq[T]] =
        ## 入力の行数・最大列数まで乗法逆元を求める。
        let (n, m) = f.shape
        f.inv(n, m)

    proc divPrefix*[T: BarrettModint or MontgomeryModint](
            f, g: seq[seq[T]], n, m: int): seq[seq[T]] =
        ## f/gを(x^n, y^m)で打ち切る。O(nm log(nm))。
        f.mulPrefix(g.inv(n, m), n, m)

    proc `/`*[T: BarrettModint or MontgomeryModint](
            f, g: seq[seq[T]]): seq[seq[T]] =
        ## 各軸について両入力の大きい方までf/gを求める。
        let a = f.shape
        let b = g.shape
        f.divPrefix(g, max(a.n, b.n), max(a.m, b.m))

    proc log*[T: BarrettModint or MontgomeryModint](
            f: seq[seq[T]], n, m: int): seq[seq[T]] =
        ## 形式的対数を(x^n, y^m)で打ち切る。定数項1。O(nm log(nm))。
        if n <= 0 or m <= 0: return @[]
        assert f.coefficient(0, 0).val == 1, "二変数FPSのlogでは定数項が1である必要がある"
        let inverses = bivariateIndexInverses[T](max(n, m))
        result = initBivariateFPS[T](n, m)
        result[0] = f[0].log(m)
        if n == 1: return
        let df = f.prefix(n, m).derivativeX
        let quotient = df.mulPrefix(f.inv(n - 1, m), n - 1, m)
        for i in 1..<n:
            for j in 0..<m: result[i][j] = quotient[i - 1][j] * inverses[i]

    proc log*[T: BarrettModint or MontgomeryModint](f: seq[seq[T]]): seq[seq[T]] =
        ## 入力の行数・最大列数まで形式的対数を求める。
        let (n, m) = f.shape
        f.log(n, m)

    proc exp*[T: BarrettModint or MontgomeryModint](
            f: seq[seq[T]], n, m: int): seq[seq[T]] =
        ## 形式的指数関数を(x^n, y^m)で打ち切る。定数項0。O(nm log(nm))。
        if n <= 0 or m <= 0: return @[]
        assert f.coefficient(0, 0).val == 0, "二変数FPSのexpでは定数項が0である必要がある"
        assert isprime(T.umod.int) and max(n, m) <= T.umod.int,
            "二変数FPSのexpでは法が素数かつn, mが法以下である必要がある"
        let row = if f.len > 0: f[0] else: newSeq[T]()
        result = @[row.exp(m)]
        while result.len < n:
            let next = min(result.len * 2, n)
            var error = f.prefix(next, m) - result.log(next, m)
            error[0][0] += 1
            result = result.mulPrefix(error, next, m)

    proc exp*[T: BarrettModint or MontgomeryModint](f: seq[seq[T]]): seq[seq[T]] =
        ## 入力の行数・最大列数まで形式的指数関数を求める。
        let (n, m) = f.shape
        f.exp(n, m)

    proc pow*[T: BarrettModint or MontgomeryModint](
            f: seq[seq[T]], k, n, m: int): seq[seq[T]] =
        ## 非負整数冪を(x^n, y^m)で打ち切る。一般にはO(nm log(nm) log(k+1))。
        assert k >= 0, "二変数FPSの整数冪では指数が非負である必要がある"
        result = initBivariateFPS[T](n, m)
        if result.len == 0: return
        result[0][0] = init(T, 1)
        if k == 0: return
        if k == 1: return f.prefix(n, m)
        let constant = f.coefficient(0, 0)
        if constant.val != 0 and isprime(T.umod.int) and max(n, m) <= T.umod.int:
            return ((f.prefix(n, m) / constant).log(n, m) * init(T, k)).exp(n, m) * constant.pow(k)
        var base = f.prefix(n, m)
        var exponent = k
        while exponent > 0:
            if (exponent and 1) != 0: result = result.mulPrefix(base, n, m)
            exponent = exponent shr 1
            if exponent > 0: base = base.mulPrefix(base, n, m)

    proc pow*[T: BarrettModint or MontgomeryModint](f: seq[seq[T]], k: int): seq[seq[T]] =
        ## 入力の行数・最大列数まで非負整数冪を求める。
        let (n, m) = f.shape
        f.pow(k, n, m)

    proc sqrtUnit*[T: BarrettModint or MontgomeryModint](
            f: seq[seq[T]], n, m: int): Option[seq[seq[T]]] =
        ## 非零定数項を持つFPSの平方根を求める。奇素数法。O(nm log(nm))。
        if n <= 0 or m <= 0: return some(newSeq[seq[T]]())
        assert T.umod > 2 and isprime(T.umod.int), "二変数FPSの平方根の法は奇素数である必要がある"
        assert f.coefficient(0, 0).val != 0, "sqrtUnitには非零の定数項が必要"
        let rowRoot = f[0].sqrt(m)
        if rowRoot.isNone: return none(seq[seq[T]])
        var root = @[rowRoot.get]
        let half = init(T, 2).inv
        while root.len < n:
            let next = min(root.len * 2, n)
            let sum = root + f.divPrefix(root, next, m)
            root = sum * half
        some(root)

    proc sqrtUnit*[T: BarrettModint or MontgomeryModint](
            f: seq[seq[T]]): Option[seq[seq[T]]] =
        ## 入力の行数・最大列数まで、非零定数項を持つFPSの平方根を求める。
        let (n, m) = f.shape
        f.sqrtUnit(n, m)
