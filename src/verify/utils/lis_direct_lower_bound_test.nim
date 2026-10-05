# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, random, sequtils
import cplib/utils/lis

proc legacyIndices[T](a: openArray[T]): seq[int] =
    var p = newSeq[int](a.len)
    var dp = newSeq[T]()
    for i in 0..<a.len:
        var pos = dp.lowerBound(a[i])
        if pos == dp.len: dp.add(a[i])
        else: dp[pos] = a[i]
        p[i] = pos
    result = newSeq[int]()
    var t = dp.len - 1
    for i in countdown(a.len - 1, 0):
        if p[i] == t:
            result.add(i)
            t -= 1
    result.reverse

proc oracle[T](a: openArray[T]): int =
    var dp = newSeq[int](a.len)
    for i in 0..<a.len:
        dp[i] = 1
        for j in 0..<i:
            if a[j] < a[i]:
                dp[i] = max(dp[i], dp[j] + 1)
        result = max(result, dp[i])

proc check[T](a: openArray[T]) =
    let expected = legacyIndices(a)
    let idx = restore_lis_index(a)
    let values = restore_lis(a)
    doAssert idx == expected
    doAssert lis(a) == oracle(a)
    doAssert values.len == idx.len
    doAssert values.len == lis(a)
    for i in 0..<idx.len:
        doAssert values[i] == a[idx[i]]
        if i > 0:
            doAssert idx[i-1] < idx[i]
            doAssert values[i-1] < values[i]

for n in 0..8:
    var cases = 1
    for _ in 0..<n: cases *= 3
    for code in 0..<cases:
        var a = newSeq[int](n)
        var x = code
        for i in 0..<n:
            a[i] = x mod 3 - 1
            x = x div 3
        check(a)
var rng = initRand(20261005)
for trial in 0..<1000:
    var a = newSeq[int](rng.rand(50))
    for i in 0..<a.len:
        a[i] = rng.rand(-20..20)
    check(a)
check([low(int), low(int), 0, high(int), high(int)])
check([0'u64, high(uint64), 1'u64, 2'u64])
check(["aaa", "ccc", "bbb", "ddd", "bbb"])
check("\0\xff\x80\0\x01")
check([0.0, -1.0, 0.5, 3.0, 3.0])
let special = [0.0, NaN, 1.0, NegInf, Inf]
doAssert restore_lis_index(special) == legacyIndices(special)
doAssert lis(special) == legacyIndices(special).len
let a = [4, 1, 3, 2, 5]
check(a.toOpenArray(1, 3))
type Descending = object
    value: int
    tag: int
proc `<`(a, b: Descending): bool = a.value > b.value
proc `==`(a, b: Descending): bool = a.value == b.value
let desc = [Descending(value: 1, tag: 7), Descending(value: 3, tag: 5), Descending(value: 2, tag: 3), Descending(value: 0, tag: 1)]
check(desc)
doAssert restore_lis(desc).mapIt(it.tag) == legacyIndices(desc).mapIt(desc[it].tag)
let increasing = toSeq(0..<100000)
doAssert lis(increasing) == increasing.len
doAssert restore_lis_index(increasing) == increasing
let decreasing = reversed(increasing)
doAssert lis(decreasing) == 1
doAssert restore_lis_index(decreasing) == @[decreasing.len-1]
echo "Hello World"
