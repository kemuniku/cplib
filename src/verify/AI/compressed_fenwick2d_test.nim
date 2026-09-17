# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/compressed_fenwick2d
import random, algorithm

block:
    let fw = initCompressedFenwick2D(@[(1'i64, 2'i64), (3'i64, 4'i64)])
    static: doAssert typeof(fw) is CompressedFenwick2D[int64, int]
    fw.add(1'i64, 2'i64, 10)
    fw[3'i64, 4'i64] = 20
    doAssert fw.get(0'i64, 4'i64, 0'i64, 5'i64) == 30
    let empty = initCompressedFenwick2D(newSeq[(int, int)]())
    static: doAssert typeof(empty) is CompressedFenwick2D[int, int]
    doAssert empty.get_all() == 0
    let fromArray = initCompressedFenwick2D([(1, 2), (3, 4)])
    static: doAssert typeof(fromArray) is CompressedFenwick2D[int, int]
    fromArray.add(1, 2, 7)
    doAssert fromArray.get_all() == 7
    let wide = initCompressedFenwick2D[int, int64]([(1, 2)])
    static: doAssert typeof(wide) is CompressedFenwick2D[int, int64]
    wide.add(1, 2, 1'i64 shl 40)
    doAssert wide.get_all() == 1'i64 shl 40

block:
    let fw = initCompressedFenwick2D[int, int64](newSeq[(int, int)]())
    doAssert fw.len == 0 and fw.get_all() == 0
    doAssert fw.prefix(0, 0) == 0 and fw.getLess(-1, 1, 0) == 0
    doAssert fw.get(-10, 10, -10, 10) == 0 and fw[0, 0] == 0
    var rejected = false
    try: fw.add(0, 0, 1)
    except AssertionDefect: rejected = true
    doAssert rejected

block:
    let points = @[(0, 0), (1, 1), (2, 0), (2, 0), (3, 2)]
    let original = points
    let fw = initCompressedFenwick2D[int, int64](points)
    doAssert points == original and fw.len == 4
    fw.add(0, 0, 5)
    fw.add(1, 1, 7)
    fw.add(2, 0, -3)
    fw[3, 2] = 11
    doAssert fw.get_all() == 20
    for p in [(1, 0), (3, 0), (3, 1), (0, 1), (4, 2), (-1, 0)]:
        doAssert fw[p[0], p[1]] == 0
        var rejected = false
        try: fw.add(p[0], p[1], 100)
        except AssertionDefect: rejected = true
        doAssert rejected and fw.get_all() == 20
        rejected = false
        try: fw[p[0], p[1]] = 100
        except AssertionDefect: rejected = true
        doAssert rejected and fw.get_all() == 20
    doAssert fw[0, 0] == 5 and fw[1, 1] == 7 and fw[2, 0] == -3 and fw[3, 2] == 11
    for axis in 0..1:
        var rejected = false
        try:
            if axis == 0: discard fw.get(1, 0, 0, 1)
            else: discard fw.get(0, 1, 1, 0)
        except AssertionDefect: rejected = true
        doAssert rejected

block:
    var rng = initRand(20260918)
    for shape in 0..3:
        for n in 0..65:
            var points: seq[(int, int)]
            for i in 0..<n:
                case shape
                of 0: points.add((rng.rand(-10..10) * 3, rng.rand(-10..10) * 5))
                of 1: points.add((0, i - 30))
                of 2: points.add((i - 30, 0))
                else: points.add((i - 30, (i * 17 mod 67) - 30))
            let original = points
            let fw = initCompressedFenwick2D[int, int64](points)
            doAssert points == original
            points.sort()
            var unique: seq[(int, int)]
            for p in points:
                if unique.len == 0 or unique[^1] != p: unique.add(p)
            var values = newSeq[int64](unique.len)
            doAssert fw.len == unique.len
            for step in 0..<200:
                if unique.len > 0:
                    let i = rng.rand(unique.len - 1)
                    let delta = int64(rng.rand(-1000..1000))
                    if step mod 4 == 0:
                        fw[unique[i][0], unique[i][1]] = delta
                        values[i] = delta
                    else:
                        fw.add(unique[i][0], unique[i][1], delta)
                        values[i] += delta
                    doAssert fw[unique[i][0], unique[i][1]] == values[i]
                var xl = rng.rand(-40..40)
                var xr = rng.rand(-40..40)
                var yl = rng.rand(-55..55)
                var yr = rng.rand(-55..55)
                if xr < xl: swap(xl, xr)
                if yr < yl: swap(yl, yr)
                var expected, total, prefix, less, point: int64
                for i, p in unique:
                    total += values[i]
                    if p[0] < xr and p[1] < yr: prefix += values[i]
                    if xl <= p[0] and p[0] < xr and p[1] < yr: less += values[i]
                    if xl <= p[0] and p[0] < xr and yl <= p[1] and p[1] < yr:
                        expected += values[i]
                    if p == (xl, yl): point = values[i]
                doAssert fw.get(xl, xr, yl, yr) == expected
                doAssert fw.prefix(xr, yr) == prefix
                doAssert fw.getLess(xl, xr, yr) == less
                doAssert fw.get_all() == total
                doAssert fw[xl, yl] == point
                doAssert fw.get(xl, xl, yl, yr) == 0
                doAssert fw.get(xl, xr, yl, yl) == 0

block:
    let fw = initCompressedFenwick2D[int64, int64](@[
        (low(int64), high(int64)), (high(int64), low(int64)), (0'i64, 0'i64)])
    fw[low(int64), high(int64)] = 3
    fw[high(int64), low(int64)] = 5
    fw[0'i64, 0'i64] = 7
    doAssert fw.get_all() == 15
    doAssert fw.get(low(int64), high(int64), low(int64), high(int64)) == 7
    doAssert fw[low(int64), high(int64)] == 3
    doAssert fw[high(int64), low(int64)] == 5
    doAssert fw.prefix(high(int64), high(int64)) == 7
    let unsigned = initCompressedFenwick2D[uint64, int](@[(0'u64, high(uint64)), (high(uint64), 0'u64)])
    unsigned[high(uint64), 0'u64] = 9
    doAssert unsigned[high(uint64), 0'u64] == 9
    doAssert unsigned.get_all() == 9
    let generic = initCompressedFenwick2D[string, int](@[("a", "b"), ("c", "b")])
    generic.add("a", "b", 7)
    generic.add("c", "b", 11)
    doAssert generic.get("a", "c", "a", "z") == 7
    doAssert generic["c", "b"] == 11

type Pair = object
    a, b: int
proc `+=`(x: var Pair, y: Pair) =
    x.a += y.a
    x.b += y.b
proc `-`(x, y: Pair): Pair = Pair(a: x.a - y.a, b: x.b - y.b)
block:
    let fw = initCompressedFenwick2D[int, Pair](@[(0, 0), (1, 0)])
    fw.add(0, 0, Pair(a: 1, b: 10))
    fw.add(1, 0, Pair(a: 2, b: 20))
    doAssert fw.get(0, 2, 0, 1) == Pair(a: 3, b: 30)
    fw[1, 0] = Pair(a: 4, b: 5)
    doAssert fw.get_all() == Pair(a: 5, b: 15)

block:
    let points = @[(3, 4, 10), (1, 2, 7), (3, 4, -3), (1, 4, 5), (9, 9, 0), (8, 8, 3), (8, 8, -3)]
    let original = points
    let fw = initCompressedFenwick2D(points)
    static: doAssert typeof(fw) is CompressedFenwick2D[int, int]
    doAssert points == original and fw.len == 5
    doAssert fw[3, 4] == 7 and fw[1, 2] == 7 and fw[1, 4] == 5
    doAssert fw.get(0, 4, 0, 5) == 19 and fw.get_all() == 19
    fw.add(9, 9, 6)
    fw.add(8, 8, 2)
    fw[3, 4] = 20
    doAssert fw.get_all() == 40
    let fromArray = initCompressedFenwick2D([(1'i64, 2'i64, 1'i64 shl 40), (1'i64, 2'i64, 3'i64)])
    static: doAssert typeof(fromArray) is CompressedFenwick2D[int64, int64]
    doAssert fromArray[1'i64, 2'i64] == (1'i64 shl 40) + 3
    let explicit = initCompressedFenwick2D[int, int64](@[(1, 2, 7'i64), (1, 2, 9'i64)])
    static: doAssert typeof(explicit) is CompressedFenwick2D[int, int64]
    doAssert explicit.get_all() == 16
    let empty = initCompressedFenwick2D(newSeq[(int, int, int64)]())
    doAssert empty.len == 0 and empty.get_all() == 0
    doAssert empty.get(-1, 1, -1, 1) == 0
    let custom = initCompressedFenwick2D([("x", "y", Pair(a: 2, b: 3)), ("x", "y", Pair(a: 5, b: -3))])
    doAssert custom.len == 1 and custom["x", "y"] == Pair(a: 7, b: 0)

block:
    var rng = initRand(20260919)
    for n in 0..80:
        var points: seq[(int, int, int64)]
        var coords: seq[(int, int)]
        for i in 0..<n:
            let x = rng.rand(-8..8)
            let y = rng.rand(-8..8)
            points.add((x, y, int64(rng.rand(-100..100))))
            coords.add((x, y))
        let fw = initCompressedFenwick2D(points)
        let incremental = initCompressedFenwick2D[int, int64](coords)
        for p in points: incremental.add(p[0], p[1], p[2])
        doAssert fw.len == incremental.len and fw.get_all() == incremental.get_all()
        for p in points: doAssert fw[p[0], p[1]] == incremental[p[0], p[1]]
        for step in 0..<200:
            if n > 0:
                let p = points[rng.rand(n - 1)]
                let value = int64(rng.rand(-100..100))
                if step mod 2 == 0:
                    fw.add(p[0], p[1], value)
                    incremental.add(p[0], p[1], value)
                else:
                    fw[p[0], p[1]] = value
                    incremental[p[0], p[1]] = value
                doAssert fw[p[0], p[1]] == incremental[p[0], p[1]]
            var xl = rng.rand(-10..10)
            var xr = rng.rand(-10..10)
            var yl = rng.rand(-10..10)
            var yr = rng.rand(-10..10)
            if xr < xl: swap(xl, xr)
            if yr < yl: swap(yl, yr)
            doAssert fw.get(xl, xr, yl, yr) == incremental.get(xl, xr, yl, yr)
            doAssert fw.prefix(xr, yr) == incremental.prefix(xr, yr)
            doAssert fw.getLess(xl, xr, yr) == incremental.getLess(xl, xr, yr)
            doAssert fw.get_all() == incremental.get_all()

echo "Hello World"
