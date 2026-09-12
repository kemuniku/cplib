when not declared CPLIB_MATH_GENERALIZED_FLOOR_SUM:
    const CPLIB_MATH_GENERALIZED_FLOOR_SUM* = 1
    import cplib/math/monoid_floor_sum

    proc generalizedFloorSumTable*[T](n, m, a, b, p, q: int): seq[seq[T]] =
        ## result[j][k] = Σ(i=0..<n) i^j * floor((a*i+b)/m)^k (0<=j<=p, 0<=k<=q)。0^0=1。
        ## n,a,b,p,q >= 0、m > 0、a*n+b <= high(int) が必要。
        ## T は int から変換できる可換環で、既定値が零の型を指定する。除算は不要。
        ## 時間 O((p+1)(q+1)(p+q+2)log(m+1)log(n+a+b+2))、空間 O((p+q+2)^2)。
        ## 整数型では結果だけでなく途中の環演算も型の範囲内に収まる必要がある。
        assert n >= 0 and m > 0 and a >= 0 and b >= 0 and p >= 0 and q >= 0
        assert n == 0 or a <= (high(int) - b) div n

        proc zeroTable(): seq[seq[T]] =
            ## (p+1) 行 (q+1) 列の零行列を作る。
            result = newSeq[seq[T]](p + 1)
            for j in 0..p:
                result[j] = newSeq[T](q + 1)

        if n == 0:
            return zeroTable()

        let one: T = 1
        let degree = max(p, q)
        var binom = newSeq[seq[T]](degree + 1)
        for j in 0..degree:
            binom[j] = newSeq[T](j + 1)
            binom[j][0] = one
            binom[j][j] = one
            for k in 1..<j:
                binom[j][k] = binom[j - 1][k - 1] + binom[j - 1][k]

        type Moment = object
            dx, dy: T
            sums: seq[seq[T]]

        proc combine(l, r: Moment): Moment =
            ## 右側の各モーメントを左側の終点だけ平行移動して結合する。O((p+1)(q+1)(p+q+2))。
            var xp = newSeq[T](p + 1)
            var yp = newSeq[T](q + 1)
            xp[0] = one
            yp[0] = one
            for j in 1..p:
                xp[j] = xp[j - 1] * l.dx
            for k in 1..q:
                yp[k] = yp[k - 1] * l.dy

            var shifted = zeroTable()
            for j in 0..p:
                for s in 0..j:
                    let coefficient = binom[j][s] * xp[j - s]
                    for k in 0..q:
                        shifted[j][k] = shifted[j][k] + coefficient * r.sums[s][k]

            result = Moment(dx: l.dx + r.dx, dy: l.dy + r.dy, sums: zeroTable())
            for k in 0..q:
                for t in 0..k:
                    let coefficient = binom[k][t] * yp[k - t]
                    for j in 0..p:
                        result.sums[j][k] = result.sums[j][k] + coefficient * shifted[j][t]
            for j in 0..p:
                for k in 0..q:
                    result.sums[j][k] = result.sums[j][k] + l.sums[j][k]

        var x = Moment(dx: one, sums: zeroTable())
        x.sums[0][0] = one
        let y = Moment(dy: one, sums: zeroTable())
        let e = Moment(sums: zeroTable())
        return monoidFloorSum(n, m, a, b, x, y, combine, e).sums

    proc generalizedFloorSum*[T](n, m, a, b, p, q: int): T =
        ## Σ(i=0..<n) i^p * floor((a*i+b)/m)^q を返す。条件・計算量は generalizedFloorSumTable と同じ。
        return generalizedFloorSumTable[T](n, m, a, b, p, q)[p][q]
