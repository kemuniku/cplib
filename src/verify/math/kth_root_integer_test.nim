# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
include cplib/math/kth_root_integer

proc referencePower(base: uint64, k: int, limit: uint64): bool =
    if base == 0:
        return true
    var product = 1'u64
    for _ in 0..<k:
        if product > limit div base:
            return false
        product *= base
    return product <= limit

proc referenceRoot(a: uint64, k: int): uint64 =
    if k == 1:
        return a
    var lo = 0'u64
    var hi = 1'u64 shl 32
    while hi - lo > 1:
        let mid = lo + (hi - lo) div 2
        if referencePower(mid, k, a):
            lo = mid
        else:
            hi = mid
    return lo

proc check(a: uint64, k: int) =
    let expected = referenceRoot(a, k)
    let root = kth_root(a, k)
    doAssert root == expected
    doAssert referencePower(root, k, a)
    if root != high(uint64):
        doAssert not referencePower(root + 1, k, a)

for k in 1..64:
    for a in 0'u64..2048'u64:
        check(a, k)
    for bit in 0..63:
        let a = 1'u64 shl bit
        for value in [a - 1, a, a + 1, high(uint64) - a]:
            check(value, k)
    for offset in 0'u64..128'u64:
        check(high(uint64) - offset, k)

var state = 0x123456789abcdef0'u64
proc nextRandom(): uint64 =
    state = state xor (state shl 13)
    state = state xor (state shr 7)
    state = state xor (state shl 17)
    return state

for _ in 0..<20_000:
    let a = nextRandom()
    let k = int(nextRandom() mod 64) + 1
    check(a, k)

for k in 2..63:
    let largest = referenceRoot(high(uint64), k)
    for root in [2'u64, 3'u64, largest div 2, largest - 1, largest]:
        if root < 2 or not referencePower(root, k, high(uint64)):
            continue
        var power = 1'u64
        for _ in 0..<k:
            power *= root
        doAssert kth_root(power - 1, k) == root - 1
        doAssert kth_root(power, k) == root
        check(power + 1, k)

for a in [4'u64, 27'u64, 65535'u64, 1'u64 shl 63, high(uint64)]:
    for k in [2, 3, 7, 31, 63]:
        let upper = 1'u64 shl ((64 + k - 1) div k)
        let expected = referenceRoot(a, k)
        for estimate in [0.0, 1.0, float64(upper - 1), float64(upper),
                         float64(expected) - 0.5, float64(expected) + 1.5,
                         -Inf, Inf, NaN]:
            doAssert kthRootCorrect(a, k, estimate, upper) == expected

for k in [65, 1000, high(int)]:
    doAssert kth_root(0'u64, k) == 0
    doAssert kth_root(1'u64, k) == 1
    doAssert kth_root(high(uint64), k) == 1
for k in [low(int), -1, 0]:
    var rejected = false
    try:
        discard kth_root(0'u64, k)
    except ValueError:
        rejected = true
    doAssert rejected

echo "Hello World"
