when not declared CPLIB_MATH_ONLINE_COMBINATION_PREFIX_SUM:
    const CPLIB_MATH_ONLINE_COMBINATION_PREFIX_SUM* = 1

    import cplib/math/combination
    import cplib/math/isqrt

    type OnlineCombinationPrefixSum*[ModInt] = object
        maxN, width: int
        modulus: uint32
        fact, factInv: seq[ModInt]
        powersOfTwo, halfScaledFact: seq[ModInt]
        samples: seq[seq[ModInt]]

    proc initOnlineCombinationPrefixSum*[ModInt](maxN: int): OnlineCombinationPrefixSum[ModInt] =
        ## 0 <= n <= maxN のオンライン二項係数和を前計算する。時間 O(N sqrt(N))、空間 O(N)。
        ## 素数法 p（素数性の判定なし）と 0 <= maxN < p が必要。範囲外は ValueError。
        ## dynamic modint の法は構築前に設定し、使用中は変更しない。
        ## N=0 も対応。オブジェクトは必ずこのコンストラクタで生成する。
        ## 幅 B=floor(sqrt(N))+1 として S(aB,bB)/2^(aB), 0<=b<=a を保存する。
        ## 表は m(m+1)/2 要素（m=floor(N/B)+1）で O(N+1) 空間。
        ## 半行走査により O(N+N^2/B) 時間。クエリ列の事前取得・整列は不要。
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
        # 法が2なら n<=1 であり、クエリはすべて端点の分岐で処理できる。
        if result.modulus == 2:
            return
        let half = ModInt(int((uint64(result.modulus) + 1) div 2))
        var inversePowersOfTwo = newSeq[ModInt](maxN + 1)
        inversePowersOfTwo[0] = 1
        for n in 1..maxN:
            inversePowersOfTwo[n] = inversePowersOfTwo[n - 1] * half
        result.halfScaledFact = newSeq[ModInt](maxN + 1)
        for n in 0..maxN:
            result.halfScaledFact[n] = result.fact[n] * inversePowersOfTwo[n] * half
        result.samples = newSeq[seq[ModInt]](maxN div result.width + 1)
        for row in 0..<result.samples.len:
            let n = row * result.width
            result.samples[row] = newSeq[ModInt](row + 1)
            let rowFact = result.fact[n]
            var sum: ModInt = 0
            var nextLow = 0
            var lowColumn = 0
            var nextHigh = result.width - 1
            var highColumn = row - 1
            result.samples[row][row] = result.powersOfTwo[n]
            # n! は保存時だけ掛け、前半の和から対称な後半の prefix も求める。
            for k in 0..(n div 2):
                sum += result.factInv[k] * result.factInv[n - k]
                if k == nextLow:
                    result.samples[row][lowColumn] = sum * rowFact
                    inc lowColumn
                    nextLow += result.width
                # 反射元は (row - 列番号) * width - 1。剰余計算せず次の位置を持つ。
                if highColumn >= 0 and k == nextHigh:
                    result.samples[row][highColumn] = result.powersOfTwo[n] - sum * rowFact
                    dec highColumn
                    nextHigh += result.width
            for column in 0..row:
                result.samples[row][column] *= inversePowersOfTwo[n]

    proc prefixSum*[ModInt](self: OnlineCombinationPrefixSum[ModInt], n, k: int): ModInt =
        ## sum(i=0..k, nCi)（右端を含む）を O(sqrt(N)) 時間、O(1) 補助空間で返す。
        ## k<0 は0、k>=n は2^n。k は任意の int を受け取る。
        ## n が [0,maxN] 外、または現在の法が構築時と異なる場合は ValueError。
        ## 近い保存点から n,k の各方向へ移動する。端のブロックを除き各方向で約B/2回以内。
        if n < 0 or n > self.maxN:
            raise newException(ValueError, "0 <= n <= maxN が必要です")
        if uint32(ModInt.umod()) != self.modulus:
            raise newException(ValueError, "構築後に法を変更してはいけません")
        if k < 0:
            return ModInt(0)
        if k >= n:
            return self.powersOfTwo[n]
        if k == 0:
            return ModInt(1)
        let
            row = min((n + self.width div 2) div self.width, self.samples.len - 1)
            column = min((k + self.width div 2) div self.width, row)
            baseN = row * self.width
            baseK = column * self.width
        result = self.samples[row][column]
        # S(x+1,k)/2^(x+1) = S(x,k)/2^x - x!/(2^(x+1) k! (x-k)!)。
        var sum: ModInt = 0
        if baseN <= n:
            for x in baseN..<n:
                sum += self.halfScaledFact[x] * self.factInv[x - baseK]
            result -= sum * self.factInv[baseK]
        else:
            for x in max(n, baseK)..<baseN:
                sum += self.halfScaledFact[x] * self.factInv[x - baseK]
            result += sum * self.factInv[baseK]
        result *= self.powersOfTwo[n]
        sum = 0
        if baseK <= k:
            for y in (baseK + 1)..k:
                sum += self.factInv[y] * self.factInv[n - y]
            result += sum * self.fact[n]
        else:
            for y in (k + 1)..min(baseK, n):
                sum += self.factInv[y] * self.factInv[n - y]
            result -= sum * self.fact[n]

    proc rangeSum*[ModInt](self: OnlineCombinationPrefixSum[ModInt], n, l, r: int): ModInt =
        ## sum(i=l..<r, nCi)（右端を含まない）を O(sqrt(N)) 時間で返す。l >= r なら 0。
        ## [0,n] 外の項は0。l,r は low(int), high(int) を含む任意の int。
        ## 空・逆転区間でも n と現在の法を検査する。補助空間 O(1)。
        let right = self.prefixSum(n, if r <= 0: -1 else: r - 1)
        if l >= r:
            return ModInt(0)
        let left = self.prefixSum(n, if l <= 0: -1 else: l - 1)
        return right - left
