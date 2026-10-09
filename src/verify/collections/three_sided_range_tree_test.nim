# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/three_sided_range_tree
import options, random

template rejects(body: untyped) =
    block:
        var caught = false
        try:
            body
        except ValueError:
            caught = true
        doAssert caught

type Stored = tuple[id: ThreeSidedPointId[int, int], x, y: int]

proc checkQuery(tree: ThreeSidedRangeTree[int, int], points: seq[Stored],
        lower, upper, limit, direction: int) =
    let found = case direction
        of 0: tree.findBelow(lower, upper, limit)
        of 1: tree.findAbove(lower, upper, limit)
        of 2: tree.findLeft(lower, upper, limit)
        else: tree.findRight(lower, upper, limit)
    var exists = false
    var witness = false
    var best: ThreeSidedPointId[int, int]
    var bestValue = 0
    for p in points:
        let primary = if direction < 2: p.x else: p.y
        let secondary = if direction < 2: p.y else: p.x
        let matches = lower <= primary and primary < upper and
            (if direction mod 2 == 0: secondary <= limit else: secondary >= limit)
        exists = exists or matches
        if matches and (best.isNil or
                (if direction mod 2 == 0: secondary < bestValue else: secondary > bestValue)):
            best = p.id
            bestValue = secondary
        if found.isSome and found.get.id == p.id:
            doAssert found.get.x == p.x and found.get.y == p.y
            witness = matches
    doAssert found.isSome == exists
    if exists:
        doAssert witness
        doAssert found.get.id == best

block:
    var uninitialized: ThreeSidedRangeTree[int, int]
    doAssert uninitialized.len == 0
    doAssert not uninitialized.contains(nil)
    rejects: discard uninitialized.add(0, 0)
    rejects: discard uninitialized.findBelow(0, 1, 0)
    let manual = ThreeSidedRangeTree[int, int]()
    doAssert manual.len == 0 and not manual.contains(nil)
    rejects: discard manual.add(0, 0)
    rejects: discard manual.findAbove(0, 1, 0)
    let a = initThreeSidedRangeTree[int, int]()
    let b = initThreeSidedRangeTree[int, int]()
    let id = a.add(0, 0)
    let foreign = b.add(0, 0)
    doAssert a.contains(id) and not a.contains(foreign)
    rejects: a.erase(foreign)
    rejects: a.update(foreign, 1, 2)
    rejects: discard a.get(foreign)
    rejects: a.erase(nil)
    let alias = a
    alias.update(id, 3, 4)
    doAssert a.get(id) == (id: id, x: 3, y: 4)
    let snapshot = a.get(id)
    a.erase(id)
    doAssert not a.contains(id) and a.len == 0
    doAssert snapshot.x == 3 and snapshot.y == 4
    rejects: a.erase(id)
    rejects: a.update(id, 0, 0)
    rejects: discard a.get(id)
    let fresh = a.add(3, 4)
    doAssert fresh != id

block:
    let tree = initThreeSidedRangeTree[int, int]()
    var points: seq[Stored]
    let extremes = @[low(int), low(int) + 1, -1, 0, 1, high(int) - 1, high(int)]
    for x in extremes:
        for y in extremes:
            for repeat in 0..<2:
                points.add((id: tree.add(x, y), x: x, y: y))
    for lower in extremes:
        for upper in extremes:
            for limit in extremes:
                for d in 0..<4: checkQuery(tree, points, lower, upper, limit, d)
    let oldest = points[0].id
    doAssert tree.findBelow(low(int), low(int) + 1, low(int)).get.id == oldest
    tree.erase(oldest)
    points.delete(0)
    doAssert tree.findBelow(low(int), low(int) + 1, low(int)).get.id == points[0].id
    tree.update(points[^1].id, low(int), high(int))
    points[^1].x = low(int)
    for d in 0..<4: checkQuery(tree, points, low(int), high(int), high(int), d)
    while points.len > 0:
        tree.erase(points[^1].id)
        points.setLen(points.len - 1)
    doAssert tree.len == 0
    for d in 0..<4: checkQuery(tree, points, low(int), high(int), 0, d)

for seed in 0..<24:
    var rng = initRand(seed)
    let tree = initThreeSidedRangeTree[int, int]()
    var points: seq[Stored]
    for step in 0..<800:
        let op = rng.rand(4)
        if points.len == 0 or op <= 1:
            let x = rng.rand(-15..15)
            let y = rng.rand(-15..15)
            points.add((id: tree.add(x, y), x: x, y: y))
        elif op == 2:
            let i = rng.rand(points.high)
            let removed = points[i].id
            tree.erase(removed)
            points.delete(i)
            doAssert not tree.contains(removed)
        else:
            let i = rng.rand(points.high)
            let x = rng.rand(-15..15)
            let y = rng.rand(-15..15)
            tree.update(points[i].id, x, y)
            points[i].x = x
            points[i].y = y
            doAssert tree.get(points[i].id) == points[i]
        doAssert tree.len == points.len
        for d in 0..<4:
            checkQuery(tree, points, rng.rand(-17..17), rng.rand(-17..17),
                rng.rand(-17..17), d)
        if step mod 100 == 0:
            for p in points: doAssert tree.get(p.id) == p
    while points.len > 0:
        let i = rng.rand(points.high)
        tree.erase(points[i].id)
        points.delete(i)
    doAssert tree.len == 0

type Coordinate = object
    value: int
proc `<`(a, b: Coordinate): bool = a.value < b.value

block:
    let tree = initThreeSidedRangeTree[Coordinate, string]()
    let id = tree.add(Coordinate(value: 3), "middle")
    discard tree.add(Coordinate(value: 3), "middle")
    discard tree.add(Coordinate(value: 9), "z")
    doAssert tree.findBelow(Coordinate(value: 3), Coordinate(value: 4), "middle").get.id == id
    doAssert tree.findAbove(Coordinate(value: 3), Coordinate(value: 4), "middle").get.id == id
    doAssert tree.findLeft("a", "z", Coordinate(value: 3)).get.id == id
    doAssert tree.findRight("a", "z", Coordinate(value: 3)).get.id == id
    doAssert tree.findBelow(Coordinate(value: 3), Coordinate(value: 4), "a").isNone
    tree.update(id, Coordinate(value: 10), "a")
    doAssert tree.findRight("a", "b", Coordinate(value: 10)).get.id == id
    tree.erase(id)

block:
    let tree = initThreeSidedRangeTree[uint64, int64]()
    let id = tree.add(high(uint64), low(int64))
    doAssert tree.findRight(low(int64), low(int64) + 1, high(uint64)).get.id == id
    doAssert tree.findLeft(low(int64), low(int64) + 1, high(uint64)).get.id == id
    tree.update(id, 0'u64, high(int64))
    doAssert tree.findAbove(0'u64, 1'u64, high(int64)).get.id == id
    doAssert tree.findBelow(0'u64, 1'u64, high(int64)).get.id == id

block:
    let tree = initThreeSidedRangeTree[float32, float64]()
    let id = tree.add(1.5'f32, 2.25)
    doAssert tree.findBelow(1'f32, 2'f32, 2.25).get.id == id
    doAssert tree.findAbove(1'f32, 2'f32, 2.25).get.id == id
    tree.update(id, -1.5'f32, -2.25)
    doAssert tree.findLeft(-3.0, -2.0, -1.5'f32).get.id == id
    doAssert tree.findRight(-3.0, -2.0, -1.5'f32).get.id == id

echo "Hello World"
