when not declared CPLIB_MATH_ISPRIME:
    const CPLIB_MATH_ISPRIME* = 1
    {.emit: """
    static inline unsigned long long cplib_isprime_mont_mul(
        unsigned long long a, unsigned long long b,
        unsigned long long n, unsigned long long inverse) {
        // 128 bit の加算で桁あふれした場合も、減算後は 64 bit に収まる。
        __uint128_t t = (__uint128_t)a * b;
        unsigned long long q = (unsigned long long)t * inverse;
        __uint128_t sum = t + (__uint128_t)q * n;
        unsigned long long r = (unsigned long long)(sum >> 64);
        return sum < t || r >= n ? r - n : r;
    }
    static inline unsigned long long cplib_isprime_mont_r2(unsigned long long n) {
        // 符号なし整数の折り返しで 2^128 - n を作る。
        return (unsigned long long)((-(__uint128_t)n) % n);
    }
    """.}
    proc montMulIsprime(a, b, n, inverse: uint64): uint64
        {.importcpp: "cplib_isprime_mont_mul(#, #, #, #)", nodecl.}
        ## Montgomery 表現の積を求める。O(1)。
    proc montR2Isprime(n: uint64): uint64
        {.importcpp: "cplib_isprime_mont_r2(#)", nodecl.}
        ## 2^128 mod n を求める。O(1)。

    proc montPowIsprime(a, exponent, n, inverse, one: uint64): uint64 =
        ## Montgomery 表現の累乗を求める。O(log exponent)。
        var a = a
        var exponent = exponent
        result = one
        while exponent > 0:
            if (exponent and 1) != 0:
                result = montMulIsprime(result, a, n, inverse)
            if exponent > 1:
                a = montMulIsprime(a, a, n, inverse)
            exponent = exponent shr 1

    proc isprime*(N: SomeInteger): bool =
        ## 64 bit 以下の符号付き・符号なし整数の素数判定を行う。O(log N)。
        let bases = [2u64, 325, 9375, 28178, 450775, 9780504, 1795265022]
        if N == 2:
            return true
        if N < 2 or (N and 1) == 0:
            return false
        let modulus = N.uint64
        let N1 = modulus - 1
        var d = N1
        var s = 0
        while (d and 1) == 0:
            d = d shr 1
            s += 1
        var inverse = modulus
        for _ in 0..<6:
            inverse *= 2u64 - modulus * inverse
        inverse = 0u64 - inverse
        let r2 = montR2Isprime(modulus)
        let one = montMulIsprime(1, r2, modulus, inverse)
        let minusOne = modulus - one
        for a in bases:
            if a mod modulus == 0:
                continue
            let base = montMulIsprime((a mod modulus).uint64, r2, modulus, inverse)
            var t = montPowIsprime(base, d, modulus, inverse, one)
            if t == one or t == minusOne:
                continue
            block test:
                for _ in 0..<(s-1):
                    t = montMulIsprime(t, t, modulus, inverse)
                    if t == minusOne:
                        break test
                return false
        return true
