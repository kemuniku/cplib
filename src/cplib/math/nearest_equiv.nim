when not declared CPLIB_MATH_NEAREST_EQUIV:
    const CPLIB_MATH_NEAREST_EQUIV* = 1
    proc nearest_equiv*(x, l, m: int): int =
        ## (y ≡ x mod m) かつ (y ≧ l) であるような最小の整数 y を返します。
        var m = abs(m)
        if x < l: return x + (l - x + m - 1) div m * m
        return x - (x - l) div m * m
