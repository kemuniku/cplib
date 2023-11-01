
when not declared CPLIB_MISC_INVERSION_NUMBER:
    const COMPETITIVE_MISC_INVERSION_NUMBER* = 1
    import algorithm, sequtils
    import atcoder/segtree
    proc op(x, y: int): int = return x+y
    proc e(): int = return 0
    proc inversion_number*(a: seq[int]): int =
        let c = a.sorted.deduplicate(isSorted = true)
        #FIXME: use BIT
        var seg = initSegTree[int](c.len, op, e)
        var ans = 0
        for i in 0..<a.len:
            var pos = c.lowerBound(a[i])
            if pos + 1 < c.len:
                ans += seg.prod(pos+1..<c.len)
            seg.set(pos, seg.get(pos)+1)
        return ans