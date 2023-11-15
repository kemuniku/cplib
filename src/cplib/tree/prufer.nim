when not declared CPLIB_TREE_PRUFER:
    const CPLIB_TREE_PRUFER* = 1

    import cplib/tree/tree
    import sequtils, heapqueue
    proc make_tree_from_prufer*(a: seq[int]): UnWeightedTree =
        var n = a.len + 2
        assert a.allIt(it in 0..<n)
        result = initUnWeightedTree(n)
        var cnt = newSeqWith(n, 1)
        for ai in a:
            cnt[ai] += 1
        var q = initHeapQueue[(int, int)]()
        for i in 0..<n:
            q.push((cnt[i], i))
        for i in 0..<a.len:
            var (c, u) = q.pop
            result.add_edge(u, a[i])
            if c != 1:
                q.push((c-1, u))
        var (_, u) = q.pop
        var (_, v) = q.pop
        result.add_edge(u, v)
