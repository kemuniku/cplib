when not declared CPLIB_CONVOLUTION_MIN_PLUS_CONVOLUTION:
    const CPLIB_CONVOLUTION_MIN_PLUS_CONVOLUTION* = 1
    import cplib/utils/monotone_minima

    proc minPlusConvolutionConvexArbitrary*[T](convex, arbitrary: seq[T]): seq[T] =
        ## Computes the min-plus convolution in
        ## O((convex.len + arbitrary.len) * log(arbitrary.len)).
        ## The first sequence must be convex: its adjacent differences are
        ## nondecreasing.
        if convex.len == 0 or arbitrary.len == 0: return @[]
        let n = convex.len
        let m = arbitrary.len
        let argmin = monotoneMinima(n + m - 1, m,
            proc(k, j1, j2: int): bool =
                let i1 = k - j1
                let i2 = k - j2
                if i2 < 0: return true
                if i1 >= n: return false
                convex[i1] + arbitrary[j1] <= convex[i2] + arbitrary[j2]
        )
        result = newSeq[T](n + m - 1)
        for k in 0..<result.len:
            let j = argmin[k]
            result[k] = convex[k - j] + arbitrary[j]

    proc minPlusConvolutionArbitraryConvex*[T](arbitrary, convex: seq[T]): seq[T] =
        ## Computes the min-plus convolution when the second sequence is convex.
        minPlusConvolutionConvexArbitrary(convex, arbitrary)

    proc minPlusConvolutionConvexConvex*[T](a, b: seq[T]): seq[T] =
        ## Computes the min-plus convolution of two convex sequences in
        ## O(a.len + b.len).
        if a.len == 0 or b.len == 0: return @[]
        result = newSeq[T](a.len + b.len - 1)
        var i = 0
        var j = 0
        result[0] = a[0] + b[0]
        for k in 1..<result.len:
            if j == b.high or (i < a.high and a[i + 1] + b[j] < a[i] + b[j + 1]):
                i.inc
            else:
                j.inc
            result[k] = a[i] + b[j]
