when not declared CPLIB_GRAPH_HUNGARIAN:
    const CPLIB_GRAPH_HUNGARIAN* = 1

    proc hungarian*[T](cost: openArray[seq[T]], zero: T): tuple[min_cost: T, assignment: seq[int]] =
        ## `cost[i][j]` を行 `i` に列 `j` を割り当てるコストとして、
        ## すべての行を相異なる列に割り当てる最小コストを求める。
        ##
        ## 行数は列数以下である必要がある。計算量は O(N^2 M)、
        ## 追加領域は O(N + M)（N: 行数、M: 列数）。
        let n = cost.len
        if n == 0:
            return (min_cost: zero, assignment: newSeq[int]())

        let m = cost[0].len
        assert n <= m, "hungarian requires the number of rows to be at most the number of columns"
        for row in cost:
            assert row.len == m, "cost matrix must be rectangular"

        # p[j] is the row currently matched with column j. Column 0 is a
        # sentinel used while finding an augmenting path.
        var u = newSeq[T](n + 1)
        var v = newSeq[T](m + 1)
        var p = newSeq[int](m + 1)
        var way = newSeq[int](m + 1)

        for i in 1..n:
            p[0] = i
            var minv = newSeq[T](m + 1)
            var hasMin = newSeq[bool](m + 1)
            var used = newSeq[bool](m + 1)
            var j0 = 0

            while true:
                used[j0] = true
                let i0 = p[j0]
                var delta: T
                var hasDelta = false
                var j1 = 0
                for j in 1..m:
                    if not used[j]:
                        let cur = cost[i0 - 1][j - 1] - u[i0] - v[j]
                        if not hasMin[j] or cur < minv[j]:
                            minv[j] = cur
                            hasMin[j] = true
                            way[j] = j0
                        if not hasDelta or minv[j] < delta:
                            delta = minv[j]
                            hasDelta = true
                            j1 = j

                for j in 0..m:
                    if used[j]:
                        u[p[j]] += delta
                        v[j] -= delta
                    elif j > 0:
                        minv[j] -= delta
                j0 = j1
                if p[j0] == 0:
                    break

            while true:
                let j1 = way[j0]
                p[j0] = p[j1]
                j0 = j1
                if j0 == 0:
                    break

        result.min_cost = -v[0]
        result.assignment = newSeq[int](n)
        for j in 1..m:
            if p[j] != 0:
                result.assignment[p[j] - 1] = j - 1

    proc hungarian*(cost: openArray[seq[int]]): tuple[min_cost: int, assignment: seq[int]] =
        hungarian(cost, 0)

    proc hungarian*(cost: openArray[seq[int32]]): tuple[min_cost: int32, assignment: seq[int]] =
        hungarian(cost, 0.int32)

    proc hungarian*(cost: openArray[seq[int64]]): tuple[min_cost: int64, assignment: seq[int]] =
        hungarian(cost, 0.int64)

    proc hungarian*(cost: openArray[seq[float]]): tuple[min_cost: float, assignment: seq[int]] =
        hungarian(cost, 0.0)

    proc hungarian*(cost: openArray[seq[float32]]): tuple[min_cost: float32, assignment: seq[int]] =
        hungarian(cost, 0.0'f32)
