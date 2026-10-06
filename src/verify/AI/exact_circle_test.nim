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
    doAssert circle.points == [a, b, c]
    doAssert circle == initExactCircle(c, b, a)
    doAssert circle == initExactCircle(b, c, a)
    doAssert circle == initExactCircle(o, 1)
    doAssert circle == initExactCircle(o, a)
    doAssert circle.center_exact == initPoint(rat(0, 1), rat(0, 1))
    doAssert circle.radius_squared_exact == rat(1, 1)
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
    doAssert z.radius_squared_exact == rat(0, 1)
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

let huge = high(int64)
let hugePoint = initPoint(huge, huge)
let generated = initExactCircle(hugePoint, huge)
static: doAssert typeof(generated) is ExactCircle[BigInt]
doAssert generated.center_exact.x == initFraction(initBigInt(huge))
doAssert generated.points[0].x == initBigInt(huge) * bi(2)
doAssert generated.contains(initPoint(low(int64), huge)) == false
doAssert generated.on_circle(initPoint(huge, 0'i64))
let through = initExactCircle(initPoint(low(int64), huge), hugePoint)
doAssert through.on_circle(hugePoint)
doAssert through.radius_squared_exact == initFraction((initBigInt(huge) - initBigInt(low(int64))).pow(2))
let extreme = initExactCircle(initPoint(low(int64), low(int64)), initPoint(huge, low(int64)), hugePoint)
doAssert extreme.on_circle(initPoint(low(int64), huge))
doAssert extreme.contains(initPoint(0'i64, 0'i64))
let unsigned = initExactCircle(initPoint(0'u64, 0'u64), initPoint(high(uint64), 0'u64), initPoint(0'u64, high(uint64)))
doAssert unsigned.on_circle(initPoint(high(uint64), high(uint64)))
let tinyTranslated = initExactCircle(initPoint(huge, huge), initPoint(huge - 2, huge), initPoint(huge - 1, huge - 1))
doAssert tinyTranslated.radius_squared_exact == rat(1, 1)
doAssert tinyTranslated.classify(initPoint(huge - 1, huge)) == circleInside
doAssert tinyTranslated.classify(initPoint(huge - 1, huge + 0)) == circleInside

let minimumFraction = Fraction[int](num: low(int), den: low(int))
let unnormalized = initExactCircle(initPoint(minimumFraction, minimumFraction), 1)
doAssert unnormalized.center_exact == initPoint(rat(1, 1), rat(1, 1))
let min128 = parseInt128("-170141183460469231731687303715884105728")
let maximum128 = parseInt128("170141183460469231731687303715884105727")
let f128 = initExactCircle(initPoint(Fraction[Int128](num: min128, den: min128), Fraction[Int128](num: maximum128, den: min128)), 1)
doAssert f128.center_exact.x == rat(1, 1)
doAssert f128.on_circle(f128.points[0])
for invalid in [Fraction[int](num: 1, den: 0), Fraction[int](num: 0, den: 0)]:
    rejects: discard initExactCircle(initPoint(invalid, invalid), 0)
let negativeDen = initExactCircle(initPoint(Fraction[int](num: 1, den: -2), Fraction[int](num: -1, den: -3)), 2)
doAssert negativeDen.center_exact == initPoint(rat(-1, 2), rat(1, 3))
let rational = initExactCircle(initPoint(initFraction(1, 3), initFraction(2, 7)), initPoint(initFraction(5, 11), initFraction(-3, 13)))
static: doAssert typeof(rational) is ExactCircle[Fraction[BigInt]]
doAssert rational.center_exact == initPoint(rat(1, 3), rat(2, 7))
for p in rational.points: doAssert rational.on_circle(p)

let unit = initExactCircle(initPoint(0, 0), 1)
for pair in [(3, 1, 0, 4), (2, 1, 1, 3), (1, 1, 2, 2), (1, 2, 1, 1), (0, 2, 0, 0)]:
    let other = initExactCircle(initPoint(pair[0], 0), pair[1])
    doAssert intersection_count(unit, other) == pair[2]
    doAssert common_tangent_count(unit, other) == pair[3]
    doAssert intersection_count(other, unit) == pair[2]
    let result = cross_points_approx(unit, other)
    doAssert result.points.len == pair[2]
    for p in result.points:
        doAssert close(hypot(p.x, p.y), 1)
        doAssert close(hypot(p.x - float(pair[0]), p.y), float(pair[1]))

let epsilon = initFraction(bi(1), parseBigInt("1" & repeat('0', 100)))
let nearBoundary = initPoint(rat(1, 1) + epsilon, rat(0, 1))
doAssert unit.classify(nearBoundary) == circleOutside
let nearTangents = tangent_lines_approx(unit, nearBoundary)
doAssert nearTangents.tangents.len == 2
let nearLine = Line[Fraction[BigInt]](s: initPoint(rat(-2, 1), rat(1, 1) - epsilon), t: initPoint(rat(2, 1), rat(1, 1) - epsilon))
doAssert intersection_count(unit, nearLine) == 2
doAssert cross_points_approx(unit, nearLine).points.len == 2
let nearCircle = initExactCircle(initPoint(rat(2, 1) - epsilon, rat(0, 1)), 1)
doAssert intersection_count(unit, nearCircle) == 2
doAssert cross_points_approx(unit, nearCircle).points.len == 2
let savedEPS = GEOMETRY_EPS
GEOMETRY_EPS = 100
for p in [nearBoundary, initPoint(rat(1, 1), rat(0, 1))]:
    doAssert unit.on_circle(p) == (p == initPoint(rat(1, 1), rat(0, 1)))
GEOMETRY_EPS = savedEPS
static:
    doAssert not compiles(initExactCircle(initPoint(0.0, 0.0), 1))
    doAssert not compiles(initExactCircle(initPoint(0, 0), 1.0))

let giant = parseBigInt("1" & repeat('0', 1000))
let bigCenter = initPoint(giant, -giant)
let bigCircle = initExactCircle(bigCenter, 1)
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

echo "Hello World"
