when not declared CPLIB_MATH_BMBM:
    const CPLIB_MATH_BMBM* = 1
    import cplib/modint/modint
    import cplib/convolution/convolution

    proc berlekamp_massey*[T: BarrettModint or MontgomeryModint](a: seq[T]): seq[T] =
        ## Returns the shortest recurrence
        ## `a[n] = result[0] * a[n-1] + ... + result[d-1] * a[n-d]`.
        var c = @[T(1)]
        var b = @[T(1)]
        var l = 0
        var m = 1
        var last_discrepancy = T(1)

        for n in 0..<a.len:
            if c.len <= l:
                c.setLen(l + 1)
            var discrepancy = a[n]
            for i in 1..l:
                discrepancy += c[i] * a[n-i]
            if discrepancy == T(0):
                inc m
                continue

            var old_c = newSeq[T](c.len)
            for i in 0..<c.len:
                old_c[i] = c[i]
            let coefficient = discrepancy / last_discrepancy
            if c.len < b.len + m:
                c.setLen(b.len + m)
            for i in 0..<b.len:
                c[i+m] -= coefficient * b[i]

            if 2 * l <= n:
                l = n + 1 - l
                b = old_c
                last_discrepancy = discrepancy
                m = 1
            else:
                inc m

        result = newSeq[T](l)
        for i in 0..<l:
            result[i] = -c[i+1]

    proc bostan_mori*[T: BarrettModint or MontgomeryModint](
        numerator, denominator: seq[T], n: int
    ): T =
        ## Returns [x^n] numerator(x) / denominator(x).
        ## `denominator[0]` must be non-zero and `n` must be non-negative.
        assert n >= 0
        assert denominator.len > 0 and denominator[0] != T(0)
        if numerator.len == 0:
            return T(0)

        var p = numerator
        var q = denominator
        var k = n
        while k > 0:
            var q_negative = q
            for i in countup(1, q_negative.high, 2):
                q_negative[i] = -q_negative[i]

            let pq = convolution(p, q_negative)
            let qq = convolution(q, q_negative)
            var next_p = newSeq[T]()
            var next_q = newSeq[T]()
            let parity = int(k and 1)
            for i in countup(parity, pq.high, 2):
                next_p.add(pq[i])
            for i in countup(0, qq.high, 2):
                next_q.add(qq[i])
            p = next_p
            q = next_q
            k = k shr 1

        return p[0] / q[0]

    proc linear_recurrence_kth*[T: BarrettModint or MontgomeryModint](
        initial, recurrence: seq[T], n: int
    ): T =
        ## Returns the n-th term (0-indexed) of a linear recurrence.
        assert n >= 0
        if n < initial.len:
            return initial[n]
        let d = recurrence.len
        assert d > 0 and initial.len >= d

        var q = newSeq[T](d + 1)
        q[0] = T(1)
        for i in 0..<d:
            q[i+1] = -recurrence[i]
        var p = convolution(initial[0..<d], q)
        p.setLen(d)
        return bostan_mori(p, q, n)

    proc bmbm*[T: BarrettModint or MontgomeryModint](a: seq[T], n: int): T =
        ## Finds a recurrence with Berlekamp--Massey and evaluates its n-th
        ## term with Bostan--Mori. At least twice the recurrence degree worth
        ## of known terms should normally be supplied.
        assert n >= 0
        if n < a.len:
            return a[n]
        assert a.len > 0
        let recurrence = berlekamp_massey(a)
        if recurrence.len == 0:
            return T(0)
        return linear_recurrence_kth(a, recurrence, n)
