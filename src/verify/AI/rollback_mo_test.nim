# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/utils/rollback_mo
import cplib/utils/offline_dynamic_queries
import cplib/collections/unionfind
import cplib/collections/segtree_static_op

block:
    var solver = initRollbackMo(0)
    var calls = 0
    proc add(idx: int) = inc calls
    proc answer(idx: int) = inc calls
    solver.runAutoRollback(add, answer)
    doAssert calls == 0
    doAssert solver.insert(0, 0) == 0
    solver.runAutoRollback(add, answer)
    doAssert calls == 1

proc testFrequencies(values: seq[int], ranges: seq[(int, int)], width: int) =
    var solver = initRollbackMo(values.len, ranges.len, width)
    var expected: seq[int]
    for idx, query in ranges:
        doAssert solver.insert(query[0], query[1]) == idx
        var counts: array[8, int]
        counts[0] = 2
        for i in query[0]..<query[1]: inc counts[values[i]]
        var best = 2
        for count in counts: best = max(best, count)
        expected.add(best)
    var counts: array[8, int]
    counts[0] = 2
    var best = 2
    var answers = newSeq[int](ranges.len)
    var seen = newSeq[int](ranges.len)
    proc increment(value: int) =
        inc counts[value]
        best = max(best, counts[value])
    proc add(idx: int) = increment(values[idx])
    proc answer(idx: int) =
        answers[idx] = best
        inc seen[idx]
    for repeat in 0..<2:
        solver.runAutoRollback(add, answer)
        doAssert answers == expected
        doAssert best == 2 and counts[0] == 2
        for i in 1..<counts.len: doAssert counts[i] == 0
        for count in seen: doAssert count == repeat + 1
    var history: seq[(int, int)]
    var additions = 0
    proc manualAdd(idx: int) =
        history.add((values[idx], best))
        increment(values[idx])
        inc additions
    proc rollback() =
        let previous = history.pop()
        dec counts[previous[0]]
        best = previous[1]
    solver.run(manualAdd, rollback, answer)
    doAssert answers == expected
    doAssert best == 2 and counts[0] == 2 and history.len == 0
    for i in 1..<counts.len: doAssert counts[i] == 0
    for count in seen: doAssert count == 3
    if width > 0:
        let b = min(width, max(1, values.len))
        doAssert additions <= values.len * (values.len div b + 1) + ranges.len * b
    solver.insert(0, 0)
    answers.add(0)
    seen.add(0)
    solver.runAutoRollback(add, answer)
    doAssert answers[^1] == 2 and seen[^1] == 1
    doAssert best == 2 and counts[0] == 2

var rng = initRand(230791)
for n in 0..12:
    var values = newSeq[int](n)
    for value in values.mitems: value = rng.rand(7)
    var ranges: seq[(int, int)]
    for l in 0..n:
        for r in l..n: ranges.add((l, r))
    rng.shuffle(ranges)
    for width in [0, 1, 2, 3, n, n + 5]:
        testFrequencies(values, ranges, width)

for trial in 0..<40:
    let n = rng.rand(80) + 1
    var values = newSeq[int](n)
    for value in values.mitems: value = rng.rand(7)
    var ranges: seq[(int, int)]
    for i in 0..<150:
        let l = rng.rand(n)
        ranges.add((l, rng.rand(l..n)))
    testFrequencies(values, ranges, rng.rand(n) + 1)

for width in [1, 2, 4]:
    let values = [2, 0, 2, 3, 1, 0, 3]
    var mo = initRollbackMo(values.len, width = width)
    var ranges: seq[(int, int)]
    for l in 0..values.len:
        for r in l..values.len:
            mo.insert(l, r)
            ranges.add((l, r))
    var tree = newSegWith(4, l + r, 0)
    for i in 0..<4: tree[i] = 1
    let original = tree.arr
    var total = 0
    proc add(idx: int) =
        tree[values[idx]] = tree[values[idx]] + 1
        total = tree[0..3]
    proc answer(idx: int) =
        var expected = [1, 1, 1, 1]
        let (l, r) = ranges[idx]
        for i in l..<r: inc expected[values[i]]
        for i in 0..<4: doAssert tree[i] == expected[i]
        doAssert tree[1..2] == expected[1] + expected[2]
        doAssert total == (if l == r: 0 else: 4 + r - l)
    for repeat in 0..<2:
        mo.runAutoRollback(add, answer)
        doAssert tree.arr == original and total == 0

proc testDirections(n, width: int) =
    var mo = initRollbackMo(n, width = width)
    var ranges: seq[(int, int)]
    for l in 0..n:
        for r in l..n: ranges.add((l, r))
    rng.shuffle(ranges)
    for query in ranges: mo.insert(query[0], query[1])
    const powers = [1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000]
    var digits = 0
    var length = 0
    var first = -1
    var last = -1
    var seen = 0
    proc addLeft(idx: int) =
        if length > 0: doAssert idx == first - 1
        else: last = idx
        first = idx
        digits = (idx + 1) * powers[length] + digits
        inc length
    proc addRight(idx: int) =
        if length > 0: doAssert idx == last + 1
        else: first = idx
        last = idx
        digits = digits * 10 + idx + 1
        inc length
    proc answer(idx: int) =
        let (l, r) = ranges[idx]
        var expected = 0
        for i in l..<r: expected = expected * 10 + i + 1
        doAssert digits == expected and length == r - l
        if l < r: doAssert first == l and last == r - 1
        inc seen
    for repeat in 0..<2:
        mo.runAutoRollback(addLeft, addRight, answer)
        doAssert digits == 0 and length == 0 and first == -1 and last == -1
        doAssert seen == (repeat + 1) * ranges.len
    var history: seq[(int, int, int, int)]
    proc manualLeft(idx: int) =
        history.add((digits, length, first, last))
        addLeft(idx)
    proc manualRight(idx: int) =
        history.add((digits, length, first, last))
        addRight(idx)
    proc rollback() = (digits, length, first, last) = history.pop()
    mo.run(manualLeft, manualRight, rollback, answer)
    doAssert seen == 3 * ranges.len and history.len == 0
    doAssert digits == 0 and length == 0 and first == -1 and last == -1

for n in 0..8:
    for width in [0, 1, 2, 3, n, n + 5]: testDirections(n, width)

block:
    var mo = initRollbackMo(3, width = 1)
    mo.insert(0, 3)
    var state = 7
    proc addLeft(idx: int) = inc state
    proc addRight(idx: int) = state += 2
    proc failingLeft(idx: int) =
        addLeft(idx)
        state += 10 div idx
    proc failingRight(idx: int) =
        addRight(idx)
        state += 10 div (idx - 1)
    proc answer(idx: int) = discard
    try:
        mo.runAutoRollback(failingLeft, addRight, answer)
        doAssert false
    except DivByZeroDefect:
        doAssert state == 7
    try:
        mo.runAutoRollback(addLeft, failingRight, answer)
        doAssert false
    except DivByZeroDefect:
        doAssert state == 7

for trial in 0..<30:
    const vertices = 10
    var edges: seq[(int, int)]
    for i in 0..<40: edges.add((rng.rand(vertices - 1), rng.rand(vertices - 1)))
    var mo = initRollbackMo(edges.len)
    var expected: seq[int]
    for i in 0..<100:
        let l = rng.rand(edges.len)
        let r = rng.rand(l..edges.len)
        mo.insert(l, r)
        var labels: array[vertices, int]
        for v in 0..<vertices: labels[v] = v
        labels[1] = 0
        var count = vertices - 1
        for e in l..<r:
            let a = labels[edges[e][0]]
            let b = labels[edges[e][1]]
            if a != b:
                dec count
                for v in 0..<vertices:
                    if labels[v] == b: labels[v] = a
        expected.add(count)
    var uf = initUnionFind(vertices)
    uf.unite(0, 1)
    proc add(idx: int) = uf.unite(edges[idx][0], edges[idx][1])
    var seen = 0
    proc answer(idx: int) =
        doAssert uf.count == expected[idx]
        inc seen
    mo.runAutoRollback(add, answer)
    doAssert seen == expected.len
    doAssert uf.count == vertices - 1 and uf.siz(0) == 2
    for v in 2..<vertices: doAssert uf.siz(v) == 1

block:
    var mo = initRollbackMo(3, width = 1)
    mo.insert(0, 3)
    var state = 7
    proc add(idx: int) = inc state
    proc answer(idx: int) = raise newException(ValueError, "test")
    try:
        mo.runAutoRollback(add, answer)
        doAssert false
    except ValueError:
        doAssert state == 7

block:
    var mo = initRollbackMo(3, width = 1)
    mo.insert(0, 3)
    var state = 7
    proc add(idx: int) =
        inc state
        state += 10 div idx
    proc answer(idx: int) = discard
    try:
        mo.runAutoRollback(add, answer)
        doAssert false
    except DivByZeroDefect:
        doAssert state == 7

block:
    var offline = initOfflineDynamicQueries(int)
    var mo = initRollbackMo(3)
    var total = 0
    proc apply(idx, value: int) = total += value
    proc add(idx: int) = total += idx
    proc answer(idx: int) = doAssert total == idx
    offline.add(0, 3)
    offline.output(3)
    offline.runAutoRollback(apply, answer)
    mo.insert(0, 0)
    mo.insert(0, 2)
    mo.runAutoRollback(add, answer)
    doAssert total == 0

static:
    doAssert not compiles(block:
        var mo = initRollbackMo(1)
        var values: seq[int]
        proc add(idx: int) = values.add(idx)
        proc answer(idx: int) = discard
        mo.runAutoRollback(add, answer)
    )

echo "Hello World"
