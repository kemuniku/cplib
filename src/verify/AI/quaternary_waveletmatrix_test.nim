# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/quaternary_waveletmatrix
import cplib/collections/waveletmatrix
import algorithm, options, random

proc checkRange(a: seq[int], w: QuadWaveletMatrix, b: WaveletMatrix, l, r: int, withSum: bool, thresholds: seq[int]) =
    let values = sorted(a[l..<r])
    var prefix = newSeq[int](values.len+1)
    for k, x in values:
        doAssert w.kth_smallest(l, r, k) == x
        doAssert w.kth_largest(l, r, values.len-1-k) == x
        doAssert w.kth_smallest(l, r, k) == b.kth_smallest(l, r, k)
        if withSum: prefix[k+1] = prefix[k]+x
    if withSum:
        for k in 0..values.len:
            let small = prefix[k]
            let large = prefix[^1]-prefix[values.len-k]
            doAssert w.sum_smallest(l, r, k) == small
            doAssert w.sum_largest(l, r, k) == large
            doAssert w.sum_smallest_with_count(l, r, k) == (sum: small, count: k)
            doAssert w.sum_largest_with_count(l, r, k) == (sum: large, count: k)
    for x in thresholds:
        let less = lowerBound(values, x)
        let lessEqual = upperBound(values, x)
        doAssert w.range_lowerbound(l, r, x) == less
        doAssert w.range_upperbound(l, r, x) == lessEqual
        doAssert w.count(l, r, x) == lessEqual-less
        doAssert w.prev_value(l, r, x) == (if less == 0: none(int) else: some(values[less-1]))
        doAssert w.next_value(l, r, x) == (if less == values.len: none(int) else: some(values[less]))
        if withSum:
            doAssert w.sum_lowerbound(l, r, x) == prefix[less]
            doAssert w.sum_upperbound(l, r, x) == prefix[lessEqual]
            doAssert w.sum_lowerbound_with_count(l, r, x) == (sum: prefix[less], count: less)
            doAssert w.sum_upperbound_with_count(l, r, x) == (sum: prefix[lessEqual], count: lessEqual)
        for high in thresholds:
            let last = max(less, lowerBound(values, high))
            doAssert w.range_freq(l, r, x, high) == last-less
            if withSum:
                doAssert w.range_sum(l, r, x, high) == prefix[last]-prefix[less]
                doAssert w.range_sum_with_count(l, r, x, high) == (sum: prefix[last]-prefix[less], count: last-less)

proc check(a: seq[int], h: int, withSum: bool, rng: var Rand) =
    let w = initQuadWaveletMatrix(a, H=h, with_sum=withSum)
    let b = initWaveletMatrix(a, H=h, with_sum=withSum)
    var thresholds = @[int.low, -1, 0, 1, 2, 3, 4, 7, 8, 15, 16, 63, 64, 255, 256, int.high]
    for i in 0..<min(a.len, 4):
        let x = a[rng.rand(a.len-1)]
        thresholds.add(x)
        if x < int.high: thresholds.add(x+1)
    if a.len <= 8:
        for l in 0..a.len:
            for r in l..a.len:
                checkRange(a, w, b, l, r, withSum, thresholds)
    else:
        checkRange(a, w, b, 0, a.len, withSum, thresholds)
        for p in [0, 1, 63, 64, 65, a.len]:
            if p <= a.len:
                checkRange(a, w, b, p, p, withSum, thresholds)
                checkRange(a, w, b, 0, p, withSum, thresholds)
        for trial in 0..<12:
            let l = rng.rand(a.len)
            let r = l+rng.rand(a.len-l)
            checkRange(a, w, b, l, r, withSum, thresholds)

var rng = initRand(20261018)
for a in [newSeq[int](), @[0], @[0, 0, 0, 0], @[3, 1, 4, 1, 5, 9, 2, 6],
          @[7, 7, 7, 7], @[int.high], @[0, int.high-2, 1, 1]]:
    for h in [-1, sizeof(int)*8]:
        for withSum in [false, true]:
            check(a, h, withSum, rng)

for h in 0..sizeof(int)*8:
    let mask = if h >= sizeof(int)*8-1: int.high else: (1 shl h)-1
    var a = newSeq[int](rng.rand(8))
    for v in a.mitems: v = rng.rand(int.high) and mask
    check(a, h, h <= 30, rng)
    check(@[0, 0], h, true, rng)

for n in [63, 64, 65, 127, 128, 129, 257, 513]:
    for pattern in 0..3:
        var a = newSeq[int](n)
        for i in 0..<n:
            a[i] = case pattern
                   of 0: rng.rand(127)
                   of 1: rng.rand(1 shl 30)
                   of 2: (if i mod 17 == 0: rng.rand(65535) else: 12345)
                   else: 12345
        for h in [-1, 63, 64]:
            for withSum in [false, true]:
                check(a, h, withSum, rng)

for n in [0, 1, 63, 64, 65, 129]:
    var current = newSeq[int](n)
    for v in current.mitems: v = rng.rand(511)
    let w = initQuadWaveletMatrix(current, H=9)
    for h in countdown(4, 0):
        var next: seq[int]
        var offsets: array[4, int]
        for d in 0..3:
            offsets[d] = next.len
            for x in current:
                if ((x shr (2*h)) and 3) == d: next.add(x)
        for l in 0..n:
            let r = l+rng.rand(n-l)
            let children = w.get_child(h, l, r)
            for d in 0..3:
                var left = offsets[d]
                var right = offsets[d]
                for i in 0..<r:
                    if ((current[i] shr (2*h)) and 3) == d:
                        inc right
                        if i < l: inc left
                doAssert children.left[d] == left
                doAssert children.right[d] == right
        current = next

template rejects(body: untyped) =
    block:
        var caught = false
        try: body
        except AssertionDefect: caught = true
        doAssert caught

rejects: discard initQuadWaveletMatrix(@[-1])
rejects: discard initQuadWaveletMatrix(@[4], H=2)
rejects: discard initQuadWaveletMatrix(@[1], H=0)
rejects: discard initQuadWaveletMatrix(@[0], H= -2)
rejects: discard initQuadWaveletMatrix(@[0], H=sizeof(int)*8+1)
let disabled = initQuadWaveletMatrix(@[0])
rejects: discard disabled.sum_smallest(0, 1, 0)
rejects: discard disabled.sum_largest(0, 1, 0)
rejects: discard disabled.sum_lowerbound(0, 1, 0)
rejects: discard disabled.range_sum(0, 1, 0, 1)
let enabled = initQuadWaveletMatrix(@[1, 2], with_sum=true)
rejects: discard enabled.kth_smallest(0, 2, 2)
rejects: discard enabled.sum_smallest(0, 2, -1)
rejects: discard enabled.sum_largest(0, 2, 3)
rejects: discard enabled.range_freq(-1, 2, 0, 3)
echo "Hello World"
