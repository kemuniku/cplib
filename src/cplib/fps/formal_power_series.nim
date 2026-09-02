when not declared CPLIB_FPS_FORMAL_POWER_SERIES:
    const CPLIB_FPS_FORMAL_POWER_SERIES* = 1

    import algorithm, options
    import cplib/convolution/convolution
    import cplib/modint/modint

    proc prefix*[T](f: seq[T], n: int): seq[T] =
        ## f を x^n で打ち切る。返り値の長さは max(n, 0) になる。
        if n <= 0: return @[]
        result = newSeq[T](n)
        for i in 0..<min(f.len, n): result[i] = f[i]

    proc normalized*[T: BarrettModint or MontgomeryModint](f: seq[T]): seq[T] =
        ## 高次側の不要な零係数を取り除く。
        result = f
        while result.len > 0 and result[^1].val == 0: result.setLen(result.len - 1)

    proc `+`*[T: BarrettModint or MontgomeryModint](f, g: seq[T]): seq[T] =
        result = newSeq[T](max(f.len, g.len))
        for i in 0..<f.len: result[i] += f[i]
        for i in 0..<g.len: result[i] += g[i]

    proc `-`*[T: BarrettModint or MontgomeryModint](f, g: seq[T]): seq[T] =
        result = newSeq[T](max(f.len, g.len))
        for i in 0..<f.len: result[i] += f[i]
        for i in 0..<g.len: result[i] -= g[i]

    proc `-`*[T: BarrettModint or MontgomeryModint](f: seq[T]): seq[T] =
        result = newSeq[T](f.len)
        for i in 0..<f.len: result[i] = -f[i]

    proc `*`*[T: BarrettModint or MontgomeryModint](f, g: seq[T]): seq[T] =
        convolution(f, g)

    proc `*`*[T: BarrettModint or MontgomeryModint](f: seq[T], c: T): seq[T] =
        result = newSeq[T](f.len)
        for i in 0..<f.len: result[i] = f[i] * c

    proc `*`*[T: BarrettModint or MontgomeryModint](c: T, f: seq[T]): seq[T] = f * c

    proc `/`*[T: BarrettModint or MontgomeryModint](f: seq[T], c: T): seq[T] =
        result = newSeq[T](f.len)
        let cinv = c.inv
        for i in 0..<f.len: result[i] = f[i] * cinv

    proc `+=`*[T: BarrettModint or MontgomeryModint](f: var seq[T], g: seq[T]) =
        if f.len < g.len: f.setLen(g.len)
        for i in 0..<g.len: f[i] += g[i]

    proc `-=`*[T: BarrettModint or MontgomeryModint](f: var seq[T], g: seq[T]) =
        if f.len < g.len: f.setLen(g.len)
        for i in 0..<g.len: f[i] -= g[i]

    proc `*=`*[T: BarrettModint or MontgomeryModint](f: var seq[T], c: T) =
        for x in f.mitems: x *= c

    proc `/=`*[T: BarrettModint or MontgomeryModint](f: var seq[T], c: T) =
        let cinv = c.inv
        for x in f.mitems: x *= cinv

    proc derivative*[T: BarrettModint or MontgomeryModint](f: seq[T]): seq[T] =
        if f.len <= 1: return @[]
        result = newSeq[T](f.len - 1)
        for i in 1..<f.len: result[i - 1] = f[i] * i

    proc integral*[T: BarrettModint or MontgomeryModint](f: seq[T]): seq[T] =
        doAssert f.len < T.umod.int,
            "FPSの積分では除数となる添字がすべて法未満である必要がある"
        result = newSeq[T](f.len + 1)
        for i in 0..<f.len: result[i + 1] = f[i] / (i + 1)

    proc inv*[T: BarrettModint or MontgomeryModint](f: seq[T], n: int): seq[T] =
        ## Newton法により、x^n を法とした乗法逆元を求める。
        if n <= 0: return @[]
        doAssert f.len > 0 and f[0].val != 0,
            "FPSの乗法逆元を求めるには定数項が非零である必要がある"
        result = @[f[0].inv]
        var m = 1
        while m < n:
            let next = min(m * 2, n)
            let fg = prefix(f, next) * result
            var correction = newSeq[T](next)
            correction[0] = 2
            for i in 0..<min(fg.len, next): correction[i] -= fg[i]
            result = prefix(result * correction, next)
            m = next

    proc inv*[T: BarrettModint or MontgomeryModint](f: seq[T]): seq[T] = f.inv(f.len)

    proc log*[T: BarrettModint or MontgomeryModint](f: seq[T], n: int): seq[T] =
        ## x^n で打ち切った形式的対数を求める。f(0) = 1 を仮定する。
        if n <= 0: return @[]
        doAssert n <= T.umod.int, "FPSの形式的対数では n が法以下である必要がある"
        doAssert f.len > 0 and f[0].val == 1,
            "FPSの形式的対数を求めるには定数項が1である必要がある"
        result = prefix(integral(derivative(f) * f.inv(n)), n)

    proc log*[T: BarrettModint or MontgomeryModint](f: seq[T]): seq[T] = f.log(f.len)

    proc exp*[T: BarrettModint or MontgomeryModint](f: seq[T], n: int): seq[T] =
        ## x^n で打ち切った形式的指数関数を求める。f(0) = 0 を仮定する。
        if n <= 0: return @[]
        doAssert n <= T.umod.int, "FPSの形式的指数関数では n が法以下である必要がある"
        doAssert f.len == 0 or f[0].val == 0,
            "FPSの形式的指数関数を求めるには定数項が0である必要がある"
        result = newSeq[T](1)
        result[0] = 1
        var m = 1
        while m < n:
            let next = min(m * 2, n)
            var correction = prefix(f, next) - result.log(next)
            correction.setLen(next)
            correction[0] += 1
            result = prefix(result * correction, next)
            m = next

    proc exp*[T: BarrettModint or MontgomeryModint](f: seq[T]): seq[T] = f.exp(f.len)

    proc pow*[T: BarrettModint or MontgomeryModint](f: seq[T], k, n: int): seq[T] =
        ## x^n で打ち切った整数冪を求める。k は非負でなければならない。
        doAssert k >= 0, "FPSの整数冪では指数が非負である必要がある"
        if n <= 0: return @[]
        doAssert n <= T.umod.int, "FPSの整数冪では n が法以下である必要がある"
        if k == 0:
            result = newSeq[T](n)
            result[0] = 1
            return
        var ord = 0
        while ord < f.len and f[ord].val == 0: inc ord
        if ord == f.len or ord > (n - 1) div k: return newSeq[T](n)
        let shift = ord * k
        let c = f[ord]
        let size = n - shift
        var unit = newSeq[T](min(f.len - ord, size))
        let cinv = c.inv
        for i in 0..<unit.len: unit[i] = f[ord + i] * cinv
        var body = (unit.log(size) * init(T, k)).exp(size)
        body *= c.pow(k)
        result = newSeq[T](n)
        for i in 0..<body.len: result[shift + i] = body[i]

    proc pow*[T: BarrettModint or MontgomeryModint](f: seq[T], k: int): seq[T] = f.pow(k, f.len)

    proc modSqrt[T: BarrettModint or MontgomeryModint](a: T): Option[T] =
        ## Tonelli--Shanks法。法が素数であることを仮定する。
        let p = T.umod.int
        if a.val == 0: return some(init(T, 0))
        if p == 2: return some(a)
        if a.pow((p - 1) div 2).val != 1: return none(T)
        if p mod 4 == 3: return some(a.pow((p + 1) div 4))
        var q = p - 1
        var s = 0
        while (q and 1) == 0:
            q = q shr 1
            inc s
        var z = init(T, 2)
        while z.pow((p - 1) div 2).val != p - 1: z += 1
        var c = z.pow(q)
        var x = a.pow((q + 1) div 2)
        var t = a.pow(q)
        var m = s
        while t.val != 1:
            var i = 1
            var tt = t * t
            while i < m and tt.val != 1:
                tt *= tt
                inc i
            if i == m: return none(T)
            let b = c.pow(1 shl (m - i - 1))
            x *= b
            c = b * b
            t *= c
            m = i
        some(x)

    proc sqrt*[T: BarrettModint or MontgomeryModint](f: seq[T], n: int): Option[seq[T]] =
        ## x^n を法とした形式的平方根を求める。存在しない場合はnoneを返す。
        if n <= 0: return some(newSeq[T]())
        var ord = 0
        while ord < min(f.len, n) and f[ord].val == 0: inc ord
        if ord == min(f.len, n): return some(newSeq[T](n))
        if (ord and 1) != 0: return none(seq[T])
        let shift = ord div 2
        let root0 = modSqrt(f[ord])
        if root0.isNone: return none(seq[T])
        let size = n - shift
        var unit = newSeq[T](min(f.len - ord, size))
        for i in 0..<unit.len: unit[i] = f[ord + i]
        var root = @[root0.get]
        var m = 1
        while m < size:
            let next = min(m * 2, size)
            root = prefix((root + prefix(unit, next) * root.inv(next)) / init(T, 2), next)
            m = next
        var answer = newSeq[T](n)
        for i in 0..<root.len: answer[shift + i] = root[i]
        some(answer)

    proc sqrt*[T: BarrettModint or MontgomeryModint](f: seq[T]): Option[seq[T]] = f.sqrt(f.len)

    proc reversed[T](f: seq[T]): seq[T] =
        result = f
        result.reverse

    proc divmod*[T: BarrettModint or MontgomeryModint](f, g: seq[T]): tuple[q, r: seq[T]] =
        ## 多項式としての商と余りを求める。末尾の零係数は無視する。
        let a = f.normalized
        let b = g.normalized
        doAssert b.len > 0, "零多項式では除算できない"
        if a.len < b.len: return (@[], a)
        let qlen = a.len - b.len + 1
        result.q = prefix(a.reversed * b.reversed.inv(qlen), qlen).reversed.normalized
        result.r = (a - result.q * b).prefix(b.len - 1).normalized

    proc `div`*[T: BarrettModint or MontgomeryModint](f, g: seq[T]): seq[T] = f.divmod(g).q
    proc `mod`*[T: BarrettModint or MontgomeryModint](f, g: seq[T]): seq[T] = f.divmod(g).r

    proc eval*[T: BarrettModint or MontgomeryModint](f: seq[T], x: T): T =
        for i in countdown(f.high, 0): result = result * x + f[i]
