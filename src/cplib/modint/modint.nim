
when not declared CPLIB_MODINT_MODINT:
    const CPLIB_MODINT_MODINT* = 1
    include cplib/modint/modint_barrett
    include cplib/modint/modint_montgomery
    declarStaticMontgomeryModint(modint998244353_montgomery, 998244353u32)
    declarStaticMontgomeryModint(modint1000000007_montgomery, 1000000007u32)
    declarStaticBarrettModint(modint998244353_barrett, 998244353u32)
    declarStaticBarrettModint(modint1000000007_barrett, 1000000007u32)
    declarDynamicBarrettModint(modint_barrett, 1u32)
