# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/dynamic_bplus_sum_kernels
import cplib/collections/dynamic_bplus_kernels

for avx2 in [false, true]:
    if avx2 and not kernelAvailable(bpkAvx2): continue
    for n in 0..257:
        for delta in [0'u64, 1'u64, uint64.high, 1'u64 shl 63, (1'u64 shl 63)-1]:
            for direction in [-1, 0, 1]:
                var a = newSeq[uint64](n+4)
                for i in 0..<a.len: a[i] = uint64(i)*1234567890123'u64
                var expected = a
                if direction > 0:
                    for i in 0..<n: expected[i+2] = a[i+1]+delta
                else:
                    for i in 0..<n: expected[i+1] = a[i+1+int(direction < 0)]+delta
                sumShiftRaw(addr a[1], cint(n), delta, cint(direction), cint(avx2))
                doAssert a == expected
    for n in 0..33:
        for delta in [0'u64, 1'u64, uint64.high, 1'u64 shl 63]:
            for sizeDelta in [-1, 0, 1]:
                var sizes = newSeq[int32](n+2)
                var sums = newSeq[uint64](n+2)
                for i in 0..<sizes.len:
                    sizes[i] = int32(10+i*2)
                    sums[i] = uint64(i)*1234567890123'u64
                var expectedSizes = sizes
                var expectedSums = sums
                for i in 1..n:
                    expectedSizes[i] += int32(sizeDelta)
                    expectedSums[i] += delta
                sumAdjustRaw(addr sizes[1], addr sums[1], cint(n), cint(sizeDelta), delta, cint(avx2))
                doAssert sizes == expectedSizes
                doAssert sums == expectedSums
echo "Hello World"
