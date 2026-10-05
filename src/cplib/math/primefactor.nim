when not declared CPLIB_MATH_PRIMEFACTOR:
    const CPLIB_MATH_PRIMEFACTOR* = 1
    import cplib/math/inner_math
    import cplib/math/isprime
    import cplib/str/run_length_encode
    import random, std/math, algorithm, tables

    {.emit: """
    static inline unsigned long long cplib_primefactor_mont_mul(
        unsigned long long a, unsigned long long b,
        unsigned long long n, unsigned long long inverse) {
        // n は正の int なので 2^63 未満。128 bit の加算は桁あふれしない。
        __uint128_t t = (__uint128_t)a * b;
        unsigned long long q = (unsigned long long)t * inverse;
        unsigned long long r = (unsigned long long)((t + (__uint128_t)q * n) >> 64);
        return r >= n ? r - n : r;
    }
    static inline unsigned long long cplib_primefactor_mont_r2(unsigned long long n) {
        return (unsigned long long)((-(__uint128_t)n) % n);
    }
    """.}
    proc montMulPrimefactor(a, b, n, inverse: uint64): uint64
        {.importcpp: "cplib_primefactor_mont_mul(#, #, #, #)", nodecl.}
        ## Montgomery 表現の積を求める。O(1)。
    proc montR2Primefactor(n: uint64): uint64
        {.importcpp: "cplib_primefactor_mont_r2(#)", nodecl.}
        ## 2^128 mod n を求める。O(1)。

    randomize()
    proc find_factor(n: int): int =
        ## Pollard rho 法で素因数を一つ求める。
        if not ((n and 1) != 0): return 2
        if isprime(n): return n
        let modulus = n.uint64
        var inverse = modulus
        for _ in 0..<6:
            inverse *= 2u64 - modulus * inverse
        inverse = 0u64 - inverse
        let r2 = montR2Primefactor(modulus)
        let one = montMulPrimefactor(1, r2, modulus, inverse)
        proc product(a, b: uint64): uint64 =
            ## Montgomery 表現の積を求める。O(1)。
            montMulPrimefactor(a, b, modulus, inverse)
        proc difference(a, b: uint64): uint64 =
            ## 差の絶対値を求める。O(1)。
            if a >= b: a - b else: b - a
        const m = 128
        while true:
            var x, ys, q = one
            var r, g = 1
            let randomValue = (rand(0..n-3) + 2).uint64
            let rnd = product(randomValue, r2)
            var y = product((rand(0..n-3) + 2).uint64, r2)
            proc f(x: uint64): uint64 =
                ## Montgomery 表現で rho の写像を求める。O(1)。
                let sum = product(x, x) + rnd
                if sum >= modulus: sum - modulus else: sum
            while g == 1:
                x = y
                for i in 0..<r: y = f(y)
                for k in countup(0, r-1, m):
                    ys = y
                    for _ in 0..<min(m, r-k):
                        y = f(y)
                        q = product(q, difference(x, y))
                    g = gcd(q.int, n)
                    if g != 1: break
                r = r shl 1
            if g == n:
                g = 1
                while g == 1:
                    ys = f(ys)
                    g = gcd(n, difference(x, ys).int)
            if g < n:
                if isprime(g): return g
                elif isprime(n div g): return n div g
                return find_factor(g)

    proc primefactor*(n: int, sorted: bool = true): seq[int] =
        var n = n
        while n > 1 and not isprime(n):
            var p = find_factor(n)
            while n mod p == 0:
                result.add(p)
                n = n div p
        if n > 1: result.add(n)
        if sorted: return result.sorted

    proc primefactor_table*(n: int): Table[int, int] =
        for p in primefactor(n):
            if p in result: result[p] += 1
            else: result[p] = 1

    proc primefactor_tuple*(n: int): seq[(int, int)] = primefactor(n, true).run_length_encode
