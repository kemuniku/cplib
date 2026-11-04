when not declared CPLIB_MATH_ENUMERATE_QUOTIENTS:
    const CPLIB_MATH_ENUMERATE_QUOTIENTS* = 1

    iterator quotientValues*[T: SomeSignedInt](n: T): T =
        ## 1 <= x <= n の相異なる floor(n/x) を昇順に返す。時間 O(sqrt(n))、補助空間 O(1)。
        ## n == 0 は空、負の n は ValueError。符号付き整数型の最大値まで扱える。
        if n < 0:
            raise newException(ValueError, "n は非負である必要があります")
        var divisor = n
        while divisor > 0:
            let quotient = n div divisor
            yield quotient
            if quotient == n:
                break
            # quotient より大きい商を持つ最大の分母に進む。quotient + 1 <= n。
            divisor = n div (quotient + 1)

    proc enumerateQuotients*[T: SomeSignedInt](n: T): seq[T] =
        ## 1 <= x <= n の相異なる floor(n/x) の昇順列。時間・出力空間 O(sqrt(n))。
        ## n == 0 は空、負の n は ValueError。全列挙には出力を格納できるメモリが必要。
        for quotient in quotientValues(n):
            result.add(quotient)
