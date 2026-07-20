when not declared CPLIB_UTILS_SUBSET_SUM:
    const CPLIB_UTILS_SUBSET_SUM* = 1

    proc subsetSumImpl(a: openArray[int], target: int,
                       restore: bool): tuple[exists: bool, indices: seq[int]] =
        ## Pisinger の balancing algorithm により部分和問題を解く。
        ## 時間計算量: O(N max(a)), 空間計算量: 復元時 O(N max(a)), 判定のみ O(max(a))
        if target < 0:
            return (false, @[])
        if target == 0:
            return (true, @[])
        if a.len == 0:
            return (false, @[])

        var mx = 0
        for x in a:
            assert x > 0, "subsetSum requires positive integers"
            mx = max(mx, x)

        var border = 0
        var sum = 0
        while border < a.len and sum + a[border] <= target:
            sum += a[border]
            inc border
        if border == a.len:
            if sum == target:
                result.exists = true
                if restore:
                    result.indices = newSeq[int](a.len)
                    for i in 0..<a.len:
                        result.indices[i] = i
            return

        let offset = target - mx + 1
        var dp = newSeq[int](2 * mx)
        for x in dp.mitems:
            x = -1
        dp[sum - offset] = border

        var parent: seq[seq[int]]
        if restore:
            parent = newSeq[seq[int]](a.len)

        for i in border..<a.len:
            var next = dp
            if restore:
                parent[i] = newSeq[int](2 * mx)
                for x in parent[i].mitems:
                    x = -1

            for j in 0..<mx:
                if dp[j] > next[j + a[i]]:
                    next[j + a[i]] = dp[j]
                    if restore:
                        parent[i][j + a[i]] = -2

            for j in countdown(2 * mx - 1, mx):
                let lower = max(dp[j], 0)
                for k in countdown(next[j] - 1, lower):
                    if k >= 0 and k > next[j - a[k]]:
                        next[j - a[k]] = k
                        if restore:
                            parent[i][j - a[k]] = k
            dp = move(next)

        let goal = mx - 1
        if dp[goal] == -1:
            return (false, @[])
        result.exists = true
        if not restore:
            return

        var used = newSeq[bool](a.len)
        var i = a.len - 1
        var j = goal
        while i >= border:
            let p = parent[i][j]
            if p == -2:
                used[i] = not used[i]
                j -= a[i]
                dec i
            elif p == -1:
                dec i
            else:
                used[p] = not used[p]
                j += a[p]
        while i >= 0:
            used[i] = not used[i]
            dec i
        for k in 0..<a.len:
            if used[k]:
                result.indices.add(k)

    proc subsetSum*(a: openArray[int], target: int): seq[int] =
        ## `a[result[i]]` の総和が `target` となる添字列を返す。
        ## 解が存在しない場合は空列を返す（`target == 0` の場合も空列）。
        ## `a` の各要素は正でなければならない。
        subsetSumImpl(a, target, true).indices

    proc hasSubsetSum*(a: openArray[int], target: int): bool =
        ## `target` を部分和として作れるか判定する。
        ## `a` の各要素は正でなければならない。
        subsetSumImpl(a, target, false).exists
