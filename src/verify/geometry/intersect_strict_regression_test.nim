# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/math/fractions
import cplib/geometry/base
import cplib/geometry/intersect

proc checkSymmetries[T](s1, s2: Segment[T], strictExpected, inclusiveExpected: bool) =
    for a in [s1, initSegment(s1.t, s1.s)]:
        for b in [s2, initSegment(s2.t, s2.s)]:
            doAssert intersect(a, b, true) == strictExpected
            doAssert intersect(b, a, true) == strictExpected
            doAssert not intersect(a, b, true) or intersect(a, b)
            doAssert not intersect(b, a, true) or intersect(b, a)
            doAssert intersect(a, b) == inclusiveExpected
            doAssert intersect(b, a) == inclusiveExpected

proc segment(x1, y1, x2, y2: int): Segment[int] =
    initSegment(initPoint(x1, y1), initPoint(x2, y2))

let outer = segment(0, 0, 3, 0)
checkSymmetries(segment(1, 0, 2, 0), outer, true, true)
checkSymmetries(outer, outer, true, true)
checkSymmetries(outer, segment(2, 0, 4, 0), true, true)
checkSymmetries(outer, segment(0, 0, 2, 0), true, true)
checkSymmetries(outer, segment(3, 0, 4, 0), false, true)
checkSymmetries(outer, segment(4, 0, 5, 0), false, false)
checkSymmetries(segment(0, 0, 0, 3), segment(0, 1, 0, 2), true, true)
checkSymmetries(segment(-2, 2, 2, -2), segment(-1, 1, 1, -1), true, true)
checkSymmetries(segment(0, 0, 2, 2), segment(0, 2, 2, 0), true, true)
checkSymmetries(outer, segment(1, 0, 1, 2), false, true)
checkSymmetries(outer, segment(3, 0, 4, 1), false, true)
checkSymmetries(outer, segment(0, 1, 3, 1), false, false)
checkSymmetries(outer, segment(4, -1, 4, 1), false, false)

let floatOuter = initSegment(initPoint(0.0, 0.0), initPoint(3.0, 0.0))
checkSymmetries(floatOuter,
    initSegment(initPoint(1.0, 0.0), initPoint(2.0, 0.0)), true, true)
checkSymmetries(floatOuter, floatOuter, true, true)
checkSymmetries(floatOuter,
    initSegment(initPoint(3.0, 0.0), initPoint(4.0, 0.0)), false, true)
checkSymmetries(
    initSegment(initPoint(0.0, 0.0), initPoint(1.0, 0.0)),
    initSegment(initPoint(1.0 - GEOMETRY_EPS / 4, 0.0), initPoint(2.0, 0.0)),
    false, true)

checkSymmetries(
    initSegment(initPoint(0.0, 0.0), initPoint(0.1, 0.0)),
    initSegment(initPoint(0.0, 5e-10), initPoint(100.0, 5e-10)),
    false, false)
checkSymmetries(
    initSegment(initPoint(0.0, 0.0), initPoint(0.0, 0.1)),
    initSegment(initPoint(5e-10, 0.0), initPoint(5e-10, 100.0)),
    false, false)
checkSymmetries(
    initSegment(initPoint(0.0, 0.0), initPoint(0.1, 0.0)),
    initSegment(initPoint(0.0, 0.0), initPoint(100.0, 0.0)),
    true, true)

checkSymmetries(
    initSegment(initPoint(0.0, 10.0), initPoint(5e-11, 0.0)),
    initSegment(initPoint(-1.5e-10, 40.0), initPoint(5e-11, 0.0)),
    true, true)

proc checkProjectedIntervals[T](direction: Point[T]) =
    let p0 = direction * 0
    let p1 = direction * 1
    let p2 = direction * 2
    let p3 = direction * 3
    let p4 = direction * 4
    checkSymmetries(initSegment(p1, p2), initSegment(p0, p4), true, true)
    checkSymmetries(initSegment(p1, p3), initSegment(p2, p4), true, true)
    checkSymmetries(initSegment(p0, p2), initSegment(p2, p4), false, true)
    checkSymmetries(initSegment(p0, p1), initSegment(p2, p3), false, false)

for scale in [1.0 / 1024.0, 1.0, 1024.0]:
    for aspect in [0.0, 1.0 / 1099511627776.0, 1.0 / 4294967296.0, 1.0]:
        for sx in [-1.0, 1.0]:
            for sy in [-1.0, 1.0]:
                let dx = sx * scale * aspect
                let dy = sy * scale
                checkProjectedIntervals(initPoint(dx, dy))
                checkProjectedIntervals(initPoint(dy, dx))

for dx in [-1000, -1, 0, 1, 1000]:
    checkProjectedIntervals(initPoint(dx, 1))
    checkProjectedIntervals(initPoint(1, dx))
checkProjectedIntervals(initPoint(initFraction(1, 10), initFraction(-2)))
checkProjectedIntervals(initPoint(initFraction(-2), initFraction(1, 10)))
checkProjectedIntervals(initPoint(initFraction(0), initFraction(1, 3)))

proc orientation(a, b, c: Point[int]): int =
    let value = (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)
    if value < 0: -1
    elif value > 0: 1
    else: 0

proc exactIntersection(a, b: Segment[int], strict: bool): bool =
    let o1 = orientation(a.s, a.t, b.s)
    let o2 = orientation(a.s, a.t, b.t)
    let o3 = orientation(b.s, b.t, a.s)
    let o4 = orientation(b.s, b.t, a.t)
    if o1 == 0 and o2 == 0:
        var a1, a2, b1, b2: int
        if a.s.x != a.t.x:
            (a1, a2, b1, b2) = (a.s.x, a.t.x, b.s.x, b.t.x)
        else:
            (a1, a2, b1, b2) = (a.s.y, a.t.y, b.s.y, b.t.y)
        let lo = max(min(a1, a2), min(b1, b2))
        let hi = min(max(a1, a2), max(b1, b2))
        return (if strict: lo < hi else: lo <= hi)
    if strict:
        return o1 * o2 < 0 and o3 * o4 < 0
    return o1 * o2 <= 0 and o3 * o4 <= 0

var segments: seq[Segment[int]]
for x1 in -1..1:
    for y1 in -1..1:
        for x2 in -1..1:
            for y2 in -1..1:
                if x1 != x2 or y1 != y2:
                    segments.add(segment(x1, y1, x2, y2))
for a in segments:
    for b in segments:
        doAssert intersect(a, b, true) == exactIntersection(a, b, true)
        doAssert intersect(a, b) == exactIntersection(a, b, false)


proc checkStrictSymmetries(s1, s2: Segment[float], expected: bool) =
    for a in [s1, initSegment(s1.t, s1.s)]:
        for b in [s2, initSegment(s2.t, s2.s)]:
            doAssert intersect(a, b, true) == expected
            doAssert intersect(b, a, true) == expected
            doAssert not intersect(a, b, true) or intersect(a, b)
            doAssert not intersect(b, a, true) or intersect(b, a)

checkStrictSymmetries(
    initSegment(initPoint(0.0, 0.0), initPoint(2e-6, 0.0)),
    initSegment(initPoint(0.0, 1e-6), initPoint(2e-6, 1e-6)), false)
for offset in [0.0, -1e9, 1e9]:
    checkStrictSymmetries(
        initSegment(initPoint(offset, 0.0), initPoint(offset + 1.0, 0.0)),
        initSegment(initPoint(offset + 0.95, 0.0), initPoint(offset + 2.0, 0.0)), true)

for length in [2e-6, 2e-3, 2.0, 200.0]:
    for offset in [0.0, -1e-3, 1e-3]:
        checkStrictSymmetries(
            initSegment(initPoint(offset, offset), initPoint(offset + length, offset)),
            initSegment(initPoint(offset, offset + 1e-6),
                        initPoint(offset + length, offset + 1e-6)), false)
        checkStrictSymmetries(
            initSegment(initPoint(offset, offset), initPoint(offset, offset + length)),
            initSegment(initPoint(offset + 1e-6, offset),
                        initPoint(offset + 1e-6, offset + length)), false)

checkStrictSymmetries(
    initSegment(initPoint(0.0, 0.0), initPoint(100.0, 0.0)),
    initSegment(initPoint(0.0, GEOMETRY_EPS / 2),
                initPoint(100.0, GEOMETRY_EPS / 2)), true)
checkStrictSymmetries(
    initSegment(initPoint(0.0, 0.0), initPoint(2e-6, 0.0)),
    initSegment(initPoint(0.0, GEOMETRY_EPS / 4),
                initPoint(2e-6, GEOMETRY_EPS / 4)), true)

for scale in [2e-6, 0.25, 16.0]:
    for offset in [0.0, -1e-3, 1e-3]:
        for direction in [initPoint(1.0, 0.0), initPoint(0.0, 1.0),
                          initPoint(0.6, 0.8), initPoint(0.6, -0.8)]:
            let origin = initPoint(offset, offset)
            let u = direction * scale
            let v = initPoint(-direction.y, direction.x) * scale
            checkStrictSymmetries(
                initSegment(origin - u, origin + u),
                initSegment(origin - v, origin + v), true)
            checkStrictSymmetries(
                initSegment(origin, origin + u),
                initSegment(origin + u * 0.75, origin + u * 2), true)
            checkStrictSymmetries(
                initSegment(origin, origin + u),
                initSegment(origin + u, origin + u * 2), false)

proc transformed(s: Segment[int], scale, offset: float): Segment[float] =
    initSegment(
        initPoint(s.s.x.float * scale + offset, s.s.y.float * scale - offset),
        initPoint(s.t.x.float * scale + offset, s.t.y.float * scale - offset))

var rng = initRand(896)
for sample in 0..<128:
    let a0 = initPoint(rng.rand(-8..8), rng.rand(-8..8))
    let a1 = initPoint(rng.rand(-8..8), rng.rand(-8..8))
    let b0 = initPoint(rng.rand(-8..8), rng.rand(-8..8))
    let b1 = initPoint(rng.rand(-8..8), rng.rand(-8..8))
    if a0 == a1 or b0 == b1: continue
    let a = initSegment(a0, a1)
    let b = initSegment(b0, b1)
    for scale in [1.0 / 1024.0, 1.0, 1024.0]:
        for offset in [0.0, -1024.0, 1024.0]:
            checkStrictSymmetries(transformed(a, scale, offset),
                                  transformed(b, scale, offset),
                                  exactIntersection(a, b, true))


checkSymmetries(
    initSegment(initPoint(0.0, 0.0), initPoint(100.0, 0.0)),
    initSegment(initPoint(-1e-9, 0.0), initPoint(100.0, 5e-11)), true, true)
checkSymmetries(
    initSegment(initPoint(0.0, 0.0), initPoint(1.0, 0.0)),
    initSegment(initPoint(2.0, 5e-11), initPoint(3.0, 1.5e-10)), false, false)
checkSymmetries(
    initSegment(initPoint(0.0, 0.0), initPoint(2e-6, 0.0)),
    initSegment(initPoint(0.0, 1e-6), initPoint(2e-6, 1e-6)), false, false)

for scale in [1e-3'f32, 1.0'f32]:
    let origin = initPoint(0.0'f32, 0.0'f32)
    let x = initPoint(scale, 0.0'f32)
    let y = initPoint(0.0'f32, scale)
    checkSymmetries(initSegment(-x, x), initSegment(-y, y), true, true)
    checkSymmetries(initSegment(origin, x), initSegment(x, x * 2), false, true)
    checkSymmetries(initSegment(origin, x), initSegment(y, y + x), false, false)


type
    OraclePoint = tuple[x, y: int64]
    OracleSegment = tuple[s, t: OraclePoint]

proc rawLess(a, b: OraclePoint): bool =
    a.x < b.x or (a.x == b.x and a.y < b.y)
proc difference(a, b: OraclePoint): OraclePoint =
    (a.x - b.x, a.y - b.y)
proc dotExact(a, b: OraclePoint): int64 =
    a.x * b.x + a.y * b.y
proc crossExact(a, b: OraclePoint): int64 =
    a.x * b.y - a.y * b.x
proc normExact(a: OraclePoint): int64 = dotExact(a, a)
proc canonical(s: OracleSegment): OracleSegment =
    result = s
    if rawLess(result.t, result.s): swap(result.s, result.t)
proc nearExact(p: OraclePoint, s: OracleSegment, boundary: var bool): bool =
    let d = difference(s.t, s.s)
    let v = difference(p, s.s)
    let along = dotExact(d, v)
    let n = normExact(d)
    if along <= 0:
        let squared = normExact(v)
        boundary = boundary or squared == 1
        return squared < 1
    if along >= n:
        let squared = normExact(difference(p, s.t))
        boundary = boundary or squared == 1
        return squared < 1
    let c = crossExact(d, v)
    boundary = boundary or c * c == n
    c * c < n

proc oracle(aInput, bInput: OracleSegment): tuple[inclusive, strict, boundary: bool] =
    let a = canonical(aInput)
    let b = canonical(bInput)
    let d1 = difference(a.t, a.s)
    let d2 = difference(b.t, b.s)
    let n1 = normExact(d1)
    let n2 = normExact(d2)
    let c1 = crossExact(d1, difference(b.s, a.s))
    let c2 = crossExact(d1, difference(b.t, a.s))
    let c3 = crossExact(d2, difference(a.s, b.s))
    let c4 = crossExact(d2, difference(a.t, b.s))
    var nearEndpoint = false
    for p in [a.s, a.t]:
        if nearExact(p, b, result.boundary): nearEndpoint = true
    for p in [b.s, b.t]:
        if nearExact(p, a, result.boundary): nearEndpoint = true
    result.inclusive = (c1 * c2 < 0 and c3 * c4 < 0) or nearEndpoint
    proc sideExact(c, n: int64): int =
        if c * c < n: 0
        elif c < 0: -1
        elif c > 0: 1
        else: 0
    let o1 = sideExact(c1, n1)
    let o2 = sideExact(c2, n1)
    let o3 = sideExact(c3, n2)
    let o4 = sideExact(c4, n2)
    result.boundary = result.boundary or c1 * c1 == n1 or c2 * c2 == n1 or
        c3 * c3 == n2 or c4 * c4 == n2
    if not result.inclusive: return
    if o1 == 0 and o2 == 0 and o3 == 0 and o4 == 0:
        let scale1 = max(abs(d1.x), abs(d1.y))
        let scale2 = max(abs(d2.x), abs(d2.y))
        let useSecond = scale1 < scale2 or (scale1 == scale2 and rawLess(d1, d2))
        let d = (if useSecond: d2 else: d1)
        let a0 = dotExact(a.s, d)
        let a1 = dotExact(a.t, d)
        let b0 = dotExact(b.s, d)
        let b1 = dotExact(b.t, d)
        let gap = min(max(a0, a1), max(b0, b1)) - max(min(a0, a1), min(b0, b1))
        result.boundary = result.boundary or gap * gap == normExact(d)
        result.strict = gap > 0 and gap * gap >= normExact(d)
    else:
        result.strict = o1 * o2 < 0 and o3 * o4 < 0

proc transformedExact(p: OraclePoint, swapAxes: bool, sign: int64): OraclePoint =
    if swapAxes: (p.y, p.x * sign)
    else: (p.x * sign, p.y)
proc asFloat(s: OracleSegment, scale: float, shift: OraclePoint): Segment[float] =
    initSegment(
        initPoint((s.s.x + shift.x).float * scale, (s.s.y + shift.y).float * scale),
        initPoint((s.t.x + shift.x).float * scale, (s.t.y + shift.y).float * scale))

block:
    let savedEps = GEOMETRY_EPS
    var rng = initRand(1896)
    var checked = 0
    var cases: seq[tuple[a, b: OracleSegment]]
    for sample in 0..<256:
        let a0: OraclePoint = (rng.rand(-32..32).int64, rng.rand(-32..32).int64)
        let a1: OraclePoint = (rng.rand(-32..32).int64, rng.rand(-32..32).int64)
        let b0: OraclePoint = (rng.rand(-32..32).int64, rng.rand(-32..32).int64)
        let b1: OraclePoint = (rng.rand(-32..32).int64, rng.rand(-32..32).int64)
        if a0 == a1 or b0 == b1: continue
        cases.add(((a0, a1), (b0, b1)))
    for d in [(1'i64, 0'i64), (1'i64, 1'i64), (3'i64, 1'i64), (1'i64, 3'i64)]:
        for ex in -1'i64..1'i64:
            for ey in -1'i64..1'i64:
                let a: OracleSegment = ((0'i64, 0'i64), (d[0] * 4, d[1] * 4))
                let b: OracleSegment = ((d[0] * 2 + ex, d[1] * 2 + ey),
                                        (d[0] * 6 + ex, d[1] * 6 + ey))
                let c: OracleSegment = ((d[0] * 2 + ex, d[1] * 2 + ey),
                                        (d[0] * 6 - ex, d[1] * 6 - ey))
                cases.add((a, b))
                cases.add((a, c))
    for fixture in cases:
        let a0 = fixture.a.s
        let a1 = fixture.a.t
        let b0 = fixture.b.s
        let b1 = fixture.b.t
        for swapAxes in [false, true]:
            for sign in [-1'i64, 1'i64]:
                let a: OracleSegment = (transformedExact(a0, swapAxes, sign),
                                        transformedExact(a1, swapAxes, sign))
                let b: OracleSegment = (transformedExact(b0, swapAxes, sign),
                                        transformedExact(b1, swapAxes, sign))
                let expected = oracle(a, b)
                if expected.boundary: continue
                for scale in [1.0 / 4096.0, 1.0 / 1024.0, 1.0 / 256.0]:
                    GEOMETRY_EPS = scale
                    for shift in [(0'i64, 0'i64), (128'i64, -256'i64)]:
                        checkSymmetries(asFloat(a, scale, shift), asFloat(b, scale, shift),
                                        expected.strict, expected.inclusive)
                        inc checked
    doAssert checked > 1000
    GEOMETRY_EPS = 1.0 / 1024.0
    let eps = GEOMETRY_EPS
    let a = initSegment(initPoint(0.0, 0.0), initPoint(1.0, 0.0))
    checkSymmetries(a,
        initSegment(initPoint(1.0 - eps, 0.0), initPoint(2.0, 0.0)), true, true)
    checkSymmetries(a,
        initSegment(initPoint(1.0 - eps / 2, 0.0), initPoint(2.0, 0.0)), false, true)
    checkSymmetries(a,
        initSegment(initPoint(1.0 + eps / 2, 0.0), initPoint(2.0, 0.0)), false, true)
    checkSymmetries(a,
        initSegment(initPoint(1.0 + eps, 0.0), initPoint(2.0, 0.0)), false, false)
    checkSymmetries(a,
        initSegment(initPoint(0.0, eps), initPoint(1.0, eps)), false, false)
    checkSymmetries(a,
        initSegment(initPoint(0.0, eps / 2), initPoint(1.0, eps / 2)), true, true)
    GEOMETRY_EPS = 0
    checkSymmetries(a,
        initSegment(initPoint(1.0, 0.0), initPoint(2.0, 0.0)), false, true)
    checkSymmetries(a,
        initSegment(initPoint(0.5, 0.0), initPoint(2.0, 0.0)), true, true)
    GEOMETRY_EPS = savedEps

for direction in [initPoint(3.0, 7.0), initPoint(3.0, -7.0)]:
    for scale in [1e-6, 1.0, 1e6]:
        for shift in [0.0, -0.25, 0.25]:
            let origin = initPoint(shift, -shift)
            let u = direction * scale
            checkSymmetries(initSegment(origin, origin + u),
                initSegment(origin + u * 2, origin + u * 3), false, false)

echo "Hello World"
