# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/math/isqrt

proc referenceIsqrt(n: int): int =
    var lo = 0
    var hi = n
    while lo < hi:
        let distance = hi - lo
        let mid = lo + (distance shr 1) + (distance and 1)
        if mid <= n div mid:
            lo = mid
        else:
            hi = mid - 1
    return lo

for n in 0..100_000:
    doAssert isqrt(n) == referenceIsqrt(n)

when sizeof(int) == 8:
    const maxRoot = 3_037_000_499
    doAssert isqrt(1_000_000_000_000.int) == 1_000_000
else:
    const maxRoot = 46_340

doAssert isqrt(high(int)) == maxRoot
doAssert isqrt(high(int) - 1) == maxRoot
for root in [1, 2, 3, 15, 16, 100, maxRoot - 1, maxRoot]:
    let square = root * root
    doAssert isqrt(square - 1) == root - 1
    doAssert isqrt(square) == root
    doAssert isqrt(square + 1) == root

for bit in 0..<(sizeof(int) * 8 - 1):
    let value = 1 shl bit
    for n in [value - 1, value, value + 1, high(int) - value]:
        doAssert isqrt(n) == referenceIsqrt(n)

for offset in 0..1000:
    let n = high(int) - offset
    doAssert isqrt(n) == referenceIsqrt(n)
