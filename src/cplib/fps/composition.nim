when not declared CPLIB_FPS_COMPOSITION:
    const CPLIB_FPS_COMPOSITION* = 1

    import cplib/fps/formal_power_series
    import cplib/modint/modint
    import cplib/fps/power_projection
    import cplib/math/isprime
    import cplib/convolution/convolution

    proc compositionRec[T: BarrettModint or MontgomeryModint](
            outer, denominator: seq[T], n, yDegree, denominatorDegree: int): seq[T] =
        ## outer(y^-1) / denominator(x, y) の必要なLaurent係数を平坦な配列で求める。
        ## Kinoshita--Li法（転置した冪射影）の再帰部分に当たる。
        if n == 0:
            result = newSeq[T](yDegree)
            for i in 0..<min(outer.len, yDegree):
                result[yDegree - 1 - i] = outer[i]
            return

        let width = denominatorDegree + 1
        let stride = n + denominatorDegree + 1
        let encodedLength = yDegree * stride + width
        var negative = newSeq[T](encodedLength)
        for y in 0..yDegree:
            for x in 0..<width:
                let value = denominator[y * width + x]
                negative[y * stride + x] =
                    (if (x and 1) == 0: value else: -value)
        let half = n div 2
        let projected = block:
            var nextDenominator: seq[T]
            if half > 0:
                # V(x^2, y) = Q(x, y) Q(-x, y) を計算する。
                var positive = newSeq[T](encodedLength)
                for y in 0..yDegree:
                    for x in 0..<width:
                        positive[y * stride + x] = denominator[y * width + x]
                let product = positive * negative
                nextDenominator = newSeq[T]((2 * yDegree + 1) * (half + 1))
                for y in 0..2 * yDegree:
                    for x in 0..half:
                        let index = y * stride + 2 * x
                        if index < product.len:
                            nextDenominator[y * (half + 1) + x] = product[index]
            compositionRec(outer, nextDenominator, half, 2 * yDegree, half)

        # x^2をxに戻してQ(-x, y)を掛け、yの指数が-yDegree+1..0の項だけ残す。
        let liftedLength = (2 * yDegree - 1) * stride + 2 * half + 1
        var lifted = newSeq[T](liftedLength)
        for y in 0..<2 * yDegree:
            for x in 0..half:
                lifted[y * stride + 2 * x] = projected[y * (half + 1) + x]
        # 積の長さは3*yDegree*stride以下なので、2*yDegree*stride以上で巡回すれば
        # 回り込みは保存範囲[yDegree*stride, 2*yDegree*stride)より手前にしか届かない。
        var cycleLength = 1
        while cycleLength < 2 * yDegree * stride: cycleLength *= 2
        let modulus = T.umod
        let useCyclic = min(lifted.len, negative.len) > 60 and
            cycleLength >= 64 and modulus < (1u32 shl 30) and
            (modulus - 1) mod cycleLength.uint32 == 0 and isprime(modulus.int)
        let recovered = (if useCyclic:
            convolutionCyclicPowerOfTwo(lifted, negative, cycleLength)
        else: lifted * negative)
        result = newSeq[T](yDegree * (n + 1))
        for y in 0..<yDegree:
            for x in 0..n:
                let index = (yDegree + y) * stride + x
                if index < recovered.len: result[y * (n + 1) + x] = recovered[index]

    proc compose*[T: BarrettModint or MontgomeryModint](
            outer, inner: seq[T], n: int): seq[T] =
        ## outer(inner(x)) mod x^n を O(n log^2 n) で求める。
        ## innerの定数項が0であることを仮定する。
        if n <= 0: return @[]
        assert inner.len == 0 or inner[0].val == 0,
            "FPSの合成では内側のFPSの定数項が0である必要がある"
        if n == 1:
            result = newSeq[T](1)
            if outer.len > 0: result[0] = outer[0]
            return

        var outerLength = min(outer.len, n)
        var innerLength = min(inner.len, n)
        while outerLength > 0 and outer[outerLength - 1].val == 0: dec outerLength
        while innerLength > 0 and inner[innerLength - 1].val == 0: dec innerLength
        if outerLength <= 1 or innerLength <= 1:
            result = newSeq[T](n)
            if outerLength > 0: result[0] = outer[0]
            return

        var first = 1
        while inner[first].val == 0: inc first
        outerLength = min(outerLength, (n - 1) div first + 1)
        if first == innerLength - 1:
            result = newSeq[T](n)
            var power = init(T, 1)
            for i in 0..<outerLength:
                result[i * first] = outer[i] * power
                power *= inner[first]
            return
        if n <= 32 or outerLength <= 8:
            let truncatedInner = inner[0..<innerLength]
            result = @[outer[outerLength - 1]]
            for i in countdown(outerLength - 2, 0):
                result = prefix(result * truncatedInner, n)
                result[0] += outer[i]
            result.setLen(n)
            return

        var size = 1
        while size < n: size *= 2
        if n >= 32 and canUseCompositionNtt(T.umod, size):
            result = newSeq[T](n)
            compositionNttKernel(cast[ptr uint32](addr result[0]),
                cast[ptr uint32](unsafeAddr outer[0]), outerLength.csize_t,
                cast[ptr uint32](unsafeAddr inner[0]), innerLength.csize_t,
                n.csize_t, size.csize_t, T.umod, T is MontgomeryModint)
            return

        # outer(y^-1) / (1 - y inner(x)) のy^0係数が
        # sum_i outer[i] inner(x)^i に一致することを利用する。
        let denominatorDegree = max(0, min(inner.len, n) - 1)
        let width = denominatorDegree + 1
        var denominator = newSeq[T](2 * width)
        denominator[0] = init(T, 1)
        for i in 0..<min(inner.len, n): denominator[width + i] = -inner[i]
        result = compositionRec(prefix(outer, n), denominator, n - 1, 1, denominatorDegree)

    proc compose*[T: BarrettModint or MontgomeryModint](
            outer, inner: seq[T]): seq[T] =
        ## outer(inner(x))をouter.len項求める。
        outer.compose(inner, outer.len)

    proc compositionalInverse*[T: BarrettModint or MontgomeryModint](
            f: seq[T], n: int): seq[T] =
        ## f(g(x)) = x (mod x^n) を満たすgをO(n log^2 n)で求める。
        if n <= 0: return @[]
        assert f.len >= 2 and f[0].val == 0 and f[1].val != 0,
            "合成逆関数を求めるには f(0)=0 かつ1次の係数が非零である必要がある"
        if n == 1: return newSeq[T](1)
        if n >= 64 and n <= T.umod.int and isprime(T.umod.int):
            # N[x^N]f^i = i[x^(N-i)](g/x)^(-N) を用いる。
            let degree = n - 1
            let linearInverse = f[1].inv
            let normalized = prefix(f, n) * linearInverse
            let projected = normalized.powerProjection(degree)
            var inverses = newSeq[T](n)
            inverses[1] = init(T, 1)
            let modulus = T.umod.int
            for i in 2..<n:
                inverses[i] = -inverses[modulus mod i] * (modulus div i)
            var powers = newSeq[T](degree)
            for j in 0..<degree:
                powers[j] = projected[degree - j] * degree * inverses[degree - j]
            let body = (powers.log(degree) * -inverses[degree]).exp(degree)
            result = newSeq[T](n)
            var scale = linearInverse
            for i in 1..<n:
                result[i] = body[i - 1] * scale
                scale *= linearInverse
            return
        result = @[init(T, 0), f[1].inv]
        var m = 2
        while m < n:
            let next = min(m * 2, n)
            let composed = compose(f, result, next)
            let correctionSize = next - m
            var upperError = newSeq[T](correctionSize)
            for i in 0..<correctionSize:
                upperError[i] = composed[m + i]
            let inverseSlope = prefix(
                result.derivative * composed.derivative.inv(correctionSize),
                correctionSize)
            let upperCorrection = prefix(
                upperError * inverseSlope, correctionSize)
            result.setLen(next)
            for i in 0..<correctionSize:
                result[m + i] -= upperCorrection[i]
            m = next

    proc compositionalInverse*[T: BarrettModint or MontgomeryModint](
            f: seq[T]): seq[T] = f.compositionalInverse(f.len)
