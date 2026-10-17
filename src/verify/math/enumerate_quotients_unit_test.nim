# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/math/enumerate_quotients
import algorithm, random

proc naive(n: int): seq[int] =
    for x in 1..n:
        result.add(n div x)
    result.sort()
    var size = 0
    for q in result:
        if size == 0 or result[size - 1] != q:
            result[size] = q
            inc size
    result.setLen(size)

proc checkSmall(n: int) =
    let expected = naive(n)
    doAssert enumerateQuotients(n) == expected
    var actual: seq[int]
    for q in quotientValues(n):
        actual.add(q)
    doAssert actual == expected

for n in 0..4096:
    checkSmall(n)
var rng = initRand(580)
for trial in 0..<200:
    checkSmall(rng.rand(100_000))

proc root(n: int64): int64 =
    var lo = 0'i64
    var hi = n
    while lo < hi:
        let distance = hi - lo
        let mid = lo + (distance shr 1) + (distance and 1)
        if mid <= n div mid:
            lo = mid
        else:
            hi = mid - 1
    result = lo

proc checkSplit[T: SomeSignedInt](n: T) =
    let r = root(int64(n))
    var expected: seq[T]
    for q in 1'i64..r:
        expected.add(T(q))
    for x in countdown(r, 1'i64):
        let q = int64(n) div x
        if q > r:
            expected.add(T(q))
    let actual = enumerateQuotients(n)
    doAssert actual == expected
    if n > 0:
        doAssert int64(actual.len) == r + int64(n) div (r + 1)
        doAssert actual[0] == T(1) and actual[^1] == n
    for i, q in actual:
        doAssert q > 0
        if i > 0:
            doAssert actual[i - 1] < q
        doAssert n div (n div q) == q
    var i = 0
    for q in quotientValues(n):
        doAssert q == actual[i]
        inc i
    doAssert i == actual.len

for r in [1'i64, 2, 3, 4, 15, 16, 100, 999, 1000, 46340, 1_000_000]:
    for delta in [-1'i64, 0, 1]:
        checkSplit(r * r + delta)
        checkSplit(r * (r + 1) + delta)

for n in 0..int(high(int8)):
    checkSplit(int8(n))
checkSplit(high(int16))
checkSplit(high(int32))
checkSplit(high(int32) - 1)
checkSplit(1_000_000_000_000'i64)

proc expectInvalid[T: SomeSignedInt](n: T) =
    var caught = false
    try:
        discard enumerateQuotients(n)
    except ValueError:
        caught = true
    doAssert caught
    caught = false
    try:
        for q in quotientValues(n):
            discard q
    except ValueError:
        caught = true
    doAssert caught

expectInvalid(-1)
expectInvalid(low(int))
expectInvalid(low(int8))
expectInvalid(low(int16))
expectInvalid(low(int32))
expectInvalid(low(int64))
doAssert enumerateQuotients(0'i64).len == 0

proc checkPrefix[T: SomeSignedInt](n: T) =
    var expected = T(1)
    for q in quotientValues(n):
        doAssert q == expected
        if expected == T(2048):
            break
        inc expected
    doAssert expected == T(2048)

checkPrefix(high(int))
checkPrefix(high(int64))
checkPrefix(high(int64) - 1)
echo "Hello World"
