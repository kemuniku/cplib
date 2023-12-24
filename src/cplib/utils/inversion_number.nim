when not declared CPLIB_UTILS_INVERSION_NUMBER:
    const COMPETITIVE_UTILS_INVERSION_NUMBER* = 1
    import algorithm, sequtils
    import atcoder/fenwicktree
    proc inversion_number*(a: seq[int]): int =
        let c = a.sorted.deduplicate(isSorted = true)
        var tree = initFenwickTree[int](c.len)
        var ans = 0
        for i in 0..<a.len:
            var pos = c.lowerBound(a[i])
            if pos + 1 < c.len:
                ans += tree.sum(pos+1..<c.len)
            tree.add(pos, 1)
        return ans
