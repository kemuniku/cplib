when not declared CPLIB_MATH_PRIMITIVE_ROOT:
    const CPLIB_MATH_PRIMITIVE_ROOT* = 1
    import cplib/math/isprime
    import cplib/math/primefactor
    import cplib/math/powmod
    import random
    import sequtils

    randomize()
    
    proc primitive_root*(p:int):int=
        assert p.isprime()
        var pf = (p-1).primefactor().deduplicate(true)
        while true:
            var a = rand(1..<p)
            var flg = true
            for q in pf:
                if powmod(a,(p-1) div q,p) == 1:
                    flg = false
                    break
            if flg:
                return a