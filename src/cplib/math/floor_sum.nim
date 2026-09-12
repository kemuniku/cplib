when not declared CPLIB_MATH_FLOOR_SUM:
    const CPLIB_MATH_FLOOR_SUM* = 1

    import cplib/math/int128

    proc floor_sum*(n, m, a, b: int): int =
        ## Σ floor((a*i+b)/m) (0 <= i < n) を O(log m) 時間、O(1) 空間で返す。
        ## n, a, b >= 0、m > 0、答えが int に収まることを前提とする。C++ バックエンド用。
        assert n >= 0 and m > 0 and a >= 0 and b >= 0
        var n = to_Int128(n)
        var m = to_Int128(m)
        var a = to_Int128(a)
        var b = to_Int128(b)
        var answer = to_Int128(0)
        while true:
            if a >= m:
                answer += n * (n - 1) div 2 * (a div m)
                a = a mod m
            if b >= m:
                answer += n * (b div m)
                b = b mod m
            assert answer <= to_Int128(high(int))
            let y = a * n + b
            if y < m:
                break
            n = y div m
            b = y mod m
            swap(m, a)
        return answer.to_int
