
when not declared CPLIB_MODINT_MODINT:
    const CPLIB_MODINT_MODINT* = 1
    include cplib/modint/barrett_impl
    include cplib/modint/montgomery_impl
    func `+`*(a, b: MontgomeryModint or BarrettModint): auto = (result = a; result += b)
    func `-`*(a, b: MontgomeryModint or BarrettModint): auto = (result = a; result -= b)
    func `*`*(a, b: MontgomeryModint or BarrettModint): auto = (result = a; result *= b)
    func `/`*(a, b: MontgomeryModint or BarrettModint): auto = (result = a; result /= b)
    func pow*(a: MontgomeryModint or BarrettModint, n: int): auto =
        result = init(typeof(a), 1)
        var a = a
        var n = n
        while n > 0:
            if (n and 1) == 1: result *= a
            a *= a
            n = (n shr 1)
    func `$`*(a: MontgomeryModint or BarrettModint): string = $(a.val)
    declarStaticMontgomeryModint(mint998244353_montgomery, 998244353u32)
    declarStaticMontgomeryModint(mint1000000007_montgomery, 1000000007u32)
    declarDynamicMontgomeryModint(mint_montgomery, 1u32)
    declarStaticBarrettModint(mint998244353_barrett, 998244353u32)
    declarStaticBarrettModint(mint1000000007_barrett, 1000000007u32)
    declarDynamicBarrettModint(mint_barrett, 1u32)
