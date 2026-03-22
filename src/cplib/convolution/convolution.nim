when not declared CPLIB_CONVOLUTION_CONVOLUTION:
    const CPLIB_CONVOLUTION_CONVOLUTION* = 1
    import bitops, sequtils
    import cplib/modint/modint
    import cplib/convolution/ntt

    proc convolution_naive*[T: BarrettModint or MontgomeryModint or int](f, g: seq[T]): seq[T] =
        var ans = newSeqWith(f.len + g.len - 1, T(0))
        if f.len > g.len:
            for i in 0..<f.len:
                for j in 0..<g.len:
                    ans[i+j] += f[i] * g[j]
        else:
            for j in 0..<g.len:
                for i in 0..<f.len:
                    ans[i+j] += f[i] * g[j]
        return ans

    proc convolution*[T: BarrettModint or MontgomeryModint](f, g: seq[T]): seq[T] =
        var f = f
        var g = g
        let m = f.len
        let n = g.len
        let deg = m + n - 1
        if min(n, m) <= 60: return convolution_naive(f, g)
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
