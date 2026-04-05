when not declared CPLIB_FPS_FPS:
    const CPLIB_FPS_FPS* = 1
    import strutils
    import cplib/convolution/convolution
    import cplib/convolution/ntt
    import cplib/modint/modint
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
    proc inv*[T](f: FormalPowerSeries[T], deg: int = -1): FormalPowerSeries[T] =
        assert(f[0].val != 0)
        var ln = (if deg != -1: deg else: f.len)
        var ans = initFormalPowerSeries[T](ln)
        ans[0] = T(1) / f[0]
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
        return ans
    proc `/=`*[T](a: var FormalPowerSeries[T], b: FormalPowerSeries[T]) = (a *= (b.inverse))
    proc `/`*[T](a, b: FormalPowerSeries[T]): FormalPowerSeries[T] = (var ans = a; ans /= b; ans)
    proc `-`*[T](a: FormalPowerSeries[T]): FormalPowerSeries[T] =
        var ans = a
        for i in 0..<a.len: ans[i] = -ans[i]
        return ans
    proc diff*[T](f: FormalPowerSeries[T]): FormalPowerSeries[T] =
        var ans = initFormalPowerSeries[T](f.len)
        for i in 0..<f.len-1:
            ans[i] = f[i+1] * T(i+1)
        return ans
    proc integral*[T](f: FormalPowerSeries[T]): FormalPowerSeries[T] =
        # 積分定数(f[0])は0
        var ans = initFormalPowerSeries[T](f.len)
        for i in 0..<f.len-1:
            ans[i+1] = f[i] / T(i+1)
        return ans
    proc `$`*[T](f: FormalPowerSeries[T]): string = (seq[T](f)).join(" ")
    proc pow*[T](f: FormalPowerSeries[T], n: int): FormalPowerSeries[T] =
        var ans = initFormalPowerSeries[T](@[T(1)])
        var f = f
        while n > 0:
            if n and 1 == 1:
                ans = ans * f
            f = f * f
            n shl 1
        return ans
    proc log*[T](f: FormalPowerSeries[T], deg: int = -1): FormalPowerSeries[T] =
        assert(f[0].val != 0)
        var ln = (if deg != -1: deg else: f.len)
        var ans = integral(diff(f) * inv(f, ln))
        ans.setLen(ln)
        return ans
    proc exp*[T](f: FormalPowerSeries[T], deg: int = -1): FormalPowerSeries[T] =
        assert(f[0].val == 0)
        var ln = (if deg != -1: deg else: f.len)
        var ans = initFormalPowerSeries[T](ln)
        ans[0] = T(1)
        var d = 1
        while d < ln:
            var a, b = newSeq[T](2*d)
            for i in 0..<d: a[i] = ans[i]
            for i in 0..<d: b[i] = ans[i]
            a = seq[T](log(a.initFormalPowerSeries))
            for i in 0..<(2*d): a[i] = -a[i]
            for i in 0..<min(2*d, f.len): a[i] += f[i]
            a[0] += T(1)
            a.ntt
            b.ntt
            for i in 0..<2*d: a[i] *= b[i]
            a.intt
            for i in d..<min(2*d, ans.len):
                ans[i] += a[i]
            d *= 2
        return ans
    proc pow*[T](f: FormalPowerSeries[T], n: int, deg: int = -1): FormalPowerSeries[T] =
        var ln = (if deg != -1: deg else: f.len)
        if n == 0:
            var ans = initFormalPowerSeries[T](ln)
            ans[0] = T(1)
            return ans
        var p = -1
        var x = T(0)
        for i in 0..<f.len:
            if f[i].val != 0:
                p = i
                x = f[i].inv
                break
        if p == -1 or p > ln div n or p * n >= ln:
            var ans = initFormalPowerSeries[T](ln)
            return ans
        var g = initFormalPowerSeries[T](0)
        for i in p..<f.len:
            seq[T](g).add(f[i] * x)
        g = log(g, ln - p * n)
        for i in 0..<g.len:
            g[i] *= T(n)
        g = exp(g)
        x = (T(1) / x).pow(n)
        for i in 0..<g.len:
            g[i] *= x
        var ans = initFormalPowerSeries(newSeq[T](p * n) & seq[T](g))
        return ans

# TODO: total_mul, pow_enumerate, polynomial_taylor_shift, multipoint_evaluation, relaxed_convolution, polynomial_interpolation
