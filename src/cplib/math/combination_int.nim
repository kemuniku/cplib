when not declared CPLIB_MATH_COMBINATION_INT:
    const CPLIB_MATH_COMBINATION_INT* = 1

    import cplib/math/int128
    import cplib/utils/constants

    proc ncr_int*(n,r:int,limit:int=INF64):int=
        ## nCrを計算する。結果はintで返す。
        ## ただし、limit以上になる場合、limitを返す。
        ## limit = INF64のとき、最大で32回ほどの演算が発生する。
        if limit <= 0:
            return limit
        if n < 0 or r < 0 or n < r:
            return 0

        let rr = min(r,n-r)
        let limit128 = to_Int128(limit)
        var res = to_Int128(1)
        for i in 1..rr:
            res = res*(n-rr+i) div i
            if res >= limit128:
                return limit
        return res.to_int
