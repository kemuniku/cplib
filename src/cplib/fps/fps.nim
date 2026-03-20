when not declared CPLIB_FPS_FPS:
    const CPLIB_FPS_FPS* = 1
    import cplib/convolution/convolution
    type FormalPowerSeries*[T] = distinct seq[T]
    proc initFormalPowerSeries*[T](n: int): FormalPowerSeries[T] = FormalPowerSeries[T](newSeq[T](n))
    proc initFormalPowerSeries*[T](f: sink seq[T]): FormalPowerSeries[T] = FormalPowerSeries[T](f)
    proc len*[T](f: FormalPowerSeries[T]): int = seq[T](f).len
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
    proc `*`*[T](a, b: FormalPowerSeries[T]): FormalPowerSeries[T] =
        var ans = convolution(seq[T](a), seq[T](b))
