when not declared CPLIB_MATH_MAXPLUS:
    const CPLIB_MATH_MAXPLUS* = 1

    import hashes

    type MaxPlus*[T] = object
        ## The max-plus (tropical) semiring.
        ##
        ## `+` is maximum, `*` is addition, `zero` is negative infinity,
        ## and `one` is the underlying value zero.
        value: T
        finite: bool

    proc initMaxPlus*[T](value: T): MaxPlus[T] {.inline.} =
        MaxPlus[T](value: value, finite: true)

    converter toMaxPlus*[T](value: T): MaxPlus[T] {.inline.} =
        initMaxPlus(value)

    proc negInfinity*[T](_: typedesc[MaxPlus[T]]): MaxPlus[T] {.inline.} =
        default(MaxPlus[T])

    proc zero*[T](_: typedesc[MaxPlus[T]]): MaxPlus[T] {.inline.} =
        default(MaxPlus[T])

    proc one*[T](_: typedesc[MaxPlus[T]]): MaxPlus[T] {.inline.} =
        initMaxPlus(T(0))

    proc isFinite*[T](x: MaxPlus[T]): bool {.inline.} = x.finite
    proc isNegInfinity*[T](x: MaxPlus[T]): bool {.inline.} = not x.finite

    proc val*[T](x: MaxPlus[T]): T {.inline.} =
        ## Returns the underlying value. Negative infinity has no value.
        assert x.finite, "max-plus negative infinity has no finite value"
        x.value

    proc get*[T](x: MaxPlus[T], fallback: T): T {.inline.} =
        if x.finite: x.value else: fallback

    proc `$`*[T](x: MaxPlus[T]): string =
        if x.finite: $x.value else: "-inf"

    proc `==`*[T](a, b: MaxPlus[T]): bool {.inline.} =
        a.finite == b.finite and (not a.finite or a.value == b.value)

    proc `<`*[T](a, b: MaxPlus[T]): bool {.inline.} =
        if not a.finite: b.finite
        elif not b.finite: false
        else: a.value < b.value

    proc `<=`*[T](a, b: MaxPlus[T]): bool {.inline.} = a < b or a == b
    proc `>`*[T](a, b: MaxPlus[T]): bool {.inline.} = b < a
    proc `>=`*[T](a, b: MaxPlus[T]): bool {.inline.} = b <= a

    proc `+`*[T](a, b: MaxPlus[T]): MaxPlus[T] {.inline.} =
        if a >= b: a else: b

    proc `+=`*[T](a: var MaxPlus[T], b: MaxPlus[T]) {.inline.} = a = a + b

    proc `*`*[T](a, b: MaxPlus[T]): MaxPlus[T] {.inline.} =
        if a.finite and b.finite: initMaxPlus(a.value + b.value)
        else: MaxPlus[T].zero

    proc `*=`*[T](a: var MaxPlus[T], b: MaxPlus[T]) {.inline.} = a = a * b

    proc pow*[T](a: MaxPlus[T], exponent: Natural): MaxPlus[T] =
        result = MaxPlus[T].one
        var a = a
        var exponent = exponent
        while exponent > 0:
            if (exponent and 1) == 1: result *= a
            a *= a
            exponent = exponent shr 1

    proc `^`*[T](a: MaxPlus[T], exponent: Natural): MaxPlus[T] {.inline.} =
        a.pow(exponent)

    proc hash*[T](x: MaxPlus[T]): Hash =
        if x.finite: hash(x.value) !& Hash(1)
        else: Hash(0)
