when not declared CPLIB_MATH_CRT:
    const CPLIB_MATH_CRT* = 1
    import std/math
    import cplib/math/inv_gcd
    import cplib/math/inner_math

    proc crt*(r, m: openArray[int]): (int, int) =
        ## すべての i について x = r[i] (mod m[i]) を満たす x を求める。
        ## 解が存在するとき (x mod lcm(m), lcm(m)) を、存在しないとき (0, 0) を返す。
        ## m[i] は正で、mod の最小公倍数は int に収まる必要がある。
        assert r.len == m.len
        var
            r0 = 0
            m0 = 1
        for i in 0..<r.len:
            assert m[i] >= 1
            var
                r1 = floorMod(r[i], m[i])
                m1 = m[i]

            if m0 < m1:
                swap(r0, r1)
                swap(m0, m1)
            if m0 mod m1 == 0:
                if r0 mod m1 != r1: return (0, 0)
                continue

            let
                (g, im) = inv_gcd(m0, m1)
                u1 = m1 div g
            if (r1 - r0) mod g != 0: return (0, 0)

            let x = mul((r1 - r0) div g, im, u1)
            r0 += x * m0
            m0 *= u1
            if r0 < 0: r0 += m0
        return (r0, m0)
