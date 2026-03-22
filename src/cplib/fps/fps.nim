when not declared CPLIB_FPS_FPS:
    const CPLIB_FPS_FPS* = 1
    import strutils
    import cplib/convolution/convolution
    import cplib/convolution/ntt
    type FormalPowerSeries*[T] = distinct seq[T]
    proc initFormalPowerSeries*[T](n: int): FormalPowerSeries[T] = FormalPowerSeries[T](newSeq[T](n))
    proc initFormalPowerSeries*[T](f: sink seq[T]): FormalPowerSeries[T] = FormalPowerSeries[T](f)
    proc len*[T](f: FormalPowerSeries[T]): int = seq[T](f).len
    proc deg*[T](f: FormalPowerSeries[T]): int = seq[T](f).len - 1
    proc `[]`*[T](f: FormalPowerSeries[T], i: Natural): T = seq[T](f)[i]
    proc `[]`*[T](f: var FormalPowerSeries[T], i: Natural): var T = seq[T](f)[i]
    proc `[]=`*[T](f: var FormalPowerSeries[T], i: Natural, v: T) = seq[T](f)[i] = v
    proc setLen*[T](f: var FormalPowerSeries[T], x: Natural) = seq[T](f).setLen(x)
    proc `+=`*[T](a: var FormalPowerSeries[T], b: FormalPowerSeries[T]) =
        if a.len < b.len: a.setLen(b.len)
        for i in 0..<b.len: a[i] += b[i]
    proc `+`*[T](a, b: FormalPowerSeries[T]): FormalPowerSeries[T] = (var ans = a; ans += b; ans)
    proc `-=`*[T](a: var FormalPowerSeries[T], b: FormalPowerSeries[T]) =
        if a.len < b.len: a.setLen(b.len)
        for i in 0..<b.len: a[i] -= b[i]
    proc `-`*[T](a, b: FormalPowerSeries[T]): FormalPowerSeries[T] = (var ans = a; ans -= b; ans)
    proc `*=`*[T](a: var FormalPowerSeries[T], b: FormalPowerSeries[T]) = inplace_convolution(seq[T](a), seq[T](b))
    proc `*`*[T](a, b: FormalPowerSeries[T]): FormalPowerSeries[T] = (var ans = a; ans *= b; ans)
    proc inverse*[T](f: FormalPowerSeries[T], deg: int = -1): FormalPowerSeries[T] =
        assert(f[0].val != 0)
        var ln = (if deg != -1: deg else: f.len)
        var ans = initFormalPowerSeries[T](ln)
        ans[0] = f[0].inv
        var d = 1
        while d < ln:
            var a, b = newSeq[T](2*d)
            for i in 0..<min(f.len, 2*d): a[i] = f[i]
            for i in 0..<d: b[i] = ans[i]
            a.ntt
            b.ntt
            for i in 0..<(2*d): a[i] *= b[i]
            a.intt
            for i in 0..<d: a[i] = T(0)
            a.ntt
            for i in 0..<(2*d): a[i] *= b[i]
            a.intt
            for i in d..<min(2*d, ln): ans[i] -= a[i]
            d *= 2
        ans.setLen(ln)
        return ans
    proc `/=`*[T](a: var FormalPowerSeries[T], b: FormalPowerSeries[T]) = (a *= (b.inverse))
    proc `/`*[T](a, b: FormalPowerSeries[T]): FormalPowerSeries[T] = (var ans = a; ans /= b; ans)
    proc `$`*[T](f: FormalPowerSeries[T]): string = (seq[T](f)).join(" ")
