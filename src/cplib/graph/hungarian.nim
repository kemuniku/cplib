when not declared CPLIB_GRAPH_HUNGARIAN:
    const CPLIB_GRAPH_HUNGARIAN* = 1

    type
        MinCostAssignmentResult* = object
            feasible*: bool
            cost*: int64
            columnOfRow*: seq[int]
        AssignmentWide = object
            hi, lo: uint64

    proc assignmentWide(x: int64): AssignmentWide {.inline.} =
        ## 符号付き64ビット整数を2の補数の128ビット表現へ拡張する。
        AssignmentWide(hi: (if x < 0: high(uint64) else: 0'u64), lo: cast[uint64](x))

    proc `+`(a, b: AssignmentWide): AssignmentWide {.inline.} =
        ## 下位桁の桁上がりを上位桁へ加える。
        result.lo = a.lo + b.lo
        result.hi = a.hi + b.hi + uint64(result.lo < a.lo)

    proc `-`(a, b: AssignmentWide): AssignmentWide {.inline.} =
        ## 下位桁の借りを上位桁から引く。
        result.lo = a.lo - b.lo
        result.hi = a.hi - b.hi - uint64(a.lo < b.lo)

    proc `<`(a, b: AssignmentWide): bool {.inline.} =
        ## 上位桁を符号付き、下位桁を符号なしとして比較する。
        if a.hi != b.hi: cast[int64](a.hi) < cast[int64](b.hi)
        else: a.lo < b.lo

    proc assignmentInt64(x: AssignmentWide): int64 =
        ## 最終費用の範囲を検査する。release/dangerでも範囲外はOverflowDefect。
        if not ((x.hi == 0 and x.lo <= uint64(high(int64))) or
                (x.hi == high(uint64) and x.lo >= (1'u64 shl 63))):
            raise newException(OverflowDefect, "assignment cost does not fit int64")
        cast[int64](x.lo)

    proc min_cost_assignment*[T: SomeSignedInt](cost: openArray[seq[T]], allowed: openArray[seq[bool]] = []): MinCostAssignmentResult =
        ## 整数矩形N×M行列の最小費用完全行割当をHungarian法で求める。時間O(N²M)、追加領域O(N+M)。
        ## 全行を相異なる列へ割り当て、0始まりのcolumnOfRowとint64のcostを返す。負費用・同費用可。
        ## allowedを省略すると全辺を許可する。指定時は同じ形でtrueの辺だけを使う。INF値は使わない。
        ## N>Mや許可辺に完全割当がない場合はfeasible=false、cost=0、columnOfRowは空。
        ## 空行列は費用0の実行可能解。不揃いな行列・許可行列はValueError。入力は変更しない。
        ## Tは符号付き64ビット以下、N≤2³¹−1、N,M<high(int)。最適費用がint64に収まらなければOverflowDefect。
        ## 中間演算は2個のuint64による符号付き128ビットで、費用差・ポテンシャル・総和のint64溢れを避ける。
        ## 交互道は高々N行を通る。各増加の距離はO(N·2⁶³)、N回の更新を含めても中間値はO(N²·2⁶³)。
        ## 上記Nの制約で128ビットに収まり、総和はN·2⁶³以下。符号なし桁の加減算は桁上がり/借りを処理する。
        ## 各増加で未訪問列への最短路の余裕を更新し、最小余裕だけ双対変数を動かす。等号辺で増加するため最適。
        let n = cost.len
        let m = if n == 0: 0 else: cost[0].len
        if n > int(high(int32)) or n == high(int) or m == high(int):
            raise newException(ValueError, "assignment dimensions are too large")
        for row in cost:
            if row.len != m:
                raise newException(ValueError, "cost matrix must be rectangular")
        if allowed.len != 0:
            if allowed.len != n:
                raise newException(ValueError, "allowed matrix must have the same shape")
            for row in allowed:
                if row.len != m:
                    raise newException(ValueError, "allowed matrix must have the same shape")
        if n == 0:
            result.feasible = true
            return
        if n > m:
            return

        var u = newSeq[AssignmentWide](n + 1)
        var v = newSeq[AssignmentWide](m + 1)
        var p = newSeq[int](m + 1)
        var way = newSeq[int](m + 1)
        var slack = newSeq[AssignmentWide](m + 1)
        var reached = newSeq[bool](m + 1)
        var used = newSeq[bool](m + 1)
        for i in 1..n:
            p[0] = i
            for j in 0..m:
                reached[j] = false
                used[j] = false
            var j0 = 0
            while true:
                used[j0] = true
                let i0 = p[j0]
                var next = 0
                var delta: AssignmentWide
                for j in 1..m:
                    if used[j]: continue
                    if allowed.len == 0 or allowed[i0 - 1][j - 1]:
                        let reduced = assignmentWide(int64(cost[i0 - 1][j - 1])) - u[i0] - v[j]
                        if not reached[j] or reduced < slack[j]:
                            reached[j] = true
                            slack[j] = reduced
                            way[j] = j0
                    if reached[j] and (next == 0 or slack[j] < delta):
                        delta = slack[j]
                        next = j
                if next == 0:
                    return
                for j in 0..m:
                    if used[j]:
                        u[p[j]] = u[p[j]] + delta
                        if j != 0: v[j] = v[j] - delta
                    elif reached[j]:
                        slack[j] = slack[j] - delta
                j0 = next
                if p[j0] == 0: break
            while j0 != 0:
                let previous = way[j0]
                p[j0] = p[previous]
                j0 = previous

        result.columnOfRow = newSeq[int](n)
        var total: AssignmentWide
        for j in 1..m:
            if p[j] != 0:
                result.columnOfRow[p[j] - 1] = j - 1
                total = total + assignmentWide(int64(cost[p[j] - 1][j - 1]))
        result.cost = assignmentInt64(total)
        result.feasible = true
