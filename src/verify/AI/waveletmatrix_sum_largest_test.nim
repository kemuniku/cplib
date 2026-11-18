# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/waveletmatrix
import cplib/collections/dynamic_bplus_waveletmatrix
import cplib/collections/dynamic_quaternary_waveletmatrix
import cplib/collections/dynamic_quaternary_waveletmatrix_sum
import algorithm, random

template rejects(error: typedesc, body: untyped) =
    block:
        var caught = false
        try: body
        except error: caught = true
        doAssert caught

proc checkRange[W](w: W, a: seq[int], l, r: int) =
    let values = sorted(a[l..<r], Descending)
    var total = 0
    doAssert w.sum_largest(l, r, 0) == 0
    doAssert w.sum_largest_with_count(l, r, 0) == (sum: 0, count: 0)
    for i, x in values:
        total += x
        doAssert w.sum_largest(l, r, i+1) == total
        doAssert w.sum_largest_with_count(l, r, i+1) == (sum: total, count: i+1)

proc checkAll[W](w: W, a: seq[int]) =
    for l in 0..a.len:
        for r in l..a.len:
            checkRange(w, a, l, r)
    for bounds in [(-1, a.len, 0), (0, a.len+1, 0), (1, 0, 0),
                   (0, a.len, -1), (0, a.len, a.len+1)]:
        let (l, r, k) = bounds
        rejects(AssertionDefect): discard w.sum_largest(l, r, k)
        rejects(AssertionDefect): discard w.sum_largest_with_count(l, r, k)

proc checkDisabled[W](w: W) =
    for k in 0..1:
        rejects(AssertionDefect): discard w.sum_largest(0, 1, k)
        rejects(AssertionDefect): discard w.sum_largest_with_count(0, 1, k)

proc exercise[W](w: W, low, high: int) =
    var a: seq[int]
    var rng = initRand(467)
    checkAll(w, a)
    for step in 0..<90:
        let kind = if a.len == 0: 0 elif a.len >= 12: 1 else: rng.rand(2)
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
            w[p] = x
            a[p] = x
        checkAll(w, a)

for a in [newSeq[int](), @[0], @[0, 0, 0], @[7, 7, 7, 7],
          @[3, 1, 4, 1, 5, 9, 2, 6], @[0, int.high-2, 1, 1]]:
    checkAll(initWaveletMatrix(a, with_sum=true), a)
    checkAll(initWaveletMatrix(a, H=sizeof(int)*8, with_sum=true), a)
    checkAll(initDynamicBPlusWaveletMatrix(a, with_sum=true), a)
    checkAll(initDynamicQuadWaveletMatrixSum(a), a)

checkAll(initWaveletMatrix(@[0, 0, 0], H=0, with_sum=true), @[0, 0, 0])
checkDisabled(initWaveletMatrix(@[0]))
checkDisabled(initDynamicBPlusWaveletMatrix(@[0]))
static:
    doAssert not compiles(initDynamicQuadWaveletMatrix(@[0]).sum_largest(0, 1, 1))
    doAssert not compiles(initDynamicQuadWaveletMatrixFast(@[0]).sum_largest(0, 1, 1))

for width in [0, 1, 3, 7, 63]:
    let high = if width >= 3: 7 else: (1 shl width)-1
    exercise(initDynamicBPlusWaveletMatrix(@[], H=width, with_sum=true), 0, high)
    exercise(initDynamicQuadWaveletMatrixSum(@[], H=width), 0, high)
for width in [1, 3, 7, 64]:
    let low = if width >= 7: -7 else: -(1 shl (width-1))
    let high = if width >= 7: 7 else: (1 shl (width-1))-1
    exercise(initDynamicQuadWaveletMatrixSum(@[], H=width, signedValues=true), low, high)
    exercise(initDynamicQuadWaveletMatrixSumFast(@[], H=width, signedValues=true), low, high)

for a in [@[-7, -1, -3, -1], @[-4, 3, -1, 0, 3, -4], @[int.low, int.high]]:
    checkAll(initDynamicQuadWaveletMatrixSum(a, signedValues=true), a)
    checkAll(initDynamicQuadWaveletMatrixSumFast(a, signedValues=true), a)

proc checkOverflow[W](w: W, x: int) =
    doAssert w.sum_largest(0, 2, 0) == 0
    doAssert w.sum_largest_with_count(0, 2, 1) == (x, 1)
    rejects(OverflowDefect): discard w.sum_largest(0, 2, 2)
    rejects(OverflowDefect): discard w.sum_largest_with_count(0, 2, 2)

checkOverflow(initDynamicBPlusWaveletMatrix(@[int.high, int.high], with_sum=true), int.high)
for x in [int.low, int.high]:
    rejects(OverflowDefect): discard initDynamicQuadWaveletMatrixSum(@[x, x], signedValues=true)
    rejects(OverflowDefect): discard initDynamicQuadWaveletMatrixSumFast(@[x, x], signedValues=true)
rejects(OverflowDefect):
    discard initDynamicQuadWaveletMatrixSum(@[int.low, int.low, int.high], signedValues=true)

var rng = initRand(20261018)
for n in [63, 64, 65, 257]:
    var a = newSeq[int](n)
    for x in a.mitems: x = rng.rand(65535)
    let w = initWaveletMatrix(a, with_sum=true)
    checkRange(w, a, 0, n)
    for trial in 0..<20:
        let l = rng.rand(n)
        let r = l+rng.rand(n-l)
        checkRange(w, a, l, r)

echo "Hello World"
