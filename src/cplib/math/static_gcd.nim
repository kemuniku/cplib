when not declared CPLIB_MATH_STATIC_GCD:
    const CPLIB_MATH_STATIC_GCD* = 1

    type StaticGCD* = object
        width: int
        factors: seq[array[3, int]]
        smallGcd: seq[int]

    proc initStaticGCD*(maxValue: int): StaticGCD =
        ## 0..maxValue の整数同士の gcd を求める表を、時間・空間 O(maxValue) で構築する。
        assert maxValue >= 0, "上限は非負である必要があります"
        result.factors = newSeq[array[3, int]](maxValue + 1)
        if maxValue >= 1:
            result.factors[1] = [1, 1, 1]
        var primes: seq[int]
        for x in 2..maxValue:
            if result.factors[x][0] == 0:
                primes.add(x)
                result.factors[x] = [1, 1, x]
            for p in primes:
                if p > maxValue div x:
                    break
                var factors = result.factors[x]
                factors[0] *= p
                if factors[0] > factors[1]:
                    swap(factors[0], factors[1])
                if factors[1] > factors[2]:
                    swap(factors[1], factors[2])
                result.factors[x * p] = factors
                if x mod p == 0:
                    break

        var root = 0
        while root + 1 <= maxValue div (root + 1):
            inc root
        result.width = root + 1
        result.smallGcd = newSeq[int](result.width * result.width)
        for a in 1..root:
            result.smallGcd[a * result.width] = a
            result.smallGcd[a] = a
            result.smallGcd[a * result.width + a] = a
            for b in 1..<a:
                let g = result.smallGcd[b * result.width + a mod b]
                result.smallGcd[a * result.width + b] = g
                result.smallGcd[b * result.width + a] = g

    proc gcd*(table: StaticGCD, a, b: int): int {.inline.} =
        ## 0 <= a, b <= maxValue の gcd を O(1) で返す。gcd(0, 0) = 0。
        assert a >= 0 and a < table.factors.len, "a は前計算の範囲内である必要があります"
        assert b >= 0 and b < table.factors.len, "b は前計算の範囲内である必要があります"
        if a == 0:
            return b
        if b == 0:
            return a
        var remaining = b
        result = 1
        for factor in table.factors[a]:
            if factor == 1:
                continue
            let remainder = remaining mod factor
            let g = if factor < table.width:
                        table.smallGcd[factor * table.width + remainder]
                    elif remainder == 0: factor
                    else: 1
            result *= g
            remaining = remaining div g
