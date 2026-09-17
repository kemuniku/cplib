when not declared CPLIB_STR_EDIT_DISTANCE:
    const CPLIB_STR_EDIT_DISTANCE* = 1

    import cplib/collections/staticRMQ
    import cplib/str/suffix_array

    proc editDistance*(s, t: string, k: int): int =
        ## 挿入・削除・置換を各コスト 1 とする編集距離を返します。k を超える場合は -1。
        ## k >= 0 が必要です。string の各バイトを 1 文字として扱います。
        ## N = |s| + |t| として、時間 O(N log N + k^2)、空間 O(N log N + k)。ハッシュは使いません。
        assert k >= 0, "kは非負である必要があります"
        let n = s.len
        let m = t.len
        if abs(n - m) > k:
            return -1
        if n == 0 or m == 0:
            return max(n, m)
        if k == 0:
            return (if s == t: 0 else: -1)

        let joined = s & t
        let sa = suffix_array(joined)
        var rank = newSeq[int](joined.len)
        for i, p in sa:
            rank[p] = i
        let rmq = initRMQ(lcp_array(joined, sa))

        template extend(x, y: int): int =
            ## 両文字列の末尾を越えない共通接頭辞長を O(1) で求めます。
            (if x == n or y == m: 0 else:
                min(min(n - x, m - y),
                    rmq.query(min(rank[x], rank[n + y]), max(rank[x], rank[n + y]))))

        let limit = min(k, max(n, m))
        let offset = limit + 1
        var previous = newSeq[int](2 * limit + 3)
        var current = newSeq[int](previous.len)
        for i in 0..<previous.len:
            previous[i] = -1
        previous[offset] = extend(0, 0)
        if n == m and previous[offset] == n:
            return 0

        # 対角線 d = y - x ごとに、編集回数以下で到達できる最大の x を保持します。
        for edits in 1..limit:
            for i in 0..<current.len:
                current[i] = -1
            for d in -min(edits, n)..min(edits, m):
                let idx = offset + d
                var x = previous[idx]
                if x >= 0 and x < n and x + d < m:
                    inc x
                let insertion = previous[idx - 1]
                if insertion >= 0 and insertion + d - 1 < m:
                    x = max(x, insertion)
                let deletion = previous[idx + 1]
                if deletion >= 0 and deletion < n:
                    x = max(x, deletion + 1)
                if x < 0:
                    continue
                let y = x + d
                x += extend(x, y)
                current[idx] = x
                if d == m - n and x == n:
                    return edits
            swap(previous, current)
        return -1
