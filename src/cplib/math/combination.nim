when not declared CPLIB_MATH_COMBINATION:
    const CPLIB_MATH_COMBINATION* = 1
    import cplib/math/isprime

    type Combination_Type[ModInt] = object
        modulus: uint64
        fact*: seq[ModInt]
        inv*: seq[ModInt]
        fact_inv*: seq[ModInt]

    proc initCombination*[ModInt](max_N: int): Combination_Type[ModInt] =
        ## 階乗・逆階乗・整数の逆元の表を作る。素数法では逆元計算を一回にまとめる。
        assert max_N >= 0, "max_Nは非負である必要があります"
        var fact = newSeq[ModInt](max_N+1)
        var inv = newSeq[ModInt](max_N+1)
        var fact_inv = newSeq[ModInt](max_N+1)
        fact[0] = 1
        fact_inv[0] = 1
        when compiles(block:
            var inverse: ModInt = fact[0].inv
            discard inverse):
            if isprime(ModInt.umod()):
                let limit = min(max_N, int(ModInt.umod()) - 1)
                for i in 1..limit: fact[i] = fact[i-1] * i
                fact_inv[limit] = fact[limit].inv
                for i in countdown(limit, 1):
                    fact_inv[i-1] = fact_inv[i] * i
                    inv[i] = fact_inv[i] * fact[i-1]
                return Combination_Type[ModInt](modulus: ModInt.umod().uint64, fact: fact, inv: inv, fact_inv: fact_inv)
        if max_N >= 1:
            fact[1] = 1
            inv[1] = 1
            fact_inv[1] = 1
        for i in 2..max_N:
            fact[i] = fact[i-1] * i
            inv[i] = -inv[int(ModInt.umod()) mod i]*(int(ModInt.umod()) div i)
            fact_inv[i] = fact_inv[i-1] * inv[i]
        result = Combination_Type[ModInt](modulus: ModInt.umod().uint64, fact: fact, inv: inv, fact_inv: fact_inv)

    proc ncr*[ModInt](c: Combination_Type[ModInt], n, r: int): ModInt =
        if n < 0 or r < 0 or n < r:
            return 0
        return c.fact[n]*c.fact_inv[n-r]*c.fact_inv[r]

    proc ncr_inv*[ModInt](c: Combination_Type[ModInt], n, r: int): ModInt =
        ## C(n,r) の逆元を O(1) で返す。素数法・構築時と同じ法・0 <= r <= n < 法・前計算済みの n が必要。
        ## 階乗と逆階乗は初期化時の値を保つこと。範囲外・法変更・階乗が可逆でない場合は ValueError。
        if n < 0 or r < 0 or r > n or n >= c.fact.len or n >= c.fact_inv.len:
            raise newException(ValueError, "二項係数の逆元には前計算済みの 0 <= r <= n が必要です")
        if c.modulus < 2 or c.modulus != ModInt.umod().uint64 or n.uint64 >= c.modulus:
            raise newException(ValueError, "構築時と同じ素数法で n < 法が必要です")
        if c.fact[n] * c.fact_inv[n] != 1:
            raise newException(ValueError, "階乗の逆元が存在しないか前計算表が不正です")
        return c.fact_inv[n] * c.fact[r] * c.fact[n-r]

    proc npr*[ModInt](c: Combination_Type[ModInt], n, r: int): ModInt =
        if n < 0 or r < 0 or n < r:
            return 0
        return c.fact[n]*c.fact_inv[n-r]

    proc nhr*[ModInt](c: Combination_Type[ModInt], n, r: int): ModInt =
        if n == 0 and r == 0:
            return Modint(1)
        return c.ncr(n+r-1, r)
