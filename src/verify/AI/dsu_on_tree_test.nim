# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sequtils, macros
import cplib/utils/private/auto_rollback
import cplib/utils/private/temporary_rollback_log
import cplib/tree/dsu_on_tree
import cplib/tree/heavylightdecomposition
import cplib/graph/graph

proc testTree(g: seq[seq[int]], root: int, colors: seq[int]) =
    let n = g.len
    var parent = newSeqWith(n, -2)
    parent[root] = -1
    var order = @[root]
    var index = 0
    while index < order.len:
        let v = order[index]
        inc index
        for u in g[v]:
            if u != parent[v]:
                parent[u] = v
                order.add(u)
    var expected = newSeq[seq[int]](n)
    for v in 0..<n:
        expected[v] = newSeq[int](n)
        var u = v
        while u != -1:
            expected[v][u] = 1
            u = parent[u]
    var counts: array[8, int]
    var active = newSeq[int](n)
    var colorKinds, best, modeSum: int
    var seen = newSeq[int](n)
    proc increment(v: int) =
        let c = colors[v]
        inc active[v]
        if counts[c] == 0: inc colorKinds
        inc counts[c]
        if counts[c] > best:
            best = counts[c]
            modeSum = c
        elif counts[c] == best:
            modeSum += c
    proc add(v: int) = increment(v)
    proc answer(v: int) =
        inc seen[v]
        var expectedCounts: array[8, int]
        var expectedDistinct, expectedBest, expectedSum: int
        for u in 0..<n:
            doAssert active[u] == expected[u][v]
            if expected[u][v] == 1: inc expectedCounts[colors[u]]
        for c in 0..<8:
            if expectedCounts[c] > 0: inc expectedDistinct
            if expectedCounts[c] > expectedBest:
                expectedBest = expectedCounts[c]
                expectedSum = c
            elif expectedCounts[c] == expectedBest:
                expectedSum += c
        doAssert counts == expectedCounts
        doAssert (colorKinds, best, modeSum) == (expectedDistinct, expectedBest, expectedSum)
    proc checkEmpty() =
        doAssert colorKinds == 0 and best == 0 and modeSum == 0
        for c in counts: doAssert c == 0
        for value in active: doAssert value == 0
    for repeat in 0..<2:
        dsuOnTree(g, add, answer, root = root)
        checkEmpty()
    let hld = initHld(g, root)
    dsuOnTree(hld, add, answer)
    checkEmpty()
    var clearCalls, addCalls: int
    proc manualAdd(v: int) =
        doAssert active[v] == 0
        inc addCalls
        increment(v)
    proc clearState(v: int) =
        doAssert active[v] == 1
        dec active[v]
        dec counts[colors[v]]
        if counts[colors[v]] == 0: dec colorKinds
        best = 0
        modeSum = 0
        for c in 0..<counts.len:
            if counts[c] > best:
                best = counts[c]
                modeSum = c
            elif counts[c] == best and best > 0:
                modeSum += c
        inc clearCalls
    dsuOnTree(g, manualAdd, answer, clear = clearState, root = root)
    checkEmpty()
    doAssert clearCalls == addCalls
    dsuOnTree(hld, manualAdd, answer, clear = clearState)
    checkEmpty()
    doAssert clearCalls == addCalls
    var levels = 1
    var size = n
    while size > 1:
        inc levels
        size = size div 2
    doAssert addCalls <= 2 * n * levels
    for count in seen: doAssert count == 5

var rng = initRand(329001)
for n in [1, 2, 3, 10, 31, 60]:
    for shape in 0..<4:
        var g = newSeq[seq[int]](n)
        var colors = newSeq[int](n)
        for v in 1..<n:
            let p = case shape
                of 0: v - 1
                of 1: 0
                of 2: (v - 1) div 2
                else: rng.rand(v - 1)
            g[v].add(p)
            g[p].add(v)
        for v in 0..<n: colors[v] = rng.rand(7)
        for root in [0, n - 1, n div 2]: testTree(g, root, colors)
for trial in 0..<100:
    let n = rng.rand(60) + 1
    var g = newSeq[seq[int]](n)
    var colors = newSeq[int](n)
    for v in 1..<n:
        let p = rng.rand(v - 1)
        g[v].add(p)
        g[p].add(v)
    for v in 0..<n: colors[v] = rng.rand(7)
    testTree(g, rng.rand(n - 1), colors)

block:
    var graph = initWeightedUnDirectedStaticGraph(3, int)
    graph.add_edge(0, 1, 7)
    graph.add_edge(1, 2, 9)
    graph.build()
    var total = 0
    var answers = newSeq[int](3)
    proc add(v: int) = total += v + 1
    proc answer(v: int) = answers[v] = total
    proc clearState(v: int) = total -= v + 1
    dsuOnTree(graph, add, answer)
    doAssert answers == @[6, 5, 3] and total == 0
    dsuOnTree(graph, add, answer, clear = clearState, root = 2)
    doAssert answers == @[1, 3, 6] and total == 0
    var dynamic = initUnWeightedUnDirectedGraph(3)
    dynamic.add_edge(0, 1)
    dynamic.add_edge(1, 2)
    dsuOnTree(dynamic, add, answer, root = 2)
    doAssert answers == @[1, 3, 6] and total == 0
    let children = [@[1], @[2], newSeq[int]()]
    dsuOnTree(children, add, answer, root = 1)
    doAssert answers == @[1, 6, 3] and total == 0

block:
    let g = @[@[1, 2], @[0], @[0]]
    var value = 17
    var answers = newSeq[int](3)
    proc add(v: int) = value += v + 1
    proc answer(v: int) = answers[v] = value
    dsuOnTree(g, add, answer)
    doAssert value == 17 and answers == @[23, 19, 20]

block:
    let g = @[@[1, 2], @[0], @[0]]
    var values = [1, 2]
    var shouldFail = true
    let failure = newException(ValueError, "test")
    proc add(v: int) =
        values = [3, 4]
        values[0] = 5
        if shouldFail: raise failure
    proc answer(v: int) = raise failure
    for repeat in 0..<3:
        try:
            dsuOnTree(g, add, answer)
            doAssert false
        except ValueError:
            doAssert values == [1, 2]
        shouldFail = false

block:
    let g = @[@[1], @[0]]
    var active: seq[int]
    var clears = 0
    proc add(v: int) = active.add(v)
    proc answer(v: int) = raise newException(ValueError, "test")
    proc clearState(v: int) =
        let index = active.find(v)
        doAssert index >= 0
        active.delete(index)
        inc clears
    try:
        dsuOnTree(g, add, answer, clear = clearState)
        doAssert false
    except ValueError:
        doAssert active.len == 0 and clears == 1

block:
    const n = 200000
    var parent = newSeq[int](n)
    for v in 0..<n: parent[v] = v - 1
    let hld = initHldFromParent(parent, 0)
    var count, seen: int
    proc add(v: int) = inc count
    proc answer(v: int) =
        doAssert count == n - v
        inc seen
    dsuOnTree(hld, add, answer)
    doAssert count == 0 and seen == n
    var removed = newSeq[bool](n)
    proc clearState(v: int) =
        doAssert not removed[v]
        removed[v] = true
        dec count
    dsuOnTree(hld, add, answer, clear = clearState)
    doAssert count == 0 and seen == 2 * n
    for value in removed: doAssert value

block:
    let g = @[@[1, 2, 3], @[0], @[0], @[0]]
    let hld = initHld(g, 0)
    var active: array[4, bool]
    var calls, cleared: int
    var failAt = 0
    proc add(v: int) =
        inc calls
        if calls == failAt: raise newException(ValueError, "test")
        doAssert not active[v]
        active[v] = true
    proc answer(v: int) = discard
    proc clearState(v: int) =
        doAssert active[v]
        active[v] = false
        inc cleared
    dsuOnTree(hld, add, answer, clear = clearState)
    let totalCalls = calls
    for stop in 1..totalCalls:
        calls = 0
        cleared = 0
        failAt = stop
        try:
            dsuOnTree(hld, add, answer, clear = clearState)
            doAssert false
        except ValueError:
            doAssert cleared == calls - 1
            for value in active: doAssert not value

static:
    doAssert not compiles(block:
        var g = @[@[1], @[0]]
        var values: seq[int]
        proc add(v: int) = values.add(v)
        proc answer(v: int) = discard
        dsuOnTree(g, add, answer)
    )

macro checkFirstWrites(update: proc(v: int)): untyped =
    let history = genSym(nskVar, "history")
    let code = buildAutoRollback(update, history, "test", temporaryMode = true)
    let declarations = code.declarations
    let call = newCall(code.transformed, history, newLit(0))
    result = quote do:
        block:
            var `history`: TemporaryRollbackLog
            `declarations`
            for batch in 0..<3:
                for repeat in 0..<1000:
                    `call`
                doAssert `history`.len == 2
                `history`.restore(0)

block:
    var values = @[4]
    var maximum = 7
    proc add(v: int) =
        inc values[v]
        maximum = max(maximum, values[v])
    checkFirstWrites(add)
    doAssert values == @[4] and maximum == 7

block:
    let g = @[@[1, 2], @[0], @[0]]
    var values = [7, 8, 9]
    var seen = 0
    proc add(v: int) =
        values[1] += v + 1
        values = [4, 5, 6]
        values[2] += 10
    proc answer(v: int) =
        doAssert values == [4, 5, 16]
        inc seen
    dsuOnTree(g, add, answer)
    doAssert values == [7, 8, 9] and seen == 3

block:
    let g = @[@[1], @[0]]
    var values = [7, 8, 9]
    proc add(v: int) =
        values = [4, 5, 6]
        values[2] += v
    proc answer(v: int) = discard
    dsuOnTree(g, add, answer)
    doAssert values == [7, 8, 9]

proc testNested(n: int) =
    var parent = newSeq[int](n)
    for v in 0..<n: parent[v] = v - 1
    let hld = initHldFromParent(parent, 0)
    var values = newSeq[int](n)
    var count, seen: int
    proc add(v: int) =
        inc values[v]
        inc count
    proc answer(v: int) =
        doAssert count == n - v
        for u in 0..<n: doAssert values[u] == int(u >= v)
        inc seen
        if v == 0 and n > 1:
            testNested(n - 1)
            doAssert count == n
            for value in values: doAssert value == 1
    dsuOnTree(hld, add, answer)
    doAssert count == 0 and seen == n
    for value in values: doAssert value == 0

testNested(6)

block:
    var values: seq[int]
    var prepared, answerCreated, seen: int
    proc prepare(): HeavyLightDecomposition =
        inc prepared
        values = newSeq[int](3)
        initHldFromParent(@[-1, 0, 0], 0)
    proc makeAnswer(): proc(v: int) =
        inc answerCreated
        values = newSeq[int](3)
        result = proc(v: int) =
            doAssert values[v] == 1
            inc seen
    proc add(v: int) = inc values[v]
    dsuOnTree(prepare(), add, makeAnswer())
    doAssert prepared == 1 and answerCreated == 1 and seen == 3
    doAssert values == @[0, 0, 0]

echo "Hello World"
