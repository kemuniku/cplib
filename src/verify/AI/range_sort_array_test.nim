# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, random
import cplib/collections/range_sort_array
import cplib/collections/range_sort_segtree

proc check(a: RangeSortArray, expected: seq[int]) =
    doAssert a.len == expected.len
    doAssert a.toSeq() == expected
    var actual: seq[int]
    for value in a.items: actual.add(value)
    doAssert actual == expected
    for i, value in expected:
        doAssert a[i] == value
        doAssert a.get(i) == value
        doAssert a.key(i) == value
        doAssert a[^(a.len - i)] == value

block:
    let a = initRangeSortArray([], 0)
    a.sort(0, 0)
    a.sort(0..<0, Descending)
    a.check(@[])

block:
    let a = initRangeSortArray([0], 1)
    a.sort(0, 1)
    a.sort(0..<1, Descending)
    a[^1] = 0
    a.check(@[0])

block:
    let a = initRangeSortArray([3, 1, 2], 5)
    a.sort(0, 3)
    a.check(@[1, 2, 3])
    a.sort(0..<2, Descending)
    a.check(@[2, 1, 3])
    a[^1] = 4
    a.check(@[2, 1, 4])
    let seg = initRangeSortSegmentTree([1, 0], ["a", "b"], 2,
        proc(x, y: string): string = x & y, "")
    seg.sort(0, 2)
    doAssert seg.get_all() == "ba"

var rng = initRand(20260928)
for n in [1, 2, 3, 7, 16, 31, 64]:
    for mode in 0..2:
        let limit = if mode == 0: n * 4 + 7 else: int.high
        let base = if mode == 2: int.high - n * 4 - 7 else: 0
        var expected = newSeq[int](n)
        for i in 0..<n:
            expected[i] = base + (2 * i + 1) *
                (if mode == 1: int.high div (n * 4 + 7) else: 1)
        rng.shuffle(expected)
        let a = initRangeSortArray(expected, limit)
        a.check(expected)
        for step in 0..<1500:
            case rng.rand(3)
            of 0, 1:
                var l = rng.rand(n)
                var r = rng.rand(n)
                if l > r: swap(l, r)
                if step mod 5 == 0:
                    l = 0
                    r = n
                let order = if step mod 2 == 0: Ascending else: Descending
                var part = expected[l..<r]
                part.sort(order)
                for i, value in part: expected[l + i] = value
                if step mod 2 == 0: a.sort(l, r, order)
                else: a.sort(l..<r, order)
            else:
                let index = rng.rand(n - 1)
                var value = base + rng.rand(limit - base - 1)
                while value != expected[index] and value in expected:
                    value = base + rng.rand(limit - base - 1)
                case step mod 3
                of 0: a.update(index, value)
                of 1: a[index] = value
                else: a[^(n - index)] = value
                expected[index] = value
            a.check(expected)

block:
    let a = initRangeSortArray([int.high - 1, 0, 1, int.high div 2], int.high)
    for _ in 0..<1000:
        a.sort(0, 4)
        a.check(@[0, 1, int.high div 2, int.high - 1])
        a.sort(1, 3, Descending)
        a.check(@[0, int.high div 2, 1, int.high - 1])
        a.sort(0, 4, Descending)
        a.check(@[int.high - 1, int.high div 2, 1, 0])

when compileOption("assertions"):
    block:
        var rejected = false
        try:
            discard initRangeSortArray([1, 1], 2)
        except AssertionDefect:
            rejected = true
        doAssert rejected
    block:
        let a = initRangeSortArray([0, 1, 2], 4)
        a.sort(0, 3, Descending)
        for value in [-1, 2, 4]:
            var rejected = false
            try:
                a[1] = value
            except AssertionDefect:
                rejected = true
            doAssert rejected
            a.check(@[2, 1, 0])
        a[1] = 1
        a[1] = 3
        a.check(@[2, 3, 0])

echo "Hello World"
