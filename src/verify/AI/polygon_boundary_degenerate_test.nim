# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, sequtils
import cplib/geometry/base
import cplib/geometry/polygon
import cplib/math/fractions

proc boundary(v: seq[Point[int]], p: Point[int]): bool =
    for i, a in v:
        let b = v[(i + 1) mod v.len]
        let determinant = (b.x - a.x) * (p.y - a.y) - (b.y - a.y) * (p.x - a.x)
        if determinant == 0 and min(a.x, b.x) <= p.x and p.x <= max(a.x, b.x) and
                min(a.y, b.y) <= p.y and p.y <= max(a.y, b.y):
            return true

proc interior(v: seq[Point[int]], p: Point[int]): bool =
    if boundary(v, p): return false
    var winding = 0
    for i, a in v:
        let b = v[(i + 1) mod v.len]
        let determinant = (b.x - a.x) * (p.y - a.y) - (b.y - a.y) * (p.x - a.x)
        if a.y <= p.y and b.y > p.y and determinant > 0: inc winding
        if a.y > p.y and b.y <= p.y and determinant < 0: dec winding
    winding != 0

proc checkTyped[T](v: seq[Point[T]], p: Point[T], edge, inside: bool, checkContains: bool) =
    let poly = initPolygon(v)
    doAssert poly.on_edge(p) == edge, $v & " / " & $p
    if checkContains:
        doAssert poly.contains(p) == (edge or inside), $v & " / " & $p
        doAssert poly.contains(p, true) == inside, $v & " / " & $p
    doAssert poly.v.len == v.len
    for i in 0..<v.len:
        doAssert poly.v[i].x == v[i].x and poly.v[i].y == v[i].y

var boundaryQueries, containsQueries = 0
proc check(v: seq[Point[int]], checkContains: bool) =
    let vi32 = v.mapIt(initPoint(int32(it.x), int32(it.y)))
    let vi64 = v.mapIt(initPoint(int64(it.x), int64(it.y)))
    let vf32 = v.mapIt(initPoint(float32(it.x), float32(it.y)))
    let vf64 = v.mapIt(initPoint(float64(it.x), float64(it.y)))
    let vr = v.mapIt(initPoint(initFraction(it.x), initFraction(it.y)))
    for x in -2..2:
        for y in -2..2:
            let p = initPoint(x, y)
            let edge = boundary(v, p)
            let inside = checkContains and interior(v, p)
            checkTyped(v, p, edge, inside, checkContains)
            checkTyped(vi32, initPoint(int32(x), int32(y)), edge, inside, checkContains)
            checkTyped(vi64, initPoint(int64(x), int64(y)), edge, inside, checkContains)
            checkTyped(vf32, initPoint(float32(x), float32(y)), edge, inside, checkContains)
            checkTyped(vf64, initPoint(float64(x), float64(y)), edge, inside, checkContains)
            checkTyped(vr, initPoint(initFraction(x), initFraction(y)), edge, inside, checkContains)
            inc boundaryQueries
            if checkContains: inc containsQueries

var grid: seq[Point[int]]
for x in -1..1:
    for y in -1..1: grid.add(initPoint(x, y))

proc enumerate(v: var seq[Point[int]], remaining: int) =
    check(v, v.len <= 3)
    if remaining == 0: return
    for p in grid:
        v.add(p)
        enumerate(v, remaining - 1)
        v.setLen(v.len - 1)
var v: seq[Point[int]]
enumerate(v, 4)
doAssert boundaryQueries == 184525
doAssert containsQueries == 20500

let shapes = @[
    @[initPoint(-2, -2), initPoint(2, -2), initPoint(2, 2), initPoint(-2, 2)],
    @[initPoint(-2, -2), initPoint(2, -2), initPoint(0, 0), initPoint(2, 2), initPoint(-2, 2)],
    @[initPoint(-2, -2), initPoint(2, -2), initPoint(2, 2), initPoint(0, 2), initPoint(0, 0), initPoint(-2, 0)],
    @[initPoint(-2, 0), initPoint(0, 0), initPoint(2, 0)],
    @[initPoint(0, -2), initPoint(0, 0), initPoint(0, 2)],
    @[initPoint(-2, -2), initPoint(0, 0), initPoint(2, 2)],
]
for shape in shapes:
    for mask in 0..<(1 shl shape.len):
        var repeated: seq[Point[int]]
        for i, p in shape:
            repeated.add(p)
            if (mask and (1 shl i)) != 0: repeated.add(p)
        for closed in [false, true]:
            var input = repeated
            if closed: input.add(input[0])
            check(input, true)
            check(input.reversed, true)
            for offset in 1..<input.len:
                check(input[offset..^1] & input[0..<offset], true)

block:
    let a = initPoint(0.0, 0.0)
    let b = initPoint(1e-12, 0.0)
    let tiny = initPolygon([a, b])
    doAssert tiny.on_edge(a)
    doAssert tiny.on_edge(b)
    doAssert tiny.contains(a)
    doAssert not tiny.contains(a, true)
    doAssert not tiny.contains(initPoint(1.0, 1.0))
    let repeated = initPolygon([a, a])
    doAssert repeated.on_edge(initPoint(1e-12, 0.0))
    doAssert not repeated.on_edge(initPoint(1.0, 0.0))

block:
    let r = initFraction(1, 2)
    let p = initPoint(r, r)
    let single = initPolygon([p, p, p])
    doAssert single.on_edge(p) and single.contains(p)
    doAssert not single.contains(p, true)
    doAssert not single.on_edge(initPoint(initFraction(1, 3), r))

echo "Hello World"
