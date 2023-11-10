when not declared COMPETITIVE_MATH_INNER_MATH:
    const COMPETITIVE_MATH_INNER_MATH* = 1
    proc mul*(a, b, m: int): int {.importcpp: "(__int128)(#) * (#) % (#)", nodecl.}
