when not declared CPLIB_MATH_ONLINE_COMBINATION_PREFIX_SUM:
    const CPLIB_MATH_ONLINE_COMBINATION_PREFIX_SUM* = 1

    import cplib/math/combination
    import cplib/math/isqrt

    type OnlineCombinationPrefixSum*[ModInt] = object
        maxN, width: int
        modulus: uint32
        fact, factInv: seq[ModInt]
        powersOfTwo: seq[ModInt]
        samples: seq[seq[ModInt]]

    proc choose[ModInt](self: OnlineCombinationPrefixSum[ModInt], n, k: int): ModInt =
        ## 前計算済み階乗から nCk を O(1) で返す。
        if k < 0 or k > n:
            return ModInt(0)
        return self.fact[n] * self.factInv[k] * self.factInv[n - k]

    proc initOnlineCombinationPrefixSum*[ModInt](maxN: int): OnlineCombinationPrefixSum[ModInt] =
        ## 0 <= n <= maxN のオンライン二項係数和を前計算する。時間 O(N sqrt(N))、空間 O(N)。
        if maxN < 0 or uint64(maxN) >= uint64(ModInt.umod()):
            raise newException(ValueError, "0 <= maxN < 法 が必要です（法は素数）")
        result.maxN = maxN
        result.width = isqrt(maxN) + 1
        result.modulus = uint32(ModInt.umod())
        let combination = initCombination[ModInt](maxN)
        result.fact = combination.fact
        result.factInv = combination.fact_inv
        result.powersOfTwo = newSeq[ModInt](maxN + 1)
        result.powersOfTwo[0] = 1
        for n in 1..maxN:
            result.powersOfTwo[n] = result.powersOfTwo[n - 1] * 2
        result.samples = newSeq[seq[ModInt]](maxN div result.width + 1)
        for row in 0..<result.samples.len:
            let n = row * result.width
            result.samples[row] = newSeq[ModInt](row + 1)
            var sum: ModInt = 0
            for k in 0..n:
                sum += result.choose(n, k)
                if k mod result.width == 0:
                    result.samples[row][k div result.width] = sum

    proc prefixSum*[ModInt](self: OnlineCombinationPrefixSum[ModInt], n, k: int): ModInt =
        ## sum(i=0..k, nCi)（右端を含む）を O(sqrt(N)) 時間、O(1) 補助空間で返す。
        if n < 0 or n > self.maxN:
            raise newException(ValueError, "0 <= n <= maxN が必要です")
        if uint32(ModInt.umod()) != self.modulus:
            raise newException(ValueError, "構築後に法を変更してはいけません")
        if k < 0:
            return ModInt(0)
        if k >= n:
            return self.powersOfTwo[n]
        let
            row = n div self.width
            column = k div self.width
            baseN = row * self.width
            baseK = column * self.width
        result = self.samples[row][column]
        for x in baseN..<n:
            result = result * 2 - self.choose(x, baseK)
        for y in (baseK + 1)..k:
            result += self.choose(n, y)

    proc rangeSum*[ModInt](self: OnlineCombinationPrefixSum[ModInt], n, l, r: int): ModInt =
        ## sum(i=l..<r, nCi)（右端を含まない）を O(sqrt(N)) 時間で返す。l >= r なら 0。
        let right = self.prefixSum(n, if r <= 0: -1 else: r - 1)
        if l >= r:
            return ModInt(0)
        let left = self.prefixSum(n, if l <= 0: -1 else: l - 1)
        return right - left
