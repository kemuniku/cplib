# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import math, strutils
import cplib/geometry/base
import cplib/geometry/circle
import cplib/geometry/exact_circle
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
    let circle = initExactCircle(a, b, c)
    static:
        doAssert typeof(circle) is ExactCircle[T]
        doAssert typeof(initExactCircle(o, 1)) is ExactCircle[T]
        doAssert typeof(initExactCircle(o, a)) is ExactCircle[T]
        doAssert typeof(initExactDiameterCircle(o, a)) is ExactCircle[T]
        when T is Fraction:
            doAssert typeof(circle.radius_squared_exact.num) is typeof(zero.num)
        else:
            doAssert typeof(circle.radius_squared_exact) is Fraction[T]
    doAssert circle.points == [a, b, c]
    doAssert $toExactPoint(initPoint(circle.point_scale, circle.point_scale)).x == "1/1"
    let diameter = initExactDiameterCircle(o, a)
    doAssert $diameter.radius_squared_exact == "1/4"
    doAssert $diameter.center_exact.x == "1/2"
    doAssert $toExactPoint(initPoint(diameter.point_scale, diameter.point_scale)).x == "2/1"
    for p in diameter.points_exact: doAssert diameter.on_circle(p)
    doAssert circle == initExactCircle(c, b, a)
    doAssert circle == initExactCircle(b, c, a)
    doAssert circle == initExactCircle(o, 1)
    doAssert circle == initExactCircle(o, a)
    doAssert ($circle.center_exact.x == "0/1" and $circle.center_exact.y == "0/1")
    doAssert $circle.radius_squared_exact == "1/1"
    doAssert circle.contains(o) and circle.classify(o) == circleInside
    doAssert circle.on_circle(a) and circle.classify(a) == circleBoundary
    doAssert not circle.contains(initPoint(two, zero))
    doAssert circle.classify(initPoint(two, zero)) == circleOutside
    doAssert close(circle.center_approx.x, 0) and close(circle.radius_approx, 1)
    doAssert close(circle.toFloatCircle.radius, 1)
    let z = initExactCircle(o, o, o)
    doAssert z == initExactCircle(o, 0) and z == initExactCircle(o, o)
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
    rejects: discard initExactCircle(a, a, b)
    rejects: discard initExactCircle(a, o, c)
    rejects: discard initExactCircle(o, -1)
    rejects: discard default(ExactCircle[T]).contains(o)
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

let translated = initExactCircle(initPoint(1000000, 1000000), initPoint(1000002, 1000000), initPoint(1000001, 1000001))
doAssert translated.center_exact == initPoint(initFraction(1000001), initFraction(1000000))
doAssert translated.classify(initPoint(1000001, 1000000)) == circleInside
let generated = initExactCircle(initPoint(1000000, 1000000), 1000)
static: doAssert typeof(generated) is ExactCircle[int]
doAssert generated.points[0].x == 1001000
doAssert $generated.radius_squared_exact == "1000000/1"
let denominator = initExactCircle(initPoint(Fraction[int](num: 1, den: -2), Fraction[int](num: -1, den: -3)), 2)
doAssert $denominator.center_exact.x == "-1/2" and $denominator.center_exact.y == "1/3"
for invalid in [Fraction[int](num: 1, den: 0), Fraction[int](num: 0, den: 0)]:
    rejects: discard initExactCircle(initPoint(invalid, invalid), 0)
let unit = initExactCircle(initPoint(0, 0), 1)
for pair in [(3, 1, 0, 4), (2, 1, 1, 3), (1, 1, 2, 2), (1, 2, 1, 1), (0, 2, 0, 0)]:
    let other = initExactCircle(initPoint(pair[0], 0), pair[1])
    doAssert intersection_count(unit, other) == pair[2]
    doAssert common_tangent_count(unit, other) == pair[3]
    doAssert intersection_count(other, unit) == pair[2]
    doAssert cross_points_approx(unit, other).points.len == pair[2]
let giant = parseBigInt("1" & repeat('0', 1000))
let bigCircle = initExactCircle(initPoint(giant, -giant), 1)
static: doAssert typeof(bigCircle) is ExactCircle[BigInt]
doAssert bigCircle.center_exact.x == initFraction(giant)
doAssert bigCircle.on_circle(initPoint(giant + bi(1), -giant))
doAssert not bigCircle.contains(initPoint(giant + bi(2), -giant))
rejects: discard bigCircle.center_approx
let small = initFraction(bi(1), giant)
let tiny = initExactCircle(initPoint(rat(0, 1), rat(0, 1)), initPoint(small, rat(0, 1)))
doAssert tiny.radius_squared_exact == small * small
rejects: discard tiny.radius_approx
let subnormal = initExactCircle(initPoint(rat(0, 1), rat(0, 1)), initPoint(initFraction(bi(5), parseBigInt("1" & repeat('0', 324))), rat(0, 1)))
doAssert subnormal.radius_approx > 0 and subnormal.radius_approx < 1e-308
let largeDen = initFraction(giant + bi(1), giant)
let ratio = initExactCircle(initPoint(largeDen, largeDen), 1)
doAssert close(ratio.center_approx.x, 1)
let far = initExactCircle(initPoint(bi(0), bi(0)), initPoint(giant, bi(0)), initPoint(bi(0), giant))
doAssert far.on_circle(initPoint(giant, giant))
doAssert far.contains(initPoint(giant div bi(2), giant div bi(2)))
let giantRadius = initExactCircle(initPoint(bi(0), bi(0)), giant)
doAssert giantRadius.radius_squared_exact.num == giant * giant
doAssert giantRadius.on_circle(initPoint(giant, bi(0)))
rejects: discard giantRadius.radius_approx
let epsilon = initFraction(bi(1), parseBigInt("1" & repeat('0', 100)))
let bigUnit = initExactCircle(initPoint(rat(0, 1), rat(0, 1)), 1)
let nearBoundary = initPoint(rat(1, 1) + epsilon, rat(0, 1))
doAssert bigUnit.classify(nearBoundary) == circleOutside
doAssert tangent_lines_approx(bigUnit, nearBoundary).tangents.len == 2
let nearLine = Line[Fraction[BigInt]](s: initPoint(rat(-2, 1), rat(1, 1) - epsilon), t: initPoint(rat(2, 1), rat(1, 1) - epsilon))
doAssert intersection_count(bigUnit, nearLine) == 2
doAssert cross_points_approx(bigUnit, nearLine).points.len == 2
let nearCircle = initExactCircle(initPoint(rat(2, 1) - epsilon, rat(0, 1)), 1)
doAssert intersection_count(bigUnit, nearCircle) == 2
doAssert cross_points_approx(bigUnit, nearCircle).points.len == 2
let savedEPS = GEOMETRY_EPS
GEOMETRY_EPS = 100
for p in [nearBoundary, initPoint(rat(1, 1), rat(0, 1))]:
    doAssert bigUnit.on_circle(p) == (p == initPoint(rat(1, 1), rat(0, 1)))
GEOMETRY_EPS = savedEPS
let wide = parseInt128("1000000000000000000000000000000")
let wideCircle = initExactCircle(initPoint(wide, wide), parseInt128("1"))
static: doAssert typeof(wideCircle) is ExactCircle[Int128]
doAssert wideCircle.on_circle(initPoint(wide + parseInt128("1"), wide))
doAssert $wideCircle.radius_squared_exact == "1/1"
static:
    doAssert not compiles(initExactCircle(initPoint(0.0, 0.0), 1))
    doAssert not compiles(initExactCircle(initPoint(0, 0), 1.0))
echo "Hello World"
