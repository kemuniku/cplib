# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/dynamic_quaternary_waveletmatrix
import cplib/collections/dynamic_quaternary_waveletmatrix_sum
import algorithm, options, random

template rejects(error: typedesc, body: untyped) =
    block:
        var caught = false
        try: body
        except error: caught = true
        doAssert caught

proc audit[W](w: W, a: seq[int], p: int, withSum: static bool = false) =
    w.validate()
    doAssert w.len == a.len
    let position = min(p, a.len)
    if a.len <= 128:
        for i, x in a: doAssert w.access(i) == x
    else:
        for i in [0, 31, 32, 511, 512, position - 1, position, a.len - 1]:
            if 0 <= i and i < a.len: doAssert w[i] == a[i]
    let sample = if position < a.len: a[position] else: 0
    for x in [int.low, 0, sample, int.high]:
        var count, before = 0
        for i, y in a:
            if y == x:
                doAssert w.select(count, x) == i
                inc count
                if i < position: inc before
        doAssert w.rank(position, x) == before
        doAssert w.rank(a.len, x) == count
        doAssert w.select(-1, x) == -1
        doAssert w.select(count, x) == -1
    for bounds in [(0, a.len), (max(0, position - 7), min(a.len, position + 8)),
                   (position, position)]:
        let (l, r) = bounds
        var part = a[l..<r]
        part.sort()
        for x in [int.low, 0, sample, int.high]:
            var equal, lower, upper, lowerSum, upperSum: int
            var previous, following: Option[int]
            for y in part:
                if y == x: inc equal
                if y < x:
                    inc lower
                    previous = some(y)
                    when withSum: lowerSum += y
                if y <= x:
                    inc upper
                    when withSum: upperSum += y
                if y >= x and following.isNone: following = some(y)
            doAssert w.count(l, r, x) == equal
            doAssert w.range_lowerbound(l, r, x) == lower
            doAssert w.range_upperbound(l, r, x) == upper
            doAssert w.prev_value(l, r, x) == previous
            doAssert w.next_value(l, r, x) == following
            if x < int.high: doAssert w.range_freq(l, r, x, x + 1) == equal
            doAssert w.range_freq(l, r, x, x) == 0
            when withSum:
                doAssert w.sum_lowerbound_with_count(l, r, x) == (lowerSum, lower)
                doAssert w.sum_upperbound_with_count(l, r, x) == (upperSum, upper)
        if part.len > 0:
            for k in [0, part.len div 2, part.len - 1]:
                doAssert w.kth_smallest(l, r, k) == part[k]
                doAssert w.kth_largest(l, r, k) == part[part.len - 1 - k]
        when withSum:
            var sum = 0
            doAssert w.sum_smallest_with_count(l, r, 0) == (0, 0)
            for i, x in part:
                sum += x
                doAssert w.sum_smallest_with_count(l, r, i + 1) == (sum, i + 1)
            var expected = 0
            var count = 0
            for x in part:
                if -4 <= x and x < 5:
                    expected += x
                    inc count
            doAssert w.range_sum_with_count(l, r, -4, 5) == (expected, count)

proc run(width: int, signed: bool, withSum: static bool, n: int) =
    let low = if not signed: 0 elif width == 64: int.low else: -(1 shl (width - 1))
    let high = if width == 64: int.high elif signed: (1 shl (width - 1)) - 1 else: (1 shl width) - 1
    var rng = initRand(73317 + width + n)
    proc value(step: int): int =
        when withSum:
            return (if signed: rng.rand(14) - 7 else: rng.rand(7))
        case step mod 5
        of 0: low
        of 1: high
        of 2: 0
        else:
            if width == 64:
                let x = rng.rand(int.high)
                if step mod 2 == 0: x else: not x
            else: low + rng.rand(high - low)
    var a = newSeq[int](n)
    for i in 0..<n: a[i] = value(i)
    # 同じimportだけで通常型とFast型が共存することも確認する。
    let normal = (when withSum: initDynamicQuadWaveletMatrixSum(a, width, signedValues = signed)
        else: initDynamicQuadWaveletMatrix(a, width, signedValues = signed))
    let fast = (when withSum: initDynamicQuadWaveletMatrixSumFast(a, H = width, signedValues = signed)
        else: initDynamicQuadWaveletMatrixFast(a, H = width, signedValues = signed))
    audit(normal, a, 0, withSum)
    audit(fast, a, 0, withSum)
    let steps = if n > 8192: 60 elif defined(dynamicWmFullTest): 240 else: 48
    for step in 0..<steps:
        let kind = if a.len == 0: 0 else: step mod 4
        let limit = a.len - int(kind != 0)
        let points = [0, 31, 32, 33, 511, 512, 513, (n + 1) div 2,
                      8191, 8192, 8193, limit]
        # 4種類の更新と12境界の対応を巡回ごとにずらす。
        let p = min(points[(step + step div 4) mod points.len], limit)
        let x = value(step + 11)
        case kind
        of 0:
            normal.insert(p, x)
            fast.insert(p, x)
            a.insert(x, p)
        of 1:
            doAssert normal.erase(p) == a[p]
            doAssert fast.erase(p) == a[p]
            a.delete(p)
        else:
            let replacement = if kind == 3: a[p] elif x != a[p]: x
                elif withSum: (if a[p] == 0: 1 else: 0)
                elif a[p] == low: high else: low
            normal[p] = replacement
            fast[p] = replacement
            a[p] = replacement
        if step mod 8 == 7 or n > 8192:
            audit(normal, a, min(p, a.len), withSum)
            audit(fast, a, min(p, a.len), withSum)
    audit(normal, a, a.len, withSum)
    audit(fast, a, a.len, withSum)

for width in [30, 60]: run(width, false, false, 33)
for width in [7, 64]: run(width, true, false, 33)
run(7, false, true, 17)
run(7, true, true, 17)
when defined(dynamicWmFullTest):
    run(5, false, false, 8192 + 5)
    run(7, true, false, 8192 + 5)

let inferred = initDynamicQuadWaveletMatrixFast(@[3, 1, 3])
doAssert inferred.bitWidth == 2
doAssert inferred.count(0, 3, 3) == 2
doAssert inferred.select(1, 3) == 2
let empty = initDynamicQuadWaveletMatrixSumFast(newSeq[int](), H = 0)
audit(empty, @[], 0, true)
for i in 0..<3: empty.insert(i, 0)
audit(empty, @[0, 0, 0], 1, true)
while empty.len > 0: doAssert empty.erase(0) == 0
rejects(AssertionDefect): discard empty[0]
rejects(AssertionDefect): discard empty.erase(0)
rejects(AssertionDefect): empty[0] = 0
rejects(AssertionDefect): empty.insert(-1, 0)
rejects(AssertionDefect): empty.insert(1, 0)
rejects(AssertionDefect): empty.insert(0, 1)
rejects(AssertionDefect): discard empty.rank(1, 0)
rejects(AssertionDefect): discard empty.kth_smallest(0, 0, 0)
rejects(AssertionDefect): discard initDynamicQuadWaveletMatrixFast(@[0], H = 65, signedValues = true)
rejects(AssertionDefect): discard initDynamicQuadWaveletMatrixFast(@[0], H = 0, signedValues = true)
rejects(AssertionDefect): discard initDynamicQuadWaveletMatrixFast(@[-1], H = 30)
rejects(AssertionDefect): discard initDynamicQuadWaveletMatrixFast(@[1 shl 30], H = 30)
let bounded = initDynamicQuadWaveletMatrixFast(@[0], H = 30)
rejects(AssertionDefect): bounded.insert(0, -1)
rejects(AssertionDefect): bounded[0] = 1 shl 30
static: doAssert not compiles(bounded.sum_smallest(0, 1, 1))
for x in [int.low, int.high]:
    let one = initDynamicQuadWaveletMatrixSumFast(@[x], H = 64, signedValues = true)
    doAssert one.sum_smallest_with_count(0, 1, 1) == (x, 1)
    rejects(OverflowDefect): discard initDynamicQuadWaveletMatrixSumFast(@[x, x], H = 64, signedValues = true)
let cancellation = initDynamicQuadWaveletMatrixSumFast(@[int.low, int.high], H = 64, signedValues = true)
doAssert cancellation.sum_smallest(0, 2, 2) == -1
echo "Hello World"
