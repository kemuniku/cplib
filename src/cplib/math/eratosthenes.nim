when not declared CPLIB_MATH_ERATOSTHENES:
    const CPLIB_MATH_ERATOSTHENES* = 1
    import bitops

    const
        WheelResidues = [1, 7, 11, 13, 17, 19, 23, 29]
        WheelIndex = [ -1, 0, -1, -1, -1, -1, -1, 1, -1, -1,
                       -1, 2, -1, 3, -1, -1, -1, 4, -1, 5,
                       -1, -1, -1, 6, -1, -1, -1, -1, -1, 7 ]
        SieveBlockBytes = 32 * 1024
        PreSieveGroups = [[7, 11, 13], [17, 19, 1], [23, 29, 1],
                          [31, 37, 1], [41, 43, 1]]
        PreSievePrimes = [7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43]

    func makePreSieve(): seq[seq[uint8]] =
        ## 小素数の倍数を除く周期パターンをコンパイル時に生成する。
        for group in PreSieveGroups:
            let period = group[0] * group[1] * group[2]
            var pattern = newSeq[uint8](period)
            for q in 0..<period:
                var bits = 255'u8
                for i, r in WheelResidues:
                    for p in group:
                        if p > 1 and (30 * q + r) mod p == 0:
                            bits = bits and not (1'u8 shl i)
                pattern[q] = bits
            result.add(pattern)

    const PreSieve = makePreSieve()

    type
        EratosthenesSieve* = object
            first, last, firstByte: int
            bits: seq[uint8]
        SieveStrike = object
            prime: int
            next: array[8, int]
            masks: array[8, uint8]

    proc basePrimes(limit: int): seq[int] =
        ## limit 以下の基底素数を奇数篩で列挙する。O(limit log log limit) 時間。
        var composite = newSeq[bool](limit div 2 + 1)
        var p = 3
        while p <= limit div p:
            if not composite[p div 2]:
                var j = p * p div 2
                while j < composite.len:
                    composite[j] = true
                    j += p
            p += 2
        for i in 1..<composite.len:
            let p = 2 * i + 1
            if p <= limit and not composite[i]:
                result.add(p)

    # 内部で保証したブロック範囲だけを操作し、AND ループの自動ベクトル化を許す。
    {.push checks: off.}
    proc fillBlock(dst: ptr UncheckedArray[uint8], firstByte, size: int) =
        ## 周期パターンを連続領域ごとに AND 合成する。O(size) 時間。
        for g in 0..<PreSieve.len:
            let period = PreSieve[g].len
            var phase = firstByte mod period
            var pos = 0
            while pos < size:
                let n = min(period - phase, size - pos)
                if g == 0:
                    copyMem(addr dst[pos], unsafeAddr PreSieve[g][phase], n)
                else:
                    let source = cast[ptr UncheckedArray[uint8]](unsafeAddr PreSieve[g][phase])
                    let target = cast[ptr UncheckedArray[uint8]](addr dst[pos])
                    for i in 0..<n:
                        target[i] = target[i] and source[i]
                pos += n
                phase = 0

    proc strikeBlock(dst: ptr UncheckedArray[uint8], size: int, state: var SieveStrike) =
        ## 各剰余の倍数を定間隔で消し、次ブロックへの位置を保存する。
        let p = state.prime
        for r in 0..<8:
            var j = state.next[r]
            let mask = state.masks[r]
            while j + 3 * p < size:
                dst[j] = dst[j] and mask
                dst[j + p] = dst[j + p] and mask
                dst[j + 2 * p] = dst[j + 2 * p] and mask
                dst[j + 3 * p] = dst[j + 3 * p] and mask
                j += 4 * p
            while j < size:
                dst[j] = dst[j] and mask
                j += p
            state.next[r] = j - size
    {.pop.}

    proc initSegmentedEratosthenes*(low, high: int): EratosthenesSieve =
        ## 閉区間 [low, high] を篩う。0 <= low <= high。保持領域は約 (high-low)/30 byte。
        doAssert low >= 0 and low <= high
        result.first = low
        result.last = high
        result.firstByte = low div 30
        let endByte = high div 30
        when declared(newSeqUninit):
            result.bits = newSeqUninit[uint8](endByte - result.firstByte + 1)
        else:
            result.bits = newSeqUninitialized[uint8](endByte - result.firstByte + 1)
        var root = 0
        var step = 1 shl ((sizeof(int) * 8 - 2) div 2)
        while step > 0:
            let candidate = root + step
            if candidate <= high div candidate:
                root = candidate
            step = step shr 1
        var states: seq[SieveStrike]
        for p in basePrimes(root):
            if p <= PreSievePrimes[^1]:
                continue
            var state = SieveStrike(prime: p)
            for i, r in WheelResidues:
                let multiplier = uint64(p) + uint64((r - p mod 30 + 30) mod 30)
                let product = uint64(p) * multiplier
                var q = product div 30
                if q < uint64(result.firstByte):
                    let gap = uint64(result.firstByte) - q
                    q += ((gap + uint64(p) - 1) div uint64(p)) * uint64(p)
                state.next[i] = int(q) - result.firstByte
                state.masks[i] = not (1'u8 shl WheelIndex[int(product mod 30)])
            states.add(state)
        var pos = 0
        while pos < result.bits.len:
            let size = min(SieveBlockBytes, result.bits.len - pos)
            let dst = cast[ptr UncheckedArray[uint8]](addr result.bits[pos])
            fillBlock(dst, result.firstByte + pos, size)
            for state in states.mitems:
                strikeBlock(dst, size, state)
            pos += size
        for p in PreSievePrimes:
            if low <= p and p <= high:
                let q = p div 30 - result.firstByte
                result.bits[q] = result.bits[q] or (1'u8 shl WheelIndex[p mod 30])
        for i, r in WheelResidues:
            if r < low mod 30:
                result.bits[0] = result.bits[0] and not (1'u8 shl i)
            if r > high mod 30:
                result.bits[^1] = result.bits[^1] and not (1'u8 shl i)
        if low <= 1 and 1 <= high:
            result.bits[0] = result.bits[0] and not 1'u8

    proc initEratosthenes*(limit: int): EratosthenesSieve =
        ## 閉区間 [0, limit] の篩を構築する。保持領域は floor(limit/30)+1 byte。
        initSegmentedEratosthenes(0, limit)

    proc is_prime*(sieve: EratosthenesSieve, n: int): bool {.inline.} =
        ## 構築した閉区間内の素数判定を O(1) 時間で行う。範囲外は false。
        if n < sieve.first or n > sieve.last or n < 2:
            return false
        if n == 2 or n == 3 or n == 5:
            return true
        let bit = WheelIndex[n mod 30]
        bit >= 0 and (sieve.bits[n div 30 - sieve.firstByte] and (1'u8 shl bit)) != 0

    proc byte_size*(sieve: EratosthenesSieve): int {.inline.} =
        ## 素数判定用の圧縮配列の byte 数を O(1) 時間で返す。
        sieve.bits.len

    proc count_primes*(sieve: EratosthenesSieve): int =
        ## 区間内の素数の個数を O(区間長 / 30) 時間で返す。
        for p in [2, 3, 5]:
            if sieve.first <= p and p <= sieve.last:
                inc result
        for bits in sieve.bits:
            result += countSetBits(bits)

    iterator items*(sieve: EratosthenesSieve): int =
        ## 区間内の素数を昇順に O(区間長 / 30 + 素数の個数) 時間で列挙する。
        for p in [2, 3, 5]:
            if sieve.first <= p and p <= sieve.last:
                yield p
        for q, byte in sieve.bits:
            var bits = byte
            while bits != 0:
                let i = countTrailingZeroBits(bits)
                yield (sieve.firstByte + q) * 30 + WheelResidues[i]
                bits = bits and (bits - 1)

    proc collectPrimes(sieve: EratosthenesSieve): seq[int] =
        ## 篩内の素数を O(圧縮配列長 + 素数の個数) 時間で昇順の seq にする。
        let count = sieve.count_primes()
        when declared(newSeqUninit):
            result = newSeqUninit[int](count)
        else:
            result = newSeqUninitialized[int](count)
        var i = 0
        for p in sieve:
            result[i] = p
            inc i

    proc get_primes*(limit: int): seq[int] =
        ## limit 以下の素数を昇順の seq で返す。limit < 2 なら空列。
        if limit < 2:
            return @[]
        collectPrimes(initEratosthenes(limit))

    proc get_primes*(l, r: int): seq[int] =
        ## 半開区間 [l, r) の素数を区間篩で昇順の seq にする。l >= r なら空列。
        if l >= r or r <= 2:
            return @[]
        collectPrimes(initSegmentedEratosthenes(max(l, 2), r - 1))
