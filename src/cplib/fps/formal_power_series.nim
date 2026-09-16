when not declared CPLIB_FPS_FORMAL_POWER_SERIES:
    const CPLIB_FPS_FORMAL_POWER_SERIES* = 1

    import algorithm, options
    import cplib/convolution/convolution
    import cplib/modint/modint
    import cplib/math/isprime

    proc prefix*[T](f: seq[T], n: int): seq[T] =
        ## f を x^n で打ち切る。返り値の長さは max(n, 0) になる。
        if n <= 0: return @[]
        result = newSeq[T](n)
        for i in 0..<min(f.len, n): result[i] = f[i]

    proc coefficient*[T: BarrettModint or MontgomeryModint](f: seq[T], degree: int): T =
        ## 指定した次数の係数を返す。範囲外なら零を返す。
        if degree < 0 or degree >= f.len: return init(T, 0)
        result = f[degree]

    proc normalized*[T: BarrettModint or MontgomeryModint](f: seq[T]): seq[T] =
        ## 高次側の不要な零係数を取り除く。
        result = f
        while result.len > 0 and result[^1].val == 0: result.setLen(result.len - 1)

    proc `+`*[T: BarrettModint or MontgomeryModint](f, g: seq[T]): seq[T] =
        result = newSeq[T](max(f.len, g.len))
        for i in 0..<f.len: result[i] += f[i]
        for i in 0..<g.len: result[i] += g[i]

    proc `+`*[T: BarrettModint or MontgomeryModint](f: seq[T], c: SomeInteger): seq[T] =
        result = f
        if result.len == 0: result.add(init(T, c))
        else: result[0] += c

    proc `+`*[T: BarrettModint or MontgomeryModint](c: SomeInteger, f: seq[T]): seq[T] = f + c

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

    proc `+=`*[T: BarrettModint or MontgomeryModint](f: var seq[T], c: SomeInteger) =
        if f.len == 0: f.add(init(T, c))
        else: f[0] += c

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

    proc fpsIndexInverses[T: BarrettModint or MontgomeryModint](n: int): seq[T] =
        ## 1以上n未満の逆数表を作る。素数法ではO(n)、合成数法では各添字のinvを使う。
        result = newSeq[T](n)
        if n > 1: result[1] = init(T, 1)
        if n <= 2: return
        let p = T.umod.int
        if not isprime(p):
            for i in 2..<n: result[i] = init(T, i).inv
            return
        for i in 2..<n: result[i] = -result[p mod i] * (p div i)

    proc integral*[T: BarrettModint or MontgomeryModint](f: seq[T]): seq[T] =
        ## 逆数表を用いて積分する。素数法ではO(n)、合成数法ではO(n log mod)。
        assert f.len < T.umod.int,
            "FPSの積分では除数となる添字がすべて法未満である必要がある"
        let inverses = fpsIndexInverses[T](f.len + 1)
        result = newSeq[T](f.len + 1)
        for i in 0..<f.len: result[i + 1] = f[i] * inverses[i + 1]

    proc fpsFixedCreate(data: ptr uint32, length, size: csize_t,
            modulus, root: uint32): pointer {.importc: "cplib_fixed_convolution_create".}
        ## 固定側のNTTと変換計画を構築する。

    proc fpsFixedRun(context: pointer, output, data: ptr uint32,
            length: csize_t) {.importc: "cplib_fixed_convolution_run".}
        ## 固定側のNTTを再利用して巡回畳み込みを求める。

    proc fpsFixedDestroy(context: pointer) {.importc: "cplib_fixed_convolution_destroy".}
        ## 固定側のNTTと変換計画を解放する。

    proc fpsInvExtend[T: BarrettModint or MontgomeryModint](
            f: seq[T], g: var seq[T], n: int) =
        ## 長さmの逆元gをm < n <= 2mまで拡張する。mは2の冪。O(m log m)。
        let m = g.len
        let size = m * 2
        let count = n - m
        let p = T.umod
        if size >= 128 and p < (1u32 shl 30) and
                (p - 1) mod size.uint32 == 0 and isprime(p):
            var product = newSeq[uint32](size)
            var context: pointer
            when T is BarrettModint:
                context = fpsFixedCreate(cast[ptr uint32](unsafeAddr g[0]),
                    m.csize_t, size.csize_t, p, 0u32)
            else:
                var fixed = newSeq[uint32](m)
                for i in 0..<m: fixed[i] = g[i].val.uint32
                context = fpsFixedCreate(addr fixed[0], m.csize_t,
                    size.csize_t, p, 0u32)
            defer: fpsFixedDestroy(context)
            let length = min(f.len, n)
            when T is BarrettModint:
                fpsFixedRun(context, addr product[0],
                    cast[ptr uint32](unsafeAddr f[0]), length.csize_t)
            else:
                var input = newSeq[uint32](length)
                for i in 0..<length: input[i] = f[i].val.uint32
                fpsFixedRun(context, addr product[0], addr input[0], length.csize_t)
            fpsFixedRun(context, addr product[0], addr product[m], count.csize_t)
            g.setLen(n)
            for i in 0..<count: g[m + i] = -init(T, product[i].int)
        else:
            let fPrefix = if f.len <= n: f else: f[0..<n]
            let product = convolutionCyclicPowerOfTwo(fPrefix, g, size)
            var error = newSeq[T](count)
            for i in 0..<count: error[i] = -product[m + i]
            let extension = g * error
            g.setLen(n)
            for i in 0..<count: g[m + i] = extension[i]

    proc inv*[T: BarrettModint or MontgomeryModint](f: seq[T], n: int): seq[T] =
        ## Newton法により、x^nを法とした乗法逆元をO(n log n)で求める。
        if n <= 0: return @[]
        assert f.len > 0 and f[0].val != 0,
            "FPSの乗法逆元を求めるには定数項が非零である必要がある"
        result = @[f[0].inv]
        while result.len < n:
            fpsInvExtend(f, result, min(result.len * 2, n))

    proc inv*[T: BarrettModint or MontgomeryModint](f: seq[T]): seq[T] = f.inv(f.len)

    proc `/`*[T: BarrettModint or MontgomeryModint](f, g: seq[T]): seq[T] =
        ## f / g の先頭 max(f.len, g.len) 項を求める。
        let n = max(f.len, g.len)
        if n == 0: return @[]
        result = prefix(f * g.inv(n), n)

    proc `/=`*[T: BarrettModint or MontgomeryModint](f: var seq[T], g: seq[T]) =
        f = f / g

    proc log*[T: BarrettModint or MontgomeryModint](f: seq[T], n: int): seq[T] =
        ## x^n で打ち切った形式的対数を求める。f(0) = 1 を仮定する。
        if n <= 0: return @[]
        assert n <= T.umod.int, "FPSの形式的対数では n が法以下である必要がある"
        assert f.len > 0 and f[0].val == 1,
            "FPSの形式的対数を求めるには定数項が1である必要がある"
        let fPrefix = if f.len <= n: f else: f[0..<n]
        let product = prefix(derivative(fPrefix) * fPrefix.inv(n - 1), n - 1)
        result = integral(product)

    proc log*[T: BarrettModint or MontgomeryModint](f: seq[T]): seq[T] = f.log(f.len)

    proc exp*[T: BarrettModint or MontgomeryModint](f: seq[T], n: int): seq[T] =
        ## x^n で打ち切った形式的指数関数を求める。f(0) = 0 を仮定する。
        if n <= 0: return @[]
        assert n <= T.umod.int, "FPSの形式的指数関数では n が法以下である必要がある"
        assert f.len == 0 or f[0].val == 0,
            "FPSの形式的指数関数を求めるには定数項が0である必要がある"
        let inverses = fpsIndexInverses[T](n)
        let fPrefix = if f.len <= n: f else: f[0..<n]
        let df = derivative(fPrefix)
        result = @[init(T, 1)]
        var inverse = @[init(T, 1)]
        var m = 1
        while m < n:
            let next = min(m * 2, n)
            if inverse.len < m: fpsInvExtend(result, inverse, m)
            # g' - f'gは次数m-1未満が零。巡回畳み込みの折り返しはそこまでに収まる。
            let dfPrefix = if df.len < next: df else: df[0..<next - 1]
            let product = convolutionCyclicPowerOfTwo(dfPrefix, result, m * 2)
            var error = newSeq[T](next - m)
            for i in 0..<error.len: error[i] = -product[m - 1 + i]
            let quotient = error * prefix(inverse, error.len)
            for i in 0..<error.len: error[i] = -quotient[i] * inverses[m + i]
            let extension = result * error
            result.setLen(next)
            for i in 0..<error.len: result[m + i] = extension[i]
            m = next

    proc exp*[T: BarrettModint or MontgomeryModint](f: seq[T]): seq[T] = f.exp(f.len)

    proc pow*[T: BarrettModint or MontgomeryModint](f: seq[T], k, n: int): seq[T] =
        ## x^n で打ち切った整数冪を求める。k は非負でなければならない。
        assert k >= 0, "FPSの整数冪では指数が非負である必要がある"
        if n <= 0: return @[]
        assert n <= T.umod.int, "FPSの整数冪では n が法以下である必要がある"
        if k == 0:
            result = newSeq[T](n)
            result[0] = 1
            return
        if k == 1: return prefix(f, n)
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
        var inverse = @[root0.get.inv]
        let half = if size > 1: init(T, 2).inv else: init(T, 0)
        var m = 1
        while m < size:
            let next = min(m * 2, size)
            if inverse.len < m: fpsInvExtend(root, inverse, m)
            let square = root * root
            var error = newSeq[T](next - m)
            for i in 0..<error.len:
                error[i] = (unit.coefficient(m + i) - square.coefficient(m + i)) * half
            let extension = error * prefix(inverse, error.len)
            root.setLen(next)
            for i in 0..<error.len: root[m + i] = extension[i]
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
        assert b.len > 0, "零多項式では除算できない"
        if a.len < b.len: return (@[], a)
        let qlen = a.len - b.len + 1
        result.q = prefix(a.reversed * b.reversed.inv(qlen), qlen).reversed.normalized
        result.r = (a - result.q * b).prefix(b.len - 1).normalized

    proc `div`*[T: BarrettModint or MontgomeryModint](f, g: seq[T]): seq[T] = f.divmod(g).q
    proc `mod`*[T: BarrettModint or MontgomeryModint](f, g: seq[T]): seq[T] = f.divmod(g).r

    proc eval*[T: BarrettModint or MontgomeryModint](f: seq[T], x: T): T =
        for i in countdown(f.high, 0): result = result * x + f[i]
