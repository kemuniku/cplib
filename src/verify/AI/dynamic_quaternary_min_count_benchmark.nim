import times, random, strutils, os
import cplib/collections/dynamic_quaternary_waveletmatrix_sum

let n = if paramCount() >= 1: parseInt(paramStr(1)) else: 100000
let q = if paramCount() >= 2: parseInt(paramStr(2)) else: 100000
let mode = if paramCount() >= 3: paramStr(3) else: "wide"
doAssert n > 0 and q > 0
doAssert mode in ["wide", "short", "small", "equal"]
let maximum = if mode == "small": 100 elif mode == "equal": 42 else: 1000000000
var rng = initRand(467)
var a = newSeq[int](n)
for x in a.mitems: x = if mode == "equal": maximum else: rng.rand(maximum-1)+1
var operations = newSeq[tuple[p, x, l, r, target: int]](q)
for op in operations.mitems:
    op.p = rng.rand(n-1)
    op.x = if mode == "equal": maximum else: rng.rand(maximum-1)+1
    if mode == "short":
        op.l = rng.rand(n-1)
        op.r = min(n, op.l+rng.rand(99)+1)
    else:
        op.l = rng.rand((n-1) div 4)
        op.r = n-rng.rand((n-1) div 4)
    op.target = rng.rand((op.r-op.l)*maximum div 2)+1

let buildStart = cpuTime()
let w = initDynamicQuadWaveletMatrixSumFast(a, H=30)
echo "build_ms=", (cpuTime()-buildStart)*1000
var largestChecksum, smallestChecksum, mixedChecksum: int
let largestStart = cpuTime()
for op in operations:
    largestChecksum += w.min_count_largest_for_sum(op.l, op.r, op.target)
echo "largest_us=", (cpuTime()-largestStart)*1000000/q.float
let smallestStart = cpuTime()
for op in operations:
    smallestChecksum += w.min_count_smallest_for_sum(op.l, op.r, op.target)
echo "smallest_us=", (cpuTime()-smallestStart)*1000000/q.float
let updateStart = cpuTime()
for op in operations: w[op.p] = op.x
echo "update_us=", (cpuTime()-updateStart)*1000000/q.float
let mixed = initDynamicQuadWaveletMatrixSumFast(a, H=30)
let mixedStart = cpuTime()
for op in operations:
    mixed[op.p] = op.x
    mixedChecksum += mixed.min_count_largest_for_sum(op.l, op.r, op.target)
echo "mixed_us=", (cpuTime()-mixedStart)*1000000/q.float
echo "checksums=", largestChecksum, ",", smallestChecksum, ",", mixedChecksum
