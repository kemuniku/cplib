when not declared CPLIB_FPS_POW_ENUMERATE:
    const CPLIB_FPS_POW_ENUMERATE* = 1

    import algorithm
    import cplib/convolution/convolution
    import cplib/fps/formal_power_series
    import cplib/modint/modint

    proc powEnumerate*[T: BarrettModint or MontgomeryModint](
            f, g: seq[T], m: int): seq[T] =
        ## [x^n] f(x)^i g(x) (i = 0, 1, ..., m) を列挙する。
        ## ここで n = f.len - 1 とする。
        doAssert f.len > 0, "pow列挙では f が空でない必要がある"
        doAssert m >= 0, "pow列挙では列挙する最大指数が非負である必要がある"

        var n = f.len - 1
        var xStride = 1
        while xStride < n + 1: xStride *= 2
        var yDegree = 1

        # P / (y^yDegree + Q) の x^n 係数を保ったまま、x方向に
        # Bostan--Mori法を適用する。各y係数を長さxStrideのブロックに置く。
        var p = newSeq[T](xStride)
        var q = newSeq[T](xStride)
        for i in 0..n:
            if i < g.len: p[i] = g[i]
            q[i] = -f[i]

        while n > 0:
            # x方向の積で隣のyブロックへ繰り上がらないよう、間隔を倍にする。
            let wideStride = 2 * xStride
            var expandedP = newSeq[T](yDegree * wideStride)
            var expandedQ = newSeq[T]((yDegree + 1) * wideStride)
            for y in 0..<yDegree:
                for x in 0..n:
                    expandedP[y * wideStride + x] = p[y * xStride + x]
                    expandedQ[y * wideStride + x] = q[y * xStride + x]
            expandedQ[yDegree * wideStride] = init(T, 1)

            var negativeQ = expandedQ
            for y in 0..yDegree:
                for x in countup(1, wideStride - 1, 2):
                    negativeQ[y * wideStride + x] =
                        -negativeQ[y * wideStride + x]

            let cycleLength = 2 * yDegree * wideStride
            let productP = convolutionCyclicPowerOfTwo(
                expandedP, negativeQ, cycleLength)
            var productQ = convolutionCyclicPowerOfTwo(
                expandedQ, negativeQ, cycleLength)
            # y^(2*yDegree) の項は巡回畳み込みにより定数項へ回り込む。
            productQ[0] -= init(T, 1)
            let nextStride = xStride div 2
            var nextP = newSeq[T](2 * yDegree * nextStride)
            var nextQ = newSeq[T](2 * yDegree * nextStride)
            for y in 0..<2 * yDegree:
                for x in 0..n div 2:
                    let base = y * wideStride + 2 * x
                    nextP[y * nextStride + x] = productP[base + (n and 1)]
                    nextQ[y * nextStride + x] = productQ[base]

            p = move(nextP)
            q = move(nextQ)
            n = n div 2
            xStride = nextStride
            yDegree *= 2

        # x次数が0になればyについての有理式だけが残る。
        # yの高次側から反転し、定数項が1のFPS除算として先頭m+1項を得る。
        var numerator = p[0..<yDegree]
        var denominator = q[0..<yDegree]
        denominator.add(init(T, 1))
        numerator.reverse
        denominator.reverse
        prefix(numerator * denominator.inv(m + 1), m + 1)

    proc powEnumerate*[T: BarrettModint or MontgomeryModint](
            f: seq[T], m: int): seq[T] =
        f.powEnumerate(@[init(T, 1)], m)

    proc powEnumerate*[T: BarrettModint or MontgomeryModint](
            f, g: seq[T]): seq[T] =
        f.powEnumerate(g, f.len - 1)

    proc powEnumerate*[T: BarrettModint or MontgomeryModint](f: seq[T]): seq[T] =
        f.powEnumerate(@[init(T, 1)], f.len - 1)
