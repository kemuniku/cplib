when not declared CPLIB_MATH_DIVISOR:
    const COMPETITIVE_MATH_DIVISOR* = 1
    import sequtils, tables, algorithm
    import cplib/math/primefactor
    proc divisor_naive(x: int, sorted: bool): seq[int] =
        for i in 1..x:
            if i*i > x: break
            if x mod i == 0:
                result.add(i)
                if i*i != x:
                    result.add(x div i)
        if sorted: result.sort

    proc divisor*(x: int, sorted: bool = true): seq[int] =
        if x <= 1000_000: return divisor_naive(x, sorted)
        var factor = primefactor(x).toCountTable.pairs.toSeq
        var ans = newSeq[int](0)
        proc dfs(d, x: int) =
            if d == factor.len:
                ans.add(x)
                return
            var mul = 1
            for i in 0..factor[d][1]:
                dfs(d+1, x*mul)
                if i != factor[d][1]: mul *= factor[d][0]
        dfs(0, 1)
        if sorted: ans.sort
        return ans
