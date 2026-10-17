when not declared CPLIB_MODINT_MODINT64:
    const CPLIB_MODINT_MODINT64* = 1
    import macros, hashes

    when not (defined(c) or defined(cpp)):
        {.error: "modint64はC/C++ backendを使用してください".}
    {.emit: """
    #if !defined(__SIZEOF_INT128__)
    #error "modint64 requires unsigned __int128"
    #endif
    """.}
    proc mulModint64Native(a, b, m: uint64): uint64 {.inline.} =
        ## 符号なし128bitの積を法で正規化する。O(1)。
        {.emit: "`result` = (NU64)(((unsigned __int128)`a` * `b`) % `m`);".}

    proc addModint64(a, b, m: uint64): uint64 {.inline.} =
        ## 正規化値を加算し、64bitのcarryも処理する。O(1)。
        let s = a + b
        if s < a or s >= m: s - m else: s

    proc mulModint64(a, b, m: uint64): uint64 {.inline.} =
        ## 実行時は128bit乗算、コンパイル時は二進法で積を求める。O(1)/O(64)。
        when nimvm:
            var factor = a
            var multiplier = b
            while multiplier != 0:
                if (multiplier and 1) != 0: result = addModint64(result, factor, m)
                multiplier = multiplier shr 1
                if multiplier != 0: factor = addModint64(factor, factor, m)
        else:
            result = mulModint64Native(a, b, m)

    proc powModint64(a, n, m: uint64): uint64 =
        ## 非負の指数で累乗を求める。O(log n)回の乗算。
        var factor = a
        var exponent = n
        result = 1
        while exponent != 0:
            if (exponent and 1) != 0: result = mulModint64(result, factor, m)
            exponent = exponent shr 1
            if exponent != 0: factor = mulModint64(factor, factor, m)

    proc primeModint64(m: uint64): bool =
        ## 64bit全域で決定的なMiller-Rabin素数判定を行う。O(64)回の乗算。
        if m == 2: return true
        if m < 2 or (m and 1) == 0: return false
        var d = m - 1
        var s = 0
        while (d and 1) == 0:
            d = d shr 1
            inc s
        for base in [2u64, 325, 9375, 28178, 450775, 9780504, 1795265022]:
            let a = base mod m
            if a == 0: continue
            var x = powModint64(a, d, m)
            if x == 1 or x == m - 1: continue
            var passed = false
            for _ in 1..<s:
                x = mulModint64(x, x, m)
                if x == m - 1:
                    passed = true
                    break
            if not passed: return false
        true

    proc checkedModint64(m: uint64): uint64 =
        ## 法が素数であることを検査する。不正な法はValueError。
        if not primeModint64(m):
            raise newException(ValueError, "modint64の法はuint64の素数である必要があります")
        m

    type StaticModint64*[M: static[uint64]] = object
        a: uint64
    type Modint64* = concept value
        value is StaticModint64

    template umod*[M: static[uint64]](self: typedesc[StaticModint64[M]] or StaticModint64[M]): uint64 =
        ## 素数検査済みの法をuint64で返す。検査はコンパイル時のみ。
        block:
            const modulus = checkedModint64(M)
            modulus
    template `mod`*[M: static[uint64]](self: typedesc[StaticModint64[M]] or StaticModint64[M]): uint64 =
        ## uint64の法を返す。O(1)。
        self.umod
    template get_M*[M: static[uint64]](self: typedesc[StaticModint64[M]]): uint64 =
        ## 既存modintと同じ名前で法を返す。O(1)。
        self.umod

    proc init*[T: Modint64](self: typedesc[T], x: T or SomeInteger): T {.inline.} =
        ## 整数を[0, 法)に正規化する。signed最小値も扱う。O(1)。
        const modulus = T.umod
        when x is T:
            result = x
        elif x is SomeUnsignedInt:
            result.a = x.uint64 mod modulus
        else:
            let value = x.int64
            if value >= 0:
                result.a = value.uint64 mod modulus
            else:
                let magnitude = 0u64 - cast[uint64](value)
                let remainder = magnitude mod modulus
                result.a = if remainder == 0: 0u64 else: modulus - remainder

    proc val*[T: Modint64](x: T): uint64 {.inline.} =
        ## 正規化済みの剰余をuint64で返す。O(1)。
        discard T.umod
        x.a
    proc `+=`*[T: Modint64](x: var T, y: T or SomeInteger) {.inline.} =
        ## 加算する。O(1)。
        x.a = addModint64(x.a, T.init(y).a, T.umod)
    proc `-=`*[T: Modint64](x: var T, y: T or SomeInteger) {.inline.} =
        ## borrowを処理して減算する。O(1)。
        let b = T.init(y).a
        x.a = if x.a >= b: x.a - b else: T.umod - (b - x.a)
    proc `*=`*[T: Modint64](x: var T, y: T or SomeInteger) {.inline.} =
        ## unsigned 128bit中間値を使って乗算する。O(1)。
        x.a = mulModint64(x.a, T.init(y).a, T.umod)
    proc `-`*[T: Modint64](x: T): T {.inline.} =
        ## 加法逆元を返す。O(1)。
        result.a = if x.a == 0: 0u64 else: T.umod - x.a
    proc pow*[T: Modint64](x: T, n: SomeInteger): T =
        ## 非負の指数の累乗を返す。負の指数はValueError。O(log n)。
        when n is SomeSignedInt:
            if n < 0: raise newException(ValueError, "指数は非負である必要があります")
        result.a = powModint64(x.a, n.uint64, T.umod)
    proc inv*[T: Modint64](x: T): T =
        ## Fermatの小定理で逆元を返す。0はValueError。O(log 法)。
        if x.a == 0: raise newException(ValueError, "0の逆元を求めることはできません")
        x.pow(T.umod - 2)
    proc `/=`*[T: Modint64](x: var T, y: T or SomeInteger) {.inline.} =
        ## 非零値で除算する。O(log 法)。
        x *= T.init(y).inv

    template defineModint64Binary(op, assignOp: untyped) =
        proc op*[T: Modint64](x: T, y: T or SomeInteger): T {.inline.} =
            ## 二項演算を行う。加減乗算O(1)、除算O(log 法)。
            result = x
            assignOp(result, y)
        proc op*[T: Modint64](x: SomeInteger, y: T): T {.inline.} =
            ## 左辺の整数を正規化して二項演算を行う。
            result = T.init(x)
            assignOp(result, y)
    defineModint64Binary(`+`, `+=`)
    defineModint64Binary(`-`, `-=`)
    defineModint64Binary(`*`, `*=`)
    defineModint64Binary(`/`, `/=`)

    proc `==`*[M: static[uint64]](x, y: StaticModint64[M]): bool {.inline.} =
        ## 正規化値の等値を判定する。O(1)。
        discard StaticModint64[M].umod
        x.a == y.a
    proc hash*[M: static[uint64]](x: StaticModint64[M]): Hash =
        ## 正規化値をハッシュ化する。O(1)。
        hash(x.val)
    proc `$`*[M: static[uint64]](x: StaticModint64[M]): string =
        ## 正規化値の十進文字列を返す。O(桁数)。
        $x.val
    proc parseModint64*[T: Modint64](self: typedesc[T], s: string): T =
        ## 任意桁数の[+-]?[0-9]+を剰余として読む。不正な入力はValueError。O(桁数)。
        var i = 0
        var negative = false
        if s.len > 0 and s[0] in {'+', '-'}:
            negative = s[0] == '-'
            inc i
        if i == s.len: raise newException(ValueError, "整数の桁が必要です")
        result = T.init(0)
        while i < s.len:
            if s[i] notin {'0'..'9'}: raise newException(ValueError, "不正な十進整数です")
            result *= 10
            result += ord(s[i]) - ord('0')
            inc i
        if negative and result.a != 0: result.a = T.umod - result.a
    proc init*[T: Modint64](self: typedesc[T], s: string): T =
        ## 十進文字列から剰余を作る。O(桁数)。
        self.parseModint64(s)

    macro declarStaticModint64*(name, M: untyped): untyped =
        ## 型と整数converterを宣言し、法をコンパイル時に検査する。
        let converterName = ident("to" & $name)
        quote do:
            type `name`* = StaticModint64[`M`]
            static:
                discard `name`.umod
            converter `converterName`*(x: int): `name` =
                ## 整数を正規化してmodint64へ変換する。O(1)。
                `name`.init(x)
