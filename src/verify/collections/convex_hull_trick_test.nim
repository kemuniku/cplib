# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, random
import cplib/collections/convex_hull_trick_monotone_slope
import cplib/collections/convex_hull_trick_monotone
import cplib/collections/convex_hull_trick
import cplib/math/int128

type Line = tuple[a, b: int]

proc naive(lines: seq[Line], x: int): Int128 =
    result = to_Int128(lines[0].a) * to_Int128(x) + to_Int128(lines[0].b)
    for line in lines:
        result = min(result, to_Int128(line.a) * to_Int128(x) + to_Int128(line.b))

proc checkDynamic(lines: seq[Line], coordinates: seq[int]) =
    var hull = initConvexHullTrick()
    var added: seq[Line]
    for line in lines:
        hull.add_line(line.a, line.b)
        added.add(line)
        for x in coordinates:
            let expected = naive(added, x)
            if to_Int128(low(int)) <= expected and expected <= to_Int128(high(int)):
                doAssert hull.get_min(x) == expected.to_int

var rng = initRand(20260912)
for slopeIncreasing in [false, true]:
    for xIncreasing in [false, true]:
        for trial in 0..<100:
            var hull = initConvexHullTrickMonotoneSlope(slopeIncreasing)
            var monotone = initConvexHullTrickMonotone(slopeIncreasing, xIncreasing)
            var dynamic = initConvexHullTrick()
            var lines: seq[Line]
            var a = if slopeIncreasing: -100 else: 100
            var x = if xIncreasing: -100 else: 100
            for step in 0..<150:
                if step == 0 or rng.rand(2) != 0:
                    a += (if slopeIncreasing: 1 else: -1) * rng.rand(3)
                    let b = rng.rand(-10000..10000)
                    lines.add((a, b))
                    hull.add_line(a, b)
                    monotone.add_line(a, b)
                    dynamic.add_line(a, b)
                else:
                    x += (if xIncreasing: 1 else: -1) * rng.rand(3)
                    doAssert monotone.get_min(x) == naive(lines, x).to_int
                let q = rng.rand(-200..200)
                doAssert hull.get_min(q) == naive(lines, q).to_int
                doAssert dynamic.get_min(q) == naive(lines, q).to_int

for trial in 0..<200:
    var lines: seq[Line]
    for i in 0..<100:
        lines.add((rng.rand(-30..30), rng.rand(-100..100)))
    checkDynamic(lines, @[-100, -17, -2, -1, 0, 1, 2, 13, 100])

let extremes = @[low(int), low(int) + 1, -1, 0, 1, high(int) - 1, high(int)]
var extremeLines: seq[Line]
for a in extremes:
    for b in extremes:
        extremeLines.add((a, b))
for trial in 0..<20:
    rng.shuffle(extremeLines)
    checkDynamic(extremeLines, extremes)

for slopeIncreasing in [false, true]:
    var lines = extremeLines
    lines.sort(proc(l, r: Line): int =
        if slopeIncreasing: cmp(l.a, r.a) else: cmp(r.a, l.a))
    var hull = initConvexHullTrickMonotoneSlope(slopeIncreasing)
    for line in lines:
        hull.add_line(line.a, line.b)
    for xIncreasing in [false, true]:
        var monotone = initConvexHullTrickMonotone(slopeIncreasing, xIncreasing)
        for line in lines:
            monotone.add_line(line.a, line.b)
        var coordinates = extremes
        if not xIncreasing: coordinates.reverse()
        for x in coordinates:
            let expected = naive(lines, x)
            if to_Int128(low(int)) <= expected and expected <= to_Int128(high(int)):
                doAssert hull.get_min(x) == expected.to_int
                doAssert monotone.get_min(x) == expected.to_int

checkDynamic(@[(3, 0), (2, 0), (1, 0), (0, 0), (-1, 0)], @[-1, 0, 1])
checkDynamic(@[(3, 0), (1, 1), (2, 0), (2, -1), (2, 2)], @[-2, -1, 0, 1, 2])
checkDynamic(@[(0, high(int)), (0, low(int))], extremes)
checkDynamic(@[(high(int), high(int)), (low(int), low(int))], @[-1, 0])

block:
    var hull = initConvexHullTrick()
    var sortedHull = initConvexHullTrickMonotoneSlope(slopeIncreasing = true)
    var monotoneHull = initConvexHullTrickMonotone(slopeIncreasing = true)
    for a in 0..<10000:
        hull.add_line(a, a * a)
        sortedHull.add_line(a, a * a)
        monotoneHull.add_line(a, a * a)
    for x in -20000..0:
        let a = min(9999, (-x) div 2)
        let expected = a * x + a * a
        doAssert hull.get_min(x) == expected
        doAssert sortedHull.get_min(x) == expected
        doAssert monotoneHull.get_min(x) == expected
    hull.add_line(0, -1000000000)
    doAssert hull.get_min(0) == -1000000000

when compileOption("assertions"):
    template rejects(body: untyped) =
        block:
            var rejected = false
            try:
                body
            except AssertionDefect:
                rejected = true
            doAssert rejected
    rejects:
        let hull = initConvexHullTrickMonotoneSlope()
        discard hull.get_min(0)
    rejects:
        var hull = initConvexHullTrickMonotone()
        discard hull.get_min(0)
    rejects:
        let hull = initConvexHullTrick()
        discard hull.get_min(0)
    rejects:
        var hull = initConvexHullTrickMonotoneSlope()
        hull.add_line(0, 0)
        hull.add_line(1, 0)
    rejects:
        var hull = initConvexHullTrickMonotone()
        hull.add_line(0, 0)
        discard hull.get_min(1)
        discard hull.get_min(0)

echo "Hello World"
