when not declared CPLIB_MATH_POWMOD:
    const CPLIB_MATH_POWMOD* = 1
    import cplib/math/inner_math
    proc powmod*(a, n, m: int): int =
        assert m != 0
        if m == 1:
            return 0
        var
            rev = 1
            a = a
            n = n
        while n > 0:
            if n mod 2 != 0: rev = mul(rev, a, m)
            if n > 1: a = mul(a, a, m)
            n = n shr 1
        return rev
