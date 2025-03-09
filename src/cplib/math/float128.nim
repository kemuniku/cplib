when not declared CPLIB_MATH_FLOAT128:
    const CPLIB_MATH_FLOAT128* = 1

    type float128* {.importcpp: "__float128", nodecl.} = object
    converter to_float128*(x: SomeInteger):float128  {.importcpp: "(__float128)((#))", nodecl.}
    converter to_float128*(x: SomeFloat):float128  {.importcpp: "(__float128)((#))", nodecl.}
    proc to_float*(x:float128):float {.importcpp: "(double)((#))", nodecl.}
    proc `-`*(x: float128): float128 {.importcpp: "-((#))", nodecl.}
    proc `+=`*(x: var float128, y: float128) {.importcpp: "((#) += (#))", nodecl.}
    proc `-=`*(x: var float128, y: float128) {.importcpp: "((#) -= (#))", nodecl.}
    proc `*=`*(x: var float128, y: float128) {.importcpp: "((#) *= (#))", nodecl.}
    proc `/=`*(x: var float128, y: float128) {.importcpp: "((#) /= (#))", nodecl.}
    proc `mod=`*(x: var float128, y: float128) {.importcpp: "((#) %= (#))", nodecl.}
    proc `&=`*(x: var float128, y: float128) {.importcpp: "((#) &= (#))", nodecl.}
    proc `|=`*(x: var float128, y: float128) {.importcpp: "((#) |= (#))", nodecl.}
    proc `^=`*(x: var float128, y: float128) {.importcpp: "((#) ^= (#))", nodecl.}
    proc `<<=`*(x: var float128, y: float128) {.importcpp: "((#) <<= (#))", nodecl.}
    proc `>>=`*(x: var float128, y: float128) {.importcpp: "((#) >>= (#))", nodecl.}

    proc `+`*(x, y: float128): float128 = (result = x; result += y)
    proc `-`*(x, y: float128): float128 = (result = x; result -= y)
    proc `*`*(x, y: float128): float128 = (result = x; result *= y)
    proc `/`*(x, y: float128): float128 = (result = x; result /= y)
    proc `mod`*(x, y: float128): float128 = (result = x; result.mod= y)
    proc `&`*(x, y: float128): float128 = (result = x; result &= y)
    proc `|`*(x, y: float128): float128 = (result = x; result |= y)
    proc `^`*(x, y: float128): float128 = (result = x; result ^= y)
    proc `<<`*(x, y: float128): float128 = (result = x; result <<= y)
    proc `>>`*(x, y: float128): float128 = (result = x; result >>= y)

    proc `>`*(x, y: float128): bool {.importcpp: "((#) > (#))", nodecl.}
    proc `>=`*(x, y: float128): bool {.importcpp: "((#) >= (#))", nodecl.}
    proc `<`*(x, y: float128): bool {.importcpp: "((#) < (#))", nodecl.}
    proc `<=`*(x, y: float128): bool {.importcpp: "((#) <= (#))", nodecl.}
    proc `==`*(x, y: float128): bool {.importcpp: "((#) == (#))", nodecl.}
    proc abs*(x: float128): float128 = (if x >= 0:x else: -x)
    proc cmp*(x, y: float128): int = (if x < y: -1 elif x == y: 0 else: 1)