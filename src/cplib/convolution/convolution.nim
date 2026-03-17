when not declared CPLIB_CONVOLUTION_CONVOLUTION:
    const CPLIB_CONVOLUTION_CONVOLUTION* = 1
    import bitops
    import cplib/modint/modint
    import cplib/convolution/ntt

    proc convolution*[T: BarrettModint or MontgomeryModint](f, g: seq[T]): seq[T] =
        var f = f
        var g = g
        let m = f.len
        let n = g.len
        let deg = m + n - 1
        var l = (if deg == 1: 1 else: (1 shl (fastLog2(deg - 1) + 1)))
        f.setLen(l)
        g.setLen(l)
        ntt(f)
        ntt(g)
        for i in 0..<f.len:
            f[i] *= g[i]
        intt(f)
        f.setlen(deg)
        return f
