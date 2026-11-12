# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/geometry/base
import cplib/geometry/polygon
import cplib/geometry/convex_polygon
import cplib/geometry/minkowski_sum
import cplib/math/fractions
import algorithm, random, sequtils

proc equal[T](a, b: Point[T]): bool = a.x == b.x and a.y == b.y
proc same[T](a, b: seq[Point[T]]): bool =
    if a.len != b.len: return false
    for i in 0..<a.len:
        if not equal(a[i], b[i]): return false
    true
proc copy[T](a: seq[Point[T]]): seq[Point[T]] =
    for p in a: result.add(p)
proc determinant[T](a, b, c: Point[T]): T =
    (b.x-a.x)*(c.y-a.y) - (b.y-a.y)*(c.x-a.x)
proc oracleHull[T](points: seq[Point[T]]): seq[Point[T]] =
    var sorted = copy(points)
    sorted.sort(proc(a, b: Point[T]): int =
        if a.x < b.x or (a.x == b.x and a.y < b.y): -1
        elif equal(a, b): 0
        else: 1)
    var unique: seq[Point[T]]
    for p in sorted:
        if unique.len == 0 or not equal(unique[^1], p): unique.add(p)
    if unique.len <= 1: return unique
    let zero = unique[0].x - unique[0].x
    var lower, upper: seq[Point[T]]
    for p in unique:
        while lower.len >= 2 and determinant(lower[^2], lower[^1], p) <= zero:
            discard lower.pop()
        lower.add(p)
    for i in countdown(unique.high, 0):
        let p = unique[i]
        while upper.len >= 2 and determinant(upper[^2], upper[^1], p) <= zero:
            discard upper.pop()
        upper.add(p)
    lower.setLen(lower.len-1)
    upper.setLen(upper.len-1)
    lower & upper
proc oracleSum[T](a, b: seq[Point[T]]): seq[Point[T]] =
    var points: seq[Point[T]]
    for p in a:
        for q in b:
            points.add(initPoint(p.x+q.x, p.y+q.y))
    oracleHull(points)
proc check[T](a, b: seq[Point[T]]) =
    let beforeA = copy(a)
    let beforeB = copy(b)
    let expected = oracleSum(a, b)
    let ac = initConvexPolygon(a)
    let bc = initConvexPolygon(b)
    let actual = minkowski_sum(ac, bc)
    doAssert same(actual.toPolygon.v, expected)
    doAssert same(minkowski_sum(a, b).toPolygon.v, expected)
    doAssert same(minkowski_sum(initPolygon(a), initPolygon(b)).toPolygon.v, expected)
    doAssert same(minkowski_sum(bc, ac).toPolygon.v, expected)
    doAssert same(a, beforeA) and same(b, beforeB)
    doAssert same(ac.toPolygon.v, oracleHull(a))
    doAssert same(bc.toPolygon.v, oracleHull(b))
    if a.len > 0 and b.len > 0:
        let shift = b[0]
        var translated, shiftedExpected: seq[Point[T]]
        for p in a: translated.add(p + shift)
        for p in expected: shiftedExpected.add(p + shift)
        doAssert same(minkowski_sum(translated, b).toPolygon.v, shiftedExpected)
    var copied = actual.toPolygon
    if copied.len > 0:
        copied.v[0] = copied.v[0] + copied.v[0]
    doAssert same(actual.toSeq, expected)
proc decorated[T](a: seq[Point[T]], offset: int, reverse: bool): seq[Point[T]] =
    var v = copy(a)
    if reverse: v.reverse()
    for i in 0..<v.len:
        let p = v[(offset+i) mod v.len]
        result.add(p)
        result.add(p)
    if result.len > 0: result.add(result[0])
proc variants[T](a, b: seq[Point[T]]) =
    for ra in [false, true]:
        for rb in [false, true]:
            for i in 0..<max(1, a.len):
                for j in 0..<max(1, b.len):
                    check(decorated(a, i, ra), decorated(b, j, rb))
proc converted[T](a: seq[Point[int]], scalar: proc(x: int): T): seq[Point[T]] =
    for p in a: result.add(initPoint(scalar(p.x), scalar(p.y)))
proc allTypes(a, b: seq[Point[int]]) =
    check(a, b)
    check(converted(a, proc(x: int): int32 = int32(x)), converted(b, proc(x: int): int32 = int32(x)))
    check(converted(a, proc(x: int): int64 = int64(x)), converted(b, proc(x: int): int64 = int64(x)))
    check(converted(a, proc(x: int): float32 = float32(x)/2), converted(b, proc(x: int): float32 = float32(x)/2))
    check(converted(a, proc(x: int): float64 = float64(x)/2), converted(b, proc(x: int): float64 = float64(x)/2))
    check(converted(a, proc(x: int): Fraction[int] = initFraction(x, 3)), converted(b, proc(x: int): Fraction[int] = initFraction(x, 2)))

var grid: seq[Point[int]]
for x in 0..2:
    for y in 0..1: grid.add(initPoint(2*x, 2*y))
var hulls: seq[seq[Point[int]]]
for mask in 0..<(1 shl grid.len):
    var points: seq[Point[int]]
    for i in 0..<grid.len:
        if (mask and (1 shl i)) != 0: points.add(grid[i])
    hulls.add(oracleHull(points))
for a in hulls:
    for b in hulls: check(a, b)
for i in 0..<hulls.len: allTypes(hulls[i], hulls[hulls.high-i])

let empty: seq[Point[int]] = @[]
let point = @[initPoint(-3, 7)]
let horizontal = @[initPoint(-4, 2), initPoint(6, 2)]
let vertical = @[initPoint(1, -5), initPoint(1, 8)]
let slanted = @[initPoint(-2, -3), initPoint(4, 6)]
let opposite = @[initPoint(4, 6), initPoint(-2, -3)]
let square = @[initPoint(0, 0), initPoint(4, 0), initPoint(4, 4), initPoint(0, 4)]
let weak = @[initPoint(0, 0), initPoint(2, 0), initPoint(4, 0), initPoint(4, 2),
    initPoint(4, 4), initPoint(2, 4), initPoint(0, 4), initPoint(0, 2)]
let triangle = @[initPoint(-2, -2), initPoint(6, 2), initPoint(0, 8)]
for a in [empty, point, horizontal, vertical, slanted, opposite, square, weak, triangle]:
    for b in [empty, point, horizontal, vertical, slanted, opposite, square, weak, triangle]:
        allTypes(a, b)
        variants(a, b)
variants(@[initPoint(3, 3), initPoint(-2, -2), initPoint(1, 1), initPoint(3, 3)], square)
variants(@[initPoint(2, 2), initPoint(2, 2), initPoint(2, 2)], horizontal)

var rng = initRand(8249071)
for trial in 0..<400:
    var a, b: seq[Point[int]]
    for i in 0..<rng.rand(0..24): a.add(initPoint(rng.rand(-20..20)*2, rng.rand(-20..20)*2))
    for i in 0..<rng.rand(0..24): b.add(initPoint(rng.rand(-20..20)*2, rng.rand(-20..20)*2))
    a = oracleHull(a)
    b = oracleHull(b)
    allTypes(a, b)
    check(decorated(a, trial, (trial and 1) != 0), decorated(b, trial+1, (trial and 2) != 0))

block:
    let a = converted(square, proc(x: int): Fraction[int32] = initFraction(int32(x), 2'i32))
    let b = converted(slanted, proc(x: int): Fraction[int32] = initFraction(int32(x)))
    check(a, b)
    check(converted(square, proc(x: int): Fraction[int64] = initFraction(int64(x), 3'i64)),
        converted(triangle, proc(x: int): Fraction[int64] = initFraction(int64(x), 2'i64)))
block:
    let tiny = 1.0 / float64(1'i64 shl 40)
    variants(@[initPoint(0.0, 0.0), initPoint(tiny, 0.0), initPoint(tiny, tiny), initPoint(0.0, tiny)],
        @[initPoint(0.0, 0.0), initPoint(2*tiny, tiny)])
    variants(@[initPoint(0.0, 0.0), initPoint(2.0, 0.0), initPoint(2.0, tiny), initPoint(0.0, tiny)],
        @[initPoint(0.0, 0.0), initPoint(2.0, tiny), initPoint(0.0, 2.0)])
    let saved = GEOMETRY_EPS
    GEOMETRY_EPS = 100.0
    check(converted(square, proc(x: int): float = float(x)), converted(triangle, proc(x: int): float = float(x)))
    GEOMETRY_EPS = saved
block:
    var many, expected: seq[Point[int64]]
    for x in -6000'i64..6000'i64:
        many.add(initPoint(x, x*x))
        expected.add(initPoint(2*x, 2*x*x))
    let cp = initConvexPolygon(many)
    doAssert cp.len == many.len
    doAssert same(minkowski_sum(cp, cp).toPolygon.v, expected)
    many[0] = initPoint(-99999'i64, -99999'i64)
    doAssert same(minkowski_sum(cp, cp).toPolygon.v, expected)
block:
    var boundary: seq[Point[int]]
    for x in 0..20000: boundary.add(initPoint(x, 0))
    for x in countdown(20000, 0): boundary.add(initPoint(x, 1))
    doAssert same(minkowski_sum(boundary, boundary).toPolygon.v,
        @[initPoint(0, 0), initPoint(40000, 0), initPoint(40000, 2), initPoint(0, 2)])

static:
    doAssert not compiles(minkowski_sum(@[initPoint(0'u, 0'u)], @[initPoint(1'u, 1'u)]))
    doAssert not compiles(minkowski_sum(@[initPoint(0, 0)], @[initPoint(1.0, 1.0)]))
echo "Hello World"
