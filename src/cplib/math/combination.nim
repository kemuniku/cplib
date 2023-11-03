when not declared CPLIB_MATH_COMBINATION:
    const COMPETITIVE_MATH_COMBINATION* = 1
    type Combination_Type[T]= object
        fact : seq[T]
        inv : seq[T]
        fact_inv : seq[T]
    
    proc initCombination*[T](max_N:int):Combination_Type[T]=
        result.fact = newSeq[T](max_N+1)
        result.inv = newSeq[T](max_N+1)
        result.fact_inv = newSeq[T](max_N+1)
        result.fact[0] = 1
        result.fact[1] = 1  
        result.inv[1] = 1
        result.fact_inv[0] = 1
        result.fact_inv[1] = 1
        for i in 2..max_N:
            result.fact[i] = result.fact[i-1]*i
            result.inv[i] = -result.inv[int(T.umod()) mod i]*(int(T.umod()) div i)
            result.fact_inv[i] = result.fact_inv[i-1]*result.inv[i]
    
    proc ncr*[T](c:Combination_Type[T],n,r:int):T=
        if n < 0 or r < 0:
            return 0
        if n < r:
            return 0
        return c.fact[n]*c.fact_inv[n-r]*c.fact_inv[r]
    proc npr*[T](c:Combination_Type[T],n,r:int):T=
        if n < 0 or r < 0:
            return 0
        if n < r:
            return 0
        return c.fact[n]*c.fact_inv[r]
    proc nhr*[T](c:Combination_Type[T],n,r:int):T=
        return c.ncr(n+r-1,r)