when not declared CPLIB_MATH_COMBINATION_ARBITRARY_MOD:
    const CPLIB_MATH_COMBINATION_ARBITRARY_MOD* = 1

    # 参考: https://nyaannyaan.github.io/library/modulo/arbitrary-mod-binomial.hpp.html
    type
        CombinationPrimePower = object
            p, q, modulus, coefficient: int
            fact, factInv: seq[int32]
        CombinationArbitraryMod* = object
            modulus: int
            factors: seq[CombinationPrimePower]

    proc power(a, exponent, modulus: int): int =
        ## aの非負整数乗をmodulusで割った余りを返す。O(log(exponent + 1))。
        var a = a
        var exponent = exponent
        result = 1
        while exponent > 0:
            if (exponent and 1) != 0:
                result = result * a mod modulus
            a = a * a mod modulus
            exponent = exponent shr 1

    proc initCombinationArbitraryMod*(max_N, modulus: int): CombinationArbitraryMod =
        ## 任意modの組合せを前計算する。64bit環境で0 <= max_N、1 <= modulus < 2^30。
        ## 素数冪mごとにL = min(max_N, m - 1)として、時間O(sqrt(modulus) + Σ(L + log m))、空間O(Σ(L + 1))。
        ## n <= max_Nを扱える。全素数冪mについてmax_N >= m - 1なら任意の非負intのnを扱える。
        assert max_N >= 0, "max_Nは非負である必要があります"
        assert modulus >= 1 and modulus < (1 shl 30), "法は1以上2^30未満である必要があります"
        result.modulus = modulus
        var remaining = modulus
        var p = 2
        while remaining > 1:
            if p > remaining div p:
                p = remaining
            if remaining mod p == 0:
                var f = CombinationPrimePower(p: p, modulus: 1)
                while remaining mod p == 0:
                    remaining = remaining div p
                    f.modulus *= p
                    inc f.q
                let limit = min(max_N, f.modulus - 1)
                f.fact = newSeq[int32](limit + 1)
                f.factInv = newSeq[int32](limit + 1)
                f.fact[0] = 1
                for i in 1..limit:
                    f.fact[i] = f.fact[i - 1]
                    if i mod p != 0:
                        f.fact[i] = int32(int(f.fact[i]) * i mod f.modulus)
                let phi = f.modulus div p * (p - 1)
                f.factInv[limit] = int32(power(int(f.fact[limit]), phi - 1, f.modulus))
                for i in countdown(limit, 1):
                    f.factInv[i - 1] = f.factInv[i]
                    if i mod p != 0:
                        f.factInv[i - 1] = int32(int(f.factInv[i]) * i mod f.modulus)
                let other = modulus div f.modulus
                f.coefficient = other * power(other mod f.modulus, phi - 1, f.modulus)
                result.factors.add(f)
            inc p

    proc factorialRatio(f: CombinationPrimePower, n, a, b: int): int =
        ## n!/(a!b!)を素数冪で割った余りを返す。a+b <= nを仮定し、O(log_p(n + 1))。
        assert n < f.fact.len or f.fact.len == f.modulus, "前計算の範囲を超えています"
        var (n, a, b) = (n, a, b)
        var exponent = 0
        var negative = false
        result = 1
        while n > 0:
            result = result * int(f.fact[n mod f.modulus]) mod f.modulus
            result = result * int(f.factInv[a mod f.modulus]) mod f.modulus
            result = result * int(f.factInv[b mod f.modulus]) mod f.modulus
            if ((n div f.modulus - a div f.modulus - b div f.modulus) and 1) != 0:
                negative = not negative
            n = n div f.p
            a = a div f.p
            b = b div f.p
            exponent += n - a - b
            if exponent >= f.q:
                return 0
        if negative and not (f.p == 2 and f.q >= 3):
            result = f.modulus - result
        result = result * power(f.p, exponent, f.modulus) mod f.modulus

    proc ncr*(c: CombinationArbitraryMod, n, r: int): int =
        ## nCr mod modulusを返す。不正なn,rには0を返す。時間O(Σ log_p(n + 1))。
        if n < 0 or r < 0 or n < r:
            return 0
        for f in c.factors:
            result = (result + f.factorialRatio(n, r, n - r) * f.coefficient) mod c.modulus

    proc npr*(c: CombinationArbitraryMod, n, r: int): int =
        ## nPr mod modulusを返す。不正なn,rには0を返す。時間O(Σ log_p(n + 1))。
        if n < 0 or r < 0 or n < r:
            return 0
        for f in c.factors:
            result = (result + f.factorialRatio(n, n - r, 0) * f.coefficient) mod c.modulus

    proc nhr*(c: CombinationArbitraryMod, n, r: int): int =
        ## nHr mod modulusを返す。n+r-1がintと前計算の範囲に収まる必要がある。時間O(Σ log_p(n + r))。
        if n < 0 or r < 0:
            return 0
        if r == 0:
            return 1 mod c.modulus
        if n == 0:
            return 0
        assert n <= high(int) - (r - 1), "n+r-1がintの範囲を超えています"
        return c.ncr(n + (r - 1), r)
