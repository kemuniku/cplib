# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, math, random
import cplib/geometry/base
import cplib/geometry/argsort

type Vector = (int, int)

proc magnitude(x: int): uint =
    if x < 0: 0'u - cast[uint](x) else: uint(x)

proc ratioCmp(an, ad, bn, bd: uint): int =
    var (a, b, c, d) = (an, ad, bn, bd)
    var sign = 1
    while true:
        let q = system.cmp(a div b, c div d)
        if q != 0: return sign * q
        let r = a mod b
        let s = c mod d
        if r == 0 or s == 0: return sign * system.cmp(r, s)
        (a, b, c, d) = (b, r, d, s)
        sign = -sign

proc quadrant(p: Vector): int =
    if p[0] > 0 and p[1] >= 0: 0
    elif p[1] > 0 and p[0] <= 0: 1
    elif p[0] < 0 and p[1] <= 0: 2
    elif p[1] < 0 and p[0] >= 0: 3
    else: 4

proc oracle(a, b: Vector): int =
    let qa = quadrant(a)
    let qb = quadrant(b)
    if qa != qb: return system.cmp(qa, qb)
    if qa == 4: return 0
    if qa == 0 or qa == 2:
        ratioCmp(magnitude(a[1]), magnitude(a[0]), magnitude(b[1]), magnitude(b[0]))
    else:
        ratioCmp(magnitude(a[0]), magnitude(a[1]), magnitude(b[0]), magnitude(b[1]))

proc insertionOracle(input: seq[Vector]): seq[Vector] =
    for p in input:
        var pos = result.len
        result.add(p)
        while pos > 0 and oracle(result[pos - 1], p) > 0:
            result[pos] = result[pos - 1]
            dec pos
        result[pos] = p

proc exactSeq[T](a, b: seq[Point[T]]): bool =
    if a.len != b.len: return false
    for i in 0..<a.len:
        if a[i].x != b[i].x or a[i].y != b[i].y: return false
    true

proc checkIntegers(input: seq[Vector]) =
    let expected = insertionOracle(input)
    var points: seq[Point[int]]
    var expectedPoints: seq[Point[int]]
    for p in input: points.add(initPoint(p))
    for p in expected: expectedPoints.add(initPoint(p))
    let saved = points
    var tuples = input
    doAssert argsorted(input) == expected
    argsort(tuples)
    doAssert tuples == expected
    var output = argsorted(points)
    doAssert exactSeq(output, expectedPoints)
    doAssert exactSeq(points, saved)
    argsort(points)
    doAssert exactSeq(points, expectedPoints)
    if output.len > 0:
        output[0].x = output[0].x xor 1
        doAssert exactSeq(points, expectedPoints)
    for a in input:
        for b in input:
            let wanted = oracle(a, b)
            doAssert argcmp(a, b) == wanted
            doAssert argcmp(initPoint(a), initPoint(b)) == wanted

proc checkOrder[T](input: seq[Point[T]]) =
    for a in input:
        doAssert argcmp(a, a) == 0
        for b in input:
            let ab = argcmp(a, b)
            doAssert ab == -argcmp(b, a)
            for c in input:
                if ab < 0 and argcmp(b, c) < 0: doAssert argcmp(a, c) < 0
                if ab == 0 and argcmp(b, c) == 0: doAssert argcmp(a, c) == 0

var grid: seq[Vector]
for x in -3..3:
    for y in -3..3: grid.add((x, y))
checkIntegers(grid)
var small: seq[Point[int]]
for x in -1..1:
    for y in -1..1: small.add(initPoint(x, y))
checkOrder(small)
checkIntegers(@[])
checkIntegers(@[(0, 0)])
checkIntegers(@[(0, 0), (0, 0), (0, 0)])
checkIntegers(@[(0, 0), (-1, 0), (0, -1), (-2, 0), (0, 0)])
checkIntegers(@[(3, 6), (1, 2), (2, 4), (-3, -6), (-1, -2), (0, 0)])

var extremes: seq[Vector]
for x in [low(int), low(int) + 1, -1, 0, 1, high(int) - 1, high(int)]:
    for y in [low(int), low(int) + 1, -1, 0, 1, high(int) - 1, high(int)]:
        extremes.add((x, y))
checkIntegers(extremes)
var extremePoints: seq[Point[int]]
for p in extremes: extremePoints.add(initPoint(p))
checkOrder(extremePoints)

var rng = initRand(618)
for trial in 0..<250:
    var input: seq[Vector]
    for i in 0..<rng.rand(0..35):
        if trial mod 2 == 0: input.add((rng.rand(-1000000000..1000000000), rng.rand(-1000000000..1000000000)))
        else: input.add((cast[int](rng.next()), cast[int](rng.next())))
    checkIntegers(input)
for repeat in 0..<20:
    rng.shuffle(grid)
    checkIntegers(grid)

proc checkFloat[T: SomeFloat]() =
    var empty: seq[Point[T]]
    doAssert argsorted(empty).len == 0
    argsort(empty)
    let dirs = @[(1, 0), (2, 1), (1, 1), (1, 2), (0, 1), (-1, 2), (-1, 1), (-2, 1),
        (-1, 0), (-2, -1), (-1, -1), (-1, -2), (0, -1), (1, -2), (1, -1), (2, -1), (0, 0)]
    for scale in [T(1e-30), T(1), T(1e30)]:
        var expected: seq[Point[T]]
        for p in dirs: expected.add(initPoint(T(p[0]) * scale, T(p[1]) * scale))
        var input = expected
        input.reverse()
        let saved = input
        doAssert exactSeq(argsorted(input), expected)
        doAssert exactSeq(input, saved)
        argsort(input)
        doAssert exactSeq(input, expected)
        checkOrder(expected)
        for i in 0..<expected.len:
            for j in 0..<expected.len:
                doAssert argcmp(expected[i], expected[j]) == system.cmp(i, j)
    let rays = @[initPoint(T(2), T(2)), initPoint(T(1), T(1)), initPoint(T(3), T(3))]
    doAssert exactSeq(argsorted(rays), rays)
    var signedZeros = @[initPoint(T(-1), T(-0.0)), initPoint(T(-1), T(0)),
        initPoint(T(1), T(-0.0)), initPoint(T(1), T(0)), initPoint(T(-0.0), T(0))]
    checkOrder(signedZeros)
    argsort(signedZeros)
    doAssert signedZeros[0].x == 1 and signedZeros[1].x == 1
    doAssert signedZeros[2].x == -1 and signedZeros[3].x == -1
    doAssert signedZeros[4].x == 0
    let close = @[initPoint(T(1), T(2e-12)), initPoint(T(1), T(1e-12)), initPoint(T(1), T(0))]
    let oldEps = GEOMETRY_EPS
    for eps in [0.0, 1e-10, 1.0]:
        GEOMETRY_EPS = eps
        let sorted = argsorted(close)
        doAssert sorted[0].y == 0 and sorted[1].y == T(1e-12) and sorted[2].y == T(2e-12)
    GEOMETRY_EPS = oldEps

checkFloat[float32]()
checkFloat[float64]()
block:
    let huge = 1.7976931348623157e308
    let tiny = 4.9406564584124654e-324
    let expected = @[initPoint(huge, 0.0), initPoint(huge, huge), initPoint(0.0, tiny),
        initPoint(-huge, huge), initPoint(-huge, -0.0), initPoint(-huge, -huge),
        initPoint(0.0, -tiny), initPoint(huge, -huge), initPoint(0.0, 0.0)]
    var input = expected
    input.reverse()
    doAssert exactSeq(argsorted(input), expected)
    checkOrder(expected)
    let rounded = @[initPoint(huge, tiny), initPoint(huge, 0.0), initPoint(huge, tiny * 2),
        initPoint(-huge, tiny), initPoint(-huge, -tiny), initPoint(0.0, 0.0)]
    checkOrder(rounded)

echo "Hello World"
