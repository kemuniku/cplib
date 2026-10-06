# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import math, random
import cplib/geometry/base
import cplib/geometry/circle
import cplib/geometry/apollonius

proc close(a, b: float, tolerance = 3e-11): bool =
    abs(a - b) <= tolerance * max(1.0, max(abs(a), abs(b)))
proc same(a, b: Point[float]): bool = close(a.x, b.x) and close(a.y, b.y)
proc checkOracle(ax, ay, bx, by, n, d: int) =
    let a = initPoint(ax, ay)
    let b = initPoint(bx, by)
    let r = float(n) / float(d)
    let locus = apollonius_locus(a, b, r)
    let aa = d*d - n*n
    let xx = -2*d*d*ax + 2*n*n*bx
    let yy = -2*d*d*ay + 2*n*n*by
    let cc = d*d*(ax*ax + ay*ay) - n*n*(bx*bx + by*by)
    if aa == 0 and xx == 0 and yy == 0:
        doAssert locus.kind == apolloniusPlane
    elif aa == 0:
        doAssert locus.kind == apolloniusLine
        let p = locus.linePoint
        let v = locus.lineDirection
        doAssert close(float(xx)*p.x + float(yy)*p.y + float(cc), 0)
        doAssert close(float(xx)*v.x + float(yy)*v.y, 0)
        doAssert close(hypot(v.x, v.y), 1)
        for t in [-10.0, 0.0, 10.0]:
            let q = p + v*t
            doAssert close(hypot(q.x-float(ax), q.y-float(ay)), hypot(q.x-float(bx), q.y-float(by)))
    else:
        doAssert locus.kind == apolloniusCircle
        let c = locus.circle.center
        let radius = locus.circle.radius
        doAssert close(2*float(aa)*c.x, -float(xx))
        doAssert close(2*float(aa)*c.y, -float(yy))
        doAssert close(float(aa)*(c.x*c.x+c.y*c.y-radius*radius), float(cc), 3e-9)
        for theta in [0.0, 0.3, 1.7, 3.1, 4.9]:
            let p = c + initPoint(cos(theta), sin(theta))*radius
            doAssert close(hypot(p.x-float(ax), p.y-float(ay)), r*hypot(p.x-float(bx), p.y-float(by)), 3e-9)
    for px in -3..3:
        for py in -3..3:
            let expected = aa*(px*px+py*py)+xx*px+yy*py+cc == 0
            var actual: bool
            case locus.kind
            of apolloniusPlane: actual = true
            of apolloniusLine:
                actual = abs(cross(initPoint(float(px), float(py))-locus.linePoint, locus.lineDirection)) < 1e-8
            of apolloniusCircle:
                actual = abs(hypot(float(px)-locus.circle.center.x, float(py)-locus.circle.center.y)-locus.circle.radius) < 1e-8
            doAssert actual == expected
    if n > 0:
        let swapped = apollonius_locus(b, a, float(d)/float(n))
        doAssert swapped.kind == locus.kind
        if locus.kind == apolloniusCircle:
            doAssert same(swapped.circle.center, locus.circle.center)
            doAssert close(swapped.circle.radius, locus.circle.radius)

for ax in -2..2:
    for ay in -2..2:
        for bx in -2..2:
            for by in -2..2:
                for nd in [(0, 1), (1, 1), (1, 2), (2, 1), (2, 3), (3, 2)]:
                    checkOracle(ax, ay, bx, by, nd[0], nd[1])
var rng = initRand(350946)
for _ in 0..<2500:
    checkOracle(rng.rand(-20..20), rng.rand(-20..20), rng.rand(-20..20), rng.rand(-20..20), rng.rand(0..20), rng.rand(1..20))

let origin = initPoint(0.0, 0.0)
for r in [0.0, -0.0, 0.5, 2.0, 1e-200, 1e200]:
    let res = apollonius_locus(origin, origin, r)
    doAssert res.kind == apolloniusCircle and res.circle.radius == 0
doAssert apollonius_locus(origin, origin, 1).kind == apolloniusPlane
for s in [1e-200, 1e-150, 1.0, 1e150, 1e300]:
    for r in [0.5, 2.0]:
        let res = apollonius_locus(origin, initPoint(s, 0.0), r)
        doAssert close(res.circle.center.x / s, if r < 1: -1.0/3 else: 4.0/3)
        doAssert close(res.circle.radius / s, 2.0/3)
    let line = apollonius_locus(origin, initPoint(s, s), 1)
    doAssert line.kind == apolloniusLine
    doAssert close(line.linePoint.x / s, 0.5)
    doAssert close(line.lineDirection.x, -sqrt(0.5))
for r in [1.0-1.1102230246251565e-16, 1.0+2.220446049250313e-16, 1.0-1e-12, 1.0+1e-12]:
    let res = apollonius_locus(origin, initPoint(1.0, 0.0), r)
    doAssert res.kind == apolloniusCircle and res.circle.radius > 1e11
    doAssert close(res.circle.radius*abs(1-r)*(1+r), r)
    doAssert close(res.circle.center.x*(1-r)*(1+r), -r*r)
let largeRatio = apollonius_locus(origin, initPoint(1.0, 0.0), 1e308)
doAssert largeRatio.circle.center.x == 1
doAssert close(largeRatio.circle.radius*1e308, 1)
let smallRatio = apollonius_locus(origin, initPoint(1e300, 0.0), 1e-200)
doAssert close(smallRatio.circle.center.x / -1e-100, 1)
doAssert close(smallRatio.circle.radius / 1e100, 1)
let tiny = apollonius_locus(origin, initPoint(1e-200, 0.0), 1)
doAssert tiny.kind == apolloniusLine
let translated = apollonius_locus(initPoint(1e150, 1e150), initPoint(2e150, 1e150), 1)
doAssert translated.kind == apolloniusLine
doAssert translated.lineDirection.x == 0 and translated.lineDirection.y == 1
doAssert close(translated.linePoint.x / 1e150, 1.5)
let subnormalLine = apollonius_locus(initPoint(1e-308, 0.0), initPoint(2e-308, 0.0), 1)
doAssert abs(subnormalLine.linePoint.x / 1e-308 - 1.5) < 1e-14
let savedEps = GEOMETRY_EPS
GEOMETRY_EPS = 10
doAssert apollonius_locus(origin, initPoint(1e-12, 0.0), 1).kind == apolloniusLine
GEOMETRY_EPS = savedEps
let ints = apollonius_locus(initPoint(low(int64), 0'i64), initPoint(high(int64), 0'i64), 0.5)
doAssert ints.circle.radius > 0
let mixed = apollonius_locus(initPoint(0, 0), initPoint(3'f32, 0'f32), 0.5'f32)
doAssert same(mixed.circle.center, initPoint(-1.0, 0.0)) and mixed.circle.radius == 2
for r in [-1.0, system.Inf, -system.Inf, NaN]:
    var rejected = false
    try: discard apollonius_locus(origin, origin, r)
    except ValueError: rejected = true
    doAssert rejected
for p in [initPoint(system.Inf, 0.0), initPoint(0.0, NaN)]:
    for r in [0.0, 1.0, 2.0]:
        var rejected = false
        try: discard apollonius_locus(origin, p, r)
        except ValueError: rejected = true
        doAssert rejected
for item in [(initPoint(-1e308, 0.0), initPoint(1e308, 0.0), 0.5),
             (origin, initPoint(1e308, 0.0), 1.0+2.220446049250313e-16),
             (origin, initPoint(1e-200, 0.0), 1e-200)]:
    var rejected = false
    try: discard apollonius_locus(item[0], item[1], item[2])
    except ValueError: rejected = true
    doAssert rejected
echo "Hello World"
