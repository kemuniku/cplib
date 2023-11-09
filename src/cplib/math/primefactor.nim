when not declared CPLIB_MATH_PRIMEFACTOR:
    const CPLIB_MATH_PRIMEFACTOR* = 1
    import cplib/math/inner_math
    import cplib/math/isprime
    import random, std/math, algorithm, tables

    randomize()
    proc find_factor*(n: int): int =
        if not ((n and 1) != 0): return 2
        if isprime(n): return n
        while true:
            var x, y, ys, q, r = 1
            var rnd = rand(0..n-1)
            proc f(x: int): int = (mul(x, 2, n) + rnd) mod n
            var g = 1
            const m = 128
            while g == 1:
                x = y
                for i in 0..<r: y = f(y)
                for k in countup(0, r-1, m):
                    ys = y
                    if g != 1: break
                    for _ in 0..<min(m, r-k):
                        y = f(y)
                        q = mul(q, abs(x-y), n)
                    g = gcd(q, n)
                r = r shl 1
            if g == n:
                g = 1
                while g == 1:
                    ys = f(ys)
                    g = gcd(n, abs(x - ys))
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

    proc primefactor_cnt*(n: int): Table[int, int] =
        for p in primefactor(n):
            if p in result: result[p] += 1
            else: result[p] = 1
