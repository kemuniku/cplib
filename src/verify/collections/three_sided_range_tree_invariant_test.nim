# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
include cplib/collections/three_sided_range_tree
import random, algorithm

proc validate(node: ThreeSidedNode[int, int, int, int]): seq[tuple[key, value, serial: int]] =
    if node.isNil: return
    let left = validate(node.left)
    let right = validate(node.right)
    doAssert abs(node.left.nodeHeight - node.right.nodeHeight) <= 1
    doAssert node.height == max(node.left.nodeHeight, node.right.nodeHeight) + 1
    result = left & @[(key: node.key, value: node.value, serial: node.point.serial)] & right
    for i in 1..<result.len:
        doAssert result[i-1].key < result[i].key or
            (result[i-1].key == result[i].key and result[i-1].serial < result[i].serial)
    var sorted = result
    sorted.sort(proc(a, b: tuple[key, value, serial: int]): int =
        if a.value != b.value: cmp(a.value, b.value)
        else: cmp(a.serial, b.serial))
    doAssert node.minValue == sorted[0].value
    doAssert node.minPoint.serial == sorted[0].serial
    let maxValue = sorted[^1].value
    var maxSerial = high(int)
    for p in sorted:
        if p.value == maxValue: maxSerial = min(maxSerial, p.serial)
    doAssert node.maxValue == maxValue and node.maxPoint.serial == maxSerial

proc validateTree(tree: ThreeSidedRangeTree[int, int]) =
    let xs = validate(tree.byX)
    let ys = validate(tree.byY)
    doAssert xs.len == tree.len and ys.len == tree.len
    var xserials, yserials: seq[int]
    for p in xs: xserials.add(p.serial)
    for p in ys: yserials.add(p.serial)
    xserials.sort()
    yserials.sort()
    doAssert xserials == yserials

for order in [@[3, 2, 1], @[1, 2, 3], @[3, 1, 2], @[1, 3, 2]]:
    let tree = initThreeSidedRangeTree[int, int]()
    var ids: seq[ThreeSidedPointId[int, int]]
    for x in order:
        ids.add(tree.add(x, -x))
        tree.validateTree()
    for id in ids:
        tree.erase(id)
        tree.validateTree()

for seed in 0..<12:
    var rng = initRand(seed)
    let tree = initThreeSidedRangeTree[int, int]()
    var ids: seq[ThreeSidedPointId[int, int]]
    for step in 0..<500:
        let op = rng.rand(3)
        if ids.len == 0 or op == 0:
            ids.add(tree.add(rng.rand(-9..9), rng.rand(-9..9)))
        elif op == 1:
            let i = rng.rand(ids.high)
            tree.erase(ids[i])
            ids.delete(i)
        else:
            let i = rng.rand(ids.high)
            tree.update(ids[i], rng.rand(-9..9), rng.rand(-9..9))
        tree.validateTree()

block:
    let tree = initThreeSidedRangeTree[int, int]()
    tree.nextSerial = high(int) - 1
    let id = tree.add(0, 0)
    doAssert id.serial == high(int) - 1
    var caught = false
    try: discard tree.add(1, 1)
    except ValueError: caught = true
    doAssert caught and tree.len == 1
    tree.update(id, high(int), low(int))
    tree.validateTree()
    tree.erase(id)
    caught = false
    try: discard tree.add(1, 1)
    except ValueError: caught = true
    doAssert caught and tree.len == 0

var comparisons = 0
type Counted = object
    value: int
proc `<`(a, b: Counted): bool =
    inc comparisons
    a.value < b.value

proc c(value: int): Counted = Counted(value: value)

block:
    const n = 65537
    let tree = initThreeSidedRangeTree[Counted, Counted]()
    var ids: seq[ThreeSidedPointId[Counted, Counted]]
    for i in 0..<n:
        comparisons = 0
        ids.add(tree.add(c(i), c(n - i)))
        let h = max(tree.byX.nodeHeight, tree.byY.nodeHeight)
        doAssert comparisons <= 32 * (h + 1)
    doAssert tree.byX.nodeHeight < 32 and tree.byY.nodeHeight < 32
    for i in 0..<2000:
        let lower = (i * 7919) mod n
        let upper = min(n, lower + (i * 37) mod 1000 + 1)
        for d in 0..<4:
            comparisons = 0
            let found = case d
                of 0: tree.findBelow(c(lower), c(upper), c(n - upper + 1))
                of 1: tree.findAbove(c(lower), c(upper), c(n - lower))
                of 2: tree.findLeft(c(lower), c(upper), c(n - upper + 1))
                else: tree.findRight(c(lower), c(upper), c(n - lower))
            let h = max(tree.byX.nodeHeight, tree.byY.nodeHeight)
            doAssert comparisons <= 32 * (h + 1)
            if d < 2:
                doAssert found.isSome
                doAssert found.get.x.value == (if d == 0: upper - 1 else: lower)
        comparisons = 0
        tree.update(ids[lower], c(lower), c(n - lower))
        let h = max(tree.byX.nodeHeight, tree.byY.nodeHeight)
        doAssert comparisons <= 80 * (h + 1)
    for i in countdown(n - 1, 0):
        comparisons = 0
        let h = max(tree.byX.nodeHeight, tree.byY.nodeHeight)
        tree.erase(ids[i])
        doAssert comparisons <= 48 * (h + 1)
    doAssert tree.len == 0
    doAssert tree.byX.isNil and tree.byY.isNil

echo "Hello World"
