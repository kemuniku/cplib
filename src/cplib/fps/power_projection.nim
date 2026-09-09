when not declared CPLIB_FPS_POWER_PROJECTION:
    const CPLIB_FPS_POWER_PROJECTION* = 1

    import algorithm
    import cplib/convolution/convolution
    import cplib/fps/formal_power_series
    import cplib/modint/modint

    proc powerProjection*[T: BarrettModint or MontgomeryModint](
            f, g: seq[T], m: int): seq[T] =
        ## Power Projection（冪の係数列挙）。
        ## [x^n] f(x)^i g(x) (i = 0, 1, ..., m) を列挙する。
        ## ここで n = f.len - 1 とする。
        doAssert f.len > 0, "Power Projectionでは f が空でない必要がある"
        doAssert m >= 0, "Power Projectionでは列挙する最大指数が非負である必要がある"

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

    proc powerProjection*[T: BarrettModint or MontgomeryModint](
            f: seq[T], m: int): seq[T] =
        f.powerProjection(@[init(T, 1)], m)

    proc powerProjection*[T: BarrettModint or MontgomeryModint](
            f, g: seq[T]): seq[T] =
        f.powerProjection(g, f.len - 1)

    proc powerProjection*[T: BarrettModint or MontgomeryModint](f: seq[T]): seq[T] =
        f.powerProjection(@[init(T, 1)], f.len - 1)

    proc powerProjectionDiagonal*[T: BarrettModint or MontgomeryModint](
            f, g: seq[T], m: int): seq[T] =
        ## [x^i] f(x)^i g(x) (i = 0, 1, ..., m) を列挙する。
        ## f は空でなく、m は非負とする。入力の範囲外の係数は零として扱う。
        ## f[0] != 0 の場合は FPS の pow と同じく m + 1 が法以下である必要がある。
        ## NTT を使える場合 O((m + 1) log^2(m + 2)) 時間。
        ## 参考: https://potato167.hatenablog.com/entry/2026/02/22/180000
        doAssert f.len > 0, "Power Projectionでは f が空でない必要がある"
        doAssert m >= 0, "Power Projectionでは列挙する最大指数が非負である必要がある"
        if f[0].val == 0:
            # f(x)^i の最低次数は i なので、f[1]^i g[0] だけが寄与する。
            result = newSeq[T](m + 1)
            result[0] = g.coefficient(0)
            let linear = f.coefficient(1)
            for i in 1..m: result[i] = result[i - 1] * linear
            return

        let size = m + 1
        let base = prefix(f, size)
        let weight = prefix(base.pow(m, size) * prefix(g, size), size)
        let inverse = base.inv(m)
        var shiftedInverse = newSeq[T](size)
        for i in 1..m: shiftedInverse[i] = inverse[i - 1]
        # k = m - i とおくと [x^i] f^i g = [x^m] (x/f)^k (f^m g)。
        result = powerProjection(shiftedInverse, weight, m)
        result.reverse

    proc powerProjectionDiagonal*[T: BarrettModint or MontgomeryModint](
            f: seq[T], m: int): seq[T] =
        ## g(x) = 1 として i = 0..m を列挙する。
        f.powerProjectionDiagonal(@[init(T, 1)], m)

    proc powerProjectionDiagonal*[T: BarrettModint or MontgomeryModint](
            f, g: seq[T]): seq[T] =
        ## i = 0..f.len - 1 を列挙する。
        f.powerProjectionDiagonal(g, f.len - 1)

    proc powerProjectionDiagonal*[T: BarrettModint or MontgomeryModint](
            f: seq[T]): seq[T] =
        ## g(x) = 1 として i = 0..f.len - 1 を列挙する。
        f.powerProjectionDiagonal(@[init(T, 1)], f.len - 1)
