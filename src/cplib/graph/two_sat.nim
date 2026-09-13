## 式から制約を追加する2-SAT。変数番号は0始まりで、解の選び方は保証しない。
## Problem2satの代入は同じ問題を共有する。solve後も制約追加と再求解が可能。
## or、nand、xor、^、==、!=、impliesはリテラル同士に使用する。
## ==と!=はboolとの比較にも対応する。3個以上のリテラルのORは扱わない。
when not declared CPLIB_GRAPH_TWO_SAT:
    const CPLIB_GRAPH_TWO_SAT* = 1

    type
        Problem2sat* = ref object
            clauses: seq[tuple[a, b: int]]
            evaluated: bool
            assignment: seq[bool]
            solved: bool
        Literal2sat* = object
            problem: Problem2sat
            vertex: int
        Constraint2sat* = object
            problem: Problem2sat
            clauses: array[2, tuple[a, b: int]]
            count: int

    proc initTwoSat*(n: int): Problem2sat =
        ## n個の変数を持つ問題を生成する。O(n)。
        if n < 0:
            raise newException(ValueError, "変数の個数は非負である必要があります")
        Problem2sat(assignment: newSeq[bool](n))

    proc `[]`*(p: Problem2sat, k: int): Literal2sat =
        ## 0始まりの番号kの変数を取得する。O(1)。
        if p.isNil:
            raise newException(ValueError, "問題が初期化されていません")
        if k < 0 or k >= p.assignment.len:
            raise newException(IndexDefect, "変数番号が範囲外です")
        Literal2sat(problem: p, vertex: 2 * k + 1)

    proc toLiteral*(a: Literal2sat): Literal2sat =
        ## リテラルをそのまま返す。O(1)。
        a

    proc `not`*(a: Literal2sat): Literal2sat =
        ## リテラルを否定する。O(1)。
        result = a
        result.vertex = result.vertex xor 1

    proc `or`*(a, b: Literal2sat): Constraint2sat =
        ## 少なくとも一方が真となる制約を生成する。O(1)。
        let x = a
        let y = b
        if x.problem.isNil or x.problem != y.problem:
            raise newException(ValueError, "同じ問題に所属する変数が必要です")
        result.problem = x.problem
        result.clauses[0] = (x.vertex, y.vertex)
        result.count = 1

    proc nand*(a, b: Literal2sat): Constraint2sat =
        ## 両方が同時に真になることを禁止する制約を生成する。O(1)。
        (not a) or (not b)

    proc implies*(a, b: Literal2sat): Constraint2sat =
        ## aが真ならbも真となる制約を生成する。O(1)。
        (not a) or b

    proc `xor`*(a, b: Literal2sat): Constraint2sat =
        ## ちょうど一方が真となる制約を生成する。O(1)。
        result = a or b
        result.clauses[1] = (result.clauses[0].a xor 1, result.clauses[0].b xor 1)
        result.count = 2

    proc `^`*(a, b: Literal2sat): Constraint2sat =
        ## ちょうど一方が真となる制約を生成する。O(1)。
        a xor b

    proc `==`*(a: Literal2sat, b: Literal2sat): Constraint2sat =
        ## 両方が同じ真偽値となる制約を生成する。O(1)。
        a xor (not b)

    proc `!=`*(a: Literal2sat, b: Literal2sat): Constraint2sat =
        ## 両方が異なる真偽値となる制約を生成する。O(1)。
        a xor b

    proc `==`*(a: Literal2sat, b: bool): Constraint2sat =
        ## リテラルの真偽値を固定する制約を生成する。O(1)。
        if b: a or a
        else: (not a) or (not a)

    proc `==`*(a: bool, b: Literal2sat): Constraint2sat =
        ## リテラルの真偽値を固定する制約を生成する。O(1)。
        b == a

    proc `!=`*(a: Literal2sat, b: bool): Constraint2sat =
        ## リテラルを指定値と異なる真偽値に固定する。O(1)。
        a == (not b)

    proc `!=`*(a: bool, b: Literal2sat): Constraint2sat =
        ## リテラルを指定値と異なる真偽値に固定する。O(1)。
        b == (not a)

    proc `+=`*(p: Problem2sat, constraint: Constraint2sat) =
        ## 制約を追加し、以前の解を無効化する。償却O(1)。
        if p.isNil or constraint.problem != p or constraint.count == 0:
            raise newException(ValueError, "この問題に所属する制約が必要です")
        for i in 0..<constraint.count:
            p.clauses.add(constraint.clauses[i])
        p.solved = false
        p.evaluated = false

    proc add_clause*(p: Problem2sat, i: int, f: bool, j: int, g: bool) =
        ## (変数i == f) or (変数j == g) を追加し、以前の解を無効化する。償却O(1)。
        let a = if f: p[i] else: not p[i]
        let b = if g: p[j] else: not p[j]
        p += a or b

    proc solve*(p: Problem2sat): bool =
        ## 全制約を解き、解が存在するか返す。O(n+m)、制約追加なしの再実行はO(1)。
        if p.isNil:
            raise newException(ValueError, "問題が初期化されていません")
        if p.evaluated:
            return p.solved
        p.solved = false
        let n = p.assignment.len * 2
        var offsets = newSeq[int](n + 1)
        for (a, b) in p.clauses:
            inc offsets[(a xor 1) + 1]
            inc offsets[(b xor 1) + 1]
        for v in 0..<n:
            offsets[v + 1] += offsets[v]
        var cursor = newSeq[int](n)
        for v in 0..<n:
            cursor[v] = offsets[v]
        var edges = newSeq[int](2 * p.clauses.len)
        for (a, b) in p.clauses:
            edges[cursor[a xor 1]] = b
            inc cursor[a xor 1]
            edges[cursor[b xor 1]] = a
            inc cursor[b xor 1]
        for v in 0..<n:
            cursor[v] = offsets[v]

        var used = newSeq[bool](n)
        var order = newSeqOfCap[int](n)
        var stack = newSeqOfCap[int](n)
        for root in 0..<n:
            if used[root]: continue
            used[root] = true
            stack.add(root)
            while stack.len > 0:
                let v = stack[^1]
                if cursor[v] == offsets[v + 1]:
                    order.add(v)
                    stack.setLen(stack.len - 1)
                else:
                    let dst = edges[cursor[v]]
                    inc cursor[v]
                    if not used[dst]:
                        used[dst] = true
                        stack.add(dst)

        var component = newSeq[int](n)
        for v in 0..<n:
            component[v] = -1
        var id = 0
        for i in countdown(order.len - 1, 0):
            let root = order[i]
            if component[root] != -1: continue
            component[root] = id
            stack.add(root)
            while stack.len > 0:
                let v = stack.pop()
                # 含意の対偶を使い、逆辺を保存せずに逆グラフを走査する。
                let opposite = v xor 1
                for e in offsets[opposite]..<offsets[opposite + 1]:
                    let dst = edges[e] xor 1
                    if component[dst] == -1:
                        component[dst] = id
                        stack.add(dst)
            inc id
        p.evaluated = true
        for i in 0..<p.assignment.len:
            if component[2 * i] == component[2 * i + 1]:
                return false
            p.assignment[i] = component[2 * i] < component[2 * i + 1]
        p.solved = true
        return true

    proc satisfiable*(p: Problem2sat): bool =
        ## solveと同様に全制約を解く。O(n+m)、制約追加なしの再実行はO(1)。
        p.solve()

    proc answer*(p: Problem2sat): seq[bool] =
        ## 最後に成功した求解での全変数の値をコピーして返す。O(n)。
        if p.isNil or not p.solved:
            raise newException(ValueError, "solveまたはsatisfiableが成功した後に解を取得してください")
        result = newSeq[bool](p.assignment.len)
        for i in 0..<p.assignment.len:
            result[i] = p.assignment[i]

    proc get*(a: Literal2sat): bool =
        ## 最後に成功したsolveでのリテラルの値を返す。O(1)。
        if a.problem.isNil or not a.problem.solved:
            raise newException(ValueError, "solveが成功した後に値を取得してください")
        let value = a.problem.assignment[a.vertex div 2]
        if (a.vertex and 1) == 1: value
        else: not value

    proc `$`*(a: Literal2sat): string =
        ## 有効な解があれば真を1、偽を0、なければ-として返す。O(1)。
        if a.problem.isNil or not a.problem.solved:
            return "-"
        if a.get(): "1"
        else: "0"
