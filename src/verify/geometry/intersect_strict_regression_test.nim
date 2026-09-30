# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/geometry/base
import cplib/geometry/intersect

proc checkSymmetries[T](s1, s2: Segment[T], strictExpected, inclusiveExpected: bool) =
    for a in [s1, initSegment(s1.t, s1.s)]:
        for b in [s2, initSegment(s2.t, s2.s)]:
            doAssert intersect(a, b, true) == strictExpected
            doAssert intersect(b, a, true) == strictExpected
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

echo "Hello World"
