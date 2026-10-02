# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/collections/range_linear_add_range_min

proc checkAll(seg: RangeLinearAddRangeMin, a: seq[int]) =
    doAssert seg.len == a.len
    for l in 0..a.len:
        var expected = high(int)
        doAssert seg.prod(l, l) == expected
        for r in l + 1..a.len:
            expected = min(expected, a[r - 1])
            doAssert seg.prod(l, r) == expected
            doAssert seg[l..<r] == expected
    for i in 0..<a.len:
        doAssert seg[i] == a[i]

proc apply(seg: RangeLinearAddRangeMin, a: var seq[int], l, r, b, c: int) =
    seg.add(l, r, b, c)
    for i in l..<r:
        a[i] += b * i + c

let empty = initRangeLinearAddRangeMin(newSeq[int]())
empty.add(0..<0, 1, 2)
checkAll(empty, @[])

var rng = initRand(20260908)
for n in [1, 2, 3, 5, 8, 13, 16, 31, 32, 33, 65]:
    for shape in 0..4:
        var a = newSeq[int](n)
        for i in 0..<n:
            a[i] = case shape
                of 0: 0
                of 1: 13 * i - 100
                of 2: i * i
                of 3: -i * i
                else: rng.rand(-1000..1000)
        let seg = initRangeLinearAddRangeMin(a)
        checkAll(seg, a)
        for step in 0..<150:
            var l = rng.rand(0..n)
            var r = rng.rand(0..n)
            if l > r: swap(l, r)
            if step mod 5 == 0:
                l = 0
                r = n
            let b = rng.rand(-100..100)
            let c = rng.rand(-1000..1000)
            apply(seg, a, l, r, b, c)
            if step mod 10 == 0:
                checkAll(seg, a)
            else:
                let x = rng.rand(0..<n)
                let y = rng.rand(x + 1..n)
                var expected = high(int)
                for i in x..<y: expected = min(expected, a[i])
                doAssert seg.prod(x..<y) == expected
        checkAll(seg, a)

block:
    var a = @[high(int) - 100, low(int) + 100, high(int) - 200,
              low(int) + 200, 0, high(int) - 300, low(int) + 300]
    let seg = initRangeLinearAddRangeMin(a)
    checkAll(seg, a)
    apply(seg, a, 0, a.len, 1, -5)
    checkAll(seg, a)
    apply(seg, a, 1, 6, -2, 10)
    checkAll(seg, a)

block:
    var a = newSeq[int](129)
    let seg = initRangeLinearAddRangeMin(a)
    for step in 0..<2000:
        seg.add(0..<a.len, 99, 9_999_999)
        for i in 0..<a.len: a[i] += 99 * i + 9_999_999
    apply(seg, a, 1, 128, -1_000_000, -1_000_000_000_000.int)
    checkAll(seg, a)

block:
    var rng = initRand(68391)
    for trial in 0..<400:
        let n = rng.rand(1..257)
        var a = newSeq[int](n)
        for i in 0..<n:
            a[i] = if trial mod 3 == 0:
                (if i mod 2 == 0: high(int) - 1_000_000_000 else: low(int) + 1_000_000_000)
                else: rng.rand(-1_000_000_000..1_000_000_000)
        let seg = initRangeLinearAddRangeMin(a)
        for step in 0..<300:
            var l = rng.rand(0..n)
            var r = rng.rand(0..n)
            if l > r: swap(l, r)
            case step mod 7
            of 0: l = 0; r = n
            of 1: r = min(l + 1, n)
            of 2: l = min(1, n); r = max(l, n - 1)
            else: discard
            let b = if step mod 5 == 0: 0 else: rng.rand(-99..99)
            let c = rng.rand(-9999..9999)
            if step mod 2 == 0: seg.add(l..<r, b, c)
            else: seg.add(l, r, b, c)
            for i in l..<r: a[i] += b * i + c
            var expected = high(int)
            for i in l..<r: expected = min(expected, a[i])
            doAssert seg.prod(l, r) == expected
            let x = rng.rand(0..<n)
            let y = rng.rand(x + 1..n)
            expected = high(int)
            for i in x..<y: expected = min(expected, a[i])
            doAssert seg.prod(x, y) == expected
            doAssert seg[^1] == a[^1]
        if n < 20: checkAll(seg, a)

block:
    let n = 100_000
    let seg = initRangeLinearAddRangeMin(newSeq[int](n))
    for step in 0..<100_000: seg.add(0, n, -99, -9_999_999)
    doAssert seg.prod(0, n) == 100_000 * (-99 * (n - 1) - 9_999_999)
    seg.add(1, n - 1, 99, 9_999_999)
    doAssert seg[1] == 99_999 * (-99 - 9_999_999)
    doAssert seg[^1] == 100_000 * (-99 * (n - 1) - 9_999_999)
    seg.add(n - 1, n, 0, 0)
    doAssert seg.prod(0, 0) == high(int)

block:
    let half = high(int) div 2
    let seg = initRangeLinearAddRangeMin([0, 0])
    seg.add(0, 2, -half, 0)
    seg.add(0, 1, 1, 0)
    seg.add(0, 2, high(int), 0)
    doAssert seg.prod(0, 2) == 0
    seg.add(0, 1, 0, 0)
    seg.add(0, 2, 1, 0)
    doAssert seg[0] == 0
    doAssert seg[1] == high(int) - half + 1

echo "Hello World"
