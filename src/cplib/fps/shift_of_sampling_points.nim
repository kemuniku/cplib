when not declared CPLIB_FPS_SHIFT_OF_SAMPLING_POINTS:
    const CPLIB_FPS_SHIFT_OF_SAMPLING_POINTS* = 1

    import cplib/convolution/convolution
    import cplib/modint/modint

    proc shiftOfSamplingPoints*[T: BarrettModint or MontgomeryModint](
            ys: openArray[T], t: T, m: int): seq[T] =
        ## 次数 n 未満の f の値 f(0), ..., f(n-1) から f(t), ..., f(t+m-1) を O(M(n+m)) で求める。
        ## 法 p は素数、n <= p、m >= 0 を要求する。空の ys は零多項式として扱う。
        doAssert m >= 0, "出力する評価点の個数は非負である必要がある"
        let n = ys.len
        let modulus = T.umod.int
        doAssert n <= modulus, "入力の評価点は法を超えない個数である必要がある"
        if m == 0: return @[]
        if n == 0: return newSeq[T](m)
        if n == 1:
            result = newSeq[T](m)
            for value in result.mitems: value = ys[0]
            return

        let count = min(m, modulus)
        let size = max(n, count)
        var fact = newSeq[T](size)
        var factInv = newSeq[T](size)
        fact[0] = init(T, 1)
        for i in 1..<size: fact[i] = fact[i - 1] * i
        factInv[^1] = fact[^1].inv
        for i in countdown(size - 1, 1): factInv[i - 1] = factInv[i] * i

        var left = newSeq[T](n)
        var right = newSeq[T](n)
        for i in 0..<n:
            left[i] = ys[i] * factInv[i]
            right[i] = if (i and 1) == 0: factInv[i] else: -factInv[i]
        let differences = convolution(left, right)

        var falling = init(T, 1)
        for i in 0..<n:
            left[i] = differences[n - 1 - i] * fact[n - 1 - i]
            right[i] = falling * factInv[i]
            falling *= t - i
        let shifted = convolution(left, right)

        left.setLen(min(n, count))
        for i in 0..<left.len: left[i] = shifted[n - 1 - i] * factInv[i]
        right = factInv[0..<count]
        result = convolution(left, right)
        result.setLen(count)
        for i in 0..<count: result[i] *= fact[i]
        result.setLen(m)
        for i in count..<m: result[i] = result[i - modulus]

    proc shiftOfSamplingPoints*[T: BarrettModint or MontgomeryModint](
            ys: openArray[T], t: T): seq[T] =
        ## 入力と同じ個数の評価値 f(t), ..., f(t+n-1) を O(M(n)) で求める。
        shiftOfSamplingPoints(ys, t, ys.len)
