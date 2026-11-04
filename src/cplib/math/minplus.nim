when not declared CPLIB_MATH_MINPLUS:
    const CPLIB_MATH_MINPLUS* = 1
    import hashes

    type MinPlus*[T: SomeSignedInt] = object
        ## minと加算の半環。既定値は正の無限大で、有限値と区別する。
        ## Tは符号付き整数。全ての有限中間加算が範囲内であることが必要。
        ## 飽和・丸め・体の減算/除算は定義しない。無限大との乗算では加算しない。
        value: T
        finite: bool

    proc initMinPlus*[T: SomeSignedInt](value: T): MinPlus[T] {.inline.} =
        ## 有限値を作る。整数の全範囲を利用できる。O(1)。
        MinPlus[T](value: value, finite: true)

    proc zero*[T](_: typedesc[MinPlus[T]]): MinPlus[T] {.inline.} =
        ## 加法単位元（正の無限大）を返す。O(1)。
        default(MinPlus[T])
    proc infinity*[T](_: typedesc[MinPlus[T]]): MinPlus[T] {.inline.} =
        ## 無限大を返す。O(1)。
        MinPlus[T].zero
    proc one*[T](_: typedesc[MinPlus[T]]): MinPlus[T] {.inline.} =
        ## 乗法単位元（有限値0）を返す。O(1)。
        initMinPlus(T(0))
    proc isFinite*[T](x: MinPlus[T]): bool {.inline.} =
        ## 有限値か判定する。O(1)。
        x.finite
    proc isInfinity*[T](x: MinPlus[T]): bool {.inline.} =
        ## 無限大か判定する。O(1)。
        not x.finite
    proc val*[T](x: MinPlus[T]): T {.inline.} =
        ## 有限値を返す。無限大はValueError。O(1)。
        if not x.finite: raise newException(ValueError, "無限大に有限値はありません")
        x.value
    proc get*[T](x: MinPlus[T], fallback: T): T {.inline.} =
        ## 有限値、または無限大の代替値を返す。O(1)。
        if x.finite: x.value else: fallback
    proc `$`*[T](x: MinPlus[T]): string =
        ## 有限値または無限大を文字列にする。
        if x.finite: $x.value else: "inf"
    proc `==`*[T](a, b: MinPlus[T]): bool {.inline.} =
        ## 有限値と無限大を区別して比較する。O(1)。
        a.finite == b.finite and (not a.finite or a.value == b.value)
    proc `<`*[T](a, b: MinPlus[T]): bool {.inline.} =
        ## 無限大を含む大小関係を比較する。O(1)。
        if not b.finite: a.finite
        elif not a.finite: false
        else: a.value < b.value
    proc `<=`*[T](a, b: MinPlus[T]): bool {.inline.} =
        ## 以下か判定する。O(1)。
        a < b or a == b
    proc `>`*[T](a, b: MinPlus[T]): bool {.inline.} =
        ## より大きいか判定する。O(1)。
        b < a
    proc `>=`*[T](a, b: MinPlus[T]): bool {.inline.} =
        ## 以上か判定する。O(1)。
        b <= a
    proc `+`*[T](a, b: MinPlus[T]): MinPlus[T] {.inline.} =
        ## 最小を取る半環の加法。O(1)。
        if a <= b: a else: b
    proc `+=`*[T](a: var MinPlus[T], b: MinPlus[T]) {.inline.} =
        ## 半環の加法で更新する。O(1)。
        a = a + b
    proc `*`*[T](a, b: MinPlus[T]): MinPlus[T] {.inline.} =
        ## 有限値を加算する。無限大は吸収元、有限overflowは全ビルドでOverflowDefect。O(1)。
        if not a.finite or not b.finite: return MinPlus[T].zero
        if (b.value > 0 and a.value > high(T) - b.value) or
                (b.value < 0 and a.value < low(T) - b.value):
            raise newException(OverflowDefect, "半環の有限値の加算が整数の範囲を超えました")
        initMinPlus(a.value + b.value)
    proc `*=`*[T](a: var MinPlus[T], b: MinPlus[T]) {.inline.} =
        ## 半環の乗法で更新する。O(1)。
        a = a * b
    proc pow*[T](a: MinPlus[T], exponent: int): MinPlus[T] =
        ## 非負整数乗を求める。指数0はone、負の指数はValueError。O(log(exponent+1))。
        if exponent < 0: raise newException(ValueError, "指数は非負である必要があります")
        result = MinPlus[T].one
        var base = a
        var e = exponent
        while e > 0:
            if (e and 1) == 1: result *= base
            e = e shr 1
            if e > 0: base *= base
    proc `^`*[T](a: MinPlus[T], exponent: int): MinPlus[T] =
        ## 半環の非負整数乗を求める。O(log(exponent+1))。
        a.pow(exponent)
    proc hash*[T](x: MinPlus[T]): Hash =
        ## 等値な要素には同じハッシュ値を返す。O(1)。
        if x.finite: hash(x.value) !& Hash(1)
        else: Hash(0)
