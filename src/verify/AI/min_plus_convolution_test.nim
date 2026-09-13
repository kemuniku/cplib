# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/convolution/min_plus_convolution
import cplib/utils/smawk
import cplib/utils/monotone_minima
import random, algorithm

proc naive[T](a, b: seq[T]): seq[T] =
    if a.len == 0 or b.len == 0: return @[]
    result = newSeq[T](a.len + b.len - 1)
    for k in 0..<result.len:
        let lo = max(0, k - b.len + 1)
        result[k] = a[lo] + b[k - lo]
        for i in lo + 1..min(k, a.len - 1):
            result[k] = min(result[k], a[i] + b[k - i])

proc checkConvex[T](a, b: seq[T]) =
    let expected = naive(a, b)
    doAssert minPlusConvolutionConvexArbitraryMonotoneMinima(a, b) == expected
    doAssert minPlusConvolutionConvexArbitrarySmawk(a, b) == expected

proc checkConcave[T](a, b: seq[T]) =
    doAssert minPlusConvolutionConcaveArbitrary(a, b) == naive(a, b)

var rng = initRand(712367)
proc convex(n: int): seq[int64] =
    if n == 0: return @[]
    var slopes = newSeq[int](n - 1)
    for x in slopes.mitems: x = rng.rand(-30..30)
    slopes.sort()
    result = newSeq[int64](n)
    result[0] = rng.rand(-100..100)
    for i in 1..<n: result[i] = result[i - 1] + slopes[i - 1]

for n in 0..45:
    for m in 0..45:
        for rep in 0..<3:
            let a = convex(n)
            let b = convex(m)
            var arbitrary = newSeq[int64](m)
            for x in arbitrary.mitems: x = rng.rand(-500..500)
            checkConvex(a, arbitrary)
            doAssert minPlusConvolutionConvexConvex(a, b) == naive(a, b)
            var ca = a
            var cb = b
            for x in ca.mitems: x = -x
            for x in cb.mitems: x = -x
            checkConcave(ca, arbitrary)
            doAssert minPlusConvolutionConcaveConcave(ca, cb) == naive(ca, cb)

for n in 0..6:
    var count = 1
    for i in 0..<n: count *= 3
    for mask in 0..<count:
        var a = newSeq[int](n)
        var q = mask
        for x in a.mitems:
            x = q mod 3 - 1
            q = q div 3
        var isConvex = true
        var isConcave = true
        for i in 2..<n:
            isConvex = isConvex and a[i] - a[i - 1] >= a[i - 1] - a[i - 2]
            isConcave = isConcave and a[i] - a[i - 1] <= a[i - 1] - a[i - 2]
        for m in 0..8:
            var b = newSeq[int](m)
            for x in b.mitems: x = rng.rand(-2..2)
            if isConvex: checkConvex(a, b)
            if isConcave: checkConcave(a, b)

checkConvex(@[low(int64), 0, high(int64)], @[0'i64])
checkConcave(@[high(int64), 0, low(int64)], @[0'i64])
checkConvex(@[1.0, 0.5, 1.0], @[2.5, -1.0, 3.0])
checkConcave(@[-1.0, -0.5, -1.0], @[2.5, -1.0, 3.0])
for n in [1, 2, 3, 127, 10000]:
    for m in [1, 2, 3]:
        let a = convex(n)
        let b = convex(m)
        checkConvex(a, b)
        checkConvex(b, a)
        var ca = a
        for x in ca.mitems: x = -x
        checkConcave(ca, b)
        var cb = b
        for x in cb.mitems: x = -x
        checkConcave(cb, a)

for h in 0..40:
    for w in 0..40:
        proc better(row, oldCol, newCol: int): bool =
            (row - newCol) * (row - newCol) < (row - oldCol) * (row - oldCol)
        let s = smawk(h, w, better)
        doAssert monotoneMinima(h, w, better) == s
        for r in 0..<h: doAssert s[r] == (if w == 0: -1 else: min(r, w - 1))
        proc tied(row, oldCol, newCol: int): bool = false
        for x in smawk(h, w, tied): doAssert x == (if w == 0: -1 else: 0)
echo "Hello World"
