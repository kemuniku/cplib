when not declared CPLIB_MODINT_MODFAST:
    const CPLIB_MODINT_MODFAST* = 1

    import std/[random, tables]
    import cplib/math/primitive_root
    import cplib/modint/modint

    const
        ModFastK = 1 shl 21
        ModFastBucketBits = 10
        ModFastBucketSize = 1 shl ModFastBucketBits
        ModFastPowBits = 15
        ModFastPowSize = 1 shl ModFastPowBits
        ModFastBsgsSize = 1 shl 17

    type ModFast*[ModInt] = object
        ## `ModInt.mod` must be an odd prime smaller than 2^30.
        ## Construction takes O(p^(2/3)) memory and sublinear expected time;
        ## inv, log and pow queries take O(1) time.
        root*: ModInt
        powLow, powHigh: seq[ModInt]
        fracA, fracB: seq[uint16]
        logarithm: seq[int32]
        inverse: seq[ModInt]

    proc powRoot[ModInt](self: ModFast[ModInt], exponent: int): ModInt {.inline.} =
        var exponent = exponent mod (ModInt.mod.int - 1)
        if exponent < 0: exponent += ModInt.mod.int - 1
        self.powLow[exponent and (ModFastPowSize - 1)] *
            self.powHigh[exponent shr ModFastPowBits]

    proc buildPow[ModInt](self: var ModFast[ModInt]) =
        self.powLow = newSeq[ModInt](ModFastPowSize + 1)
        self.powHigh = newSeq[ModInt](ModFastPowSize + 1)
        self.powLow[0] = init(ModInt, 1)
        self.powHigh[0] = init(ModInt, 1)
        for i in 0..<ModFastPowSize:
            self.powLow[i + 1] = self.powLow[i] * self.root
        let step = self.powLow[ModFastPowSize]
        for i in 0..<ModFastPowSize:
            self.powHigh[i + 1] = self.powHigh[i] * step

    proc buildInverse[ModInt](self: var ModFast[ModInt]) =
        let p = ModInt.mod.int
        self.inverse = newSeq[ModInt](2 * ModFastK + 1)
        self.inverse[ModFastK + 1] = init(ModInt, 1)
        for i in 2..ModFastK:
            let q = (p + i - 1) div i
            self.inverse[ModFastK + i] = self.inverse[ModFastK + i * q - p] * q
        for i in 1..ModFastK:
            self.inverse[ModFastK - i] = -self.inverse[ModFastK + i]

    proc leastPrimeFactorTable(n: int): seq[int32] =
        result = newSeq[int32](n + 1)
        for i in 2..n:
            if result[i] != 0: continue
            result[i] = i.int32
            if i <= n div i:
                var j = i * i
                while j <= n:
                    if result[j] == 0: result[j] = i.int32
                    j += i

    proc buildLog[ModInt](self: var ModFast[ModInt]) =
        let p = ModInt.mod.int
        let order = p - 1
        let lpf = leastPrimeFactorTable(ModFastK)
        self.logarithm = newSeq[int32](2 * ModFastK + 1)

        var baby = initTable[int, int32](ModFastBsgsSize * 2)
        var value = init(ModInt, 1)
        for k in 0..<ModFastBsgsSize:
            baby[value.val] = k.int32
            value *= self.root
        let giantStep = self.powRoot(order - ModFastBsgsSize)

        proc bsgs(x: int): int =
            var value = init(ModInt, x)
            var offset = 0
            while true:
                if value.val in baby:
                    return (offset + baby[value.val].int) mod order
                value *= giantStep
                offset += ModFastBsgsSize

        self.logarithm[ModFastK + 1] = 0
        for i in 2..ModFastK:
            let q = lpf[i].int
            if q < i:
                self.logarithm[ModFastK + i] =
                    ((self.logarithm[ModFastK + q].int +
                      self.logarithm[ModFastK + i div q].int) mod order).int32
            elif i < 100:
                self.logarithm[ModFastK + i] = bsgs(i).int32
            elif i > p div i:
                let j = p div i
                let k = p mod i
                self.logarithm[ModFastK + i] =
                    ((self.logarithm[ModFastK + k].int + order div 2 + order -
                      self.logarithm[ModFastK + j].int) mod order).int32
            else:
                while true:
                    let exponent = rand(0..<order)
                    var ans = order - exponent
                    var x = (init(ModInt, i) * self.powRoot(exponent)).val
                    template divide(q: int) =
                        let divisor = q
                        x = x div divisor
                        ans += self.logarithm[ModFastK + divisor].int
                    for q in [2, 3, 5, 7, 11, 13, 17, 19]:
                        while x mod q == 0: divide(q)
                    if x >= ModFastK: continue
                    while i < x and lpf[x].int < i: divide(lpf[x].int)
                    if 1 < x and x < i: divide(x)
                    if x == 1:
                        self.logarithm[ModFastK + i] = (ans mod order).int32
                        break
        for i in 1..ModFastK:
            self.logarithm[ModFastK - i] =
                ((self.logarithm[ModFastK + i].int + order div 2) mod order).int32

    proc buildFrac[ModInt](self: var ModFast[ModInt]) =
        let p = ModInt.mod.int
        let buckets = (p - 1) shr ModFastBucketBits
        self.fracA = newSeq[uint16](buckets + 1)
        self.fracB = newSeq[uint16](buckets + 1)
        var stack = @[(0, 1, 1, 1)]
        while stack.len > 0:
            let (aa, bb, cc, dd) = stack.pop
            if bb + dd < 2048:
                stack.add((aa + cc, bb + dd, cc, dd))
                stack.add((aa, bb, aa + cc, bb + dd))
                continue
            let s = aa * p div (ModFastBucketSize * bb)
            let t = cc * p div (ModFastBucketSize * dd)
            self.fracA[s] = aa.uint16
            self.fracB[s] = bb.uint16
            self.fracA[t] = cc.uint16
            self.fracB[t] = dd.uint16
            let a = min(aa, cc).uint16
            let b = min(bb, dd).uint16
            for i in (s + 1)..<t:
                self.fracA[i] = a
                self.fracB[i] = b

    proc initModFast*[ModInt](T: typedesc[ModInt], root = 0): ModFast[ModInt] =
        ## `root == 0` chooses a primitive root automatically.
        let p = T.mod.int
        assert p > ModFastK * 2 and p < (1 shl 30)
        result.root = init(ModInt, if root == 0: primitive_root(p) else: root)
        result.buildPow
        result.buildInverse
        result.buildLog
        result.buildFrac

    proc log*[ModInt](self: ModFast[ModInt], x: ModInt): int {.inline.} =
        ## Returns e in [0, p-2] such that root^e == x.
        assert x.val != 0
        let v = x.val
        let bucket = v shr ModFastBucketBits
        let a = self.fracA[bucket].int
        let b = self.fracB[bucket].int
        let t = v * b - a * ModInt.mod.int
        (self.logarithm[ModFastK + t].int + ModInt.mod.int - 1 -
            self.logarithm[ModFastK + b].int) mod (ModInt.mod.int - 1)

    proc inv*[ModInt](self: ModFast[ModInt], x: ModInt): ModInt {.inline.} =
        assert x.val != 0
        let v = x.val
        let bucket = v shr ModFastBucketBits
        let a = self.fracA[bucket].int
        let b = self.fracB[bucket].int
        let t = v * b - a * ModInt.mod.int
        self.inverse[ModFastK + t] * b

    proc pow*[ModInt](self: ModFast[ModInt], x: ModInt, exponent: int): ModInt {.inline.} =
        ## Negative exponents are supported for nonzero x.
        if x.val == 0:
            assert exponent >= 0
            return init(ModInt, if exponent == 0: 1 else: 0)
        self.powRoot(self.log(x) * (exponent mod (ModInt.mod.int - 1)))
