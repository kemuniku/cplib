# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import bitops, random
import cplib/utils/count_set_bits

proc oracle(n: uint64, bit: int): uint64 =
    var dp: array[2, array[2, uint64]]
    dp[1][0] = 1
    for pos in countdown(63, 0):
        var next: array[2, array[2, uint64]]
        for tight in 0..1:
            for seen in 0..1:
                let limit = if tight == 1: int((n shr pos) and 1) else: 1
                for digit in 0..limit:
                    let nextTight = int(tight == 1 and digit == limit)
                    let nextSeen = int(seen == 1 or (pos == bit and digit == 1))
                    next[nextTight][nextSeen] += dp[tight][seen]
        dp = next
    return dp[0][1] + dp[1][1]

var counts: array[64, uint64]
for n in 0u64..4095u64:
    for bit in 0..63:
        counts[bit] += (n shr bit) and 1
        doAssert count_set_bits(n, bit) == counts[bit]

proc check(n: uint64) =
    for bit in 0..63:
        doAssert count_set_bits(n, bit) == oracle(n, bit)
        if n > 0:
            doAssert count_set_bits(n, bit) - count_set_bits(n - 1, bit) == ((n shr bit) and 1)

check(0)
check(high(uint64))
for power in 0..63:
    let pivot = 1u64 shl power
    check(pivot - 1)
    check(pivot)
    check(pivot + 1)
    for offset in 0u64..3u64:
        if offset <= pivot:
            check(high(uint64) - pivot + offset)

var rng = initRand(237)
for _ in 0..<256:
    let n = (uint64(rng.rand(int(high(int32)))) shl 33) or
            (uint64(rng.rand(int(high(int32)))) shl 2) or uint64(rng.rand(0..3))
    check(n)

for bit in 0..63:
    doAssert count_set_bits(high(uint64), bit) == (1u64 shl 63)
    for n in [0u64, 1u64, high(uint64)]:
        for invalidBit in [low(int), -1, 64, high(int)]:
            doAssertRaises(ValueError):
                discard count_set_bits(n, invalidBit)

proc maskedPopcount(n, mask: uint64): uint64 =
    for bit in 0..63:
        if ((mask shr bit) and 1) != 0:
            result = (result + count_set_bits(n, bit) mod 998244353u64) mod 998244353u64

for mask in 0u64..127u64:
    var expected = 0u64
    for n in 0u64..127u64:
        expected += uint64(countSetBits(n and mask))
        doAssert maskedPopcount(n, mask) == expected
doAssert maskedPopcount(4, 3) == 4
doAssert maskedPopcount(0, 0) == 0
doAssert maskedPopcount(1152921504606846975u64, 1152921504606846975u64) == 499791890u64

static:
    doAssert count_set_bits(0u64, 63) == 0
    doAssert count_set_bits((1u64 shl 63) - 1, 63) == 0
    doAssert count_set_bits(1u64 shl 63, 63) == 1
    doAssert count_set_bits(high(uint64), 0) == (1u64 shl 63)
    doAssert count_set_bits(high(uint64), 63) == (1u64 shl 63)
    doAssertRaises(ValueError):
        discard count_set_bits(0u64, -1)
    doAssertRaises(ValueError):
        discard count_set_bits(high(uint64), 64)

echo "Hello World"
