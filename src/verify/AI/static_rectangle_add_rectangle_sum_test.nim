# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/utils/static_rectangle_add_rectangle_sum
import cplib/modint/modint
import random

block:
    let rectangles = [(0, 0, 2, 4, 1), (1, 1, 3, 5, 2)]
    let queries = [(0, 0, 1, 1), (1, 1, 2, 2), (2, 2, 3, 3), (0, 0, 3, 5),
        (0, 0, 3, 2), (0, 1, 3, 3), (3, 0, 4, 4)]
    let answers = static_rectangle_add_rectangle_sum(rectangles, queries)
    static: doAssert typeof(answers) is seq[int]
    doAssert answers == @[1, 3, 2, 24, 8, 12, 0]

block:
    let emptyRectangles: seq[(int, int, int, int, int64)] = @[]
    let emptyQueries: seq[(int, int, int, int)] = @[]
    doAssert static_rectangle_add_rectangle_sum(emptyRectangles, [(0, 0, 1, 1)]) == @[0'i64]
    doAssert static_rectangle_add_rectangle_sum([(0, 0, 1, 1, 5'i64)], emptyQueries).len == 0
    doAssert static_rectangle_add_rectangle_sum(emptyRectangles, emptyQueries).len == 0
    doAssert static_rectangle_add_rectangle_sum([(2, -1, 2, 5, 9), (-4, 3, 8, 3, 7)],
        [(-10, -10, 10, 10)]) == @[0]
    doAssert static_rectangle_add_rectangle_sum([(-3, -2, 4, 5, 7)],
        [(-1, -8, -1, 9), (-8, 3, 9, 3)]) == @[0, 0]

block:
    let rectangles = @[(-5, -3, 2, 4, 6'i64), (-5, -3, 2, 4, -6'i64),
        (-2, -1, 3, 5, -4'i64), (3, -1, 7, 5, 8'i64)]
    let queries = @[(-20, -20, 20, 20), (-2, -1, 3, 5), (3, -1, 7, 5),
        (2, 0, 4, 2), (-20, -20, -5, -3), (7, -1, 10, 5)]
    let originalRectangles = rectangles
    let originalQueries = queries
    doAssert static_rectangle_add_rectangle_sum(rectangles, queries) == @[72'i64, -120, 192, 8, 0, 0]
    doAssert rectangles == originalRectangles and queries == originalQueries

block:
    let x = 1_000_000_000_000'i64
    let rectangles = [(x, -3'i64, x + 7, 5'i64, 9'i64)]
    doAssert static_rectangle_add_rectangle_sum(rectangles,
        [(x - 1, -9'i64, x + 20, 8'i64), (x + 2, -1'i64, x + 4, 2'i64)]) == @[504'i64, 54]
    let wide = static_rectangle_add_rectangle_sum(
        [(0'i32, 0'i32, 100_000'i32, 100_000'i32, 7'i64)],
        [(1'i32, 2'i32, 100_001'i32, 100_002'i32)])
    static: doAssert typeof(wide) is seq[int64]
    doAssert wide == @[7'i64 * 99_999 * 99_998]

block:
    let answers = static_rectangle_add_rectangle_sum(
        [(-1.5, 0.25, 2.5, 1.75, 2.0), (0.5, -0.5, 3.0, 0.5, -3.0)],
        [(-2.0, -2.0, 4.0, 3.0), (0.0, 0.0, 1.0, 1.0), (2.5, 0.5, 3.0, 2.0)])
    for i, expected in [4.5, 0.75, 0.0]:
        doAssert abs(answers[i] - expected) < 1e-9

type
    Coordinate = distinct int64
    Pair = object
        a, b: int64
proc `<`(a, b: Coordinate): bool = int64(a) < int64(b)
proc `+=`(a: var Pair, b: Pair) =
    a.a += b.a
    a.b += b.b
proc `-`(a, b: Pair): Pair = Pair(a: a.a - b.a, b: a.b - b.b)
proc `*`(a: Pair, b: Coordinate): Pair = Pair(a: a.a * int64(b), b: a.b * int64(b))

block:
    let answers = static_rectangle_add_rectangle_sum(
        [(Coordinate(-2), Coordinate(1), Coordinate(3), Coordinate(4), Pair(a: 2, b: -3))],
        [(Coordinate(-1), Coordinate(2), Coordinate(5), Coordinate(5))])
    doAssert answers == @[Pair(a: 16, b: -24)]

proc checkModint[M](rectangles: seq[(int, int, int, int, int64)],
    queries: seq[(int, int, int, int)], expected: seq[int64]) =
    var modular = newSeq[(int, int, int, int, M)](rectangles.len)
    for i, rectangle in rectangles:
        modular[i] = (rectangle[0], rectangle[1], rectangle[2], rectangle[3], M.init(rectangle[4]))
    let answers = static_rectangle_add_rectangle_sum(modular, queries)
    for i, value in expected: doAssert answers[i] == M.init(value)

block:
    var rng = initRand(20260927)
    modint_barrett.setMod(1_000_000_007)
    modint_montgomery.setMod(998_244_353)
    for trial in 0..<160:
        var rectangles: seq[(int, int, int, int, int64)]
        var queries: seq[(int, int, int, int)]
        for i in 0..<rng.rand(0..40):
            var l = rng.rand(-15..15) * 7
            var r = rng.rand(-15..15) * 7
            var d = rng.rand(-15..15) * 11
            var u = rng.rand(-15..15) * 11
            if r < l: swap(l, r)
            if u < d: swap(d, u)
            rectangles.add((l, d, r, u, int64(rng.rand(-1_000_000..1_000_000))))
        for i in 0..<rng.rand(0..60):
            var l = rng.rand(-120..120)
            var r = rng.rand(-120..120)
            var d = rng.rand(-180..180)
            var u = rng.rand(-180..180)
            if r < l: swap(l, r)
            if u < d: swap(d, u)
            queries.add((l, d, r, u))
        var expected = newSeq[int64](queries.len)
        for i, q in queries:
            for r in rectangles:
                let width = max(0, min(q[2], r[2]) - max(q[0], r[0]))
                let height = max(0, min(q[3], r[3]) - max(q[1], r[1]))
                expected[i] += r[4] * int64(width) * int64(height)
        doAssert static_rectangle_add_rectangle_sum(rectangles, queries) == expected
        checkModint[modint998244353_montgomery](rectangles, queries, expected)
        checkModint[modint998244353_barrett](rectangles, queries, expected)
        checkModint[modint_montgomery](rectangles, queries, expected)
        checkModint[modint_barrett](rectangles, queries, expected)

block:
    type mint = modint998244353_montgomery
    let l = low(int64)
    let r = high(int64)
    let weight = mint.init(17)
    let answers = static_rectangle_add_rectangle_sum([(l, l, r, r, weight)],
        [(l, l, r, r), (-1'i64, -2'i64, 3'i64, 5'i64)])
    let width = mint.init(r) - mint.init(l)
    doAssert answers == @[weight * width * width, weight * 28]
    let unsigned = static_rectangle_add_rectangle_sum([(0'u64, 0'u64, high(uint64), high(uint64), weight)],
        [(0'u64, 0'u64, high(uint64), high(uint64))])
    let side = mint.init(high(uint64))
    doAssert unsigned == @[weight * side * side]

block:
    for invalid in [(1, 0, 0, 1), (0, 1, 1, 0)]:
        var rejected = false
        try:
            discard static_rectangle_add_rectangle_sum(
                [(invalid[0], invalid[1], invalid[2], invalid[3], 1)], newSeq[(int, int, int, int)]())
        except AssertionDefect: rejected = true
        doAssert rejected
        rejected = false
        try:
            discard static_rectangle_add_rectangle_sum(newSeq[(int, int, int, int, int)](), [invalid])
        except AssertionDefect: rejected = true
        doAssert rejected

proc checkCoordinateType[K](coordinates: openArray[K]) =
    type mint = modint998244353_montgomery
    var rng = initRand(20260928)
    var rectangles: seq[(K, K, K, K, mint)]
    var queries: seq[(K, K, K, K)]
    for i in 0..<100:
        var l = coordinates[rng.rand(coordinates.high)]
        var r = coordinates[rng.rand(coordinates.high)]
        var d = coordinates[rng.rand(coordinates.high)]
        var u = coordinates[rng.rand(coordinates.high)]
        if r < l: swap(l, r)
        if u < d: swap(d, u)
        rectangles.add((l, d, r, u, mint.init(rng.rand(-1000..1000))))
    for i in 0..<120:
        var l = coordinates[rng.rand(coordinates.high)]
        var r = coordinates[rng.rand(coordinates.high)]
        var d = coordinates[rng.rand(coordinates.high)]
        var u = coordinates[rng.rand(coordinates.high)]
        if r < l: swap(l, r)
        if u < d: swap(d, u)
        queries.add((l, d, r, u))
    let answers = static_rectangle_add_rectangle_sum(rectangles, queries)
    for i, q in queries:
        var expected: mint
        for rectangle in rectangles:
            let l = max(q[0], rectangle[0])
            let r = min(q[2], rectangle[2])
            let d = max(q[1], rectangle[1])
            let u = min(q[3], rectangle[3])
            if l < r and d < u:
                expected += rectangle[4] * (mint.init(r) - mint.init(l)) * (mint.init(u) - mint.init(d))
        doAssert answers[i] == expected

checkCoordinateType([low(int8), -1'i8, 0'i8, 1'i8, high(int8)])
checkCoordinateType([0'u8, 1'u8, 127'u8, 128'u8, high(uint8)])
checkCoordinateType([low(int16), -256'i16, -1'i16, 0'i16, 256'i16, high(int16)])
checkCoordinateType([0'u16, 1'u16, 255'u16, 256'u16, high(uint16)])
checkCoordinateType([low(int32), -2048'i32, -1'i32, 0'i32, 2048'i32, high(int32)])
checkCoordinateType([0'u32, 1'u32, 2047'u32, 2048'u32, high(uint32)])
checkCoordinateType([low(int64), low(int64) + 1, -1_000_000_000_000'i64, -1'i64,
    0'i64, 1'i64, 1_000_000_000_000'i64, high(int64) - 1, high(int64)])
checkCoordinateType([0'u64, 1'u64, 1'u64 shl 32, (1'u64 shl 63) - 1,
    1'u64 shl 63, high(uint64) - 1, high(uint64)])

echo "Hello World"
