# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import math, strutils, random
import cplib/geometry/base
import cplib/geometry/circle
import cplib/math/bigint
import cplib/math/int128
import cplib/math/fractions

proc bi(x: int): BigInt = initBigInt(x)
proc rat(n, d: int): Fraction[BigInt] = initFraction(bi(n), bi(d))
proc close(a, b: float): bool = abs(a - b) <= 2e-8 * max(1.0, max(abs(a), abs(b)))
template rejects(body: untyped) =
    block:
        var rejected = false
        try: body
        except ValueError: rejected = true
        doAssert rejected

proc checkType[T](zero, one, two, minusOne: T) =
    let o = initPoint(zero, zero)
    let a = initPoint(one, zero)
    let b = initPoint(zero, one)
    let c = initPoint(minusOne, zero)
    let circle = initCircle(a, b, c)
    static:
        doAssert typeof(circle) is Circle[T]
        doAssert typeof(initCircle(o, 1)) is Circle[T]
        doAssert typeof(initCircle(o, a)) is Circle[T]
        doAssert typeof(initDiameterCircle(o, a)) is Circle[T]
        when T is Fraction:
            doAssert typeof(circle.radius_squared_exact.num) is typeof(zero.num)
        else:
            doAssert typeof(circle.radius_squared_exact) is Fraction[T]
    doAssert circle.points == [a, b, c]
    doAssert $toExactPoint(initPoint(circle.point_scale, circle.point_scale)).x == "1/1"
    let diameter = initDiameterCircle(o, a)
    doAssert $diameter.radius_squared_exact == "1/4"
    doAssert $diameter.center_exact.x == "1/2"
    doAssert $toExactPoint(initPoint(diameter.point_scale, diameter.point_scale)).x == "2/1"
    for p in diameter.points_exact: doAssert diameter.on_circle(p)
    doAssert circle == initCircle(c, b, a)
    doAssert circle == initCircle(b, c, a)
    doAssert circle == initCircle(o, 1)
    doAssert circle == initCircle(o, a)
    doAssert ($circle.center_exact.x == "0/1" and $circle.center_exact.y == "0/1")
    doAssert $circle.radius_squared_exact == "1/1"
    doAssert circle.contains(o) and circle.classify(o) == circleInside
    doAssert circle.on_circle(a) and circle.classify(a) == circleBoundary
    doAssert not circle.contains(initPoint(two, zero))
    doAssert circle.classify(initPoint(two, zero)) == circleOutside
    doAssert close(circle.center_approx.x, 0) and close(circle.radius_approx, 1)
    doAssert close(circle.toFloatCircle.radius, 1)
    let z = initCircle(o, o, o)
    doAssert z == initCircle(o, 0) and z == initCircle(o, o)
    doAssert z.on_circle(o) and z.classify(o) == circleBoundary
    doAssert not z.contains(a) and z.classify(a) == circleOutside
    doAssert $z.radius_squared_exact == "0/1"
    doAssert z.radius_approx == 0
    doAssert intersection_count(z, z) == 1
    doAssert intersection_count(circle, circle) == -1
    doAssert common_tangent_count(circle, circle) == -1
    doAssert tangent_count(z, o) == -1
    doAssert tangent_count(z, a) == 1
    doAssert tangent_count(circle, o) == 0
    doAssert tangent_count(circle, a) == 1
    doAssert tangent_count(circle, initPoint(two, zero)) == 2
    rejects: discard initCircle(a, a, b)
    rejects: discard initCircle(a, o, c)
    rejects: discard initCircle(o, -1)
    rejects: discard default(Circle[T]).contains(o)
    let line = Line[T](s: a, t: c)
    doAssert intersection_count(circle, line) == 2
    doAssert intersection_count(circle, Line[T](s: b, t: initPoint(one, one))) == 1
    doAssert intersection_count(circle, Line[T](s: initPoint(zero, two), t: initPoint(one, two))) == 0
    doAssert intersection_count(circle, Segment[T](s: a, t: o)) == 1
    doAssert intersection_count(circle, Segment[T](s: a, t: a)) == 1
    doAssert intersection_count(circle, Segment[T](s: o, t: o)) == 0
    doAssert intersection_count(circle, Segment[T](s: c, t: a)) == 2
    rejects: discard intersection_count(circle, Line[T](s: a, t: a))
    for segment in [Segment[T](s: a, t: o), Segment[T](s: c, t: a), Segment[T](s: a, t: a), Segment[T](s: o, t: o)]:
        doAssert cross_points_approx(circle, segment).points.len == intersection_count(circle, segment)
    let intersections = cross_points_approx(circle, line)
    doAssert intersections.points.len == 2
    for p in intersections.points:
        doAssert close(hypot(p.x, p.y), 1)
    doAssert cross_points_approx(circle, circle).kind == circleInfinite
    doAssert cross_points_approx(z, z).points.len == 1
    doAssert tangent_lines_approx(z, o).kind == circleInfinite
    doAssert tangent_lines_approx(z, a).tangents.len == 1
    for p in [a, initPoint(two, zero)]:
        let tangents = tangent_lines_approx(circle, p)
        doAssert tangents.tangents.len == tangent_count(circle, p)
        for tangent in tangents.tangents:
            doAssert close(hypot(tangent.first.x, tangent.first.y), 1)
            doAssert close(hypot(tangent.direction.x, tangent.direction.y), 1)
            doAssert close(dot(tangent.first, tangent.direction), 0)
            doAssert close(cross(tangent.second - tangent.first, tangent.direction), 0)

checkType(0, 1, 2, -1)
checkType(0'i64, 1'i64, 2'i64, -1'i64)
checkType(bi(0), bi(1), bi(2), bi(-1))
checkType(parseInt128("0"), parseInt128("1"), parseInt128("2"), parseInt128("-1"))
checkType(initFraction(0), initFraction(1), initFraction(2), initFraction(-1))
checkType(initFraction(parseInt128("0")), initFraction(parseInt128("1")), initFraction(parseInt128("2")), initFraction(parseInt128("-1")))
checkType(rat(0, 1), rat(1, 1), rat(2, 1), rat(-1, 1))

let translated = initCircle(initPoint(1000000, 1000000), initPoint(1000002, 1000000), initPoint(1000001, 1000001))
doAssert translated.center_exact == initPoint(initFraction(1000001), initFraction(1000000))
doAssert translated.classify(initPoint(1000001, 1000000)) == circleInside
let generated = initCircle(initPoint(1000000, 1000000), 1000)
static: doAssert typeof(generated) is Circle[int]
doAssert generated.points[0].x == 1001000
doAssert $generated.radius_squared_exact == "1000000/1"
let denominator = initCircle(initPoint(Fraction[int](num: 1, den: -2), Fraction[int](num: -1, den: -3)), 2)
doAssert $denominator.center_exact.x == "-1/2" and $denominator.center_exact.y == "1/3"
for invalid in [Fraction[int](num: 1, den: 0), Fraction[int](num: 0, den: 0)]:
    rejects: discard initCircle(initPoint(invalid, invalid), 0)
let fractionRadius = initCircle(initPoint(initFraction(0), initFraction(0)), initFraction(1, 2))
doAssert $fractionRadius.radius_squared_exact == "1/4"
rejects: discard initCircle(initPoint(0, 0), initFraction(1, 2))
let unit = initCircle(initPoint(0, 0), 1)
for pair in [(3, 1, 0, 4), (2, 1, 1, 3), (1, 1, 2, 2), (1, 2, 1, 1), (0, 2, 0, 0)]:
    let other = initCircle(initPoint(pair[0], 0), pair[1])
    doAssert intersection_count(unit, other) == pair[2]
    doAssert common_tangent_count(unit, other) == pair[3]
    for circles in [(unit, other), (other, unit)]:
        let tangents = common_tangents(circles[0], circles[1])
        doAssert tangents.tangents.len == pair[3]
        for tangent in tangents.tangents:
            let first = tangent.first - circles[0].center_approx
            let second = tangent.second - circles[1].center_approx
            doAssert close(hypot(first.x, first.y), circles[0].radius)
            doAssert close(hypot(second.x, second.y), circles[1].radius)
            doAssert close(dot(first, tangent.direction), 0)
            doAssert close(dot(second, tangent.direction), 0)
            doAssert close(cross(tangent.second - tangent.first, tangent.direction), 0)
    doAssert intersection_count(other, unit) == pair[2]
    doAssert cross_points_approx(unit, other).points.len == pair[2]
let giant = parseBigInt("1" & repeat('0', 1000))
let bigCircle = initCircle(initPoint(giant, -giant), 1)
static: doAssert typeof(bigCircle) is Circle[BigInt]
doAssert bigCircle.center_exact.x == initFraction(giant)
doAssert bigCircle.on_circle(initPoint(giant + bi(1), -giant))
doAssert not bigCircle.contains(initPoint(giant + bi(2), -giant))
rejects: discard bigCircle.center_approx
let giantDisjointSegment = Segment[BigInt](s: initPoint(giant + bi(2), -giant), t: initPoint(giant + bi(3), -giant))
doAssert cross_points(bigCircle, giantDisjointSegment).points.len == 0
let giantOuter = initCircle(initPoint(giant, -giant), 3)
let giantInner = initCircle(initPoint(giant + bi(1), -giant), 1)
doAssert common_tangents(giantOuter, giantInner).tangents.len == 0

let small = initFraction(bi(1), giant)
let tiny = initCircle(initPoint(rat(0, 1), rat(0, 1)), initPoint(small, rat(0, 1)))
doAssert tiny.radius_squared_exact == small * small
rejects: discard tiny.radius_approx
let subnormal = initCircle(initPoint(rat(0, 1), rat(0, 1)), initPoint(initFraction(bi(5), parseBigInt("1" & repeat('0', 324))), rat(0, 1)))
doAssert subnormal.radius_approx > 0 and subnormal.radius_approx < 1e-308
let largeDen = initFraction(giant + bi(1), giant)
let ratio = initCircle(initPoint(largeDen, largeDen), 1)
doAssert close(ratio.center_approx.x, 1)
let far = initCircle(initPoint(bi(0), bi(0)), initPoint(giant, bi(0)), initPoint(bi(0), giant))
doAssert far.on_circle(initPoint(giant, giant))
doAssert far.contains(initPoint(giant div bi(2), giant div bi(2)))
let giantRadius = initCircle(initPoint(bi(0), bi(0)), giant)
doAssert giantRadius.radius_squared_exact.num == giant * giant
doAssert giantRadius.on_circle(initPoint(giant, bi(0)))
rejects: discard giantRadius.radius_approx
let epsilon = initFraction(bi(1), parseBigInt("1" & repeat('0', 100)))
let bigUnit = initCircle(initPoint(rat(0, 1), rat(0, 1)), 1)
let nearBoundary = initPoint(rat(1, 1) + epsilon, rat(0, 1))
doAssert bigUnit.classify(nearBoundary) == circleOutside
doAssert tangent_lines_approx(bigUnit, nearBoundary).tangents.len == 2
let nearLine = Line[Fraction[BigInt]](s: initPoint(rat(-2, 1), rat(1, 1) - epsilon), t: initPoint(rat(2, 1), rat(1, 1) - epsilon))
doAssert intersection_count(bigUnit, nearLine) == 2
doAssert cross_points_approx(bigUnit, nearLine).points.len == 2
let nearCircle = initCircle(initPoint(rat(2, 1) - epsilon, rat(0, 1)), 1)
doAssert intersection_count(bigUnit, nearCircle) == 2
doAssert cross_points_approx(bigUnit, nearCircle).points.len == 2
doAssert common_tangents(bigUnit, nearCircle).tangents.len == common_tangent_count(bigUnit, nearCircle)
let savedEPS = GEOMETRY_EPS
GEOMETRY_EPS = 100
for p in [nearBoundary, initPoint(rat(1, 1), rat(0, 1))]:
    doAssert bigUnit.on_circle(p) == (p == initPoint(rat(1, 1), rat(0, 1)))
GEOMETRY_EPS = savedEPS
let wide = parseInt128("1000000000000000000000000000000")
let wideCircle = initCircle(initPoint(wide, wide), parseInt128("1"))
static: doAssert typeof(wideCircle) is Circle[Int128]
doAssert wideCircle.on_circle(initPoint(wide + parseInt128("1"), wide))
doAssert $wideCircle.radius_squared_exact == "1/1"
static:
    doAssert typeof(initCircle(initPoint(0.0, 0.0), 1)) is Circle[float]
    doAssert typeof(initCircle(initPoint(0, 0), 1.0)) is Circle[float]
var tangentRng = initRand(85791)
for trial in 0..<1000:
    let x = tangentRng.rand(-20..20)
    let y = tangentRng.rand(-20..20)
    let ra = tangentRng.rand(0..10)
    let rb = tangentRng.rand(0..10)
    let a = initCircle(initPoint(0, 0), ra)
    let b = initCircle(initPoint(x, y), rb)
    let dsq = x * x + y * y
    if dsq == 0:
        doAssert common_tangents(a, b).kind == (if ra == rb: circleInfinite else: circleFinite)
        continue
    let sumsq = (ra + rb) * (ra + rb)
    let diffsq = (ra - rb) * (ra - rb)
    var expected = 0
    if ra == 0 and rb == 0: expected = 1
    elif ra == 0 or rb == 0:
        expected = if dsq == sumsq: 1 elif dsq > sumsq: 2 else: 0
    else:
        if dsq == diffsq: expected = 1
        elif dsq > diffsq: expected = 2
        if dsq == sumsq: inc expected
        elif dsq > sumsq: expected += 2
    let forward = common_tangents(a, b)
    let backward = common_tangents(b, a)
    doAssert forward.tangents.len == expected and backward.tangents.len == expected
    for tangent in forward.tangents:
        let first = tangent.first
        let second = tangent.second - initPoint(float(x), float(y))
        doAssert close(hypot(first.x, first.y), float(ra))
        doAssert close(hypot(second.x, second.y), float(rb))
        doAssert close(dot(first, tangent.direction), 0)
        doAssert close(dot(second, tangent.direction), 0)
        doAssert close(cross(tangent.second - tangent.first, tangent.direction), 0)
        var found = false
        for reverse in backward.tangents:
            if close(reverse.first.x, tangent.second.x) and close(reverse.first.y, tangent.second.y) and
                    close(reverse.second.x, tangent.first.x) and close(reverse.second.y, tangent.first.y): found = true
        doAssert found
echo "Hello World"
