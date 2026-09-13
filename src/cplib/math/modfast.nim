when not declared CPLIB_MATH_MODFAST:
    ## 素数法の逆元・原始根を底とする離散対数・累乗を、前計算後 O(1) で求める。
    ## 使用例: let table = initModFast[modint1000000007_barrett]()
    ## table.inv(2), table.log(2), table.pow(2, 100), table.powRoot(100)
    ## log の底は table.root で取得する。底は構築ごとに異なる場合がある。
    const CPLIB_MATH_MODFAST* = 1

    import random
    import cplib/math/primitive_root
    import cplib/modint/modint

    # https://maspypy.com/o1-mod-inv-mod-pow
    # 64 bit 環境用。法は 2 <= p < 2^30 の素数を指定する。
    type ModFast*[T: BarrettModint or MontgomeryModint] = object
        modulus, generator, bucketShift, powerShift: int
        fractions: seq[tuple[a, b: uint16]]
        logarithms, powerLow, powerHigh: seq[uint32]

    proc p*[T](self: ModFast[T]): int {.inline.} =
        ## 構築時の素数法を返す。O(1)。
        self.modulus

    proc checkModulus[T](self: ModFast[T]) {.inline.} =
        ## 動的 modint の法が構築時から変わっていないことを確認する。O(1)。
        assert self.modulus == T.umod.int, "構築時と同じ法を使用してください"

    proc root*[T](self: ModFast[T]): T {.inline.} =
        ## 対数の底として使う原始根を返す。O(1)。
        self.checkModulus()
        init(T, self.generator)

    proc powerRaw[T](self: ModFast[T], exponent: int): int {.inline.} =
        ## 0 <= exponent < p-1 に対して原始根の累乗を返す。O(1)。
        int(self.powerLow[exponent and ((1 shl self.powerShift) - 1)]) *
            int(self.powerHigh[exponent shr self.powerShift]) mod self.modulus

    proc powRoot*[T](self: ModFast[T], exponent: int): T {.inline.} =
        ## 原始根の exponent 乗を返す。負の指数も許す。O(1)。
        self.checkModulus()
        var e = exponent mod (self.modulus - 1)
        if e < 0: e += self.modulus - 1
        init(T, self.powerRaw(e))

    proc log*[T](self: ModFast[T], x: T or int): int {.inline.} =
        ## 1 <= x < p の原始根を底とする離散対数を [0,p-2] で返す。O(1)。
        self.checkModulus()
        let x = when x is int: x else: x.val
        assert 1 <= x and x < self.modulus
        let fraction = self.fractions[x shr self.bucketShift]
        let a = x * int(fraction.b) - self.modulus * int(fraction.a)
        result = int(self.logarithms[abs(a)]) - int(self.logarithms[int(fraction.b)])
        if a < 0: result += (self.modulus - 1) div 2
        if result < 0: result += self.modulus - 1
        if result >= self.modulus - 1: result -= self.modulus - 1

    proc inv*[T](self: ModFast[T], x: T or int): T {.inline.} =
        ## 1 <= x < p の逆元を返す。対数表と累乗表を共有し O(1)。
        let e = self.log(x)
        init(T, self.powerRaw(if e == 0: 0 else: self.modulus - 1 - e))

    proc pow*[T](self: ModFast[T], x: T or int, exponent: int): T {.inline.} =
        ## 0 <= x < p の累乗を O(1) で返す。負の指数も許すが 0 の負乗は不可。0^0=1。
        self.checkModulus()
        let x = when x is int: x else: x.val
        assert 0 <= x and x < self.modulus
        if x == 0:
            assert exponent >= 0
            return init(T, int(exponent == 0))
        var e = exponent mod (self.modulus - 1)
        if e < 0: e += self.modulus - 1
        init(T, self.powerRaw(self.log(x) * e mod (self.modulus - 1)))

    proc buildFractions[T](self: var ModFast[T]): int =
        ## Farey 数列から近似分数表を O(p^(2/3)) で作り、必要な対数表の上限を返す。
        let p = self.modulus
        var n = 1
        while n * n * n < p:
            n *= 2
            inc self.bucketShift
        self.fractions = newSeq[tuple[a, b: uint16]]((p shr self.bucketShift) + 1)
        var (a, b, c, d) = (0, 1, 1, n)
        while c <= n:
            let left = (a * p div b) shr self.bucketShift
            let right = (c * p div d) shr self.bucketShift
            let fraction = if b <= d: (uint16(a), uint16(b)) else: (uint16(c), uint16(d))
            for j in left..right: self.fractions[j] = fraction
            if c == d: break
            let k = (n + b) div d
            (a, b, c, d) = (c, d, k * c - a, k * d - b)
        # 各バケットの端点で |bx-ap| を評価し、実際に必要な領域だけ確保する。
        for j, fraction in self.fractions:
            let lo = max(1, j shl self.bucketShift)
            let hi = min(p - 1, ((j + 1) shl self.bucketShift) - 1)
            if lo > hi: continue
            result = max(result, int(fraction.b))
            result = max(result, abs(lo * int(fraction.b) - p * int(fraction.a)))
            result = max(result, abs(hi * int(fraction.b) - p * int(fraction.a)))

    proc buildLogarithms[T](self: var ModFast[T], limit: int) =
        ## 小素数の対数を乱択で求め、合成数と大きな素数の対数を漸化式で埋める。
        let p = self.modulus
        let order = p - 1
        self.logarithms = newSeq[uint32](limit + 1)
        var least = newSeq[uint32](limit + 1)
        for i in 2..limit:
            if least[i] != 0: continue
            least[i] = uint32(i)
            if i * i <= limit:
                var j = i * i
                while j <= limit:
                    if least[j] == 0: least[j] = uint32(i)
                    j += i

        let step = min(order, 4 shl self.powerShift)
        var capacity = 1
        while capacity < 2 * step: capacity *= 2
        var keys = newSeq[uint32](capacity)
        var values = newSeq[uint32](capacity)
        proc slot(x: int): int =
            ## 剰余値を専用ハッシュ表の添字に変換する。O(1)。
            int((uint32(x) * 2654435761u32) and uint32(capacity - 1))
        var value = 1
        for e in 0..<step:
            var h = slot(value)
            while keys[h] != 0: h = (h + 1) and (capacity - 1)
            keys[h] = uint32(value)
            values[h] = uint32(e)
            value = value * self.generator mod p
        let giant = self.powerRaw((order - step) mod order)
        proc bsgs(x: int): int =
            ## 共通の baby step 表で離散対数を求める。期待 O(p/step)。
            var x = x
            var offset = 0
            while offset < order:
                var h = slot(x)
                while keys[h] != 0:
                    if int(keys[h]) == x: return (offset + int(values[h])) mod order
                    h = (h + 1) and (capacity - 1)
                x = x * giant mod p
                offset += step
            raise newException(ValueError, "法または原始根が不正です")

        var rng = initRand(20260914)
        for i in 2..limit:
            if i * i > p:
                self.logarithms[i] = uint32((int(self.logarithms[p mod i]) +
                    order div 2 + order - int(self.logarithms[p div i])) mod order)
            elif int(least[i]) < i:
                self.logarithms[i] = uint32((int(self.logarithms[int(least[i])]) +
                    int(self.logarithms[i div int(least[i])])) mod order)
            elif i < 100:
                self.logarithms[i] = uint32(bsgs(i))
            else:
                var found = false
                for attempt in 0..<128:
                    let e = rng.rand(order - 1)
                    var x = i * self.powerRaw(e) mod p
                    var answer = order - e
                    for q in [2, 3, 5, 7, 11, 13, 17, 19]:
                        while x mod q == 0:
                            x = x div q
                            answer += int(self.logarithms[q])
                    if x > limit: continue
                    while x >= i and int(least[x]) < i:
                        let q = int(least[x])
                        x = x div q
                        answer += int(self.logarithms[q])
                    if x < i:
                        answer += int(self.logarithms[x])
                        self.logarithms[i] = uint32(answer mod order)
                        found = true
                        break
                if not found: self.logarithms[i] = uint32(bsgs(i))

    proc initModFast*[T: BarrettModint or MontgomeryModint](): ModFast[T] =
        ## 素数 2 <= p < 2^30 用の O(1) inv/log/pow を構築する。64 bit 環境用。
        ## 空間 O(p^(2/3))。構築は篩・分数表 O(p^(2/3) log log p) と小素数の離散対数。
        ## 乱択による高速化は 128 回で打ち切り、未解決なら BSGS で確実に求める。
        ## BSGS に解決を任せた場合の構築時間は、ハッシュ表の期待計算量で O(p/log p + p^(2/3) log log p)。
        ## 法は T.umod から取得する。動的 modint は先に setMod し、使用中は法を変更しない。
        let p = T.umod.int
        assert sizeof(int) >= 8
        assert 2 <= p and p < (1 shl 30)
        result.modulus = p
        result.generator = if p == 2: 1 else: primitive_root(p)
        var width = 1
        while width * width < p - 1:
            width *= 2
            inc result.powerShift
        result.powerLow = newSeq[uint32](width)
        result.powerHigh = newSeq[uint32]((p - 2) div width + 1)
        var value = 1
        for i in 0..<width:
            result.powerLow[i] = uint32(value)
            value = value * result.generator mod p
        let stride = value
        value = 1
        for i in 0..<result.powerHigh.len:
            result.powerHigh[i] = uint32(value)
            value = value * stride mod p
        if p <= 64:
            result.fractions = newSeq[tuple[a, b: uint16]](p)
            result.logarithms = newSeq[uint32](p)
            value = 1
            for e in 0..<p - 1:
                result.fractions[value] = (0u16, 1u16)
                result.logarithms[value] = uint32(e)
                value = value * result.generator mod p
        else:
            let limit = result.buildFractions()
            result.buildLogarithms(limit)
