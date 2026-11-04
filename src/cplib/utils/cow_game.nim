when not declared CPLIB_UTILS_COW_GAME:
    const CPLIB_UTILS_COW_GAME* = 1
    when sizeof(int) != 8:
        {.error: "CowGameは64bitのint環境に対応しています".}
    import cplib/graph/graph
    import cplib/graph/dijkstra
    import cplib/graph/bellmanford

    type
        CowAlgorithm* = enum
            cowDijkstra, cowBellmanFord
        CowStatus* = enum
            cowFinite, cowUnbounded, cowInfeasible
        CowResult* = object
            case status*: CowStatus
            of cowFinite: value*: int
            else: discard
        CowGame* = ref object
            n: int
            algorithm: CowAlgorithm
            edges: seq[tuple[src, dst, cost: int]]
            maxWeight: int
            feasibilityKnown, feasible: bool
            potential, values: seq[int]
        CowVariable* = object
            problem: CowGame
            id: int
        CowDifference* = object
            left, right: CowVariable
        CowOffset* = object
            variable: CowVariable
            constant: int
        CowConstraint* = object
            left, right: CowVariable
            bound: int

    proc cowCheck(p: CowGame) =
        ## 初期化済みの問題であることを検査する。O(1)。
        if p == nil: raise newException(ValueError, "CowGameが初期化されていません")

    proc cowCheck(x: CowVariable) =
        ## 有効な変数であることを検査する。O(1)。
        cowCheck(x.problem)
        if x.id < 0 or x.id >= x.problem.n:
            raise newException(ValueError, "CowGameの変数番号が範囲外です")

    proc cowCheck(x, y: CowVariable) =
        ## 二変数が同じ問題に属することを検査する。O(1)。
        cowCheck(x)
        cowCheck(y)
        if x.problem != y.problem:
            raise newException(ValueError, "異なるCowGameの変数は混在できません")

    proc cowNegate(c: int): int =
        ## 符号反転のオーバーフローを検査する。O(1)。
        if c == low(int):
            raise newException(ValueError, "low(int)はCowGameの数値範囲外です")
        -c

    proc cowInvalidate(p: CowGame) =
        ## 変数・制約変更後の計算結果を破棄する。O(1)。
        p.feasibilityKnown = false
        p.potential.setLen(0)
        p.values.setLen(0)

    proc initCowGame*(algorithm: CowAlgorithm = cowDijkstra): CowGame =
        ## 原点と空の制約集合を作る。既定は非負辺専用。O(1)。
        CowGame(n: 1, algorithm: algorithm)

    proc initCowGameBellmanFord*(): CowGame =
        ## 負辺を許す差分制約問題を作る。O(1)。
        initCowGame(cowBellmanFord)

    proc makeProblem*(): CowGame =
        ## 元の牛ゲーDSLと同じ非負辺専用の問題を作る。O(1)。
        initCowGame()

    proc origin*(p: CowGame): CowVariable =
        ## 値0の基準変数を返す。O(1)。
        cowCheck(p)
        CowVariable(problem: p, id: 0)

    proc getVariable*(p: CowGame): CowVariable =
        ## 自由な整数変数を追加し、保存済み解を無効にする。償却O(1)。
        cowCheck(p)
        result = CowVariable(problem: p, id: p.n)
        inc p.n
        cowInvalidate(p)

    proc `+`*(x: CowVariable, c: int): CowOffset =
        ## x+cを表す。O(1)。
        cowCheck(x)
        CowOffset(variable: x, constant: c)

    proc `+`*(c: int, x: CowVariable): CowOffset =
        ## c+xを表す。O(1)。
        x + c

    proc `-`*(x: CowVariable, c: int): CowOffset =
        ## x-cを表す。O(1)。
        x + cowNegate(c)

    proc `-`*(x, y: CowVariable): CowDifference =
        ## x-yを表す。同じ問題の変数に限る。O(1)。
        cowCheck(x, y)
        CowDifference(left: x, right: y)

    proc `<=`*(d: CowDifference, c: int): CowConstraint =
        ## x-y<=cを表す。制約追加時に辺の符号を検査する。O(1)。
        cowCheck(d.left, d.right)
        CowConstraint(left: d.left, right: d.right, bound: c)

    proc `<=`*(x, y: CowVariable): CowConstraint =
        ## x<=yを表す。O(1)。
        (x - y) <= 0

    proc `<=`*(x: CowVariable, y: CowOffset): CowConstraint =
        ## x<=y+cを表す。O(1)。
        (x - y.variable) <= y.constant

    proc `<=`*(x: CowVariable, c: int): CowConstraint =
        ## 原点を基準とするx<=cを表す。O(1)。
        cowCheck(x)
        (x - x.problem.origin()) <= c

    proc `<=`*(c: int, x: CowVariable): CowConstraint =
        ## 原点を基準とするc<=xを表す。O(1)。
        cowCheck(x)
        (x.problem.origin() - x) <= cowNegate(c)

    proc `>=`*(d: CowDifference, c: int): CowConstraint =
        ## x-y>=cを向きを反転した上限制約にする。O(1)。
        (d.right - d.left) <= cowNegate(c)

    proc `>=`*(x, y: CowVariable): CowConstraint =
        ## x>=yを表す。O(1)。
        y <= x

    proc `>=`*(x: CowVariable, y: CowOffset): CowConstraint =
        ## x>=y+cを表す。O(1)。
        (y.variable - x) <= cowNegate(y.constant)

    proc `>=`*(x: CowVariable, c: int): CowConstraint =
        ## x>=cを表す。O(1)。
        c <= x

    proc `>=`*(c: int, x: CowVariable): CowConstraint =
        ## c>=xを表す。O(1)。
        x <= c

    proc cowValidate(p: CowGame, c: CowConstraint) =
        ## 所属・辺の符号・反転不能な整数を検査する。O(1)。
        cowCheck(p)
        cowCheck(c.left, c.right)
        if p != c.left.problem:
            raise newException(ValueError, "制約の変数が追加先のCowGameに属していません")
        if c.bound == low(int):
            raise newException(ValueError, "low(int)はCowGameの数値範囲外です")
        if p.algorithm == cowDijkstra and c.bound < 0:
            raise newException(ValueError, "負の辺にはBellmanFord版を使用してください")

    proc `+=`*(p: CowGame, c: CowConstraint) =
        ## x-y<=cを辺y->xとして追加する。償却O(1)。
        cowValidate(p, c)
        p.edges.add((c.right.id, c.left.id, c.bound))
        p.maxWeight = max(p.maxWeight, abs(c.bound))
        cowInvalidate(p)

    proc addEquality*(p: CowGame, x: CowVariable, y: CowOffset) =
        ## x=y+cを二本の制約として追加する。検査失敗時は変更しない。償却O(1)。
        let upper = x <= y
        let lower = x >= y
        cowValidate(p, upper)
        cowValidate(p, lower)
        p += upper
        p += lower

    proc addEquality*(p: CowGame, x, y: CowVariable) =
        ## x=yを追加する。償却O(1)。
        p.addEquality(x, y + 0)

    proc addEquality*(p: CowGame, x: CowVariable, c: int) =
        ## x=cを追加する。非零の定数にはBellmanFord版が必要。償却O(1)。
        p.addEquality(x, p.origin() + c)

    proc cowFeasible(p: CowGame): bool =
        ## 全成分の実行可能性とポテンシャルを求める。BF: O(VE+V)、Dijkstra: O(V)。
        cowCheck(p)
        if p.feasibilityKnown: return p.feasible
        if p.maxWeight > (high(int) - 1) div p.n div 2:
            raise newException(ValueError, "CowGameの辺重みはabs(c)<=(high(int)-1) div V div 2が必要です")
        var distances = newSeq[int](p.n)
        if p.algorithm == cowBellmanFord:
            var candidates = newSeq[int](p.edges.len)
            for iteration in 0..<p.n:
                # 同期更新により負閉路があっても加算する経路長はV本以下となる。
                for i, e in p.edges: candidates[i] = distances[e.src] + e.cost
                var changed = false
                for i, e in p.edges:
                    if candidates[i] < distances[e.dst]:
                        distances[e.dst] = candidates[i]
                        changed = true
                if not changed: break
                if iteration == p.n - 1:
                    p.feasibilityKnown = true
                    p.feasible = false
                    return false
        p.potential = newSeq[int](p.n)
        for i in 0..<p.n: p.potential[i] = distances[i] - distances[0]
        p.feasibilityKnown = true
        p.feasible = true
        true

    proc solve*(p: CowGame): bool =
        ## 原点0の実行可能解を保存する。矛盾時はfalse。BF: O(VE+V)、Dijkstra: O(V)。
        cowCheck(p)
        p.values.setLen(0)
        if not cowFeasible(p): return false
        p.values = newSeq[int](p.n)
        for i in 0..<p.n: p.values[i] = p.potential[i]
        true

    proc getValue*(x: CowVariable): int =
        ## 保存済み解の値を返す。未計算・変更後・失敗後はValueError。O(1)。
        cowCheck(x)
        if x.problem.values.len != x.problem.n:
            raise newException(ValueError, "solveまたは有限なmaximizeVariables/minimizeVariablesが必要です")
        x.problem.values[x.id]

    proc cowDistances(p: CowGame, source: int, reverse: bool = false): seq[int] =
        ## 実行可能性確認後に既存の最短路実装を使う。BF: O(VE)、Dijkstra: O((V+E)log V)。
        var g = initWeightedDirectedGraph(p.n, capacity = p.edges.len)
        for e in p.edges:
            if reverse: g.add_edge(e.dst, e.src, e.cost)
            else: g.add_edge(e.src, e.dst, e.cost)
        if p.algorithm == cowDijkstra: g.dijkstra(source, 0, high(int))
        else: g.bellmanford(source, 0, high(int))

    proc maximize*(p: CowGame, d: CowDifference): CowResult =
        ## x-yの最大値を求める。全体の矛盾・非有界・有限を区別する。最短路一回分。
        cowCheck(p)
        cowCheck(d.left, d.right)
        if p != d.left.problem: raise newException(ValueError, "目的変数が別のCowGameに属しています")
        if not cowFeasible(p): return CowResult(status: cowInfeasible)
        let value = cowDistances(p, d.right.id)[d.left.id]
        if value == high(int): CowResult(status: cowUnbounded)
        else: CowResult(status: cowFinite, value: value)

    proc minimize*(p: CowGame, d: CowDifference): CowResult =
        ## x-yの最小値を求める。最大化の向きを反転して符号を変える。最短路一回分。
        result = p.maximize(d.right - d.left)
        if result.status == cowFinite: result.value = -result.value

    proc maximize*(p: CowGame, x: CowVariable): CowResult =
        ## 原点0に対するxの最大値を求める。最短路一回分。
        p.maximize(x - p.origin())

    proc minimize*(p: CowGame, x: CowVariable): CowResult =
        ## 原点0に対するxの最小値を求める。最短路一回分。
        p.minimize(x - p.origin())

    proc cowOptimizeVariables(p: CowGame, minimize: bool): CowStatus =
        ## 全変数の同時最適解を保存する。全て有限のときだけ保存する。最短路一回分。
        cowCheck(p)
        p.values.setLen(0)
        if not cowFeasible(p): return cowInfeasible
        let distances = cowDistances(p, 0, minimize)
        for d in distances:
            if d == high(int): return cowUnbounded
        p.values = newSeq[int](p.n)
        for i in 0..<p.n:
            p.values[i] = if minimize: -distances[i] else: distances[i]
        cowFinite

    proc maximizeVariables*(p: CowGame): CowStatus {.discardable.} =
        ## 原点から全変数に到達できるとき、同時最大解を保存する。最短路一回分。
        cowOptimizeVariables(p, false)

    proc minimizeVariables*(p: CowGame): CowStatus {.discardable.} =
        ## 全変数から原点に到達できるとき、同時最小解を保存する。最短路一回分。
        cowOptimizeVariables(p, true)
