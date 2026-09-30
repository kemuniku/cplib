when not declared CPLIB_MATH_ISQRT:
    const CPLIB_MATH_ISQRT* = 1
    proc isqrt*(n: int): int =
        ## 非負整数nの平方根の床を返す。
        var x = n
        var y = (x shr 1) + (x and 1)
        while y < x:
            x = y
            y = (x + n div x) shr 1
        return x
