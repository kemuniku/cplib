when not declared CPLIB_MATH_INNER_MATH:
    const CPLIB_MATH_INNER_MATH* = 1
    proc mul*(a, b, m: int): int {.importcpp: "(__int128)(#) * (#) % (#)", nodecl.}
