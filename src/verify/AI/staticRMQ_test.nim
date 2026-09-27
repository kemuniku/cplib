# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/collections/staticRMQ

proc checkAllRanges[T](values: openArray[T]) =
    ## 全区間の最小値を愚直解と比較する。
    let rmq = initRMQ(values)
    for l in 0..<values.len:
        var expected = values[l]
        for r in l+1..values.len:
            expected = min(expected, values[r-1])
            doAssert rmq.query(l, r) == expected

proc checkBoundaries[T](values, thresholds: openArray[T]) =
    let rmq = initRMQ(values)
    for lower in thresholds:
        for edge in 0..values.len:
            var left = edge
            while left > 0 and values[left-1] >= lower: dec left
            doAssert rmq.minLeft(edge, lower) == left
            var right = edge
            while right < values.len and values[right] >= lower: inc right
            doAssert rmq.maxRight(edge, lower) == right

checkBoundaries(newSeq[int](), [0])
checkBoundaries([5], [4, 5, 6])
checkBoundaries([high(int), low(int), 0], [low(int), -1, 0, 1, high(int)])
checkBoundaries([3.5, -1.25, 0.0, -1.25, 8.0], [-2.0, -1.25, 0.0, 1.0, 8.0, 9.0])
checkBoundaries(["banana", "apple", "pear", "apple", "orange"], ["", "apple", "banana", "z"])

checkAllRanges(newSeq[int]())
checkAllRanges([42])
checkAllRanges([5, 2, 7, 1, 4, 3, 6, 0, 9, 8, 11, 10, 12, 13, 14, 15, -1])
checkAllRanges([high(int), low(int), 0, high(int), low(int)])
checkAllRanges([3.5, -1.25, 0.0, -1.25, 8.0])
checkAllRanges(["banana", "apple", "pear", "apple", "orange"])

var rng = initRand(20260908)
for n in [2, 7, 8, 9, 15, 16, 17, 31, 32, 33, 63, 64, 65,
          127, 128, 129, 255, 256, 257, 511, 512, 513]:
    var values = newSeq[int](n)
    for i in 0..<n: values[i] = i
    checkAllRanges(values)
    for i in 0..<n: values[i] = n-i
    checkAllRanges(values)
    for i in 0..<n: values[i] = 7
    checkAllRanges(values)
    for i in 0..<n: values[i] = (if i mod 2 == 0: -1 else: 1)
    checkAllRanges(values)
    for trial in 0..<4:
        for value in values.mitems: value = rng.rand(-100..100)
        checkAllRanges(values)

var values32 = newSeq[int32](257)
var strings = newSeq[string](129)
for value in values32.mitems: value = int32(rng.rand(-100..100))
for value in strings.mitems: value = $rng.rand(100)
checkAllRanges(values32)
checkAllRanges(strings)

block:
    var values = @[3, 1, 4]
    let rmq = initRMQ(values)
    values[1] = 9
    doAssert rmq.query(0, 3) == 1

for n in 0..130:
    var values = newSeq[int32](n)
    for value in values.mitems:
        case rng.rand(3)
        of 0: value = low(int32)
        of 1: value = high(int32)
        else: value = int32(rng.rand(-10..10))
    checkAllRanges(values)
    var values64 = newSeq[int64](n)
    for i in 0..<n:
        values64[i] = (if values[i] == low(int32): low(int64)
                       elif values[i] == high(int32): high(int64)
                       else: int64(values[i]))
    checkAllRanges(values64)

checkAllRanges([0'u64, high(uint64), 1'u64])

static:
    let rmq = initRMQ([3, 1, 4])
    doAssert rmq.query(0, 3) == 1

block:
    var original = initRMQ([3, 1, 4])
    let copied = original
    original = initRMQ([9, 8, 7])
    doAssert copied.query(0, 3) == 1
    doAssert original.query(0, 3) == 7

block:
    var values = newSeq[int32](4097)
    for value in values.mitems: value = int32(rng.rand(-1_000_000..1_000_000))
    let rmq = initRMQ(values)
    for trial in 0..<4096:
        let l = rng.rand(values.high)
        let r = rng.rand(l+1..values.len)
        var expected = values[l]
        for i in l+1..<r: expected = min(expected, values[i])
        doAssert rmq.query(l, r) == expected

for n in [0, 1, 63, 64, 65, 127, 128, 129, 511, 512, 513, 4097]:
    var values = newSeq[int32](n)
    for value in values.mitems: value = int32(rng.rand(-2..2))
    checkBoundaries(values, [-3'i32, -2, -1, 0, 1, 2, 3])
    for value in values.mitems: value = 2
    checkBoundaries(values, [1'i32, 2, 3])
    if n > 0:
        values[n div 2] = -1
        checkBoundaries(values, [-1'i32, 0, 2, 3])

static:
    let rmq = initRMQ([3, 1, 4])
    doAssert rmq.minLeft(3, 2) == 2
    doAssert rmq.maxRight(0, 2) == 1
    doAssert rmq.minLeft(3, 1) == 0
    doAssert rmq.maxRight(0, 1) == 3

when compileOption("assertions"):
    let rmq = initRMQ([3, 1, 4])
    for (l, r) in [(-1, 1), (0, 0), (1, 1), (0, 4), (2, 1)]:
        var rejected = false
        try:
            discard rmq.query(l, r)
        except AssertionDefect:
            rejected = true
        doAssert rejected

    for edge in [-1, 4]:
        var rejected = false
        try:
            discard rmq.minLeft(edge, 1)
        except AssertionDefect:
            rejected = true
        doAssert rejected
        rejected = false
        try:
            discard rmq.maxRight(edge, 1)
        except AssertionDefect:
            rejected = true
        doAssert rejected

echo "Hello World"
