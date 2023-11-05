when not declared CPLIB_MATH_POWMOD:
    const COMPETITIVE_MATH_POWMOD* = 1
    proc mul(a, b, m:int):int {.importcpp: "(__int128)(#) * (#) % (#)", nodecl.}
    proc powmod*(a, n, m: int): int =
        var
            rev = 1
            a = a
            n = n
        while n > 0:
            if n mod 2 != 0: rev = mul(rev,a,m)
            if n > 1: a = mul(a,a,m)
            n = n shr 1
        return rev