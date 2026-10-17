# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, random, sequtils, sets
import cplib/geometry/base
import cplib/geometry/polygon
import cplib/math/fractions

proc oracle(input: seq[Point[int]], strict: bool): seq[Point[int]] =
    var points: seq[Point[int]]
    for p in input:
        if p notin points: points.add(p)
    if points.len <= 1: return points
    let first = points.min
    var current = first
    var corners: seq[Point[int]]
    while true:
        corners.add(current)
        var next = points[0]
        for p in points:
            if p == current: continue
            let turn = cross(next - current, p - current)
            if next == current or turn < 0 or
                    (turn == 0 and norm(p - current) > norm(next - current)):
                next = p
        current = next
        if current == first: break
        doAssert corners.len <= points.len
    if strict: return corners
    if corners.len == 2: return points.sorted
    for i, a in corners:
        let b = corners[(i + 1) mod corners.len]
        var edge: seq[Point[int]]
        for p in points:
            if p != b and cross(b - a, p - a) == 0 and dot(p - a, p - b) <= 0:
                edge.add(p)
        edge.sort(proc(p, q: Point[int]): int = cmp(norm(p - a), norm(q - a)))
        result.add(edge)

proc check(points: seq[Point[int]]) =
    let original = points
    for strict in [false, true]:
        let expected = oracle(points, strict)
        let actual = convex_hull(points, strict).v
        doAssert actual == expected, $points & " / " & $strict & " / " & $actual & " / " & $expected
        doAssert points == original
        doAssert actual.toHashSet.len == actual.len
        doAssert convex_hull(actual, strict).v == actual
        for reflected in [false, true]:
            let floats = points.mapIt(initPoint(float(it.x), float(if reflected: -it.y else: it.y)))
            let transformed = points.mapIt(initPoint(it.x, if reflected: -it.y else: it.y))
            let floatExpected = oracle(transformed, strict).mapIt(initPoint(float(it.x), float(it.y)))
            doAssert convex_hull(floats, strict).v.mapIt(it.toPointKey) == floatExpected.mapIt(it.toPointKey)
        let fractions = points.mapIt(initPoint(initFraction(it.x), initFraction(it.y)))
        let fractionExpected = expected.mapIt(initPoint(initFraction(it.x), initFraction(it.y)))
        doAssert convex_hull(fractions, strict).v == fractionExpected

check(@[])
check(@[initPoint(0, 0)])
check(@[initPoint(2, 1), initPoint(0, 0)])
check(newSeqWith(10, initPoint(2, 3)))
check(@[initPoint(0, 0), initPoint(0, 0), initPoint(1, 1)])
check(@[initPoint(0, 0), initPoint(1, 0), initPoint(2, 0)])
check(@[initPoint(0, 0), initPoint(0, 1), initPoint(0, 2)])
check(@[initPoint(0, 0), initPoint(1, 1), initPoint(2, 2)])
check(@[initPoint(-1, 1), initPoint(0, 0), initPoint(1, -1)])

var rng = initRand(20261003)
for mask in 0..<512:
    var points: seq[Point[int]]
    for i in 0..<9:
        if (mask and (1 shl i)) != 0:
            points.add(initPoint(i div 3 - 1, i mod 3 - 1))
    check(points)
    points.add(points)
    rng.shuffle(points)
    check(points)
for trial in 0..<500:
    var points: seq[Point[int]]
    for i in 0..<rng.rand(0..20):
        points.add(initPoint(rng.rand(-10..10), rng.rand(-10..10)))
    check(points)

block:
    let points = @[initPoint(0.0, 0.0), initPoint(1e-12, 0.0),
        initPoint(1.0, 0.0), initPoint(1.0, 1.0), initPoint(0.0, 1.0)]
    doAssert convex_hull(points, false).v.mapIt(it.toPointKey) == points.mapIt(it.toPointKey)
    doAssert convex_hull(points).v.mapIt(it.toPointKey) == @[points[0], points[2], points[3], points[4]].mapIt(it.toPointKey)
    let small = points.mapIt(initPoint(float32(it.x), float32(it.y)))
    doAssert convex_hull(small, false).v.mapIt(it.toPointKey) == small.mapIt(it.toPointKey)
    let fraction32 = @[initPoint(initFraction(0'i32), initFraction(0'i32)),
        initPoint(initFraction(1'i32), initFraction(0'i32)),
        initPoint(initFraction(0'i32), initFraction(1'i32))]
    doAssert convex_hull(fraction32).v == fraction32
    let oldEps = GEOMETRY_EPS
    GEOMETRY_EPS = 1
    doAssert convex_hull(points, false).v.mapIt(it.toPointKey) == points.mapIt(it.toPointKey)
    GEOMETRY_EPS = oldEps
    let tiny = @[initPoint(0.0, 0.0), initPoint(1e-12, 0.0), initPoint(0.0, 1e-12)]
    doAssert convex_hull(tiny).v.mapIt(it.toPointKey) == tiny.mapIt(it.toPointKey)
    var shuffledTiny = tiny
    for repeat in 0..<20:
        rng.shuffle(shuffledTiny)
        doAssert convex_hull(shuffledTiny).v.mapIt(it.toPointKey) == tiny.mapIt(it.toPointKey)
    let near = @[initPoint(0.0, 0.0), initPoint(1e-12, 0.0)]
    doAssert near[0] == near[1]
    doAssert convex_hull(near.reversed).v.mapIt(it.toPointKey) == near.mapIt(it.toPointKey)

block:
    const n = 10000
    var line: seq[Point[int]]
    for i in 0..<n:
        line.add(initPoint(i, -i))
        line.add(initPoint(i, -i))
    rng.shuffle(line)
    doAssert convex_hull(line).v == @[initPoint(0, 0), initPoint(n-1, 1-n)]
    doAssert convex_hull(line, false).len == n

echo "Hello World"
