when not declared CPLIB_STRING_ROLLING_HASH:
    const CPLIB_STRING_ROLLING_HASH* = 1
    import random, math

    type RollingHash* = object
        base, base_inv: uint
        s: string
        hash_accum: seq[uint]

    const MASK30 = (1u shl 30) - 1
    const MASK31 = (1u shl 31) - 1
    const RH_MOD = (1u shl 61) - 1
    const RH_ROOT = 37

    proc calc_mod(x: uint): uint =
        result = (x shr 61) + (x and RH_MOD)
        if result > RH_MOD:
            result -= RH_MOD

    proc mul(a, b: uint): uint =
        let
            a_upper = a shr 31
            a_lower = a and MASK31
            b_upper = b shr 31
            b_lower = b and MASK31
            mid = a_lower * b_upper + a_upper * b_lower
            mid_upper = mid shr 30
            mid_lower = mid and MASK30
        result = a_upper * b_upper * 2 + mid_upper + (mid_lower shl 31) + a_lower * b_lower

    proc pow(a, n: uint): uint =
        var a = a
        var n = n
        result = 1
        while n > 0:
            if (n and 1u) != 0u:
                result = mul(result, a).calc_mod
            a = mul(a, a).calc_mod
            n = n shr 1

    proc find_base(maxa: uint, seed: int64): (uint, uint) =
        var
            rng = if seed == -1: initRand() else: initRand(seed)
            k = 0u
            base = pow(RH_ROOT, k)
        while base <= maxa or gcd(RH_MOD, k) != 1:
            k = rng.rand(0u..<RH_MOD)
            base = pow(RH_ROOT, k)
        let base_inv = pow(base, RH_MOD-2)
        return (base, base_inv)

    proc build*(rh: var RollingHash) =
        rh.hash_accum = newSeq[uint](rh.s.len + 1)
        rh.hash_accum[0] = 0u
        var base_pow = 1u
        for i in 0..<rh.s.len:
            rh.hash_accum[i+1] = (rh.hash_accum[i] + mul(uint(rh.s[i]), base_pow)).calc_mod
            base_pow = mul(base_pow, rh.base).calc_mod

    proc initRollingHash*(s: string, seed: int64 = -1): RollingHash =
        let (base, base_inv) = find_base(256u, seed)
        result = RollingHash(base: base, base_inv: base_inv, s: s, hash_accum: newSeq[uint]())
        result.build

    proc query*(rh: RollingHash, rng: HSlice[int, int]): uint =
        return 0u
