import times, random, strutils, os
when defined(quadSumBenchBaseline):
    import cplib/collections/dynamic_quaternary_waveletmatrix
else:
    import cplib/collections/dynamic_quaternary_waveletmatrix_sum

let n = if paramCount() >= 1: parseInt(paramStr(1)) else: 100000
let q = if paramCount() >= 2: parseInt(paramStr(2)) else: 10000
var rng = initRand(467)
var a = newSeq[int](n)
for i in 0..<n: a[i] = (i*10007) mod 1000000000+1
var updates = newSeq[tuple[p, x: int]](q)
var ranges = newSeq[tuple[l, r, k: int]](q)
for i in 0..<q:
    updates[i] = (rng.rand(n-1), rng.rand(999999999)+1)
    let l = rng.rand(n div 4)
    let r = n-rng.rand(n div 4)
    ranges[i] = (l, r, rng.rand(r-l-1))
let buildStart = cpuTime()
when defined(quadSumBenchBaseline):
    let w = initDynamicQuadWaveletMatrixFast(a, H=30)
else:
    let w = initDynamicQuadWaveletMatrixSumFast(a, H=30)
echo "build_ms=", (cpuTime()-buildStart)*1000
let updateStart = cpuTime()
for op in updates: w[op.p] = op.x
echo "update_us=", (cpuTime()-updateStart)*1000000/q.float
var checksum = 0
let kthStart = cpuTime()
for op in ranges: checksum = checksum xor w.kth_largest(op.l, op.r, op.k)
echo "kth_us=", (cpuTime()-kthStart)*1000000/q.float
when not defined(quadSumBenchBaseline):
    let sumStart = cpuTime()
    for op in ranges: checksum = checksum xor w.sum_largest(op.l, op.r, op.k)
    echo "sum_largest_us=", (cpuTime()-sumStart)*1000000/q.float
    let bisectStart = cpuTime()
    for op in ranges:
        let target = w.range_sum(op.l, op.r)
        var ok = op.r-op.l
        var ng = 0
        while ok-ng > 1:
            let mid = (ok+ng) div 2
            if w.sum_largest(op.l, op.r, mid) >= target: ok = mid
            else: ng = mid
        checksum = checksum xor ok
    echo "bisect_us=", (cpuTime()-bisectStart)*1000000/q.float
echo "storage_bytes=", w.storageBytes(), " checksum=", checksum
