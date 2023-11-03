when not declared CPLIB_MATH_COMBINATION:
    const COMPETITIVE_MATH_COMBINATION* = 1
    import atcoder/modint
    type Combination_Type[ModInt] = ref object
        fact: seq[ModInt]
        inv: seq[ModInt]
        fact_inv: seq[ModInt]

    proc initCombination*[ModInt](max_N: int): Combination_Type[ModInt] =
        var fact = newSeq[ModInt](max_N+1)
        var inv = newSeq[ModInt](max_N+1)
        var fact_inv = newSeq[ModInt](max_N+1)
        fact[0] = 1
        fact[1] = 1
        inv[1] = 1
        fact_inv[0] = 1
        fact_inv[1] = 1
        for i in 2..max_N:
            fact[i] = fact[i-1] * i
            inv[i] = -inv[int(ModInt.umod()) mod i]*(int(ModInt.umod()) div i)
            fact_inv[i] = fact_inv[i-1] * inv[i]
        result = Combination_Type[ModInt](fact: fact, inv: inv, fact_inv: fact_inv)

    proc ncr*[ModInt](c: Combination_Type[ModInt], n, r: int): ModInt =
        if n < 0 or r < 0:
            return 0
        if n < r:
            return 0
        return c.fact[n]*c.fact_inv[n-r]*c.fact_inv[r]
    proc npr*[ModInt](c: Combination_Type[ModInt], n, r: int): ModInt =
        if n < 0 or r < 0:
            return 0
        if n < r:
            return 0
        return c.fact[n]*c.fact_inv[r]
    proc nhr*[ModInt](c: Combination_Type[ModInt], n, r: int): ModInt =
        return c.ncr(n+r-1, r)
