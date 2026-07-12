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

    let r = min(r,n-r)
    var res = to_Int128(1)
    for i in 1..r:
        res = res*(n-r+i) div i
        if res >= limit:
            return limit
    return res.to_int
