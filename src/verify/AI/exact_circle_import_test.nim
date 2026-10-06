# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/geometry/base
import cplib/geometry/exact_circle
import cplib/geometry/minimum_enclosing_circle_exact
let c = initExactCircle(initPoint(0, 0), 1)
let d = initExactCircle(initPoint(2, 0), 1)
doAssert c.contains(initPoint(0, 0))
doAssert c.on_circle(initPoint(1, 0))
doAssert c.classify(initPoint(2, 0)) == circleOutside
doAssert intersection_count(c, d) == 1
doAssert common_tangent_count(c, d) == 3
doAssert intersection_count(c, Line[int](s: initPoint(-2, 0), t: initPoint(2, 0))) == 2
doAssert intersection_count(c, Segment[int](s: initPoint(-1, 0), t: initPoint(0, 0))) == 1
doAssert cross_points_approx(c, d).points.len == 1
doAssert tangent_lines_approx(c, initPoint(2, 0)).tangents.len == 2
doAssert c.center_approx.x == 0 and c.radius_approx == 1
let mec = minimum_enclosing_circle_exact(@[initPoint(0, 0), initPoint(1, 0)])
doAssert mec.contains(initPoint(0, 0)) and mec.contains(initPoint(1, 0))
doAssert mec.center_approx.x == 0.5 and mec.radius_approx == 0.5
static:
    doAssert typeof(c) is ExactCircle[int]
    doAssert typeof(c.radius_squared_exact.num) is int
    doAssert typeof(c.center_exact.x.num) is int
    doAssert typeof(c.points[0].x) is int
    doAssert typeof(mec) is ExactCircle[int]
    doAssert typeof(mec.point_scale) is int
    doAssert not declared(CPLIB_MATH_BIGINT)
    doAssert not declared(CPLIB_MATH_INT128)
echo "Hello World"
