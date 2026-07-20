when not declared CPLIB_MATH_KTH_ROOT_MOD:
    const CPLIB_MATH_KTH_ROOT_MOD* = 1

    import std/[math, tables]
    import cplib/math/[isprime, powmod, primefactor]
    import cplib/math/inner_math

    proc invModKthRoot(a, m: int): int =
        ## The caller guarantees gcd(a, m) = 1.
        if m == 1: return 0
        var
            a = a mod m
            b = m
            x0 = 1
            x1 = 0
        while b != 0:
            let q = a div b
            (a, b) = (b, a mod b)
            (x0, x1) = (x1, x0 - q * x1)
        result = x0 mod m
        if result < 0: result += m

    proc intPowKthRoot(a, n: int): int =
        result = 1
        for _ in 0..<n: result *= a

    proc discreteLogPrimeOrder(g, x, q, modulus: int): int =
        ## Returns e in [0, q) such that g^e = x. Here q is prime and
        ## the order of g is q.
        let width = int(sqrt(float(q))).succ
        var baby = initTable[int, int](width * 2)
        var cur = 1
        for i in 0..<width:
            if cur notin baby: baby[cur] = i
            cur = mul(cur, g, modulus)

        let giant = powmod(invModKthRoot(g, modulus), width, modulus)
        cur = x
        for j in 0..width:
            if cur in baby:
                let e = j * width + baby[cur]
                if e < q: return e
            cur = mul(cur, giant, modulus)
        raise newException(AssertionDefect, "discrete logarithm does not exist")

    proc primePowerRoot(c, prime, exponent, modulus: int): int =
        ## Extracts a prime^exponent-th root. Existence is checked by the
        ## public procedure before this is called.
        var
            s = modulus - 1
            valuation = 0
            primePower = 1
        while s mod prime == 0:
            s = s div prime
            inc valuation
        for _ in 0..<exponent: primePower *= prime

        let u = invModKthRoot(primePower - s mod primePower, primePower)
        var
            z = powmod(c, (s * u + 1) div primePower, modulus)
            error = powmod(c, s * u, modulus)
        if error == 1: return z
        doAssert valuation > exponent

        var v = 2
        let topPower = intPowKthRoot(prime, valuation - 1)
        while powmod(powmod(v, s, modulus), topPower, modulus) == 1:
            inc v
        var
            vs = powmod(v, s, modulus)
            vsPower = powmod(vs, primePower, modulus)
            vsValuation = exponent
            base = vsPower
        for _ in 0..<(valuation - exponent - 1):
            base = powmod(base, prime, modulus)

        while error != 1:
            var
                tmp = error
                distance = 0
            while tmp != 1:
                inc distance
                tmp = powmod(tmp, prime, modulus)
            let neededValuation = valuation - distance
            while vsValuation != neededValuation:
                vs = powmod(vs, prime, modulus)
                vsPower = powmod(vsPower, prime, modulus)
                inc vsValuation

            var target = invModKthRoot(error, modulus)
            for _ in 0..<(distance - 1):
                target = powmod(target, prime, modulus)
            let correction = discreteLogPrimeOrder(base, target, prime, modulus)
            z = mul(z, powmod(vs, correction, modulus), modulus)
            error = mul(error, powmod(vsPower, correction, modulus), modulus)
        result = z

    proc kthRootMod*(a, k, p: int): int =
        ## Finds x such that x^k = a (mod p), or returns -1 if no solution
        ## exists. `p` must be prime and `k` must be nonnegative.
        ##
        ## Runs in O(min(p, k)^(1/4) polylog(p)) expected time, including
        ## Pollard--Rho factorization.
        doAssert p >= 2 and p.isprime
        doAssert k >= 0
        var a = a mod p
        if a < 0: a += p
        if k == 0: return (if a == 1: 1 else: -1)
        if a <= 1 or k == 1 or p == 2: return a

        let g = gcd(k, p - 1)
        if powmod(a, (p - 1) div g, p) != 1: return -1
        a = powmod(a, invModKthRoot(k div g, (p - 1) div g), p)

        var factors = initCountTable[int]()
        for q in primefactor(g): factors.inc(q)
        for q, e in factors.pairs:
            a = primePowerRoot(a, q, e, p)
        result = a
