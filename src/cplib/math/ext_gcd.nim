when not declared CPLIB_MATH_EXT_GCD:
    const CPLIB_MATH_EXT_GCD* = 1
    import algorithm
    proc ext_gcd*(a, b: int): (int, int) =
        ## a*x + b*y = gcd(a, b) となる (x, y) をひとつ返す。
        ## 返す値はそのような(x, y) のうち |x| + |y| が最小となるもの
        var invert_a = a < 0
        var invert_b = b < 0
        var a = abs(a)
        var b = abs(b)
        var swap_ab = a < b
        if swap_ab: swap(a, b)
        var line = @[(a, b)]
        while a > 0 and b > 0:
            if line.len mod 2 == 1: a = a mod b
            else: b = b mod a
            line.add((a, b))
        var x = line.len and 1
        var y = 1 xor (line.len and 1)
        for (a, b) in line[0..^2].reversed:
            if a < b: x -= (b div a) * y
            else: y -= (a div b) * x
        if swap_ab: swap(x, y)
        if invert_a: x = -x
        if invert_b: y = -y
        return (x, y)
