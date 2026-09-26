when not declared CPLIB_MATH_MULTIPLICATIVE_PREFIX_SUM:
    const CPLIB_MATH_MULTIPLICATIVE_PREFIX_SUM* = 1

    import algorithm, bitops
    import cplib/math/isqrt
    import cplib/math/isprime
    import cplib/modint/modint
    import cplib/fps/formal_power_series

    type MultiplicativeLogBuckets = object
        scale: int
        thresholds: seq[uint64]

    proc multiplicativeLogFraction(mantissa: uint64, bits: int): int =
        ## Q31 の仮数の対数を、下側から bits 桁の二進小数にする。O(bits)。
        var x = mantissa
        for _ in 0..<bits:
            x = (x * x) shr 31
            result = result shl 1
            if x >= (1'u64 shl 32):
                x = x shr 1
                inc result

    proc initMultiplicativeLogBuckets(scale: int): MultiplicativeLogBuckets =
        ## 対数区間の整数境界を構築する。scale は 2 の冪、2^20 以下。
        result.scale = scale
        result.thresholds = newSeq[uint64](scale + 1)
        result.thresholds[0] = 1'u64 shl 31
        result.thresholds[scale] = 1'u64 shl 32
        let bits = fastLog2(scale)
        for i in 1..<scale:
            var low = result.thresholds[i - 1]
            var high = 1'u64 shl 32
            while high - low > 1:
                let mid = (low + high) shr 1
                if multiplicativeLogFraction(mid, bits) >= i:
                    high = mid
                else:
                    low = mid
            result.thresholds[i] = high

    proc bucketIndex(buckets: MultiplicativeLogBuckets, n: int): int =
        ## 正整数 n の区間番号を返す。0 <= scale*log2(n)-番号 < 2。O(log scale)。
        let exponent = fastLog2(n)
        let mantissa = if exponent <= 31: n.uint64 shl (31 - exponent)
                       else: n.uint64 shr (exponent - 31)
        exponent * buckets.scale + buckets.thresholds.upperBound(mantissa) - 1

    proc bucketStart(buckets: MultiplicativeLogBuckets, index: int): int =
        ## 区間番号が index 以上になる最小の正整数を返す。O(1)。
        let exponent = index div buckets.scale
        let mantissa = buckets.thresholds[index mod buckets.scale]
        if exponent <= 31:
            let shift = 31 - exponent
            return ((mantissa + (1'u64 shl shift) - 1) shr shift).int
        (mantissa shl (exponent - 31)).int

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
        ## f(1)+...+f(n) を求める。固定次数・O(1) の primePower に対し時間・空間とも O~(sqrt(n))。
        ## f(p)=sum(j, primeCoefficients[j]*p^j)。primePower は e>=2 の f(p^e) を返す。
        ## 素数法の cplib modint を使用する。詳細な制約と計算量は同名の .md を参照。
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

        # 小さい入力では対数区間を構築せず、素因数分解表で計算する。
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

        let root = isqrt(n)
        var scale = 1
        while scale < root:
            scale = scale shl 1
        scale = max(64, scale shr 1)
        # FPS と任意 mod 畳み込みの変換長上限を、確保前に確認する。
        assert (fastLog2(n) + 1) * scale <= (1 shl 23),
            "対数区間数が畳み込みの上限を超えています"
        let buckets = initMultiplicativeLogBuckets(scale)
        let last = buckets.bucketIndex(n)
        let length = last + 1
        assert max(length, coefficients.len + 1) < T.umod.int,
            "法は対数区間数および多項式の次数+2より大きい必要があります"

        # Q31 の丸め誤差も含め、境界の両側で過不足を補正する。
        let low = buckets.bucketStart(max(0, last - 2))
        var composite = newSeq[bool](root + 1)
        var primes: seq[int]
        for p in 2..root:
            if composite[p]:
                continue
            primes.add(p)
            if p <= root div p:
                for multiple in countup(p * p, root, p):
                    composite[multiple] = true

        # B*log2(p) <= k(p)*(1+errorRatio/2^20) を整数だけで評価する。
        # 畳み込みに入る積は B*log2(m) < last*(1+errorRatio/2^20)+2 を満たす。
        const precision = 1 shl 20
        var primeIndices = newSeq[int](primes.len)
        var errorRatio = 0
        for i, p in primes:
            let index = buckets.bucketIndex(p)
            primeIndices[i] = index
            let exponent = fastLog2(p)
            let fineIndex = exponent * precision +
                multiplicativeLogFraction(p.uint64 shl (31 - exponent), 20)
            let error = scale * (fineIndex + 2) - index * precision
            errorRatio = max(errorRatio, (error + index - 1) div index)
        let excess = (last * errorRatio + precision - 1) div precision + 3
        let high = buckets.bucketStart(last + excess) - 1
        let maxExponent = fastLog2(high)
        var inverses = newSeq[T](maxExponent + 1)
        for e in 1..maxExponent:
            inverses[e] = init(T, e).inv
        var primeValues = newSeq[seq[T]](primes.len)
        var smoothLog = newSeq[T](length)
        for i, p in primes:
            let index = primeIndices[i]
            var values = @[init(T, 1)]
            var power = 1
            while power <= high div p:
                power *= p
                let exponent = values.len
                values.add(if power > n: init(T, 0)
                           elif exponent == 1: multiplicativePolynomialValue(coefficients, p)
                           else: primePower(p, exponent))
            primeValues[i] = values
            let count = last div index
            var localLog = newSeq[T](count + 1)
            for e in 1..count:
                var value = if e < values.len: values[e] else: init(T, 0)
                for k in 1..<e:
                    if e - k < values.len:
                        value -= localLog[k] * k * values[e - k] * inverses[e]
                localLog[e] = value
                smoothLog[e * index] += value

        var smoothCoefficient = init(T, 1)
        for coefficient in coefficients:
            smoothCoefficient -= coefficient
        if smoothCoefficient.val != 0:
            let smooth = smoothLog.exp(length)
            var total = init(T, 0)
            for value in smooth:
                total += value
            result += smoothCoefficient * total

        let powerSums = multiplicativePowerSumPolynomials[T](coefficients.len - 1)
        var ends = newSeq[int](length)
        for k in 0..<length:
            ends[k] = buckets.bucketStart(k + 1) - 1
        var correctionValues = newSeq[seq[seq[T]]](coefficients.len)
        for degree, coefficient in coefficients:
            if coefficient.val == 0:
                continue
            var logarithm = smoothLog
            correctionValues[degree] = newSeq[seq[T]](primes.len)
            for i, p in primes:
                let weight = init(T, p).pow(degree)
                let index = primeIndices[i]
                var power = init(T, 1)
                for e in 1..last div index:
                    power *= weight
                    logarithm[e * index] -= power * inverses[e]
                correctionValues[degree][i] = newSeq[T](primeValues[i].len)
                correctionValues[degree][i][0] = init(T, 1)
                for e in 1..<primeValues[i].len:
                    correctionValues[degree][i][e] = primeValues[i][e] - weight * primeValues[i][e - 1]
            let smooth = logarithm.exp(length)
            var total = init(T, 0)
            for k in 0..<length:
                total += smooth[k] * multiplicativePolynomialValue(powerSums[degree], ends[last - k])
            result += coefficient * total

        # 補正区間はブロックごとに篩い、素因数分解結果の保持量を抑える。
        type Factor = tuple[primeIndex, exponent: int]
        var start = low
        while start <= high:
            let finish = min(high, start + max(root, 4096) - 1)
            var factors = newSeq[seq[Factor]](finish - start + 1)
            var remainders = newSeq[int](factors.len)
            for i in 0..<remainders.len:
                remainders[i] = start + i
            for i, p in primes:
                let first = start + (p - start mod p) mod p
                for multiple in countup(first, finish, p):
                    let offset = multiple - start
                    var exponent = 0
                    while remainders[offset] mod p == 0:
                        remainders[offset] = remainders[offset] div p
                        inc exponent
                    factors[offset].add((i, exponent))

            if smoothCoefficient.val != 0:
                var total = init(T, 0)
                for offset in 0..<factors.len:
                    if remainders[offset] != 1:
                        continue
                    var index = 0
                    var value = init(T, 1)
                    for (i, e) in factors[offset]:
                        index += e * primeIndices[i]
                        value *= primeValues[i][e]
                    if start + offset <= n:
                        total += value
                    if index <= last:
                        total -= value
                result += smoothCoefficient * total

            for degree, coefficient in coefficients:
                if coefficient.val == 0:
                    continue
                var total = init(T, 0)
                for offset in 0..<factors.len:
                    let inside = start + offset <= n
                    proc correct(position, rest, index: int, weight: T) =
                        ## 小素数のみからなる約数を列挙し、区間境界での過不足を補正する。
                        if weight.val == 0:
                            return
                        if position == factors[offset].len:
                            let included = index + buckets.bucketIndex(rest) <= last
                            if included != inside:
                                let value = weight * init(T, rest).pow(degree)
                                if inside: total += value
                                else: total -= value
                            return
                        let (i, exponent) = factors[offset][position]
                        var remaining = rest
                        var shifted = index
                        for e in 0..exponent:
                            correct(position + 1, remaining, shifted,
                                weight * correctionValues[degree][i][e])
                            if e < exponent:
                                remaining = remaining div primes[i]
                                shifted += primeIndices[i]
                    correct(0, start + offset, 0, init(T, 1))
                result += coefficient * total
            start = finish + 1
