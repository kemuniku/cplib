# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import math
import cplib/geometry/base
import cplib/geometry/circle
import cplib/geometry/minimum_enclosing_circle
import cplib/math/fractions
import cplib/math/int128
import cplib/math/bigint

let integer = initCircle(initPoint(0, 0), 2)
let floating = initCircle(initPoint(0, 0), 2.0)
let float32Circle = initCircle(initPoint(0'f32, 0'f32), 2'f32)
let mixedPoints = initCircle(initPoint(2, 0), initPoint(0.0, 2.0), initPoint(-2'f32, 0'f32))
let mixedThrough = initCircle(initPoint(0, 0), initPoint(2.0, 0.0))
let fractionMixed = initCircle(initPoint(initFraction(0), initFraction(0)), 2.0)
let int128Mixed = initCircle(initPoint(parseInt128("0"), parseInt128("0")), 2.0)
let bigMixed = initCircle(initPoint(initBigInt(0), initBigInt(0)), 2.0)
static:
    doAssert typeof(integer) is Circle[int]
    doAssert typeof(integer.center) is Point[Fraction[int]]
    doAssert typeof(integer.radius) is float
    doAssert typeof(floating) is Circle[float]
    doAssert typeof(float32Circle) is Circle[float]
    doAssert typeof(mixedPoints) is Circle[float]
    doAssert typeof(mixedThrough) is Circle[float]
    doAssert typeof(fractionMixed) is Circle[float]
    doAssert typeof(int128Mixed) is Circle[float]
    doAssert typeof(bigMixed) is Circle[float]
    doAssert typeof(minimum_enclosing_circle(@[initPoint(0'f32, 0'f32)])) is Circle[float]
    doAssert typeof(minimum_enclosing_circle(@[initPoint(0, 0)])) is Circle[int]
    doAssert not declared(ExactCircle)
    doAssert not declared(MinimumExactCircle)
for c in [floating, float32Circle, mixedPoints, mixedThrough, fractionMixed, int128Mixed, bigMixed]:
    doAssert c == floating
    doAssert c.center.x == 0 and c.radius == 2
    doAssert c.classify(initPoint(0, 0)) == circleInside
    doAssert c.classify(initPoint(2, 0)) == circleBoundary
    doAssert c.classify(initPoint(3, 0)) == circleOutside
    doAssert c.on_circle(initPoint(2, 0))
    doAssert c.intersection_count(Line[int](s: initPoint(-3, 0), t: initPoint(3, 0))) == 2
    doAssert c.intersection_count(Segment[int](s: initPoint(0, 0), t: initPoint(3, 0))) == 1
    doAssert c.tangent_count(initPoint(3, 0)) == 2
    doAssert c.common_tangent_count(initCircle(initPoint(5.0, 0.0), 2)) == 4
    doAssert c.cross_points_approx(Line[int](s: initPoint(-3, 0), t: initPoint(3, 0))).points.len == 2
    doAssert c.tangent_lines_approx(initPoint(3, 0)).tangents.len == 2
let minimum128 = parseInt128("-170141183460469231731687303715884105728")
let minimumMixed = initCircle(initPoint(minimum128, parseInt128("0")), 0.0)
doAssert minimumMixed.center.x < -1.7e38 and minimumMixed.radius == 0
let minimumFraction = Fraction[int](num: low(int), den: 1)
let fractionMinimumMixed = initCircle(initPoint(minimumFraction, initFraction(0)), 0.0)
doAssert fractionMinimumMixed.center.x < -9e18
let negativeDenMixed = initCircle(initPoint(Fraction[int](num: -1, den: -2), Fraction[int](num: 1, den: -2)), 0.0)
doAssert negativeDenMixed.center.x == 0.5 and negativeDenMixed.center.y == -0.5
var annotated: Circle[float] = floating
proc returnAnnotated(): Circle[float] = annotated
doAssert returnAnnotated() == floating
for points in [@[initPoint(2.0, 0.0), initPoint(0.0, 2.0), initPoint(-2.0, 0.0)],
               @[initPoint(-2.0, 0.0), initPoint(0.0, 2.0), initPoint(2.0, 0.0)]]:
    doAssert initCircle(points[0], points[1], points[2]) == floating
let diameter = initDiameterCircle(initPoint(0'f32, 0'f32), initPoint(1'f32, 0'f32))
doAssert diameter.center.x == 0.5 and diameter.radius == 0.5
for points in [@[initPoint(0.0, 0.0), initPoint(1.0, 0.0), initPoint(2.0, 0.0)],
               @[initPoint(0.0, 0.0), initPoint(0.0, 0.0), initPoint(1.0, 0.0)]]:
    var rejected = false
    try: discard initCircle(points[0], points[1], points[2])
    except ValueError: rejected = true
    doAssert rejected
for scale in [1e-150, 1e150]:
    let c = initCircle(initPoint(scale, 0.0), initPoint(0.0, scale), initPoint(-scale, 0.0))
    doAssert abs(c.radius / scale - 1) < 1e-10
let z = initCircle(initPoint(1.0, 2.0), initPoint(1.0, 2.0), initPoint(1.0, 2.0))
doAssert z.radius == 0 and z.center == initPoint(1.0, 2.0)
echo "Hello World"
