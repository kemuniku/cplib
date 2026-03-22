when not declared CPLIB_CONVOLUTION_CONVOLUTION:
    const CPLIB_CONVOLUTION_CONVOLUTION* = 1
    import bitops, sequtils
    import cplib/modint/modint
    import cplib/convolution/ntt

    proc inplace_convolution_naive*[T: BarrettModint or MontgomeryModint or int](f: var seq[T], g: seq[T]) =
        var n = f.len
        f &= newSeqWith(g.len - 1, T(0))
        for i in countdown(f.len-1, 0):
            for j in 0..<g.len:
                if i-j < 0: break
                if j == 0: f[i] = f[i-j] * g[j]
                else: f[i] += f[i-j] * g[j]

    proc convolution_naive*[T: BarrettModint or MontgomeryModint or int](f, g: seq[T]): seq[T] =
        var f = f
        inplace_convolution_naive(f, g)
        return f

    proc inplace_convolution*[T: BarrettModint or MontgomeryModint](f: var seq[T], g: seq[T]) =
        var g = g
        let m = f.len
        let n = g.len
        let deg = m + n - 1
        if min(n, m) <= 60:
            inplace_convolution_naive(f, g)
            return
        var l = (if deg == 1: 1 else: (1 shl (fastLog2(deg - 1) + 1)))
        f.setLen(l)
        g.setLen(l)
        ntt(f)
        ntt(g)
        for i in 0..<f.len:
            f[i] *= g[i]
        intt(f)
        f.setlen(deg)

proc convolution*[T: BarrettModint or MontgomeryModint](f, g: seq[T]): seq[T] =
    var f = f
    inplace_convolution(f, g)
    return f
