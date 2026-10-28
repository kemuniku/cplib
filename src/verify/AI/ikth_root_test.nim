# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/math/ikth_root

proc reference(n: uint64, k: int): uint64 =
    if n <= 1 or k == 1: return n
    if k >= 64: return 1
    var lo = 0'u64
    var hi = n
    while lo < hi:
        let distance = hi - lo
        let mid = lo + (distance shr 1) + (distance and 1)
        var power = 1'u64
        var fits = true
        for _ in 0..<k:
            if power > n div mid:
                fits = false
                break
            power *= mid
        if fits: lo = mid
        else: hi = mid - 1
    return lo

for n in 0..4096:
    for k in 1..70:
        doAssert ikthRoot(n, k) == int(reference(uint64(n), k))

for k in 1..100:
    for bit in 0..63:
        let n = 1'u64 shl bit
        for value in [n - 1, n, n + 1, high(uint64) - n]:
            doAssert ikthRoot(value, k) == reference(value, k)
    doAssert ikthRoot(high(uint64), k) == reference(high(uint64), k)
    doAssert ikthRoot(high(int), k) == int(reference(uint64(high(int)), k))

for k in 2..63:
    for root in [2'u64, 3, 7, 16, 255, 65535, 4294967295'u64]:
        var power = 1'u64
        var fits = true
        for _ in 0..<k:
            if power > high(uint64) div root:
                fits = false
                break
            power *= root
        if fits:
            doAssert ikthRoot(power - 1, k) == root - 1
            doAssert ikthRoot(power, k) == root
            if power < high(uint64):
                doAssert ikthRoot(power + 1, k) == root

var state = 123456789'u64
for _ in 0..<20000:
    state = state xor (state shl 13)
    state = state xor (state shr 7)
    state = state xor (state shl 17)
    let k = int(state mod 100) + 1
    doAssert ikthRoot(state, k) == reference(state, k)

template checkType(T: typedesc) =
    block:
        let answer: T = ikthRoot(T(27), 3)
        doAssert answer == T(3)
        doAssert ikthRoot(high(T), 1) == high(T)
        doAssert uint64(ikthRoot(high(T), 2)) == reference(uint64(high(T)), 2)
        doAssert ikthRoot(T(0), high(int)) == T(0)
        doAssert ikthRoot(high(T), high(int)) == T(1)
checkType(int)
checkType(int8)
checkType(int16)
checkType(int32)
checkType(int64)
checkType(uint)
checkType(uint8)
checkType(uint16)
checkType(uint32)
checkType(uint64)

for k in [low(int), -1, 0]:
    for n in [0'u64, 1, high(uint64)]:
        var caught = false
        try: discard ikthRoot(n, k)
        except ValueError: caught = true
        doAssert caught
for n in [low(int), -1]:
    for k in [1, 2, high(int)]:
        var caught = false
        try: discard ikthRoot(n, k)
        except ValueError: caught = true
        doAssert caught

echo "Hello World"
