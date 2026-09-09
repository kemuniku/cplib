# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/waveletmatrix
import algorithm, options, random

let wm = initWaveletMatrix(@[3, 1, 4, 1, 5, 9, 2, 6])
assert wm.kth_smallest(0, 8, 0) == 1
assert wm.kth_smallest(0, 8, 3) == 3
assert wm.kth_smallest(2, 6, 1) == 4
assert wm.range_lowerbound(0, 8, 4) == 4
assert wm.range_upperbound(0, 8, 4) == 5
assert wm.range_lowerbound(1, 5, 2) == 2
assert wm.range_upperbound(1, 5, 1) == 2
let child = wm.get_child(3, 0, 8)
assert child == (l0: 0, r0: 7, l1: 7, r1: 8)

let boundary = initWaveletMatrix(@[0, 7, 3, 7])
assert boundary.range_lowerbound(0, 4, 8) == 4
assert boundary.range_lowerbound(1, 4, 9) == 3
assert boundary.range_lowerbound(0, 4, int.high) == 4
assert boundary.range_lowerbound(0, 4, -1) == 0

let empty = initWaveletMatrix(@[])
assert empty.range_lowerbound(0, 0, 10) == 0

assert boundary.range_upperbound(0, 4, -1) == 0
assert boundary.count(0, 4, -1) == 0
assert boundary.prev_value(0, 4, 3) == some(0)
assert boundary.next_value(0, 4, 3) == some(3)
assert boundary.prev_value(0, 4, 0) == none(int)
assert boundary.next_value(0, 4, 8) == none(int)
assert boundary.range_freq(0, 4, 3, 7) == 1
assert boundary.count(0, 4, 7) == 2
assert boundary.kth_largest(0, 4, 0) == 7

let withSum = initWaveletMatrix(@[3, 1, 4, 1, 5, 9, 2, 6], with_sum=true)
assert withSum.sum_smallest(0, 8, 0) == 0
assert withSum.sum_smallest(0, 8, 4) == 7
assert withSum.sum_smallest(0, 8, 8) == 31
assert withSum.sum_smallest(2, 6, 3) == 10
assert withSum.sum_smallest(3, 3, 0) == 0

proc checkRange(a: seq[int], wm: WaveletMatrix, l, r: int, withSum: bool) =
    let values = sorted(a[l..<r])
    var total = 0
    if withSum:
        assert wm.sum_smallest(l, r, 0) == 0
    for k, x in values:
        assert wm.kth_smallest(l, r, k) == x
        assert wm.kth_largest(l, r, k) == values[values.len-1-k]
        total += x
        if withSum:
            assert wm.sum_smallest(l, r, k+1) == total
    let thresholds = @[int.low, -1, 0, 1, 2, 3, 7, 8, 15, 16, 63, 64, 127, 128, int.high]
    for x in thresholds:
        var less, lessEqual, equal = 0
        var prev, next = none(int)
        for v in values:
            if v < x:
                inc less
                prev = some(v)
            elif next.isNone:
                next = some(v)
            if v <= x:
                inc lessEqual
            if v == x:
                inc equal
        assert wm.range_lowerbound(l, r, x) == less
        assert wm.range_upperbound(l, r, x) == lessEqual
        assert wm.count(l, r, x) == equal
        assert wm.prev_value(l, r, x) == prev
        assert wm.next_value(l, r, x) == next
        for high in thresholds:
            var freq = 0
            for v in values:
                if x <= v and v < high:
                    inc freq
            assert wm.range_freq(l, r, x, high) == freq

proc checkAll(a: seq[int], h: int = -1) =
    for withSum in [false, true]:
        let wm = initWaveletMatrix(a, H=h, with_sum=withSum)
        for l in 0..a.len:
            for r in l..a.len:
                checkRange(a, wm, l, r, withSum)

checkAll(@[])
checkAll(@[], 8)
checkAll(@[0])
checkAll(@[0, 0, 0, 0])
checkAll(@[0, 0, 0, 0], 0)
checkAll(@[7, 7, 7, 7])
checkAll(@[3, 1, 4, 1, 5, 9, 2, 6])
checkAll(@[0, 7, 3, 7], 10)
checkAll(@[int.high])
checkAll(@[0, int.high-2, 1, 1])

var rng = initRand(20260909)
for trial in 0..<30:
    var a = newSeq[int](rng.rand(12))
    for v in a.mitems:
        v = rng.rand(127)
    checkAll(a)

for n in [63, 64, 65, 127, 128, 129]:
    var a = newSeq[int](n)
    for v in a.mitems:
        v = rng.rand(127)
    for withSum in [false, true]:
        let wm = initWaveletMatrix(a, with_sum=withSum)
        checkRange(a, wm, 0, n, withSum)
        checkRange(a, wm, n, n, withSum)
        for trial in 0..<20:
            let l = rng.rand(n)
            let r = l + rng.rand(n-l)
            checkRange(a, wm, l, r, withSum)
