# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/utils/offline_dynamic_queries
import cplib/collections/rollback_unionfind

block:
    var solver = initOfflineDynamicQueries()
    var calls = 0
    solver.add(1000000000)
    solver.remove(1000000000)
    solver.run((proc(idx: int) = inc calls),
        (proc() = inc calls), (proc(idx: int) = inc calls))
    doAssert calls == 0

block:
    var solver = initOfflineDynamicQueries()
    var stack: seq[int]
    var total = 17
    var answers: seq[(int, int)]
    proc apply(idx: int) =
        stack.add(idx)
        total += idx
    proc rollback() = total -= stack.pop()
    proc answer(idx: int) = answers.add((idx, total))
    solver.output(90)
    solver.add(3)
    solver.add(5)
    solver.output(12)
    solver.remove(3)
    solver.output(12)
    solver.add(3)
    solver.remove(5)
    solver.output(-1)
    solver.add(99)
    solver.remove(99)
    for repeat in 0..<2:
        answers.setLen(0)
        solver.run(apply, rollback, answer)
        doAssert answers == @[(90, 17), (12, 25), (12, 22), (-1, 20)]
        doAssert total == 17 and stack.len == 0
    solver.remove(3)
    solver.output(42)
    answers.setLen(0)
    solver.run(apply, rollback, answer)
    doAssert answers[^1] == (42, 17)
    doAssert total == 17 and stack.len == 0

block:
    type Query = tuple[amount: int, name: string]
    var solver = initOfflineDynamicQueries(Query)
    var stack: seq[int]
    var total = 0
    var answers: seq[int]
    proc apply(idx: int, value: Query) =
        doAssert idx == 7
        doAssert value.name == "value" & $value.amount
        stack.add(value.amount)
        total += value.amount
    proc rollback() = total -= stack.pop()
    proc answer(idx: int) =
        doAssert idx == answers.len
        answers.add(total)
    solver.add(7, (99, "value99"))
    solver.remove(7)
    solver.output(0)
    solver.add(7, (3, "value3"))
    solver.output(1)
    solver.remove(7)
    solver.add(7, (8, "value8"))
    solver.output(2)
    for repeat in 0..<2:
        answers.setLen(0)
        solver.run(apply, rollback, answer)
        doAssert answers == @[0, 3, 8]
        doAssert total == 0 and stack.len == 0
    solver.remove(7)
    solver.output(3)
    answers.setLen(0)
    solver.run(apply, rollback, answer)
    doAssert answers == @[0, 3, 8, 0]
    doAssert total == 0 and stack.len == 0

var rng = initRand(712367)
for trial in 0..<100:
    const n = 8
    var edges: seq[(int, int)]
    for i in 0..<24: edges.add((rng.rand(n - 1), rng.rand(n - 1)))
    var active = newSeq[bool](edges.len)
    var expected: seq[seq[int]]
    var solver = initOfflineDynamicQueries()
    var typedSolver = initOfflineDynamicQueries((int, int))
    for step in 0..<200:
        if rng.rand(2) == 0:
            var labels = newSeq[int](n)
            for i in 0..<n: labels[i] = i
            for idx, edge in edges:
                if active[idx]:
                    let oldLabel = labels[edge[1]]
                    let newLabel = labels[edge[0]]
                    for i in 0..<n:
                        if labels[i] == oldLabel: labels[i] = newLabel
            solver.output(expected.len)
            typedSolver.output(expected.len)
            expected.add(labels)
        else:
            let idx = rng.rand(edges.high)
            if active[idx]:
                solver.remove(idx)
                typedSolver.remove(idx)
            else:
                solver.add(idx)
                typedSolver.add(idx, edges[idx])
            active[idx] = not active[idx]
    var uf = initRollbackUnionFind(n)
    var answered = 0
    proc apply(idx: int) = uf.unite(edges[idx][0], edges[idx][1])
    proc rollback() = uf.undo()
    proc answer(idx: int) =
        doAssert idx == answered
        inc answered
        for u in 0..<n:
            for v in 0..<n:
                doAssert uf.issame(u, v) == (expected[idx][u] == expected[idx][v])
    solver.run(apply, rollback, answer)
    doAssert answered == expected.len
    doAssert uf.get_state == 0 and uf.count == n
    answered = 0
    proc applyTyped(idx: int, edge: (int, int)) = uf.unite(edge[0], edge[1])
    typedSolver.run(applyTyped, rollback, answer)
    doAssert answered == expected.len
    doAssert uf.get_state == 0 and uf.count == n

echo "Hello World"
