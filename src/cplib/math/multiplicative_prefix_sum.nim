when not declared CPLIB_MATH_MULTIPLICATIVE_PREFIX_SUM:
    const CPLIB_MATH_MULTIPLICATIVE_PREFIX_SUM* = 1
    import cplib/math/isqrt
    import cplib/math/isprime
    import cplib/modint/modint

    proc multiplicativePolynomialValue[T](coefficients: openArray[T], n: int): T =
        ## 昇冪順の多項式を Horner 法で評価する。O(次数)。
        let x = init(T, n)
        for i in countdown(coefficients.len - 1, 0):
            result = result * x + coefficients[i]

    proc multiplicativePowerSumPolynomials[T](degree: int): seq[seq[T]] =
        ## sum(k=1..n, k^j) の多項式を j=0..degree について作る。O(degree^3)。
        for j in 0..degree:
            var binomial = newSeq[T](j + 2)
            binomial[0] = init(T, 1)
            for k in 1..j + 1:
                binomial[k] = binomial[k - 1] * (j + 2 - k) / k
            var polynomial = binomial
            polynomial[0] -= 1
            for k in 0..<j:
                for t in 0..<result[k].len:
                    polynomial[t] -= binomial[k] * result[k][t]
            let inverse = init(T, j + 1).inv
            for x in polynomial.mitems:
                x *= inverse
            result.add(polynomial)

    proc multiplicativePrefixSum*[T: BarrettModint or MontgomeryModint](
            n: int, primeCoefficients: openArray[T],
            primePower: proc(p, e: int): T {.closure.}): T =
        ## f(1)+...+f(n) を求める。固定次数・O(1) の primePower に対し時間 O~(n^(3/4))、空間 O(sqrt(n))。
        ## f(p)=sum(j, primeCoefficients[j]*p^j)。primePower は e>=2 の f(p^e) を返す。
        ## 0 <= n <= 2^40。素数法は多項式の次数+1より大きい必要がある。
        assert n >= 0, "n は非負である必要があります"
        assert n <= (1'i64 shl 40), "n は 2^40 以下である必要があります"
        assert isprime(T.umod), "法は素数である必要があります"
        if n == 0:
            return init(T, 0)
        if n == 1:
            return init(T, 1)

        var coefficients = @primeCoefficients
        while coefficients.len > 0 and coefficients[^1].val == 0:
            coefficients.setLen(coefficients.len - 1)

        # 小さい入力では素因数分解表で直接計算する。
        if n <= 4096:
            var leastPrime = newSeq[int](n + 1)
            var values = newSeq[T](n + 1)
            values[1] = init(T, 1)
            result = values[1]
            for p in 2..n:
                if leastPrime[p] == 0:
                    for multiple in countup(p, n, p):
                        if leastPrime[multiple] == 0:
                            leastPrime[multiple] = p
                var rest = p
                let prime = leastPrime[p]
                var exponent = 0
                while rest mod prime == 0:
                    rest = rest div prime
                    inc exponent
                let value = if exponent == 1:
                                multiplicativePolynomialValue(coefficients, prime)
                            else: primePower(prime, exponent)
                values[p] = values[rest] * value
                result += values[p]
            return

        assert coefficients.len < T.umod.int,
            "法は多項式の次数+1より大きい必要があります"
        let root = isqrt(n)
        let largeCount = n div (root + 1)
        var composite = newSeq[bool](root + 1)
        var primes: seq[int]
        for p in 2..root:
            if composite[p]: continue
            primes.add(p)
            if p <= root div p:
                for multiple in countup(p * p, root, p):
                    composite[multiple] = true

        # small[x] と large[i] に、x および floor(n/i) 以下の素数での値の和を持つ。
        var small = newSeq[T](root + 1)
        var large = newSeq[T](largeCount + 1)
        let powerSums = multiplicativePowerSumPolynomials[T](coefficients.len - 1)
        for degree, coefficient in coefficients:
            if coefficient.val == 0: continue
            var low = newSeq[T](root + 1)
            var high = newSeq[T](largeCount + 1)
            for x in 1..root:
                low[x] = multiplicativePolynomialValue(powerSums[degree], x) - 1
            for i in 1..largeCount:
                high[i] = multiplicativePolynomialValue(powerSums[degree], n div i) - 1
            # p より小さい素因数を除去済みの表から、最小素因数が p の合成数を除く。
            for p in primes:
                let weight = init(T, p).pow(degree)
                let before = low[p - 1]
                let bound = min(largeCount, n div (p * p))
                var ip = p
                for i in 1..bound:
                    let previous = if ip <= largeCount: high[ip]
                                   else: low[n div ip]
                    high[i] -= weight * (previous - before)
                    ip += p
                for x in countdown(root, p * p):
                    low[x] -= weight * (low[x div p] - before)
            for x in 1..root:
                small[x] += coefficient * low[x]
            for i in 1..largeCount:
                large[i] += coefficient * high[i]

        # コールバックの評価を素数冪ごとに一度に抑え、値を連続した配列に保存する。
        var offsets = newSeq[int](primes.len)
        var values: seq[T]
        var primePrefix = newSeq[T](primes.len + 1)
        for i, p in primes:
            offsets[i] = values.len
            let value = multiplicativePolynomialValue(coefficients, p)
            primePrefix[i + 1] = primePrefix[i] + value
            values.add(value)
            var power = p
            var e = 1
            while power <= n div p:
                power *= p
                inc e
                values.add(primePower(p, e))

        var answer = init(T, 1) + large[1]
        proc visit(limit, start: int, weight: T) =
            ## 最小素因数とその指数を固定し、合成数の寄与を加算する。
            if weight.val == 0: return
            var i = start
            while i < primes.len and primes[i] * primes[i] <= limit:
                let p = primes[i]
                var power = p
                var e = 1
                while power <= limit div p:
                    let remaining = limit div power
                    let value = weight * values[offsets[i] + e - 1]
                    let primeSum = if remaining <= root: small[remaining]
                                   else: large[n div remaining]
                    # p^(e+1) 単独と、p^e に p より大きい素数を一つ掛ける場合をまとめる。
                    answer += weight * values[offsets[i] + e] +
                              value * (primeSum - primePrefix[i + 1])
                    visit(remaining, i + 1, value)
                    power *= p
                    inc e
                inc i
        visit(n, 0, init(T, 1))
        result = answer
