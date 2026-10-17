# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import random, algorithm
import cplib/utils/largest_rectangle

proc oracle[T: SomeInteger](a: openArray[T]): int64 =
    for l in 0..<a.len:
        var height = int64.high
        for r in l..<a.len:
            height = min(height, int64(a[r]))
            result = max(result, height * int64(r - l + 1))

proc check[T: SomeInteger](a: openArray[T], expected: int64) =
    let rectangle = largest_rectangle_with_range(a)
    doAssert rectangle.area == expected
    doAssert largest_rectangle(a) == expected
    doAssert 0 <= rectangle.l and rectangle.l <= rectangle.r and rectangle.r <= a.len
    doAssert rectangle.height >= 0
    doAssert rectangle.area == rectangle.height * int64(rectangle.r - rectangle.l)
    if expected == 0:
        doAssert rectangle == (0'i64, 0, 0, 0'i64)
    else:
        doAssert rectangle.l < rectangle.r
        var minimum = int64.high
        for i in rectangle.l..<rectangle.r:
            doAssert int64(a[i]) >= rectangle.height
            minimum = min(minimum, int64(a[i]))
        doAssert rectangle.height == minimum

check(newSeq[int](), 0)
check([0, 0, 0], 0)
check([7], 7)
check([2, 1, 3, 5, 3, 4, 2, 1], 12)
check([2, 0, 1], 2)
check([2, 2, 1, 2, 2], 5)
check([0, 5, 5, 0, 5, 0], 10)
check([2, 1, 2], 3)
check([int64.high], int64.high)
check([int64.high div 2, int64.high div 2], int64.high - 1)
check([int64.high div 3, int64.high div 3, int64.high div 3], (int64.high div 3) * 3)

template checkIntegerType(T: typedesc) =
    check([T(2), T(2), T(0), T(3)], 4)
    check(newSeq[T](), 0)

checkIntegerType(int)
checkIntegerType(int8)
checkIntegerType(int16)
checkIntegerType(int32)
checkIntegerType(int64)
checkIntegerType(uint)
checkIntegerType(uint8)
checkIntegerType(uint16)
checkIntegerType(uint32)
checkIntegerType(uint64)
check([1_000_000_000'i32, 1_000_000_000'i32, 1_000_000_000'i32], 3_000_000_000'i64)
check([uint64(int64.high)], int64.high)
let backing = [99, 2, 1, 2, 99]
check(backing.toOpenArray(1, 3), 3)

for n in 0..8:
    var count = 1
    for i in 0..<n: count *= 4
    for code in 0..<count:
        var a = newSeq[int](n)
        var digits = code
        for i in 0..<n:
            a[i] = digits mod 4
            digits = digits div 4
        check(a, oracle(a))

var rng = initRand(441)
for trial in 0..<2000:
    var a = newSeq[int64](rng.rand(0..60))
    for x in a.mitems: x = int64(rng.rand(0..1_000_000_000))
    let snapshot = a & newSeq[int64]()
    let expected = oracle(a)
    check(a, expected)
    doAssert a == snapshot
    a.reverse
    check(a, expected)
    for x in a.mitems: x *= 3
    check(a, expected * 3)

const n = 100_000
var a = newSeq[int64](n)
for x in a.mitems: x = 1_000_000_000
check(a, 100_000_000_000_000'i64)
for i in 0..<n: a[i] = int64(i + 1)
check(a, int64(n + 1) * int64(n + 1) div 4)
a.reverse
check(a, int64(n + 1) * int64(n + 1) div 4)
for i in 0..<n: a[i] = if i mod 2 == 0: 0'i64 else: 1_000_000_000'i64
check(a, 1_000_000_000)
for x in a.mitems: x = 0
check(a, 0)

echo "Hello World"
