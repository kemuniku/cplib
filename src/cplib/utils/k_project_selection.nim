when not declared CPLIB_UTILS_K_PROJECT_SELECTION:
    const CPLIB_UTILS_K_PROJECT_SELECTION* = 1
    import cplib/utils/project_selection

    type
        KProjectSelection*[Cost] = object
            sizes, starts: seq[int]
            binary: ProjectSelection[Cost]
        KProjectSelectionResult*[Cost] = object
            feasible*: bool
            min_cost*: Cost
            assignment*: seq[int]

    proc kpsSub[Cost: SomeSignedInt](a, b: Cost): Cost =
        ## 費用の差をオーバーフローを検査して求める。O(1)。
        if (b > 0 and a < low(Cost) + b) or (b < 0 and a > high(Cost) + b):
            raise newException(OverflowDefect, "KProjectSelectionの減算が費用型の範囲を超えます")
        a - b

    proc initKProjectSelection*(sizes: openArray[int], costType: typedesc[SomeSignedInt] = int): KProjectSelection[costType] =
        ## 各変数の値域を0..<sizes[i]とする。各サイズは正。型の省略時はint。O(n + Σsizes[i])。
        result.sizes = @sizes
        result.starts = newSeq[int](sizes.len)
        var count = 2
        for i, k in sizes:
            if k <= 0:
                raise newException(ValueError, "値域のサイズは正である必要があります: " & $i)
            if count > high(int) - (k - 1):
                raise newException(OverflowDefect, "閾値変数の個数がintの範囲を超えます")
            result.starts[i] = count
            count += k - 1
        result.binary = initProjectSelection(count, costType)
        result.binary.force(0, false)
        result.binary.force(1, true)
        for i, k in sizes:
            for t in 2..<k:
                result.binary.imply(result.starts[i] + t - 1, result.starts[i] + t - 2)

    proc initKProjectSelection*(n, k: int, costType: typedesc[SomeSignedInt] = int): KProjectSelection[costType] =
        ## n変数それぞれの値域を0..<kとする。nは非負、kは正。O(nk)。
        if n < 0 or k <= 0:
            raise newException(ValueError, "変数数は非負、値域のサイズは正である必要があります")
        var sizes = newSeq[int](n)
        for i in 0..<n: sizes[i] = k
        initKProjectSelection(sizes, costType)

    proc kpsCheckIndex[Cost](opt: KProjectSelection[Cost], i: int) =
        ## 元の変数の添字を検査する。O(1)。
        if i < 0 or i >= opt.sizes.len:
            raise newException(ValueError, "変数番号が範囲外です: " & $i)

    proc kpsGe[Cost](opt: KProjectSelection[Cost], i, lower: int): int =
        ## x[i] >= lowerを表す内部変数を返す。0とsizes[i]は定数条件。O(1)。
        opt.kpsCheckIndex(i)
        if lower < 0 or lower > opt.sizes[i]:
            raise newException(ValueError, "下側の閾値は0..sizes[i]である必要があります")
        if lower == 0: return 1
        if lower == opt.sizes[i]: return 0
        opt.starts[i] + lower - 1

    proc kpsGt[Cost](opt: KProjectSelection[Cost], i, upper: int): int =
        ## x[i] > upperを表す内部変数を返す。O(1)。
        opt.kpsCheckIndex(i)
        if upper < -1 or upper >= opt.sizes[i]:
            raise newException(ValueError, "上側の閾値は-1..<sizes[i]である必要があります")
        opt.kpsGe(i, upper + 1)

    proc add_unary_cost*[Cost](opt: var KProjectSelection[Cost], i: int, costs: openArray[Cost]) =
        ## x[i] == vの費用costs[v]を加算する。負値も可。O(sizes[i])。
        opt.kpsCheckIndex(i)
        if costs.len != opt.sizes[i]:
            raise newException(ValueError, "単項費用表の長さが値域のサイズと一致しません")
        var diffs = newSeq[Cost](costs.len - 1)
        for t in 1..<costs.len: diffs[t - 1] = kpsSub(costs[t], costs[t - 1])
        opt.binary.add_unary_cost(0, costs[0], costs[0])
        for t in 1..<costs.len:
            opt.binary.add_unary_cost(opt.kpsGe(i, t), Cost(0), diffs[t - 1])

    proc add_cost*[Cost](opt: var KProjectSelection[Cost], i, value: int, w: Cost) =
        ## x[i] == valueのとき費用wを加算する。負値は利益となる。O(sizes[i])。
        opt.kpsCheckIndex(i)
        if value < 0 or value >= opt.sizes[i]:
            raise newException(ValueError, "値が値域外です")
        var costs = newSeq[Cost](opt.sizes[i])
        costs[value] = w
        opt.add_unary_cost(i, costs)

    proc add_gain*[Cost](opt: var KProjectSelection[Cost], i, value: int, w: Cost) =
        ## x[i] == valueのとき利益wを加算する。負値は費用となる。O(sizes[i])。
        opt.add_cost(i, value, kpsSub(Cost(0), w))

    proc add_pair_cost*[Cost](opt: var KProjectSelection[Cost], i, j: int, costs: openArray[seq[Cost]]) =
        ## 費用costs[x[i]][x[j]]を加算する。異なる変数ではMonge性が必要。O(sizes[i] sizes[j])。
        opt.kpsCheckIndex(i)
        opt.kpsCheckIndex(j)
        let ki = opt.sizes[i]
        let kj = opt.sizes[j]
        if costs.len != ki:
            raise newException(ValueError, "2変数費用表の行数が値域のサイズと一致しません")
        for row in costs:
            if row.len != kj:
                raise newException(ValueError, "2変数費用表の列数が値域のサイズと一致しません")
        if i == j:
            var diagonal = newSeq[Cost](ki)
            for a in 0..<ki: diagonal[a] = costs[a][a]
            opt.add_unary_cost(i, diagonal)
            return
        var rowDiffs = newSeq[Cost](ki - 1)
        var colDiffs = newSeq[Cost](kj - 1)
        var mixed = newSeq[seq[Cost]](ki - 1)
        for a in 1..<ki: rowDiffs[a - 1] = kpsSub(costs[a][0], costs[a - 1][0])
        for b in 1..<kj: colDiffs[b - 1] = kpsSub(costs[0][b], costs[0][b - 1])
        for a in 1..<ki:
            mixed[a - 1] = newSeq[Cost](kj - 1)
            for b in 1..<kj:
                let left = kpsSub(costs[a][b], costs[a][b - 1])
                let right = kpsSub(costs[a - 1][b], costs[a - 1][b - 1])
                if left > right:
                    raise newException(ValueError, "変数 " & $i & ", " & $j &
                        " の費用表がMonge条件を満たしません: 隣接セルの右下 = (" & $a & ", " & $b & ")")
                mixed[a - 1][b - 1] = kpsSub(right, left)
        opt.binary.add_unary_cost(0, costs[0][0], costs[0][0])
        for a in 1..<ki: opt.binary.add_unary_cost(opt.kpsGe(i, a), Cost(0), rowDiffs[a - 1])
        for b in 1..<kj: opt.binary.add_unary_cost(opt.kpsGe(j, b), Cost(0), colDiffs[b - 1])
        for a in 1..<ki:
            for b in 1..<kj:
                let w = mixed[a - 1][b - 1]
                if w != 0:
                    opt.binary.add_pair_cost(opt.kpsGe(i, a), opt.kpsGe(j, b), Cost(0), Cost(0), Cost(0), -w)

    proc add_cost_if_ge_lt*[Cost](opt: var KProjectSelection[Cost], i, lower_i, j, lower_j: int, w: Cost) =
        ## x[i] >= lower_iかつx[j] < lower_jなら非負の費用wを加算する。償却O(1)。
        let a = opt.kpsGe(i, lower_i)
        let b = opt.kpsGe(j, lower_j)
        opt.binary.add_cost_if_true_false(a, b, w)

    proc add_gain_if_all_ge*[Cost](opt: var KProjectSelection[Cost], conditions: openArray[tuple[variable, threshold: int]], w: Cost) =
        ## 全条件x[variable] >= thresholdを満たすと非負の利益w。空なら常に利益。O(|conditions|)。
        var ids: seq[int]
        for c in conditions: ids.add(opt.kpsGe(c.variable, c.threshold))
        opt.binary.add_gain_if_all(ids, true, w)

    proc add_gain_if_all_le*[Cost](opt: var KProjectSelection[Cost], conditions: openArray[tuple[variable, threshold: int]], w: Cost) =
        ## 全条件x[variable] <= thresholdを満たすと非負の利益w。空なら常に利益。O(|conditions|)。
        var ids: seq[int]
        for c in conditions: ids.add(opt.kpsGt(c.variable, c.threshold))
        opt.binary.add_gain_if_all(ids, false, w)

    proc set_min*[Cost](opt: var KProjectSelection[Cost], i, lower: int) =
        ## x[i] >= lowerを強制する。lower == sizes[i]なら実行不能。償却O(1)。
        opt.binary.force(opt.kpsGe(i, lower), true)

    proc set_max*[Cost](opt: var KProjectSelection[Cost], i, upper: int) =
        ## x[i] <= upperを強制する。upper == -1なら実行不能。償却O(1)。
        opt.binary.force(opt.kpsGt(i, upper), false)

    proc force*[Cost](opt: var KProjectSelection[Cost], i, value: int) =
        ## x[i] == valueを強制する。償却O(1)。
        opt.kpsCheckIndex(i)
        if value < 0 or value >= opt.sizes[i]:
            raise newException(ValueError, "固定する値が値域外です")
        opt.set_min(i, value)
        opt.set_max(i, value)

    proc imply*[Cost](opt: var KProjectSelection[Cost], i, lower_i, j, lower_j: int) =
        ## x[i] >= lower_iならx[j] >= lower_jを強制する。償却O(1)。
        let a = opt.kpsGe(i, lower_i)
        let b = opt.kpsGe(j, lower_j)
        opt.binary.imply(a, b)

    proc solve*[Cost](opt: KProjectSelection[Cost]): KProjectSelectionResult[Cost] =
        ## 最小費用と整数の割当を返す。矛盾時はfeasible=false。内部グラフでO(V^2 E)。再実行可。
        let answer = opt.binary.solve()
        if not answer.feasible: return
        result.feasible = true
        result.min_cost = answer.min_cost
        result.assignment = newSeq[int](opt.sizes.len)
        for i, k in opt.sizes:
            for t in 1..<k:
                if answer.assignment[opt.kpsGe(i, t)]: inc result.assignment[i]
