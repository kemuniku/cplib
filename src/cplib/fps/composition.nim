when not declared CPLIB_FPS_COMPOSITION:
    const CPLIB_FPS_COMPOSITION* = 1

    import cplib/fps/formal_power_series
    import cplib/modint/modint

    proc compositionRec[T: BarrettModint or MontgomeryModint](
            outer: seq[T], denominator: seq[seq[T]], n, yDegree: int): seq[seq[T]] =
        ## outer(y^-1) / denominator(x, y) のうち必要なy方向のLaurent係数を求める。
        ## Kinoshita--Li法（転置した冪射影）の再帰部分に当たる。
        if n == 0:
            result = newSeq[seq[T]](yDegree)
            for i in 0..<yDegree: result[i] = newSeq[T](1)
            for i in 0..<min(outer.len, yDegree):
                result[yDegree - 1 - i][0] = outer[i]
            return

        # V(x^2, y) = Q(x, y) Q(-x, y) を計算する。
        # 復元時のx次数より広い間隔で平坦化すれば、二変数積を1回の畳み込みにできる。
        var denominatorDegree = 0
        for polynomial in denominator:
            denominatorDegree = max(denominatorDegree,
                min(polynomial.len, n + 1) - 1)
        let stride = n + denominatorDegree + 1
        let encodedLength = yDegree * stride + denominatorDegree + 1
        var positive = newSeq[T](encodedLength)
        var negative = newSeq[T](encodedLength)
        for y in 0..yDegree:
            for x in 0..<min(denominator[y].len, n + 1):
                positive[y * stride + x] = denominator[y][x]
                negative[y * stride + x] =
                    (if (x and 1) == 0: denominator[y][x] else: -denominator[y][x])
        let product = positive * negative
        let half = n div 2
        var nextDenominator = newSeq[seq[T]](2 * yDegree + 1)
        for y in 0..2 * yDegree:
            nextDenominator[y] = newSeq[T](half + 1)
            for x in 0..half:
                let index = y * stride + 2 * x
                if index < product.len: nextDenominator[y][x] = product[index]

        let projected = compositionRec(outer, nextDenominator, half, 2 * yDegree)

        # x^2 を x に戻してQ(-x, y)を掛け、yの指数が -yDegree+1 .. 0 の項だけ残す。
        let liftedLength = (2 * yDegree - 1) * stride + 2 * half + 1
        var lifted = newSeq[T](liftedLength)
        for y in 0..<2 * yDegree:
            for x in 0..<projected[y].len:
                lifted[y * stride + 2 * x] = projected[y][x]
        let recovered = lifted * negative
        result = newSeq[seq[T]](yDegree)
        for y in 0..<yDegree:
            result[y] = newSeq[T](n + 1)
            let encodedY = yDegree + y
            for x in 0..n:
                let index = encodedY * stride + x
                if index < recovered.len: result[y][x] = recovered[index]

    proc compose*[T: BarrettModint or MontgomeryModint](
            outer, inner: seq[T], n: int): seq[T] =
        ## outer(inner(x)) mod x^n を O(n log^2 n) で求める。
        ## innerの定数項が0であることを仮定する。
        if n <= 0: return @[]
        doAssert inner.len == 0 or inner[0].val == 0,
            "FPSの合成では内側のFPSの定数項が0である必要がある"
        if n == 1:
            result = newSeq[T](1)
            if outer.len > 0: result[0] = outer[0]
            return

        # outer(y^-1) / (1 - y inner(x)) のy^0係数が
        # sum_i outer[i] inner(x)^i に一致することを利用する。
        var denominator = newSeq[seq[T]](2)
        denominator[0] = @[init(T, 1)]
        denominator[1] = -prefix(inner, n)
        result = prefix(compositionRec(prefix(outer, n), denominator, n - 1, 1)[0], n)

    proc compose*[T: BarrettModint or MontgomeryModint](
            outer, inner: seq[T]): seq[T] = outer.compose(inner, outer.len)

    proc compositionalInverse*[T: BarrettModint or MontgomeryModint](
            f: seq[T], n: int): seq[T] =
        ## Newton法により f(g(x)) = x (mod x^n) を満たすgを求める。
        if n <= 0: return @[]
        doAssert f.len >= 2 and f[0].val == 0 and f[1].val != 0,
            "合成逆関数を求めるには f(0)=0 かつ1次の係数が非零である必要がある"
        if n == 1: return newSeq[T](1)
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
