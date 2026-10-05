# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import math
import cplib/geometry/base
import cplib/geometry/distance
import cplib/math/fractions

proc checkDivision[T: SomeFloat, S](p: Point[T], scalar: S) =
    let x = T(float(p.x) / float(scalar))
    let y = T(float(p.y) / float(scalar))
    var inplace = p
    inplace /= scalar
    let divided = p / scalar
    static:
        doAssert typeof(divided) is Point[T]
        doAssert typeof(inplace.x) is T
    doAssert inplace.x == x and inplace.y == y
    doAssert divided.x == x and divided.y == y

proc checkFloat[T: SomeFloat]() =
    for value in [-1e10, -3.0, -0.125, -0.0, 0.0, 0.125, 3.0, 1e10]:
        let p = initPoint(T(value), T(value + 2.0))
        for divisor in [-8, -3, -1, 1, 2, 3, 8]:
            checkDivision(p, divisor)
            checkDivision(p, int32(divisor))
            checkDivision(p, int64(divisor))
            checkDivision(p, float32(divisor))
            checkDivision(p, float64(divisor))
        for divisor in [1e-40, 1e40, -1e40, 0.25, -0.25]:
            checkDivision(p, divisor)
    let original = initPoint(T(3), T(-2))
    var scaled = original
    scaled *= 8
    scaled /= 8
    doAssert scaled.x == original.x and scaled.y == original.y

checkFloat[float32]()
checkFloat[float64]()

proc oriented(a, b, p: Point[int]): int =
    (b.x - a.x) * (p.y - a.y) - (b.y - a.y) * (p.x - a.x)
proc hit(a, b, c, d: Point[int]): bool =
    min(a.x, b.x) <= max(c.x, d.x) and min(c.x, d.x) <= max(a.x, b.x) and
        min(a.y, b.y) <= max(c.y, d.y) and min(c.y, d.y) <= max(a.y, b.y) and
        oriented(a, b, c) * oriented(a, b, d) <= 0 and
        oriented(c, d, a) * oriented(c, d, b) <= 0
proc pointNorm(p, a, b: Point[int]): Fraction[int] =
    let dx = b.x - a.x
    let dy = b.y - a.y
    let t = (p.x - a.x) * dx + (p.y - a.y) * dy
    let length = dx * dx + dy * dy
    if t <= 0: return initFraction((p.x - a.x) * (p.x - a.x) + (p.y - a.y) * (p.y - a.y))
    if t >= length: return initFraction((p.x - b.x) * (p.x - b.x) + (p.y - b.y) * (p.y - b.y))
    let area = oriented(a, b, p)
    initFraction(area * area, length)
proc pairNorm(a, b, c, d: Point[int]): Fraction[int] =
    if hit(a, b, c, d): return initFraction(0)
    min(min(pointNorm(a, c, d), pointNorm(b, c, d)),
        min(pointNorm(c, a, b), pointNorm(d, a, b)))
proc rational(p: Point[int], scale: int): Point[Fraction[int]] =
    initPoint(initFraction(p.x, scale), initFraction(p.y, scale))

var grid: seq[Point[int]]
for x in -1..1:
    for y in -1..1: grid.add(initPoint(x, y))
var pairs = 0
for a in grid:
    for b in grid:
        if a == b: continue
        for c in grid:
            for d in grid:
                if c == d: continue
                let expected = pairNorm(a, b, c, d)
                for scale in [1, 2, 4]:
                    let s1 = initSegment(rational(a, scale), rational(b, scale))
                    let s2 = initSegment(rational(c, scale), rational(d, scale))
                    let actual = norm(s1, s2)
                    static: doAssert typeof(actual) is Fraction[int]
                    doAssert actual == expected / (scale * scale)
                    if expected == initFraction(0):
                        doAssert actual.num == 0 and actual.den == 1
                    doAssert norm(s2, s1) == actual
                    let p = rational(c, scale)
                    doAssert norm(p, s1) == pointNorm(c, a, b) / (scale * scale)
                let f1 = initSegment(initPoint(float(a.x), float(a.y)), initPoint(float(b.x), float(b.y)))
                let f2 = initSegment(initPoint(float(c.x), float(c.y)), initPoint(float(d.x), float(d.y)))
                doAssert abs(norm(f1, f2) - expected.toFloat) < 1e-12
                doAssert abs(distance(f1, f2) - sqrt(expected.toFloat)) < 1e-12
                inc pairs
doAssert pairs == 5184

block:
    var p = initPoint(initFraction(3, 4), initFraction(-1, 2))
    p /= 2
    doAssert p.x == initFraction(3, 8) and p.y == initFraction(-1, 4)
    let divided = p / initFraction(1, 2)
    doAssert divided.x == initFraction(3, 4) and divided.y == initFraction(-1, 2)

echo "Hello World"
