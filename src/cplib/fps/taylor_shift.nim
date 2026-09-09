when not declared CPLIB_FPS_TAYLOR_SHIFT:
    const CPLIB_FPS_TAYLOR_SHIFT* = 1

    import cplib/fps/formal_power_series
    import cplib/modint/modint

    proc taylorShift*[T: BarrettModint or MontgomeryModint](f: seq[T], c: T): seq[T] =
        ## f(x + c) の係数列を O(M(n)) で求める。
        let n = f.len
        if n == 0: return @[]
        doAssert n <= T.umod.int,
            "Taylor shiftでは使用する階乗がすべて法未満である必要がある"
        var fact = newSeq[T](n)
        var factInv = newSeq[T](n)
        fact[0] = 1
        factInv[0] = 1
        for i in 1..<n:
            fact[i] = fact[i - 1] * i
            factInv[i] = factInv[i - 1] / i
        var left = newSeq[T](n)
        var right = newSeq[T](n)
        var cpow = init(T, 1)
        for i in 0..<n:
            left[n - 1 - i] = f[i] * fact[i]
            right[i] = cpow * factInv[i]
            cpow *= c
        let product = left * right
        result = newSeq[T](n)
        for i in 0..<n: result[i] = product[n - 1 - i] * factInv[i]
