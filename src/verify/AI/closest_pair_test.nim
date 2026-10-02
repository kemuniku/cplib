# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import math, options, random, sequtils
import cplib/geometry/base
import cplib/geometry/closest_pair

proc oracle[T](points: seq[Point[T]]): auto =
    when T is SomeSignedInt:
        type D = int64
    else:
        type D = float64
    var best = none(D)
    for i in 0..<points.len:
        for j in i + 1..<points.len:
            let dx = D(points[i].x) - D(points[j].x)
            let dy = D(points[i].y) - D(points[j].y)
            let d = dx * dx + dy * dy
            if best.isNone or d < best.get:
                best = some(d)
    best

proc check[T](points: seq[Point[T]]) =
    var original = newSeq[Point[T]](points.len)
    for i, p in points:
        original[i] = p
    let answer = closest_pair(points)
    for i, p in points:
        doAssert p.x == original[i].x and p.y == original[i].y
    let expected = oracle(points)
    doAssert answer.isSome == expected.isSome
    if answer.isSome:
        let value = answer.get
        let (i, j) = value.indices
        doAssert 0 <= i and i < j and j < points.len
        doAssert value.distanceSquared == expected.get, $points
        let pair = @[points[i], points[j]]
        doAssert oracle(pair).get == value.distanceSquared

proc checkIntegers(points: seq[(int64, int64)]) =
    check(points.mapIt(initPoint(it)))

checkIntegers(@[])
checkIntegers(@[(17'i64, -11'i64)])
checkIntegers(@[(0'i64, 0'i64), (3'i64, 4'i64)])
checkIntegers(newSeqWith(100, (7'i64, -11'i64)))
checkIntegers(@[(5'i64, -8'i64), (0'i64, 0'i64), (3'i64, 4'i64), (5'i64, -8'i64)])
for mask in 0..<512:
    var points: seq[(int64, int64)]
    for i in 0..<9:
        if (mask and (1 shl i)) != 0:
            points.add((int64(i div 3 - 1), int64(i mod 3 - 1)))
    checkIntegers(points)

for n in 0..5:
    for code in 0..<(1 shl (2 * n)):
        var value = code
        var points: seq[(int64, int64)]
        for i in 0..<n:
            points.add((int64((value and 3) div 2 - 1), int64((value and 3) mod 2 - 1)))
            value = value shr 2
        checkIntegers(points)

var rng = initRand(20261002)
for direction in [(0'i64, 1'i64), (1'i64, 0'i64), (2'i64, 3'i64), (2'i64, -3'i64)]:
    var points: seq[(int64, int64)]
    for i in -60..60:
        points.add((direction[0] * int64(i) + 17, direction[1] * int64(i) - 31))
    for trial in 0..<5:
        rng.shuffle(points)
        checkIntegers(points)

const bound = 1_000_000_000'i64
checkIntegers(@[(-bound, -bound), (bound, bound)])
checkIntegers(@[(-bound, -bound), (-bound, bound), (bound, -bound), (bound, bound)])
checkIntegers(@[(low(int64), low(int64)), (low(int64) + 2_000_000_000, low(int64) + 2_000_000_000)])
checkIntegers(@[(high(int64), high(int64)), (high(int64) - 2_000_000_000, high(int64) - 2_000_000_000)])
for offset in [low(int64), -9_007_199_254_740_995'i64, 9_007_199_254_740_995'i64, high(int64) - 100]:
    checkIntegers(@[(offset, offset), (offset + 3, offset + 4), (offset + 4, offset + 4)])

for trial in 0..<2000:
    var points: seq[(int64, int64)]
    let n = rng.rand(0..70)
    for i in 0..<n:
        case trial mod 5
        of 0:
            points.add((int64(rng.rand(-5..5)), int64(rng.rand(-5..5))))
        of 1:
            points.add((int64(rng.rand(-1_000_000_000..1_000_000_000)),
                int64(rng.rand(-1_000_000_000..1_000_000_000))))
        of 2:
            points.add((9_007_199_254_740_992'i64 + int64(rng.rand(0..10000)),
                -9_007_199_254_740_992'i64 + int64(rng.rand(0..10000))))
        of 3:
            points.add((low(int64) + int64(rng.rand(0..10000)), high(int64) - int64(rng.rand(0..10000))))
        else:
            let cluster = int64(rng.rand(0..3)) * 10000
            points.add((cluster + int64(rng.rand(-100..100)), -cluster + int64(rng.rand(-100..100))))
    rng.shuffle(points)
    checkIntegers(points)

check(@[initPoint(-128'i8, -128'i8), initPoint(127'i8, 127'i8)])
check(@[initPoint(-32768'i16, -32768'i16), initPoint(32767'i16, 32767'i16)])
check(@[initPoint(-1_000_000_000'i32, -1_000_000_000'i32), initPoint(1_000_000_000'i32, 1_000_000_000'i32)])
check(@[initPoint(0, 0), initPoint(3, 4)])
static:
    doAssert not compiles(closest_pair([initPoint(0'u64, 0'u64), initPoint(1'u64, 0'u64)]))

check(newSeq[Point[float64]]())
check(@[initPoint(1.0, -2.0)])
check(@[initPoint(0.0, 0.0), initPoint(3.0, 4.0)])
check(@[initPoint(0.0, -0.0), initPoint(-0.0, 0.0)])
check(newSeqWith(100, initPoint(0.125, -0.25)))
check(@[initPoint(0.0, 0.0), initPoint(5e-12, 10.0), initPoint(1e-11, 0.0), initPoint(-5e-12, 10.0)])
check(@[initPoint(-1e150, -1e150), initPoint(1e150, 1e150)])
check(@[initPoint(0.0, 0.0), initPoint(2e-162, 0.0), initPoint(4e-162, 0.0), initPoint(0.0, 2e-162)])
check(@[initPoint(-1e30'f32, -1e30'f32), initPoint(1e30'f32, 1e30'f32)])
check(@[initPoint(0'f32, 0'f32), initPoint(1e-45'f32, 0'f32)])
check(@[initPoint(1e-20'f32, -2e-20'f32), initPoint(2e-20'f32, -2e-20'f32)])
check(@[initPoint(9_007_199_254_740_992.0, 0.0), initPoint(9_007_199_254_740_996.0, 0.0),
    initPoint(9_007_199_254_740_998.0, 0.0)])
block:
    let originalEps = GEOMETRY_EPS
    GEOMETRY_EPS = 1e20
    check(@[initPoint(0.0, 0.0), initPoint(1e-12, 10.0), initPoint(2e-12, 0.0)])
    GEOMETRY_EPS = originalEps

for trial in 0..<1500:
    var points: seq[Point[float64]]
    let n = rng.rand(0..70)
    let scale = [1.0, 1e-12, 1e120, 1e-120, 2e-162][trial mod 5]
    for i in 0..<n:
        points.add(initPoint(float64(rng.rand(-1000..1000)) * scale,
            float64(rng.rand(-1000..1000)) * scale))
    rng.shuffle(points)
    check(points)
    if trial mod 5 == 0:
        check(points.mapIt(initPoint(float32(it.x), float32(it.y))))

for trial in 0..<1000:
    var points: seq[Point[float64]]
    for i in 0..<rng.rand(0..70):
        let x = float64(rng.rand(-1000..1000)) * pow(10.0, float64(rng.rand(-120..120)))
        let y = float64(rng.rand(-1000..1000)) * pow(10.0, float64(rng.rand(-120..120)))
        points.add(initPoint(x, y))
    rng.shuffle(points)
    check(points)

proc rejects[T](points: seq[Point[T]]) =
    var rejected = false
    try:
        discard closest_pair(points)
    except ValueError:
        rejected = true
    doAssert rejected

rejects(@[initPoint(low(int64), 0'i64), initPoint(high(int64), 0'i64)])
rejects(@[initPoint(0'i64, 0'i64), initPoint(2_000_000_001'i64, 0'i64)])
rejects(@[initPoint(0'i64, 0'i64), initPoint(0'i64, 2_000_000_001'i64)])
rejects(@[initPoint(0.0, 0.0), initPoint(Inf, 0.0)])
rejects(@[initPoint(0.0, NegInf)])
rejects(@[initPoint(NaN, 0.0)])
rejects(@[initPoint(-1e308, 0.0), initPoint(1e308, 0.0)])
rejects(@[initPoint(0.0, 0.0), initPoint(1e200, 0.0)])
rejects(@[initPoint(0.0, 0.0), initPoint(1e-200, 0.0)])
rejects(@[initPoint(0.0, 0.0), initPoint(0.0, 1e-200)])

proc checkLarge[T](points: seq[Point[T]], expected: auto) =
    let answer = closest_pair(points).get
    let (i, j) = answer.indices
    doAssert 0 <= i and i < j and j < points.len
    doAssert answer.distanceSquared == expected
    doAssert oracle(@[points[i], points[j]]).get == expected

block:
    const n = 200000
    checkLarge(newSeqWith(n, initPoint(7'i64, -11'i64)), 0'i64)
    checkLarge(newSeqWith(n, initPoint(0.125, -0.25)), 0.0)
    var points = newSeq[Point[int64]](n)
    for direction in [(0'i64, 1'i64), (1'i64, 0'i64), (1'i64, -1'i64)]:
        for i in 0..<n:
            points[i] = initPoint(direction[0] * int64(i), direction[1] * int64(i))
        rng.shuffle(points)
        checkLarge(points, direction[0] * direction[0] + direction[1] * direction[1])
        checkLarge(points.mapIt(initPoint(float64(it.x), float64(it.y))),
            float64(direction[0] * direction[0] + direction[1] * direction[1]))
    for i in 0..<n:
        points[i] = initPoint(int64(i div 500), int64(i mod 500))
    rng.shuffle(points)
    checkLarge(points, 1'i64)
    for i in 0..<n:
        points[i] = initPoint(10'i64 * int64(i), 10'i64 * int64(i mod 101))
    points[^1] = initPoint(1'i64, 0'i64)
    rng.shuffle(points)
    checkLarge(points, 1'i64)
    checkLarge(points.mapIt(initPoint(float64(it.x), float64(it.y))), 1.0)

echo "Hello World"
