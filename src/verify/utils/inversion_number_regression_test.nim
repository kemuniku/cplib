# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/utils/inversion_number

proc oracle(a: openArray[int]): int =
    for i in 0..<a.len:
        for j in i+1..<a.len:
            if a[i] > a[j]:
                inc result

proc check(a: openArray[int]) =
    doAssert inversion_number(a) == oracle(a)

check(newSeq[int]())
check([low(int)])
check([high(int), low(int), 0, high(int), low(int)])
for n in 0..8:
    var count = 1
    for _ in 0..<n:
        count *= 3
    for code in 0..<count:
        var a = newSeq[int](n)
        var x = code
        for i in 0..<n:
            a[i] = x mod 3 - 1
            x = x div 3
        check(a)

var rng = initRand(20261005)
for trial in 0..<1500:
    var a = newSeq[int](rng.rand(128))
    for x in a.mitems:
        x = rng.rand(-1000..1000)
    check(a)

var descending = newSeq[int](100000)
for i in 0..<descending.len:
    descending[i] = descending.len - i
doAssert inversion_number(descending) == descending.len * (descending.len - 1) div 2
doAssert inversion_number(newSeq[int](100000)) == 0
echo "Hello World"
