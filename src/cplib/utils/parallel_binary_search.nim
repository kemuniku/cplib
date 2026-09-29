when not declared CPLIB_UTILS_PARALLEL_BINARY_SEARCH:
    const CPLIB_UTILS_PARALLEL_BINARY_SEARCH* = 1

    proc parallelBinarySearch*(updateCount, queryCount: int,
            reset: proc(), apply: proc(updateIdx: int),
            check: proc(queryIdx: int): bool): seq[int] =
        ## 各クエリが成立する最小の操作数を返す。初期状態で成立なら0、不成立ならupdateCount + 1。
        ## resetは初回を含む各巡回の先頭で初期状態へ戻し、applyは0始まりの操作を添字順に適用する。
        ## checkには0始まりのクエリ番号を渡す。成立条件は操作数に対してfalseからtrueへ単調であること。
        ## checkは判定結果に影響する状態を変更しないこと。UnionFindの経路圧縮などは許可する。
        ## 終了時の状態は復元しない。クエリが0個ならコールバックを呼ばない。
        ## M操作、Qクエリに対し、コールバックを除き時間O((M + Q) log(M + 2))、追加領域O(M + Q)。
        ## resetはO(log(M + 2))回、applyはO(M log(M + 2))回、checkはO(Q log(M + 2))回。
        assert 0 <= updateCount and updateCount < high(int)
        assert queryCount >= 0
        result = newSeq[int](queryCount)
        if queryCount == 0: return
        var lower = newSeq[int](queryCount)
        var heads = newSeq[int](updateCount + 1)
        var next = newSeq[int](queryCount)
        for q in 0..<queryCount: result[q] = updateCount + 1

        while true:
            for head in heads.mitems: head = -1
            var last = -1
            for q in 0..<queryCount:
                if lower[q] < result[q]:
                    let mid = lower[q] + (result[q] - lower[q]) div 2
                    next[q] = heads[mid]
                    heads[mid] = q
                    last = max(last, mid)
            if last < 0: break

            reset()
            for count in 0..last:
                if count > 0: apply(count - 1)
                var q = heads[count]
                while q >= 0:
                    if check(q): result[q] = count
                    else: lower[q] = count + 1
                    q = next[q]
