when not declared CPLIB_MATH_MULTIPLICATIVE_PREFIX_SUM:
    const CPLIB_MATH_MULTIPLICATIVE_PREFIX_SUM* = 1

    proc multiplicativePrefixSum*[T](
        n: int,
        primePrefixSum: proc(x: int): T,
        primePower: proc(p, exponent: int): T
    ): T =
        ## Returns `sum(f(i), i = 1..n)` for a multiplicative function `f`.
        ##
        ## `primePrefixSum(x)` must return `sum(f(p), p <= x)` over primes,
        ## and `primePower(p, e)` must return `f(p^e)`.  In particular,
        ## `primePower(p, 1)` and the terms used by `primePrefixSum` must agree.
        ## The value of `f(1)` is assumed to be `1` (`T(1)`).
        ##
        ## The number of arithmetic operations is O(n^(3/4) / log n), apart
        ## from calls to `primePrefixSum`, and O(sqrt(n) / log n) memory is used.
        if n <= 0:
            return T(0)

        var limit = 0
        while limit + 1 <= n div (limit + 1):
            inc limit

        var isPrime = newSeq[bool](limit + 1)
        for i in 2..limit:
            isPrime[i] = true
        var primes: seq[int]
        for i in 2..limit:
            if isPrime[i]:
                primes.add(i)
                if i <= limit div i:
                    var j = i * i
                    while j <= limit:
                        isPrime[j] = false
                        j += i

        proc dfs(x, primeIndex: int): T =
            result = T(1)
            # All primes before primeIndex are excluded.  primeIndex may equal
            # primes.len (and for n < 4 the sieve itself may be empty), so use
            # the preceding prime instead of looking at primes[primeIndex].
            if primeIndex == 0:
                result += primePrefixSum(x)
            elif primes[primeIndex - 1] < x:
                result += primePrefixSum(x) - primePrefixSum(primes[primeIndex - 1])

            var i = primeIndex
            while i < primes.len and primes[i] <= x div primes[i]:
                let p = primes[i]

                # exponent = 1 is already present once in primePrefixSum.
                result += primePower(p, 1) * (dfs(x div p, i + 1) - T(1))

                var exponent = 2
                var power = p * p
                while power <= x:
                    result += primePower(p, exponent) * dfs(x div power, i + 1)
                    if power > x div p:
                        break
                    power *= p
                    inc exponent
                inc i

        result = dfs(n, 0)
