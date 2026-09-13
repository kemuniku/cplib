when not declared CPLIB_MATH_MONOID_FLOOR_SUM:
    const CPLIB_MATH_MONOID_FLOOR_SUM* = 1

    proc monoidFloorSum*[T](n, m, a, b: int, x, y: T,
                                 op: proc(l, r: T): T, e: T): T =
        ## h(i) = floor((a*i+b)/m) として y^h(0) * Π(i=1..n, x*y^(h(i)-h(i-1))) を返す。
        ## op は結合的な積、e は単位元。積は左から順に取り、可換性は不要。
        ## n,a,b >= 0、m > 0、a*n+b <= high(int) が必要。n=0 では y^h(0) を返す。
        ## op の呼び出し回数は O(log(m+1)*log(n+a+b+2))、追加領域は O(1) 個の T。
        proc power(value: T, exponent: int): T =
            ## モノイドの非負整数乗を O(log(exponent+1)) 回の演算で求める。
            var value = value
            var exponent = exponent
            result = e
            while exponent > 0:
                if (exponent and 1) != 0:
                    result = op(result, value)
                exponent = exponent shr 1
                if exponent > 0:
                    value = op(value, value)

        assert n >= 0 and m > 0 and a >= 0 and b >= 0
        assert n == 0 or a <= (high(int) - b) div n
        var
            n = n
            m = m
            a = a
            b = b
            x = x
            y = y
            prefix = e
            suffix = e
        while true:
            prefix = op(prefix, power(y, b div m))
            x = op(x, power(y, a div m))
            a = a mod m
            b = b mod m
            let height = (a * n + b) div m
            if height == 0:
                return op(op(prefix, power(x, n)), suffix)

            let lastX = (m * height - b - 1) div a + 1
            prefix = op(prefix, x)
            suffix = op(op(y, power(x, n - lastX)), suffix)
            # 縦横を交換する。切片から a を外して先頭の x に移し、加算のオーバーフローを避ける。
            n = height - 1
            b = m - b - 1
            swap(a, m)
            swap(x, y)
