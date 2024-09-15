when not declared CPLIB_MATH_ISQRT:
    const CPLIB_MATH_ISQRT* = 1
    proc isqrt*(n: int): int =
        var x = n
        var y = (x + 1) shr 1
        while y < x:
            x = y
            y = (x + n div x) shr 1
        return x
