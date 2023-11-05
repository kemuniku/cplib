when not declared CPLIB_MATH_ISPRIME:
    const COMPETITIVE_MATH_ISPRIME* = 1
    import cplib/math/powmod
    import std/bitops

    proc isprime*(N:int):bool=
        let bases = [2,325,9375,28178,450775,9780504,1795265022]
        if N == 2:
            return true
        if N < 2 or (N and 1) == 0:
            return false
        let N1 = N-1
        var d = N1
        var s = 0
        while (d and 1) == 0:
            d = d shr 1
            s += 1
        for a in bases:
            var t:int
            if a mod N == 0:
                continue
            t = powmod(a,d,N)
            if t == 1 or t == N1:
                continue
            block test:
                for _ in 0..<(s-1):
                    t = powmod(t,2,N)
                    if t == N1:
                        break test
                return false
        return true