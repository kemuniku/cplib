# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/geometry/base
import cplib/geometry/circle
import cplib/geometry/minimum_enclosing_circle
import cplib/math/int128
import cplib/math/fractions

proc check[T](zero, one: T) =
    let o = initPoint(zero, zero)
    let p = initPoint(one, zero)
    let c = initCircle(o, p)
    let d = initDiameterCircle(o, p)
    let m = minimum_enclosing_circle(@[o, p])
    static:
        doAssert typeof(c) is Circle[T]
        doAssert typeof(d) is Circle[T]
        doAssert typeof(m) is Circle[T]
        doAssert typeof(c.points[0].x) is T
        doAssert typeof(d.point_scale) is T
        when T is Fraction:
            doAssert typeof(c.center_exact.x.num) is typeof(zero.num)
            doAssert typeof(c.radius_squared_exact.num) is typeof(zero.num)
        else:
            doAssert typeof(c.center_exact) is Point[Fraction[T]]
            doAssert typeof(c.radius_squared_exact) is Fraction[T]
    doAssert c.contains(o) and c.on_circle(p)
    doAssert intersection_count(c, m) == 1
    doAssert common_tangent_count(c, m) == 1
    doAssert tangent_count(m, p) == 1
    doAssert intersection_count(m, Line[T](s: o, t: p)) == 2
    doAssert intersection_count(m, Segment[T](s: o, t: p)) == 2
    doAssert cross_points_approx(m, c).points.len == 1
    doAssert tangent_lines_approx(c, p).tangents.len == 1
    doAssert c.radius_approx == 1
    doAssert m.radius_approx == 0.5 and m.center_approx.x == 0.5
    for q in m.points_exact: doAssert m.on_circle(q)

check(0, 1)
check(parseInt128("0"), parseInt128("1"))
check(initFraction(0), initFraction(1))
check(initFraction(parseInt128("0")), initFraction(parseInt128("1")))
static:
    doAssert not declared(CPLIB_MATH_BIGINT)
    doAssert not compiles(initCircle(initPoint(0'u64, 0'u64), 1))
echo "Hello World"
