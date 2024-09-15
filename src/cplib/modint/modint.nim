when not declared CPLIB_MODINT_MODINT:
    const CPLIB_MODINT_MODINT* = 1
    include cplib/modint/barrett_impl
    include cplib/modint/montgomery_impl
    import std/math, std/algorithm
    import cplib/math/isqrt
    declarStaticMontgomeryModint(modint998244353_montgomery, 998244353u32)
    declarStaticMontgomeryModint(modint1000000007_montgomery, 1000000007u32)
    declarDynamicMontgomeryModint(modint_montgomery, 1u32)
    declarStaticBarrettModint(modint998244353_barrett, 998244353u32)
    declarStaticBarrettModint(modint1000000007_barrett, 1000000007u32)
    declarDynamicBarrettModint(modint_barrett, 1u32)
    func `+`*(a, b: MontgomeryModint or BarrettModint): auto = (result = a; result += b)
    func `-`*(a, b: MontgomeryModint or BarrettModint): auto = (result = a; result -= b)
    func `*`*(a, b: MontgomeryModint or BarrettModint): auto = (result = a; result *= b)
    func `/`*(a, b: MontgomeryModint or BarrettModint): auto = (result = a; result /= b)
    func `+`*(a: MontgomeryModint or BarrettModint, b: SomeInteger): auto = (result = a; result += b)
    func `-`*(a: MontgomeryModint or BarrettModint, b: SomeInteger): auto = (result = a; result -= b)
    func `*`*(a: MontgomeryModint or BarrettModint, b: SomeInteger): auto = (result = a; result *= b)
    func `/`*(a: MontgomeryModint or BarrettModint, b: SomeInteger): auto = (result = a; result /= b)
    func `+`*(a: SomeInteger, b: MontgomeryModint or BarrettModint): auto = b + a
    func `-`*(a: SomeInteger, b: MontgomeryModint or BarrettModint): auto = b - a
    func `*`*(a: SomeInteger, b: MontgomeryModint or BarrettModint): auto = b * a
    func `/`*(a: SomeInteger, b: MontgomeryModint or BarrettModint): auto = b / a
    proc `/`*[ModInt: MontgomeryModint or BarrettModint](a: ModInt, b: static int): auto =
        const tmp = init(Modint, b).inv
        return a * tmp
    func pow*(a: MontgomeryModint or BarrettModint, n: int): auto =
        result = init(typeof(a), 1)
        var a = a
        var n = n
        while n > 0:
            if (n and 1) == 1: result *= a
            a *= a
            n = (n shr 1)
    func `$`*(a: MontgomeryModint or BarrettModint): string = $(a.val)
    proc estimate_rational*(a: MontgomeryModint or BarrettModint, ub: int = isqrt(typeof(a).mod)): string =
        var v: seq[tuple[s, n, d: int]]
        for d in 1..ub:
            var n = (a * d).val
            if n * 2 > a.mod:
                n = - (a.mod - n)
            if gcd(n, d) > 1: continue
            v.add((n.abs + d, n, d))
        v.sort
        return $v[0].n & "/" & $v[0].d
