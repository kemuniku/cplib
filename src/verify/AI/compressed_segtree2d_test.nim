# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/compressed_segtree2d
import random, algorithm

proc sum(a, b: int64): int64 = a + b

block:
    let empty = newCompressedSeg2DWith(newSeq[(int, int)](), l + r, 0)
    doAssert empty.len == 0 and empty.get_all() == 0
    doAssert empty.get(-10, 10, -10, 10) == 0
    doAssert empty[0, 0] == 0
    var rejected = false
    try: empty[0, 0] = 1
    except AssertionDefect: rejected = true
    doAssert rejected

block:
    let points = @[(0, 0), (0, 2), (2, 0), (2, 3), (4, 0), (4, 2), (4, 5), (0, 0)]
    let original = points
    let st = newCompressedSeg2DWith(points, min(l, r), high(int))
    doAssert points == original and st.len == 7
    doAssert st.get_all() == high(int)
    st[0, 0] = -10
    st[2, 0] = -20
    st[4, 0] = -30
    doAssert st.get(-1, 5, 0, 1) == -30
    st[4, 0] = 100
    doAssert st.get(-1, 5, 0, 1) == -20
    st[2, 0] = 200
    doAssert st.get_all() == -10
    doAssert st[2, 2] == high(int)
    for point in [(2, 2), (1, 0), (4, 3)]:
        var rejected = false
        try: st[point[0], point[1]] = -100
        except AssertionDefect: rejected = true
        doAssert rejected and st.get_all() == -10
    var rejected = false
    try: discard st.get(2, 1, 0, 1)
    except AssertionDefect: rejected = true
    doAssert rejected

block:
    var rng = initRand(20260917)
    for n in 0..65:
        var points: seq[(int, int)]
        for i in 0..<n: points.add((rng.rand(-8..8) * 3, rng.rand(-8..8) * 5))
        let original = points
        let ordinary = initCompressedSegmentTree2D(points, sum, 0'i64)
        let direct: CompressedSegmentTree2D[int, int64] = newCompressedSeg2DWith(points, l + r, 0'i64)
        doAssert points == original
        points.sort()
        var unique: seq[(int, int)]
        for p in points:
            if unique.len == 0 or unique[^1] != p: unique.add(p)
        for st in [ordinary, direct]:
            var values = newSeq[int64](unique.len)
            doAssert st.len == unique.len
            for step in 0..<400:
                if unique.len > 0 and rng.rand(2) != 0:
                    let i = rng.rand(unique.len - 1)
                    values[i] = int64(rng.rand(-1000..1000))
                    st[unique[i][0], unique[i][1]] = values[i]
                    doAssert st[unique[i][0], unique[i][1]] == values[i]
                var xl = rng.rand(-30..30)
                var xr = rng.rand(-30..30)
                var yl = rng.rand(-45..45)
                var yr = rng.rand(-45..45)
                if xr < xl: swap(xl, xr)
                if yr < yl: swap(yl, yr)
                var expected, total: int64
                for i, p in unique:
                    total += values[i]
                    if xl <= p[0] and p[0] < xr and yl <= p[1] and p[1] < yr:
                        expected += values[i]
                doAssert st.get(xl, xr, yl, yr) == expected
                doAssert st.get_all() == total
                doAssert st.get(xl, xl, yl, yr) == 0
                doAssert st.get(xl, xr, yl, yl) == 0

block:
    let st = newCompressedSeg2DWith(@[(low(int64), high(int64)), (high(int64), low(int64))], l + r, 0)
    st[low(int64), high(int64)] = 3
    st[high(int64), low(int64)] = 5
    doAssert st.get_all() == 8
    doAssert st.get(low(int64), high(int64), low(int64), high(int64)) == 0
    doAssert st[low(int64), high(int64)] == 3
    let generic = newCompressedSeg2DWith(@[("a", "b"), ("c", "b")], l + r, 0)
    generic["a", "b"] = 7
    doAssert generic.get("a", "c", "a", "z") == 7

block:
    proc make(modulus: int): CompressedSegmentTree2D[int, int] =
        newCompressedSeg2DWith(@[(0, 0), (1, 0), (1, 1)], (l + r) mod modulus, 0)
    let a = make(7)
    let b = make(11)
    for st in [a, b]:
        st[0, 0] = 5
        st[1, 0] = 6
        st[1, 1] = 4
    doAssert a.get_all() == 1 and b.get_all() == 4
    doAssert a.get(0, 2, 0, 1) == 4 and b.get(0, 2, 0, 1) == 0

echo "Hello World"
