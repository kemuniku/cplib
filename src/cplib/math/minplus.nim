when not declared CPLIB_MATH_MINPLUS:
    const CPLIB_MATH_MINPLUS* = 1

    import hashes

    type MinPlus*[T] = object
        ## The min-plus (tropical) semiring.
        ##
        ## `+` is minimum, `*` is addition, `zero` is positive infinity,
        ## and `one` is the underlying value zero.
        value: T
        finite: bool

    proc initMinPlus*[T](value: T): MinPlus[T] {.inline.} =
        MinPlus[T](value: value, finite: true)

    converter toMinPlus*[T](value: T): MinPlus[T] {.inline.} =
        initMinPlus(value)

    proc infinity*[T](_: typedesc[MinPlus[T]]): MinPlus[T] {.inline.} =
        default(MinPlus[T])

    proc zero*[T](_: typedesc[MinPlus[T]]): MinPlus[T] {.inline.} =
        default(MinPlus[T])

    proc one*[T](_: typedesc[MinPlus[T]]): MinPlus[T] {.inline.} =
        initMinPlus(T(0))

    proc isFinite*[T](x: MinPlus[T]): bool {.inline.} = x.finite
    proc isInfinity*[T](x: MinPlus[T]): bool {.inline.} = not x.finite

    proc val*[T](x: MinPlus[T]): T {.inline.} =
        ## Returns the underlying value. Infinity has no value.
        assert x.finite, "min-plus infinity has no finite value"
        x.value

    proc get*[T](x: MinPlus[T], fallback: T): T {.inline.} =
        if x.finite: x.value else: fallback

    proc `$`*[T](x: MinPlus[T]): string =
        if x.finite: $x.value else: "inf"

    proc `==`*[T](a, b: MinPlus[T]): bool {.inline.} =
        a.finite == b.finite and (not a.finite or a.value == b.value)

    proc `<`*[T](a, b: MinPlus[T]): bool {.inline.} =
        if not b.finite: a.finite
        elif not a.finite: false
        else: a.value < b.value

    proc `<=`*[T](a, b: MinPlus[T]): bool {.inline.} = a < b or a == b
    proc `>`*[T](a, b: MinPlus[T]): bool {.inline.} = b < a
    proc `>=`*[T](a, b: MinPlus[T]): bool {.inline.} = b <= a

    proc `+`*[T](a, b: MinPlus[T]): MinPlus[T] {.inline.} =
        if a <= b: a else: b

    proc `+=`*[T](a: var MinPlus[T], b: MinPlus[T]) {.inline.} = a = a + b

    proc `*`*[T](a, b: MinPlus[T]): MinPlus[T] {.inline.} =
        if a.finite and b.finite: initMinPlus(a.value + b.value)
        else: MinPlus[T].zero

    proc `*=`*[T](a: var MinPlus[T], b: MinPlus[T]) {.inline.} = a = a * b

    proc pow*[T](a: MinPlus[T], exponent: Natural): MinPlus[T] =
        result = MinPlus[T].one
        var a = a
        var exponent = exponent
        while exponent > 0:
            if (exponent and 1) == 1: result *= a
            a *= a
            exponent = exponent shr 1

    proc `^`*[T](a: MinPlus[T], exponent: Natural): MinPlus[T] {.inline.} =
        a.pow(exponent)

    proc hash*[T](x: MinPlus[T]): Hash =
        if x.finite: hash(x.value) !& Hash(1)
        else: Hash(0)
