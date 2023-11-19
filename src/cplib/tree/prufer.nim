when not declared CPLIB_TREE_PRUFER:
    const CPLIB_TREE_PRUFER* = 1

    import cplib/tree/tree
    import sequtils, heapqueue
    proc prufer_decode*(a: seq[int]): UnWeightedTree =
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
            while cnt[u] != c: (c, u) = q.pop
            result.add_edge(u, a[i])
            cnt[u] -= 1
            cnt[a[i]] -= 1
            if cnt[u] != 0: q.push((cnt[u], u))
            if cnt[a[i]] != 0: q.push((cnt[a[i]], a[i]))
        var u = (0..<n).toSeq.filterIt(cnt[it] == 1)
        result.add_edge(u[0], u[1])
