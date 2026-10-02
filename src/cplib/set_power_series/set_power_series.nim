when not declared CPLIB_SET_POWER_SERIES_SET_POWER_SERIES:
    const CPLIB_SET_POWER_SERIES_SET_POWER_SERIES* = 1
    import bitops
    import cplib/convolution/subset_convolution
    import cplib/modint/modint
    import cplib/math/isprime

    proc setVariableCount(size: int): int =
        ## 正の2冪長を検査し、集合の変数数を返す。
        assert size > 0 and (size and (size - 1)) == 0, "集合冪級数の長さは正の2冪である必要があります"
        fastLog2(size)

    proc setComposeDerivatives[T: BarrettModint or MontgomeryModint](derivatives, s: seq[T]): seq[T] =
        ## 定数項での微分値から、変数を1つずつ追加して合成する。
        let n = setVariableCount(s.len)
        var values = newSeq[seq[T]](n + 1)
        for k in 0..n: values[k] = @[derivatives[k]]
        var width = 1
        for v in 0..<n:
            let h = s[width..<width * 2]
            for k in 0..<n - v:
                let upper = subsetConvolution(values[k + 1], h)
                values[k].add(upper)
            values.setLen(n - v)
            width *= 2
        values[0]

    proc setExp*[T: BarrettModint or MontgomeryModint](s: seq[T]): seq[T] =
        ## exp(s)をO(n² 2^n)時間・O(n 2^n)追加領域で返す。s[0]=0、素数法>nを要求する。
        let n = setVariableCount(s.len)
        assert s[0].val == 0, "expの定数項は0である必要があります"
        assert T.umod.int > n and isprime(T.umod.int), "expは変数数より大きい素数法を要求します"
        result = @[init(T, 1)]
        var width = 1
        for v in 0..<n:
            let upper = subsetConvolution(result, s[width..<width * 2])
            result.add(upper)
            width *= 2

    proc setLog*[T: BarrettModint or MontgomeryModint](s: seq[T]): seq[T] =
        ## log(s)をO(n² 2^n)時間・O(n 2^n)追加領域で返す。s[0]=1、素数法>nを要求する。
        let n = setVariableCount(s.len)
        assert s[0] == init(T, 1), "logの定数項は1である必要があります"
        assert T.umod.int > n and isprime(T.umod.int), "logは変数数より大きい素数法を要求します"
        var derivatives = newSeq[T](n + 1)
        if n > 0: derivatives[1] = init(T, 1)
        for k in 2..n: derivatives[k] = derivatives[k - 1] * (-(k - 1))
        setComposeDerivatives(derivatives, s)

    proc setUnitInverse[T: BarrettModint or MontgomeryModint](c: T): T =
        ## 逆元を計算し、合成数法でも単元であることを検査する。
        assert c.val != 0, "定数項は単元である必要があります"
        result = c.inv
        assert c * result == init(T, 1), "定数項は単元である必要があります"

    proc setInv*[T: BarrettModint or MontgomeryModint](s: seq[T]): seq[T] =
        ## 単元sの逆元をO(n² 2^n)時間・O(n 2^n)追加領域で返す。定数項に逆元を要求する。
        let n = setVariableCount(s.len)
        let inverse = setUnitInverse(s[0])
        var derivatives = newSeq[T](n + 1)
        derivatives[0] = inverse
        for k in 1..n: derivatives[k] = derivatives[k - 1] * (-k) * inverse
        setComposeDerivatives(derivatives, s)

    proc setScalarPower[T: BarrettModint or MontgomeryModint](c: T, exponent: uint): T =
        ## unsigned指数の二分累乗。最小intの絶対値も表現できる。
        result = init(T, 1)
        var base = c
        var e = exponent
        while e > 0:
            if (e and 1) != 0: result *= base
            e = e shr 1
            if e > 0: base *= base

    proc setPow*[T: BarrettModint or MontgomeryModint](s: seq[T], exponent: int): seq[T] =
        ## sの整数冪。O(n² 2^n+n log(|exponent|+1))時間・O(n 2^n)領域。負指数は単元のみ。
        let n = setVariableCount(s.len)
        var derivatives = newSeq[T](n + 1)
        var falling = init(T, 1)
        if exponent >= 0:
            for k in 0..min(n, exponent):
                derivatives[k] = falling * setScalarPower(s[0], uint(exponent - k))
                falling *= init(T, exponent) - k
        else:
            let inverse = setUnitInverse(s[0])
            let magnitude = uint(-(exponent + 1)) + 1u
            derivatives[0] = setScalarPower(inverse, magnitude)
            for k in 1..n:
                derivatives[k] = derivatives[k - 1] * (init(T, exponent) - (k - 1)) * inverse
        setComposeDerivatives(derivatives, s)

    proc setSqrt*[T: BarrettModint or MontgomeryModint](s: seq[T], constantRoot: T): seq[T] =
        ## 指定した定数項の平方根を持つ平方根をO(n² 2^n)時間・O(n 2^n)領域で返す。
        ## constantRoot²=s[0]、2と定数項が単元であることを要求する。全零とroot=0は零を返す。
        let n = setVariableCount(s.len)
        assert constantRoot * constantRoot == s[0], "指定した定数項の平方根が一致しません"
        if constantRoot.val == 0:
            for c in s: assert c.val == 0, "定数項0の非零集合冪級数の平方根は対応していません"
            return newSeq[T](s.len)
        let inverse = setUnitInverse(s[0])
        let half = setUnitInverse(init(T, 2))
        var derivatives = newSeq[T](n + 1)
        derivatives[0] = constantRoot
        for k in 1..n: derivatives[k] = derivatives[k - 1] * (half - (k - 1)) * inverse
        setComposeDerivatives(derivatives, s)

    proc polynomialCompositeSetPowerSeries*[T: BarrettModint or MontgomeryModint](f, s: seq[T]): seq[T] =
        ## 多項式f(s)をO(n² 2^n+n M)時間・O(n 2^n+M)追加領域で返す。M=f.len、sの定数項は任意。
        let n = setVariableCount(s.len)
        var derivatives = newSeq[T](n + 1)
        var polynomial = f
        for k in 0..n:
            if polynomial.len == 0: break
            var value = init(T, 0)
            for j in countdown(polynomial.high, 0): value = value * s[0] + polynomial[j]
            derivatives[k] = value
            for j in 1..<polynomial.len: polynomial[j - 1] = polynomial[j] * j
            polynomial.setLen(polynomial.len - 1)
        setComposeDerivatives(derivatives, s)

    proc setPowerProjection*[T: BarrettModint or MontgomeryModint](s, weights: seq[T], m: int): seq[T] =
        ## [Σ_S weights[S] (s^k)[S]]_{k=0..<m} を返す。O(n² 2^n+n m)時間・O(n 2^n+m)追加領域。
        let n = setVariableCount(s.len)
        assert weights.len == s.len, "重みの長さは集合冪級数と一致する必要があります"
        assert m >= 0, "出力長は非負である必要があります"
        if m == 0: return @[]
        var adjoints = @[weights]
        for v in countdown(n - 1, 0):
            let width = 1 shl v
            let h = s[width..<width * 2]
            var next = newSeq[seq[T]](adjoints.len + 1)
            for k in 0..<next.len: next[k] = newSeq[T](width)
            for k in 0..<adjoints.len:
                var reversed = newSeq[T](width)
                for mask in 0..<width:
                    next[k][mask] += adjoints[k][mask]
                    reversed[width - 1 - mask] = adjoints[k][width + mask]
                let product = subsetConvolution(h, reversed)
                for mask in 0..<width: next[k + 1][mask] += product[width - 1 - mask]
            adjoints = move(next)
        var powers = newSeq[T](m)
        powers[0] = init(T, 1)
        for k in 1..<m: powers[k] = powers[k - 1] * s[0]
        result = newSeq[T](m)
        for k in 0..<m:
            var falling = init(T, 1)
            for j in 0..min(k, n):
                result[k] += falling * powers[k - j] * adjoints[j][0]
                falling *= init(T, k) - j
