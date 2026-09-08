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

echo "Hello World"
