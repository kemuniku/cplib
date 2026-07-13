when not declared CPLIB_MATH_ERATOSTHENES:
    const CPLIB_MATH_ERATOSTHENES* = 1

    const
        wheelResidues = [1, 7, 11, 13, 17, 19, 23, 29]
        wheelSteps = [6, 4, 2, 4, 2, 4, 6, 2]
        residueToBit = [
            -1'i8, 0, -1, -1, -1, -1, -1, 1, -1, -1,
            -1, 2, -1, 3, -1, -1, -1, 4, -1, 5,
            -1, -1, -1, 6, -1, -1, -1, -1, -1, 7
        ]

    type Eratosthenes* = object
        ## Inclusive prime sieve.  Each byte represents the eight integers
        ## `30k + {1, 7, 11, 13, 17, 19, 23, 29}`.
        limit*: int
        flags: seq[uint8]

    type SegmentedEratosthenes* = object
        ## Inclusive segmented sieve for `lower..upper`.
        lower*, upper*: int
        firstBlock: int
        flags: seq[uint8]

    proc initEratosthenes*(maxN: int): Eratosthenes =
        ## Builds a sieve for `0..maxN` using a mod-30 wheel.
        assert maxN >= 0
        result.limit = maxN
        result.flags = newSeq[uint8](maxN div 30 + 1)
        for i in 0..<result.flags.len:
            result.flags[i] = 0xff'u8
        result.flags[0] = result.flags[0] and not 1'u8 # 1 is not prime.

        var blockIndex = 0
        while blockIndex < result.flags.len:
            for bitIndex in 0..7:
                if (result.flags[blockIndex] and (1'u8 shl bitIndex)) == 0:
                    continue
                let p = blockIndex * 30 + wheelResidues[bitIndex]
                if p > maxN div p:
                    return

                # p*q visits only q coprime to 30.  Starting at q=p avoids
                # touching composites already removed by smaller primes.
                var composite = p * p
                var qWheelIndex = bitIndex
                while composite <= maxN:
                    let compositeBit = residueToBit[composite mod 30]
                    result.flags[composite div 30] =
                        result.flags[composite div 30] and
                        not (1'u8 shl compositeBit.int)
                    composite += p * wheelSteps[qWheelIndex]
                    qWheelIndex = (qWheelIndex + 1) and 7
            inc blockIndex

    proc isPrime*(sieve: Eratosthenes, n: int): bool {.inline.} =
        ## Returns whether `n` is prime.  Values outside the sieve are false.
        if n < 2 or n > sieve.limit:
            return false
        if n == 2 or n == 3 or n == 5:
            return true
        let bit = residueToBit[n mod 30]
        bit >= 0 and (sieve.flags[n div 30] and (1'u8 shl bit.int)) != 0

    proc `[]`*(sieve: Eratosthenes, n: int): bool {.inline.} =
        sieve.isPrime(n)

    iterator primes*(sieve: Eratosthenes): int =
        ## Iterates over all primes not greater than `sieve.limit`.
        for p in [2, 3, 5]:
            if p <= sieve.limit:
                yield p
        for blockIndex, byte in sieve.flags:
            for bitIndex in 0..7:
                if (byte and (1'u8 shl bitIndex)) != 0:
                    let p = blockIndex * 30 + wheelResidues[bitIndex]
                    if p >= 7 and p <= sieve.limit:
                        yield p

    proc primeList*(sieve: Eratosthenes): seq[int] =
        ## Materializes the primes in ascending order.
        for p in sieve.primes:
            result.add(p)

    proc countPrimes*(sieve: Eratosthenes): int =
        ## Counts the primes not greater than `sieve.limit`.
        for _ in sieve.primes:
            inc result

    proc initSegmentedEratosthenes*(lower, upper: int): SegmentedEratosthenes =
        ## Builds a mod-30 segmented sieve for the inclusive interval
        ## `lower..upper`.  Its memory usage is approximately
        ## `(upper - lower) / 30` bytes, plus the base sieve up to sqrt(upper).
        assert 0 <= lower and lower <= upper
        result.lower = lower
        result.upper = upper
        result.firstBlock = lower div 30
        let lastBlock = upper div 30
        result.flags = newSeq[uint8](lastBlock - result.firstBlock + 1)
        for i in 0..<result.flags.len:
            result.flags[i] = 0xff'u8

        # Integer square root without relying on floating-point rounding.
        var root = 0
        var bit = 1
        while bit <= upper div 4:
            bit = bit shl 2
        var remainder = upper
        while bit != 0:
            if remainder >= root + bit:
                remainder -= root + bit
                root = (root shr 1) + bit
            else:
                root = root shr 1
            bit = bit shr 2

        let base = initEratosthenes(root)
        let intervalStart = result.firstBlock * 30
        for p in base.primes:
            if p < 7:
                continue

            # Write p*q only for q coprime to 30.  This skips all multiples
            # already excluded by the 2/3/5 wheel.
            var q = max(p, (intervalStart + p - 1) div p)
            while residueToBit[q mod 30] < 0:
                inc q
            var qWheelIndex = residueToBit[q mod 30].int
            var composite = p * q
            while composite <= upper:
                let flagIndex = composite div 30 - result.firstBlock
                result.flags[flagIndex] = result.flags[flagIndex] and
                    not (1'u8 shl residueToBit[composite mod 30].int)
                composite += p * wheelSteps[qWheelIndex]
                qWheelIndex = (qWheelIndex + 1) and 7

    proc isPrime*(sieve: SegmentedEratosthenes, n: int): bool {.inline.} =
        ## Returns whether `n` in the represented interval is prime.
        if n < sieve.lower or n > sieve.upper or n < 2:
            return false
        if n == 2 or n == 3 or n == 5:
            return true
        let bit = residueToBit[n mod 30]
        bit >= 0 and
            (sieve.flags[n div 30 - sieve.firstBlock] and
             (1'u8 shl bit.int)) != 0

    proc `[]`*(sieve: SegmentedEratosthenes, n: int): bool {.inline.} =
        sieve.isPrime(n)

    iterator primes*(sieve: SegmentedEratosthenes): int =
        ## Iterates over the primes in the interval in ascending order.
        for p in [2, 3, 5]:
            if sieve.lower <= p and p <= sieve.upper:
                yield p
        for localBlock, byte in sieve.flags:
            let blockIndex = sieve.firstBlock + localBlock
            for bitIndex in 0..7:
                if (byte and (1'u8 shl bitIndex)) != 0:
                    let p = blockIndex * 30 + wheelResidues[bitIndex]
                    if p >= max(7, sieve.lower) and p <= sieve.upper:
                        yield p

    proc primeList*(sieve: SegmentedEratosthenes): seq[int] =
        for p in sieve.primes:
            result.add(p)

    proc countPrimes*(sieve: SegmentedEratosthenes): int =
        for _ in sieve.primes:
            inc result
