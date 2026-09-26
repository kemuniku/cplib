when not declared CPLIB_MATH_LINEAR_PROGRAMMING:
    const CPLIB_MATH_LINEAR_PROGRAMMING* = 1

    type
        LinearProgrammingStatus* = enum
            lpOptimal, lpInfeasible, lpUnbounded
        LinearProgrammingResult* = object
            status*: LinearProgrammingStatus
            value*: float64
            x*: seq[float64]
        LinearProgrammingTableau = object
            m, n: int
            basic, nonbasic: seq[int]
            data: seq[seq[float64]]
            eps: float64

    proc lpPivot(t: var LinearProgrammingTableau, row, col: int) =
        ## 基底変数と非基底変数を交換する。O((m + 1)(n + 1)) 時間。
        let inverse = 1.0 / t.data[row][col]
        for j in 0..t.n + 1:
            if j != col:
                t.data[row][j] *= inverse
        t.data[row][col] = inverse
        for i in 0..t.m + 1:
            if i == row: continue
            let coefficient = t.data[i][col]
            for j in 0..t.n + 1:
                if j != col:
                    t.data[i][j] -= coefficient * t.data[row][j]
            t.data[i][col] = -coefficient * inverse
        swap(t.basic[row], t.nonbasic[col])

    proc lpSimplex(t: var LinearProgrammingTableau, phaseOne: bool): bool =
        ## 指定した目的関数を最大化し、非有界なら false を返す。1 反復 O((m + 1)(n + 1))。
        let objective = if phaseOne: t.m + 1 else: t.m
        while true:
            var col = -1
            for j in 0..t.n:
                if not phaseOne and t.nonbasic[j] == -1: continue
                if t.data[objective][j] < -t.eps:
                    if col == -1 or t.nonbasic[j] < t.nonbasic[col]:
                        col = j
            if col == -1: return true
            var row = -1
            var bestRatio = 0.0
            for i in 0..<t.m:
                if t.data[i][col] <= t.eps: continue
                let ratio = t.data[i][t.n + 1] / t.data[i][col]
                if row == -1 or ratio < bestRatio - t.eps or
                        (abs(ratio - bestRatio) <= t.eps and t.basic[i] < t.basic[row]):
                    row = i
                    bestRatio = ratio
            if row == -1: return false
            t.lpPivot(row, col)

    proc linear_programming*(a: openArray[seq[float64]], b, c: openArray[float64],
            eps: float64 = 1e-9): LinearProgrammingResult =
        ## Ax <= b, x >= 0 のもとで c^T x を最大化する。空間 O((m + 1)(n + 1))、時間は反復回数倍。
        ## 二段階シンプレックス法を用い、最悪の反復回数は指数的。入力は変更しない。
        ## 係数は有限値、eps は有限の正数とする。eps は比較の絶対許容誤差で、解の誤差保証ではない。
        ## 最適時のみ x を返す。実行不能なら value = -Inf、非有界なら value = Inf、x は空。
        assert a.len == b.len, "A の行数と b の長さを一致させてください"
        assert eps > 0.0 and eps < Inf, "eps は有限の正数にしてください"
        let m = b.len
        let n = c.len
        var t = LinearProgrammingTableau(m: m, n: n, eps: eps,
            basic: newSeq[int](m), nonbasic: newSeq[int](n + 1),
            data: newSeq[seq[float64]](m + 2))
        for i in 0..m + 1:
            t.data[i] = newSeq[float64](n + 2)
        for i in 0..<m:
            assert a[i].len == n, "A の各行の長さと c の長さを一致させてください"
            assert b[i] > -Inf and b[i] < Inf, "b の要素は有限値にしてください"
            for j in 0..<n:
                assert a[i][j] > -Inf and a[i][j] < Inf, "A の要素は有限値にしてください"
                t.data[i][j] = a[i][j]
            t.basic[i] = n + i
            t.data[i][n] = -1.0
            t.data[i][n + 1] = b[i]
        for j in 0..<n:
            assert c[j] > -Inf and c[j] < Inf, "c の要素は有限値にしてください"
            t.nonbasic[j] = j
            t.data[m][j] = -c[j]
        t.nonbasic[n] = -1
        t.data[m + 1][n] = 1.0

        var row = -1
        for i in 0..<m:
            if row == -1 or t.data[i][n + 1] < t.data[row][n + 1]:
                row = i
        if row != -1 and t.data[row][n + 1] < -eps:
            t.lpPivot(row, n)
            if not t.lpSimplex(true) or abs(t.data[m + 1][n + 1]) > eps:
                return LinearProgrammingResult(status: lpInfeasible, value: -Inf)
            for i in 0..<m:
                if t.basic[i] != -1: continue
                var col = -1
                for j in 0..n:
                    if abs(t.data[i][j]) > eps:
                        if col == -1 or t.nonbasic[j] < t.nonbasic[col]:
                            col = j
                if col != -1:
                    t.lpPivot(i, col)

        if not t.lpSimplex(false):
            return LinearProgrammingResult(status: lpUnbounded, value: Inf)
        result = LinearProgrammingResult(status: lpOptimal, x: newSeq[float64](n))
        for i in 0..<m:
            if 0 <= t.basic[i] and t.basic[i] < n:
                result.x[t.basic[i]] = max(0.0, t.data[i][n + 1])
        for j in 0..<n:
            result.value += c[j] * result.x[j]
