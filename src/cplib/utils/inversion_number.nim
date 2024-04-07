when not declared CPLIB_UTILS_INVERSION_NUMBER:
    const COMPETITIVE_UTILS_INVERSION_NUMBER* = 1
    import algorithm, sequtils
    import cplib/collections/segtree
    proc inversion_number*(a: seq[int]): int =
        let c = a.sorted.deduplicate(true)
        var seg = initSegmentTree(newSeqWith(c.len, 0), proc(l, r: int): int = l+r, 0)
        var ans = 0
        for i in 0..<a.len:
            let pos = c.lowerbound(a[i])
            if pos + 1 < c.len:
                ans += seg.get(pos+1..<c.len)
            seg[pos] = seg[pos] + 1
        return ans
