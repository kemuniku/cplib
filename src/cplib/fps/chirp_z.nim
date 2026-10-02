when not declared CPLIB_FPS_CHIRP_Z:
    const CPLIB_FPS_CHIRP_Z* = 1

    import cplib/convolution/convolution
    import cplib/math/inv_gcd
    import cplib/modint/modint

    # 参考: NyaanNyaan/library の ntt/chirp-z.hpp (CC0-1.0)。
    # https://github.com/NyaanNyaan/library/blob/master/ntt/chirp-z.hpp
    proc multipointEvaluationGeometric*[T: BarrettModint or MontgomeryModint](
            f: seq[T], a, r: T, m: int): seq[T] =
        ## f(a*r^i), 0 <= i < m を求める。rが可逆ならO(M(n+m))、非可逆ならO(n*m)。入力は変更しない。
        assert m >= 0, "出力する評価点の個数は非負である必要がある"
        result = newSeq[T](m)
        let n = f.len
        if m == 0 or n == 0: return
        if n == 1 or a.val == 0:
            for value in result.mitems: value = f[0]
            return

        if m == 1 or r.val == 0 or r == init(T, 1) or r == init(T, -1):
            var atA = init(T, 0)
            var atMinusA = init(T, 0)
            for j in countdown(n - 1, 0):
                atA = atA * a + f[j]
                if r == init(T, -1): atMinusA = atMinusA * (-a) + f[j]
            result[0] = atA
            for i in 1..<m:
                if r.val == 0: result[i] = f[0]
                elif r == init(T, 1) or (i and 1) == 0: result[i] = atA
                else: result[i] = atMinusA
            return

        let (divisor, inverse) = inv_gcd(r.val, T.umod.int)
        if divisor != 1:
            var x = a
            for i in 0..<m:
                for j in countdown(n - 1, 0): result[i] = result[i] * x + f[j]
                x *= r
            return

        var chirp = newSeq[T](n + m - 1)
        var inverseChirp = newSeq[T](max(n, m))
        chirp[0] = init(T, 1)
        inverseChirp[0] = init(T, 1)
        let inverseRatio = init(T, inverse)
        var ratioPower = init(T, 1)
        var inverseRatioPower = init(T, 1)
        for i in 1..<chirp.len:
            chirp[i] = chirp[i - 1] * ratioPower
            ratioPower *= r
        for i in 1..<inverseChirp.len:
            inverseChirp[i] = inverseChirp[i - 1] * inverseRatioPower
            inverseRatioPower *= inverseRatio

        var left = newSeq[T](n)
        var aPower = init(T, 1)
        for j in 0..<n:
            left[n - 1 - j] = f[j] * aPower * inverseChirp[j]
            aPower *= a
        let product = convolution(left, chirp)
        for i in 0..<m: result[i] = product[n - 1 + i] * inverseChirp[i]

    proc chirpZ*[T: BarrettModint or MontgomeryModint](
            f: seq[T], r: T, m: int, a: T = init(T, 1)): seq[T] =
        ## f(a*r^i), 0 <= i < m を求めるChirp Z変換。計算量はmultipointEvaluationGeometricと同じ。
        multipointEvaluationGeometric(f, a, r, m)
