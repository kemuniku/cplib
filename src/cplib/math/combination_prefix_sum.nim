when not declared CPLIB_MATH_COMBINATION_PREFIX_SUM:
    const CPLIB_MATH_COMBINATION_PREFIX_SUM* = 1

    import cplib/math/combination
    import cplib/utils/mo

    proc combinationPrefixSum*[ModInt](queries: openArray[(int, int)]): seq[ModInt] =
        ## 二項係数のprefix sumをオフラインで求める
        if queries.len == 0:
            return @[]

        var maxX = 0
        for (x, _) in queries:
            maxX = max(maxX, x)

        let combination = initCombination[ModInt](max(1, maxX))
        var mo = initMo(max(1, maxX), queries.len)
        for (x, y) in queries:
            mo.insert(x, min(x, y))

        var answers = newSeq[ModInt](queries.len)
        var
            x = 0
            y = 0
            sum: ModInt = 1

        mo.run(
            proc(newX: int) =
                x = newX
                sum = (sum + combination.ncr(x, y)) / 2,
            proc(oldY: int) =
                y = oldY + 1
                sum += combination.ncr(x, y),
            proc(oldX: int) =
                sum = 2 * sum - combination.ncr(oldX, y)
                x = oldX + 1,
            proc(newY: int) =
                sum -= combination.ncr(x, newY + 1)
                y = newY,
            proc(queryIndex: int) =
                answers[queryIndex] = sum
        )
        result = answers

    proc combinationRangeSum*[ModInt](queries: openArray[(int, int, int)]): seq[ModInt] =
        ## 各 (n, l, r) について sum(i=l..<r, nCi) をオフラインで求める
        result = newSeq[ModInt](queries.len)

        var
            prefixQueries: seq[(int, int)]
            queryIndices: seq[(int, int)]
        for queryIndex, (n, l, r) in queries:
            let
                left = max(0, l)
                right = min(n + 1, r)
            if left >= right:
                continue
            queryIndices.add((queryIndex, prefixQueries.len))
            prefixQueries.add((n, right - 1))
            prefixQueries.add((n, left - 1))

        let prefixSums = combinationPrefixSum[ModInt](prefixQueries)
        for (queryIndex, prefixIndex) in queryIndices:
            result[queryIndex] = prefixSums[prefixIndex] - prefixSums[prefixIndex + 1]
