# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/dynamic_quaternary_waveletmatrix_sum
import cplib/collections/dynamic_quaternary_waveletmatrix
import cplib/collections/dynamic_quaternary_vector
import cplib/collections/dynamic_bplus_kernels
import algorithm, random

static:
    doAssert not compiles(initDynamicQuadWaveletMatrix(@[1], with_sum=true))
    doAssert not compiles(initDynamicQuadWaveletMatrixFast(@[1]).sum_largest(0, 1, 1))

proc expectedMinCount(part: openArray[int], target: int, largest: bool): int =
    if target <= 0: return 0
    var sum = 0
    for count in 1..part.len:
        let i = if largest: part.len-count else: count-1
        sum += part[i]
        if sum >= target: return count
    -1

proc checkMinCounts[W](w: W, l, r: int, part: seq[int], target: int) =
    let largest = expectedMinCount(part, target, true)
    doAssert w.min_count_largest_for_sum(l, r, target) == largest
    doAssert w.min_count_for_sum(l, r, target) == largest
    doAssert w.min_count_smallest_for_sum(l, r, target) == expectedMinCount(part, target, false)

proc audit[W](w: W, a: seq[int], rng: var Rand, nonnegative: bool) =
    w.validate()
    doAssert w.len == a.len
    for trial in 0..<20:
        let l = if trial == 0: 0 else: rng.rand(a.len)
        let r = if trial == 0: a.len else: l+rng.rand(a.len-l)
        let part = sorted(a[l..<r])
        var prefix = newSeq[int](part.len+1)
        for i, x in part: prefix[i+1] = prefix[i]+x
        doAssert w.range_sum(l, r) == prefix[^1]
        for k in [0, part.len div 2, part.len]:
            doAssert w.sum_smallest(l, r, k) == prefix[k]
            doAssert w.sum_largest(l, r, k) == prefix[^1]-prefix[part.len-k]
            doAssert w.sum_smallest_with_count(l, r, k) == (prefix[k], k)
            doAssert w.sum_largest_with_count(l, r, k) == (prefix[^1]-prefix[part.len-k], k)
            if nonnegative:
                for boundary in [prefix[k], prefix[^1]-prefix[part.len-k]]:
                    for target in [boundary-1, boundary, boundary+1]:
                        checkMinCounts(w, l, r, part, target)
        if nonnegative:
            let target = rng.rand(prefix[^1]+1)
            checkMinCounts(w, l, r, part, target)
        if l < r:
            doAssert w[l] == a[l]
            doAssert w.kth_largest(l, r, 0) == part[^1]
            doAssert w.kth_smallest(l, r, part.len div 2) == part[part.len div 2]
        for x in [int.low, -1, 0, 1, rng.rand(1000)-500, int.high]:
            let lower = part.lowerBound(x)
            let upper = part.upperBound(x)
            doAssert w.sum_lowerbound_with_count(l, r, x) == (prefix[lower], lower)
            doAssert w.sum_upperbound_with_count(l, r, x) == (prefix[upper], upper)
            doAssert w.sum_lowerbound(l, r, x) == prefix[lower]
            doAssert w.sum_upperbound(l, r, x) == prefix[upper]
            doAssert w.range_lowerbound(l, r, x) == lower
        for bounds in [(int.low, int.high), (-100, 100), (0, 0), (1, -1)]:
            let (lo, hi) = bounds
            let count = if lo >= hi: 0 else: part.lowerBound(hi)-part.lowerBound(lo)
            let sum = if lo >= hi: 0 else: prefix[part.lowerBound(hi)]-prefix[part.lowerBound(lo)]
            doAssert w.range_sum_with_count(l, r, lo, hi) == (sum, count)
            doAssert w.range_sum(l, r, lo, hi) == sum

proc exercise[W](w: W, initial: seq[int], low, high: int, seed: int) =
    var a = initial
    var rng = initRand(seed)
    audit(w, a, rng, low >= 0)
    for step in 0..<400:
        let kind = if a.len == 0: 0 else: step mod 4
        let p = rng.rand(a.len-int(kind != 0))
        let x = low+rng.rand(high-low)
        case kind
        of 0:
            w.insert(p, x)
            a.insert(x, p)
        of 1:
            doAssert w.erase(p) == a[p]
            a.delete(p)
        else:
            let x = if kind == 3: a[p] else: x
            w[p] = x
            a[p] = x
        if step mod 47 == 0: audit(w, a, rng, low >= 0)
    audit(w, a, rng, low >= 0)
    while a.len > 0:
        let p = rng.rand(a.len-1)
        doAssert w.erase(p) == a[p]
        a.delete(p)
    audit(w, a, rng, low >= 0)
    for i in 0..<260:
        let x = low+rng.rand(high-low)
        w.insert(0, x)
        a.insert(x, 0)
    audit(w, a, rng, low >= 0)

for signed in [false, true]:
    for width in [0, 1, 3, 10, 30, 63, 64]:
        if signed and width == 0 or not signed and width == 64: continue
        let low = if signed: -min(500, 1 shl min(width-1, 10)) else: 0
        let high = min(500, (1 shl min(width-int(signed), 10))-1)
        var rng = initRand(width+int(signed))
        var a = newSeq[int](if width == 10: 2200 else: 40)
        for x in a.mitems: x = low+rng.rand(high-low)
        exercise(initDynamicQuadWaveletMatrixSum(a, H=width, signedValues=signed), a, low, high, 467)
        exercise(initDynamicQuadWaveletMatrixSumFast(a, H=width, signedValues=signed), a, low, high, 468)
        exercise(initDynamicQuadWaveletMatrixSum(a, QuadVector[4, 1], H=width, signedValues=signed), a, low, high, 469)

for kernel in [bpkScalar, bpkAvx2, bpkAvx512]:
    var rng = initRand(831)
    let a = @[int.low, int.high]
    let w = initDynamicQuadWaveletMatrixSumFast(a, H=64, signedValues=true, kernel=kernel)
    doAssert w.range_sum(0, 2) == -1
    doAssert w.sum_largest(0, 2, 1) == int.high
    doAssert w.sum_smallest(0, 2, 1) == int.low
    doAssert w.sum_upperbound_with_count(0, 2, int.high) == (-1, 2)
    doAssert w.range_sum(0, 2, int.low, int.high) == int.low
    w.validate()

block:
    var rng = initRand(80176113)
    var a = newSeq[int](257)
    for x in a.mitems: x = rng.rand(999999999)+1
    let w = initDynamicQuadWaveletMatrixSumFast(a, H=30)
    for step in 0..<100:
        let p = rng.rand(a.len-1)
        let x = rng.rand(999999999)+1
        case step mod 4
        of 0:
            w[p] = x
            a[p] = x
        of 1:
            w.insert(p, x)
            a.insert(x, p)
        of 2:
            doAssert w.erase(p) == a[p]
            a.delete(p)
        else: w[p] = a[p]
        for bounds in [(0, a.len), (13, a.len-7), (0, a.len)]:
            let (l, r) = bounds
            let part = sorted(a[l..<r])
            var prefix = newSeq[int](part.len+1)
            for i, value in part: prefix[i+1] = prefix[i]+value
            for k in 0..part.len:
                doAssert w.sum_smallest(l, r, k) == prefix[k]
                doAssert w.sum_largest(l, r, k) == prefix[^1]-prefix[part.len-k]
                for boundary in [prefix[k], prefix[^1]-prefix[part.len-k]]:
                    for target in [boundary-1, boundary, boundary+1]:
                        checkMinCounts(w, l, r, part, target)
    w.validate()

block:
    let w = initDynamicQuadWaveletMatrixSumFast(@[0, 3, 0, 10, 3])
    doAssert w.min_count_smallest_for_sum(0, 5, 0) == 0
    doAssert w.min_count_smallest_for_sum(0, 5, 3) == 3
    doAssert w.min_count_smallest_for_sum(0, 5, 6) == 4
    doAssert w.min_count_smallest_for_sum(0, 5, 7) == 5
    doAssert w.min_count_largest_for_sum(0, 5, 7) == 1
    doAssert w.min_count_smallest_for_sum(0, 5, 17) == -1

var edgeCases = @[newSeq[int](), @[0, 0, 0], @[7, 7, 7], @[0, 5, 0, 5, 0],
        @[9, 8, 1, 0], @[0, int.high-1, 1], @[int.high div 2, int.high div 2]]
for shift in [2, 16, 32, 60]:
    let base = 1 shl shift
    edgeCases.add(@[0, base, base+1, base+2, base+3])
for a in edgeCases:
    let w = initDynamicQuadWaveletMatrixSumFast(a)
    for l in 0..a.len:
        for r in l..a.len:
            let part = sorted(a[l..<r])
            var targets = @[int.low, -1, 0, 1, int.high-2, int.high-1, int.high]
            for largest in [false, true]:
                var sum = 0
                for count in 1..part.len:
                    let i = if largest: part.len-count else: count-1
                    sum += part[i]
                    targets.add(sum)
                    if sum > 0: targets.add(sum-1)
                    if sum < int.high: targets.add(sum+1)
            for target in targets:
                checkMinCounts(w, l, r, part, target)
echo "Hello World"
