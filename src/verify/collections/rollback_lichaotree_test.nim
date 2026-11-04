# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/collections/rollback_lichaotree
import cplib/utils/constants

type
    OracleLine = object
        a, b, l, r: int
        whole: bool
    Saved = object
        token: RollbackLiChaoSnapshot
        depth: int
        id: int

template expectValueError(body: untyped) =
    block:
        var raised = false
        try:
            body
        except ValueError:
            raised = true
        doAssert raised

proc check(tree: RollbackLiChaoTree, coords: openArray[int], lines: seq[OracleLine]) =
    for x in coords:
        var found = false
        var expected = INF64
        for line in lines:
            if line.whole or (line.l <= x and x < line.r):
                let value = line.a * x + line.b
                if not found or value < expected: expected = value
                found = true
        doAssert tree.get_min(x) == expected

proc add(tree: RollbackLiChaoTree, line: OracleLine) =
    if line.whole: tree.add_line(line.a, line.b)
    else: tree.add_segment(line.a, line.b, line.l, line.r)

block:
    var coords = @[3, -2, 0, 3]
    let tree = initRollbackLiChaoTree(coords)
    doAssert coords == @[3, -2, 0, 3]
    coords[0] = 100
    let initial = tree.snapshot()
    let alias = tree
    alias.add_line(0, 9)
    doAssert tree.get_min(3) == 9
    let ancestor = tree.snapshot()
    tree.add_line(0, -3)
    let abandoned = tree.snapshot()
    tree.rollback(ancestor)
    doAssert tree.get_min(3) == 9
    tree.rollback(ancestor)
    tree.add_line(0, -5)
    expectValueError: tree.rollback(abandoned)
    doAssert tree.get_min(3) == -5
    let other = initRollbackLiChaoTree(@[-2, 0, 3])
    other.add_line(0, -8)
    expectValueError: tree.rollback(other.snapshot())
    expectValueError: tree.rollback(default(RollbackLiChaoSnapshot))
    doAssert tree.get_min(3) == -5
    doAssert other.get_min(3) == -8
    expectValueError: discard tree.get_min(1)
    expectValueError: discard tree.get_min(100)
    tree.undo()
    tree.rollback(ancestor)
    tree.add_line(0, 9)
    let duplicate = tree.snapshot()
    tree.add_line(0, 10)
    tree.undo()
    tree.rollback(duplicate)
    tree.undo()
    tree.rollback(ancestor)
    for (l, r) in [(1, 1), (10, 20), (5, -5)]:
        tree.add_segment(0, -100, l, r)
        let noChange = tree.snapshot()
        tree.undo()
        expectValueError: tree.rollback(noChange)
        doAssert tree.get_min(3) == 9
    tree.rollback(initial)
    tree.check(@[-2, 0, 3], @[])
    expectValueError: tree.undo()
    expectValueError: tree.rollback(ancestor)
    tree.add_line(0, 7)
    expectValueError: tree.rollback(ancestor)
    tree.rollback(initial)

block:
    let tree = initRollbackLiChaoTree(newSeq[int]())
    let initial = tree.snapshot()
    expectValueError: discard tree.get_min(0)
    tree.add_line(1, 2)
    let afterLine = tree.snapshot()
    tree.add_segment(-1, -2, low(int), high(int))
    tree.undo()
    tree.rollback(afterLine)
    tree.undo()
    expectValueError: tree.rollback(afterLine)
    tree.rollback(initial)
    expectValueError: tree.undo()

block:
    let tree = initRollbackLiChaoTree(@[0, 1])
    let initial = tree.snapshot()
    for b in [high(int), INF64 + 1, INF64, low(int)]:
        tree.add_line(0, b)
        doAssert tree.get_min(0) == b
        doAssert tree.get_min(1) == b
        tree.rollback(initial)
    tree.add_segment(0, high(int), 0, 1)
    doAssert tree.get_min(0) == high(int)
    doAssert tree.get_min(1) == INF64
    tree.undo()
    doAssert tree.get_min(0) == INF64

proc boundaryCheck(coords: seq[int]) =
    let tree = initRollbackLiChaoTree(coords)
    var oracle: seq[OracleLine]
    let initial = tree.snapshot()
    var tokens = @[initial]
    for (a, b) in [(0, 0), (-1, 1_600_000_000), (1, -1_600_000_000), (-2, 17), (2, -19)]:
        let line = OracleLine(a: a, b: b, whole: true)
        tree.add(line)
        oracle.add(line)
        tokens.add(tree.snapshot())
        tree.check(coords, oracle)
    for (a, b, l, r) in [
        (-3, 11, 1_400_000_000, 1_800_000_000),
        (4, -20, 1_550_000_000, 1_650_000_000),
        (0, -50, 1_700_000_000, 1_800_000_000),
        (0, -100, 1_800_000_000, 1_900_000_000),
        (0, -100, 1_550_000_000, 1_550_000_000),
        (1, -17, low(int), high(int)),
        (-1, 31, int(low(int32)), int(high(int32)))]:
        let line = OracleLine(a: a, b: b, l: l, r: r)
        tree.add(line)
        oracle.add(line)
        tokens.add(tree.snapshot())
        tree.check(coords, oracle)
    for depth in countdown(oracle.len - 1, 0):
        tree.rollback(tokens[depth])
        oracle.setLen(depth)
        tree.check(coords, oracle)
    tree.rollback(initial)

for coords in [
    @[1_500_000_000, 1_600_000_000, 1_700_000_000],
    @[1_500_000_000, 1_700_000_000],
    @[1_500_000_000, 1_600_000_000, 1_650_000_000, 1_700_000_000],
    @[1_700_000_000, 1_500_000_000, 1_700_000_000, 1_600_000_000],
    @[1_700_000_000],
    @[int(low(int32)), -1, 0, 1, int(high(int32))],
    @[low(int), -1, 0, high(int)]]:
    if coords[0] == low(int):
        let tree = initRollbackLiChaoTree(coords)
        let initial = tree.snapshot()
        tree.add_line(0, 42)
        tree.add_segment(0, -42, low(int), high(int))
        doAssert tree.get_min(low(int)) == -42
        doAssert tree.get_min(high(int)) == 42
        tree.undo()
        doAssert tree.get_min(low(int)) == 42
        tree.rollback(initial)
        tree.check(coords, @[])
    else:
        boundaryCheck(coords)

block:
    let coords = @[-2, 0, 3]
    let tree = initRollbackLiChaoTree(coords)
    var candidates: seq[OracleLine]
    for a in -2..2:
        for b in -2..2:
            candidates.add(OracleLine(a: a, b: b, whole: true))
            for (l, r) in [(-3, 4), (-2, 0), (0, 3), (3, 4), (0, 0), (4, 5), (3, -2)]:
                candidates.add(OracleLine(a: a, b: b, l: l, r: r))
    let initial = tree.snapshot()
    for first in candidates:
        tree.add(first)
        let parent = tree.snapshot()
        tree.check(coords, @[first])
        for second in candidates:
            tree.add(second)
            tree.check(coords, @[first, second])
            tree.undo()
            tree.check(coords, @[first])
            tree.add(second)
            tree.rollback(parent)
            tree.check(coords, @[first])
        tree.rollback(initial)
        tree.check(coords, @[])

var rng = initRand(500)
for n in [0, 1, 2, 3, 4, 5, 8, 15]:
    for trial in 0..<3:
        var coords: seq[int]
        for i in 0..<n: coords.add(i * 7 - n * 3)
        if n > 0: coords.add(coords[0])
        rng.shuffle(coords)
        let tree = initRollbackLiChaoTree(coords)
        var oracle: seq[OracleLine]
        var ids: seq[int]
        var saved = @[Saved(token: tree.snapshot(), depth: 0, id: 0)]
        var serial = 0
        for step in 0..<1000:
            let action = rng.rand(99)
            if action < 50:
                inc serial
                let line = OracleLine(a: rng.rand(20) - 10, b: rng.rand(100) - 50,
                    l: rng.rand(160) - 80, r: rng.rand(160) - 80, whole: action < 25)
                tree.add(line)
                oracle.add(line)
                ids.add(serial)
            elif action < 65:
                if oracle.len == 0:
                    expectValueError: tree.undo()
                else:
                    tree.undo()
                    oracle.setLen(oracle.len - 1)
                    ids.setLen(ids.len - 1)
            elif action < 75:
                saved.add(Saved(token: tree.snapshot(), depth: oracle.len,
                    id: (if ids.len == 0: 0 else: ids[^1])))
            else:
                let target = saved[rng.rand(saved.len - 1)]
                let valid = target.depth <= ids.len and
                    (target.depth == 0 or ids[target.depth - 1] == target.id)
                if valid:
                    tree.rollback(target.token)
                    oracle.setLen(target.depth)
                    ids.setLen(target.depth)
                else:
                    expectValueError: tree.rollback(target.token)
            tree.check(coords, oracle)
        tree.rollback(saved[0].token)
        tree.check(coords, @[])

block:
    let tree = initRollbackLiChaoTree(@[0])
    let initial = tree.snapshot()
    tree.add_line(0, -1)
    let parent = tree.snapshot()
    for i in 0..<100_000: tree.add_line(0, i)
    let noChangeFuture = tree.snapshot()
    tree.rollback(parent)
    doAssert tree.get_min(0) == -1
    tree.add_line(0, 0)
    expectValueError: tree.rollback(noChangeFuture)
    tree.undo()
    tree.undo()
    tree.rollback(initial)
    doAssert tree.get_min(0) == INF64

echo "Hello World"
