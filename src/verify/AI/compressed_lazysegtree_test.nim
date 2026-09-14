# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/compressed_lazysegtree
import random

type
    S = tuple[sum, size: int64]
    F = tuple[a, b: int64]
proc merge(x, y: S): S = (x.sum + y.sum, x.size + y.size)
proc mapping(f: F, x: S): S = (f.a * x.sum + f.b * x.size, x.size)
proc composition(f, g: F): F = (f.a * g.a, f.a * g.b + f.b)
proc pointInitial(x: int): S = (0'i64, 1'i64)
proc intervalInitial(l, r: int): S = (0'i64, int64(r - l))
const zero: S = (0'i64, 0'i64)
const id: F = (1'i64, 0'i64)

block:
    let st = initCompressedLazySegmentTree([9, -100, 9, 100], merge, zero,
        mapping, composition, id, pointInitial)
    doAssert st.len == 3
    st.apply(-1000, 1000, (1'i64, 3'i64))
    st.apply(-99, 101, (2'i64, 1'i64))
    doAssert st.get_all() == (17'i64, 3'i64)
    doAssert st[-100] == (3'i64, 1'i64)
    doAssert st[9] == (7'i64, 1'i64)
    doAssert st[8] == zero
    st[9] = (20'i64, 1'i64)
    doAssert st.get(-99, 100) == (20'i64, 1'i64)
    var rejected = false
    try: st[8] = zero
    except AssertionDefect: rejected = true
    doAssert rejected

block:
    let st = initCompressedLazySegmentTree([1000000000000'i64, -1000000000000'i64, 0'i64],
        merge, zero, mapping, composition, id,
        proc(l, r: int64): S = (0'i64, r - l))
    st.apply(-1000000000000'i64, 1000000000000'i64, (1'i64, 3'i64))
    st.apply(0'i64, 1000000000000'i64, (2'i64, 1'i64))
    doAssert st.len == 2
    doAssert st.get_all() == (10000000000000'i64, 2000000000000'i64)
    doAssert st[0'i64] == (7000000000000'i64, 1000000000000'i64)
    var rejected = false
    try: discard st.get(-1'i64, 0'i64)
    except AssertionDefect: rejected = true
    doAssert rejected
    rejected = false
    try: st.apply(-1'i64, 0'i64, id)
    except AssertionDefect: rejected = true
    doAssert rejected
    rejected = false
    try: st[1000000000000'i64] = zero
    except AssertionDefect: rejected = true
    doAssert rejected

block:
    let empty = initCompressedLazySegmentTree(newSeq[int](), merge, zero, mapping, composition, id)
    empty.apply(-10, 10, (1'i64, 5'i64))
    doAssert empty.len == 0 and empty.get_all() == zero
    doAssert empty.get(-10, 10) == zero and empty[0] == zero
    let intervals = initCompressedLazySegmentTree(newSeq[int](), merge, zero,
        mapping, composition, id, intervalInitial)
    doAssert intervals.len == 0 and intervals.get_all() == zero
    let single = initCompressedLazySegmentTree([5, 5], merge, zero,
        mapping, composition, id, intervalInitial)
    single.apply(5, 5, (0'i64, 9'i64))
    doAssert single.len == 0 and single.get(5, 5) == zero

block:
    var rng = initRand(20260914)
    for n in 1..30:
        var coords = @[-100]
        for i in 0..<n: coords.add(coords[^1] + rng.rand(1..9))
        let points = initCompressedLazySegmentTree(coords, merge, zero,
            mapping, composition, id, pointInitial)
        let intervals = initCompressedLazySegmentTree(coords, merge, zero,
            mapping, composition, id, intervalInitial)
        var pointValues = newSeq[int64](coords.len)
        var denseValues = newSeq[int64](coords[^1] - coords[0])
        for step in 0..<400:
            var a = rng.rand(n)
            var b = rng.rand(n)
            if b < a: swap(a, b)
            let l = coords[a]
            let r = coords[b]
            case rng.rand(2)
            of 0:
                let f: F = (int64(rng.rand(0..1)), int64(rng.rand(-5..5)))
                points.apply(l, r, f)
                intervals.apply(l, r, f)
                for i in a..<b: pointValues[i] = f.a * pointValues[i] + f.b
                for i in l..<r:
                    denseValues[i - coords[0]] = f.a * denseValues[i - coords[0]] + f.b
            of 1:
                let value = int64(rng.rand(-10..10))
                points[coords[a]] = (value, 1'i64)
                pointValues[a] = value
                if a < n:
                    intervals[coords[a]] = (value * int64(coords[a + 1] - coords[a]), int64(coords[a + 1] - coords[a]))
                    for x in coords[a]..<coords[a + 1]: denseValues[x - coords[0]] = value
            else: discard
            var expectedPoints, expectedDense: S
            for i in a..<b: expectedPoints = merge(expectedPoints, (pointValues[i], 1'i64))
            for x in l..<r: expectedDense = merge(expectedDense, (denseValues[x - coords[0]], 1'i64))
            doAssert points.get(l, r) == expectedPoints
            doAssert intervals.get(l, r) == expectedDense
            var totalPoints, totalDense: S
            for v in pointValues: totalPoints = merge(totalPoints, (v, 1'i64))
            for v in denseValues: totalDense = merge(totalDense, (v, 1'i64))
            doAssert points.get_all() == totalPoints
            doAssert intervals.get_all() == totalDense
            doAssert points[coords[a]] == (pointValues[a], 1'i64)

echo "Hello World"
