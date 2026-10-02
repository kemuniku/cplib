# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, hashes, sets, tables, random
import cplib/geometry/base
import cplib/math/fractions

let originalEps = GEOMETRY_EPS
block:
    doAssert geometry_eq(1e9, 1e9 + 0.01)
    doAssert geometry_eq(-1e9, -1e9 - 0.01)
    let values = @[-1e12, -1e9, -1.0, -1e-12, 0.0, 1e-12, 1.0, 1e9, 1e12]
    for a in values:
        for b in values:
            doAssert geometry_eq(a, b) == geometry_eq(b, a)
            doAssert geometry_eq(a, b) == geometry_eq(-a, -b)
            doAssert geometry_lt(a, b) == geometry_gt(b, a)
    GEOMETRY_EPS = 0.125
    doAssert geometry_eq(8.0, 9.1) == geometry_eq(9.1, 8.0)
    doAssert geometry_eq(8.0, 9.1)
    doAssert geometry_eq(0.0, 0.0625)
    doAssert not geometry_eq(0.0, 0.125)
    doAssert not geometry_eq(1.0, 2.0)
    GEOMETRY_EPS = 0
    doAssert geometry_eq(3.0, 3.0)
    doAssert not geometry_eq(3.0, 3.0 + 1e-12)
    doAssert geometry_eq(0.0, -0.0)
    doAssert geometry_eq(Inf, Inf)
    doAssert geometry_eq(-Inf, -Inf)
    doAssert not geometry_eq(Inf, -Inf)
    doAssert not geometry_eq(Inf, 1.0)
    doAssert not geometry_eq(1.0, Inf)
    doAssert not geometry_eq(NaN, NaN)
    GEOMETRY_EPS = originalEps
    doAssert not geometry_eq(Inf, 1.0)
    doAssert not geometry_eq(NaN, 0.0)
    doAssert geometry_eq(1, 1.0)
    doAssert geometry_eq(-1.0, -1)

proc checkFloatPoints[T: SomeFloat]() =
    let p = initPoint(T(1), T(2))
    let delta = (when T is float32: T(1e-6) else: T(1e-12))
    let q = initPoint(T(1) + delta, T(2))
    GEOMETRY_EPS = 1e-5
    doAssert p != q and p.almost_equal(q)
    doAssert p < q and cmp(p, q) == -1 and cmp(q, p) == 1
    var seen = initHashSet[Point[T]]()
    var table = initTable[Point[T], int]()
    seen.incl(p)
    seen.incl(q)
    table[p] = 1
    table[q] = 2
    doAssert seen.len == 2 and p in seen and q in seen
    doAssert table[p] == 1 and table[q] == 2
    let zero = initPoint(T(0), T(0))
    let negativeZero = initPoint(-T(0), -T(0))
    doAssert zero == negativeZero and hash(zero) == hash(negativeZero)
    seen.incl(zero)
    doAssert negativeZero in seen
    let tiny = initPoint(T(1e-12), T(0))
    doAssert zero != tiny and zero.almost_equal(tiny)
    doAssert initLine(zero, tiny).t == tiny
    doAssert initSegment(zero, tiny).t == tiny
    GEOMETRY_EPS = 1
    doAssert table[p] == 1 and table[q] == 2 and seen.len == 3
    GEOMETRY_EPS = originalEps

checkFloatPoints[float32]()
checkFloatPoints[float64]()

block:
    let a = initPoint(0.0, 2.0)
    let b = initPoint(0.75e-10, 1.0)
    let c = initPoint(1.5e-10, 0.0)
    doAssert a < b and b < c and a < c
    var points = @[a, b, c, a, initPoint(-0.0, 2.0)]
    var rng = initRand(20261003)
    for i in 0..<100:
        points.add(initPoint(float(rng.rand(-10..10)) * 1e-11,
            float(rng.rand(-10..10))))
    for p in points:
        doAssert not (p < p)
        for q in points:
            doAssert (cmp(p, q) == 0) == (p == q)
            doAssert cmp(p, q) == -cmp(q, p)
            doAssert (p <= q) == (p < q or p == q)
            doAssert (p >= q) == (q <= p)
            for r in points:
                if p < q and q < r: doAssert p < r
    let expected = points.sorted(proc(p, q: Point[float]): int =
        cmp((p.x, p.y), (q.x, q.y)))
    for i in 0..<20:
        rng.shuffle(points)
        doAssert points.sorted == expected

block:
    let p = initPoint(initFraction(1, 2), initFraction(3, 4))
    let q = initPoint(initFraction(2, 4, false), initFraction(6, 8, false))
    doAssert p == q and p.almost_equal(q)
    doAssert hash(p) == hash(q)
    var seen = initHashSet[Point[Fraction[int]]]()
    seen.incl(p)
    doAssert q in seen
    doAssert initPoint(1, 2) < initPoint(1, 3)
    doAssert not almost_equal(initPoint(1, 2), initPoint(1, 3))

echo "Hello World"
