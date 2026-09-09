when not declared CPLIB_FPS_BOSTAN_MORI:
    const CPLIB_FPS_BOSTAN_MORI* = 1

    import cplib/fps/formal_power_series
    import cplib/modint/modint

    proc parityTerms[T](f: seq[T], parity: int): seq[T] =
        if f.len <= parity: return @[]
        result = newSeq[T]((f.len - parity + 1) div 2)
        var j = 0
        for i in countup(parity, f.high, 2):
            result[j] = f[i]
            inc j

    proc bostanMori*[T: BarrettModint or MontgomeryModint](
            numerator, denominator: seq[T], k: int): T =
        ## numerator(x) / denominator(x) のx^kの係数を返す。
        doAssert k >= 0, "Bostan--Mori法では添字が非負である必要がある"
        doAssert denominator.len > 0 and denominator[0].val != 0,
            "Bostan--Mori法では分母の定数項が非零である必要がある"
        var p = numerator.normalized
        var q = denominator.normalized
        var index = k
        while index > 0:
            var qNegative = q
            for i in countup(1, qNegative.high, 2): qNegative[i] = -qNegative[i]
            p = parityTerms(p * qNegative, index and 1)
            q = parityTerms(q * qNegative, 0)
            index = index shr 1
        if p.len == 0: return init(T, 0)
        p[0] / q[0]

    proc linearRecurrenceKth*[T: BarrettModint or MontgomeryModint](
            initial, coefficients: seq[T], k: int): T =
        ## a[n] = sum(coefficients[i] * a[n-i-1], i=0..<d) の第k項を求める。
        doAssert initial.len == coefficients.len and initial.len > 0,
            "線形漸化式では初期値と係数の個数が一致し、かつ1個以上である必要がある"
        doAssert k >= 0, "線形漸化式の添字は非負である必要がある"
        if k < initial.len: return initial[k]
        var q = newSeq[T](coefficients.len + 1)
        q[0] = 1
        for i in 0..<coefficients.len: q[i + 1] = -coefficients[i]
        let p = prefix(initial * q, coefficients.len)
        bostanMori(p, q, k)
