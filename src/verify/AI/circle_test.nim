# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import math, random
import cplib/geometry/base
import cplib/geometry/circle

proc length(p: Point[float]): float = hypot(p.x, p.y)
proc close(a, b: float, scale = 1.0): bool = abs(a - b) <= 2e-8 * scale
proc same(a, b: Point[float], scale = 1.0): bool = length(a - b) <= 2e-8 * scale
proc point(x, y: float): Point[float] = initPoint(x, y)
proc residual(c: Circle, p: Point[float], scale = 1.0) =
    doAssert close(length(p - c.center), c.radius, scale)
proc checkTangents(a, b: Circle, expected: int, scale = 1.0) =
    let res = common_tangents(a, b)
    doAssert res.kind == circleFinite
    doAssert res.tangents.len == expected
    for t in res.tangents:
        residual(a, t.first, scale)
        residual(b, t.second, scale)
        doAssert close(length(t.direction), 1)
        doAssert abs(dot(t.first - a.center, t.direction)) <= 2e-8 * scale
        doAssert abs(dot(t.second - b.center, t.direction)) <= 2e-8 * scale
        doAssert abs(cross(t.second - t.first, t.direction)) <= 2e-8 * scale
    let reverse = common_tangents(b, a)
    doAssert reverse.kind == res.kind and reverse.tangents.len == res.tangents.len
    for t in res.tangents:
        var found = false
        for r in reverse.tangents:
            if same(t.first, r.second, scale) and same(t.second, r.first, scale): found = true
        doAssert found

let unit = initCircle(point(0, 0), 1)
doAssert unit.center.x == 0 and unit.radius == 1
doAssert unit.contains(point(1, 0)) and not unit.contains(point(2, 0))
doAssert initCircle(initPoint(0'i64, 0'i64), 2).radius == 2
for invalid in [-1.0, system.Inf, NaN]:
    var rejected = false
    try: discard initCircle(point(0, 0), invalid)
    except ValueError: rejected = true
    doAssert rejected
for invalid in [-1.0, 1.0, NaN]:
    var rejected = false
    try: discard unit.contains(point(0, 0), invalid)
    except ValueError: rejected = true
    doAssert rejected
let zero = initCircle(point(0, 0), 0)
doAssert cross_points(unit, unit).kind == circleInfinite
doAssert common_tangents(unit, unit).kind == circleInfinite
doAssert common_tangents(zero, zero).kind == circleInfinite
doAssert cross_points(zero, zero).points.len == 1
doAssert cross_points(unit, zero).points.len == 0
doAssert cross_points(unit, initCircle(point(0, 0), 1 + 1e-12)).points.len == 0
doAssert tangent_lines(zero, point(0, 0)).kind == circleInfinite
doAssert tangent_lines(unit, point(0, 0)).tangents.len == 0
doAssert tangent_lines(unit, point(1, 0)).tangents.len == 1
doAssert tangent_lines(unit, point(2, 0)).tangents.len == 2
checkTangents(zero, initCircle(point(2, 0), 0), 1)
checkTangents(unit, initCircle(point(3, 0), 1), 4)
checkTangents(unit, initCircle(point(2, 0), 1), 3)
checkTangents(unit, initCircle(point(1, 0), 1), 2)
checkTangents(initCircle(point(0, 0), 2), initCircle(point(1, 0), 1), 1)
checkTangents(initCircle(point(0, 0), 2), initCircle(point(0.5, 0), 1), 0)
checkTangents(unit, initCircle(point(1, 0), 0), 1)
for scale in [1e-150, 1.0, 1e150]:
    let a = initCircle(point(0, 0), scale)
    let b = initCircle(point(1.2 * scale, 0), scale)
    let res = cross_points(a, b)
    doAssert res.points.len == 2
    for p in res.points:
        residual(a, p, scale)
        residual(b, p, scale)
    checkTangents(a, b, 2, scale)
    let line = Line[float](s: point(-2 * scale, 0), t: point(2 * scale, 0))
    doAssert cross_points(a, line).points.len == 2
    let seg = Segment[float](s: point(-scale, 0), t: point(0, 0))
    doAssert cross_points(a, seg).points.len == 1
    doAssert cross_points(a, Segment[float](s: point(scale, 0), t: point(scale, 0))).points.len == 1
    doAssert cross_points(a, Segment[float](s: point(0, 0), t: point(0, 0))).points.len == 0
    doAssert cross_points(a, Line[float](s: point(-scale, scale), t: point(scale, scale))).points.len == 1
let tinySeparation = cross_points(unit, initCircle(point(1e-200, 0), 1))
doAssert tinySeparation.points.len == 2
for p in tinySeparation.points: residual(unit, p)
let translated = initCircle(point(1e12, -1e12), 100)
for p in cross_points(translated, initCircle(point(1e12 + 120, -1e12), 100)).points:
    residual(translated, p, 1e5)

var rng = initRand(612903)
for _ in 0..<2500:
    let x = rng.rand(-20..20)
    let y = rng.rand(-20..20)
    let ra = rng.rand(0..10)
    let rb = rng.rand(0..10)
    let a = initCircle(point(0, 0), ra)
    let b = initCircle(point(float(x), float(y)), rb)
    let dsq = x * x + y * y
    let sumsq = (ra + rb) * (ra + rb)
    let diffsq = (ra - rb) * (ra - rb)
    let res = cross_points(a, b)
    var expected = 0
    if dsq == 0:
        if ra == rb:
            if ra == 0: expected = 1
            else: doAssert res.kind == circleInfinite
    elif dsq == sumsq or dsq == diffsq: expected = 1
    elif diffsq < dsq and dsq < sumsq: expected = 2
    doAssert res.points.len == expected
    for p in res.points:
        residual(a, p)
        residual(b, p)
    let reverse = cross_points(b, a)
    doAssert reverse.kind == res.kind and reverse.points.len == res.points.len
    for p in res.points:
        var found = false
        for q in reverse.points:
            if same(p, q): found = true
        doAssert found
    if dsq > 0:
        var tangentCount = 0
        if ra == 0 and rb == 0: tangentCount = 1
        elif ra == 0 or rb == 0:
            if dsq == sumsq: tangentCount = 1
            elif dsq > sumsq: tangentCount = 2
        else:
            if dsq == diffsq: tangentCount = 1
            elif dsq > diffsq: tangentCount = 2
            if dsq == sumsq: inc tangentCount
            elif dsq > sumsq: tangentCount += 2
        checkTangents(a, b, tangentCount)
    let line = Line[float](s: point(-30, float(y)), t: point(30, float(y)))
    let lr = cross_points(a, line)
    let lineCount = if y * y == ra * ra: 1 elif y * y < ra * ra: 2 else: 0
    doAssert lr.points.len == lineCount
    for p in lr.points:
        residual(a, p)
        doAssert close(p.y, float(y))
    let sl = Segment[float](s: point(float(x), float(y)), t: point(float(x + 1), float(y)))
    var segmentCount = 0
    for p in lr.points:
        if p.x >= float(x) - 1e-9 and p.x <= float(x + 1) + 1e-9: inc segmentCount
    doAssert cross_points(a, sl).points.len == segmentCount

echo "Hello World"
