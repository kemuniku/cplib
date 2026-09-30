# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/collections/persistent_array

proc check(shift: static int) =
    let empty = initPersistentArray(newSeq[int](), shift)
    doAssert empty.toseq() == newSeq[int]()
    let emptyStrings = initPersistentArray(newSeq[string](), shift)
    doAssert emptyStrings.toseq() == newSeq[string]()
    var rng = initRand(18731 + shift)
    for size in 1..100:
        var initial = newSeq[int](size)
        for i in 0..<size:
            initial[i] = i
        var versions = @[initPersistentArray(initial, shift)]
        var expected = @[initial]
        for step in 0..<30:
            let parent = rng.rand(versions.high)
            let index = rng.rand(size-1)
            let value = rng.rand(-100..100)
            versions.add(versions[parent].change_value(index, value))
            var next = expected[parent]
            next[index] = value
            expected.add(next)
            doAssert versions[parent].toseq() == expected[parent]
            doAssert versions[^1].toseq() == next
            doAssert versions[^1][index] == value
        for i in 0..<versions.len:
            doAssert versions[i].toseq() == expected[i]

check(1)
check(2)
check(5)
echo "Hello World"
