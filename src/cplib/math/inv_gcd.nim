when not declared CPLIB_MATH_INVGCD:
    const CPLIB_MATH_INVGCD* = 1
    # @param b `1 <= b`
    # @return pair(g, x) s.t. g = gcd(a, b), xa = g (mod b), 0 <= x < b/g
    import std/math
    proc inv_gcd*(a, b: int): (int, int) =
        var a = floorMod(a, b)
        if a == 0: return (b, 0)
        var
            s = b
            t = a
            m0 = 0
            m1 = 1

        while t != 0:
            var u = s div t
            s -= t * u
            m0 -= m1 * u

            var tmp = s
            s = t
            t = tmp
            tmp = m0
            m0 = m1
            m1 = tmp
        if m0 < 0: m0 += b div s
        return (s, m0)

