# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, random, sequtils
import cplib/collections/avlset

proc check(values: seq[int]) =
    var expected = values.sorted
    var unique: seq[int]
    for value in expected:
        if unique.len == 0 or unique[^1] != value: unique.add(value)
    let multi = initAvlSortedMultiSet(values)
    let single = initAvlSortedSet(values)
    doAssert multi.toSeq == expected
    doAssert single.toSeq == unique
    doAssert multi.toSeq == expected
    doAssert multi.len == expected.len
    doAssert single.len == unique.len
    var prefix: seq[int]
    for value in multi:
        prefix.add(value)
        if prefix.len == 3: break
    doAssert prefix == expected[0..<min(3, expected.len)]
    for a in single:
        doAssert multi.toSeq == expected
        doAssert a in unique

check(@[])
check(@[42])
check(@[1, 1, 1, 1])
check(@[low(int), high(int), 0, low(int), high(int)])
for values in [@[3, 2, 1], @[1, 2, 3], @[3, 1, 2], @[1, 3, 2]]:
    check(values)
for n in [2, 3, 7, 8, 31, 32, 63, 64, 127, 128]:
    var values = toSeq(0..<n)
    check(values)
    values.reverse
    check(values)
    check(newSeqWith(n, 5))

for seed in 0..<16:
    var rng = initRand(seed)
    var multi = initAvlSortedMultiSet[int]()
    var single = initAvlSortedSet[int]()
    var expected: seq[int]
    var unique: seq[int]
    for step in 0..<600:
        let value = rng.rand(-30..30)
        case rng.rand(0..3)
        of 0, 1:
            multi.incl(value)
            single.incl(value)
            expected.add(value)
            expected.sort
            if value notin unique:
                unique.add(value)
                unique.sort
        of 2:
            let pos = expected.find(value)
            doAssert multi.excl(value) == (pos >= 0)
            if pos >= 0: expected.delete(pos)
            let uniquePos = unique.find(value)
            doAssert single.excl(value) == (uniquePos >= 0)
            if uniquePos >= 0: unique.delete(uniquePos)
        else:
            if expected.len > 0:
                let pos = rng.rand(0..<expected.len)
                doAssert multi.pop(pos) == expected[pos]
                expected.delete(pos)
            if unique.len > 0:
                let pos = rng.rand(0..<unique.len)
                doAssert single.pop(pos) == unique[pos]
                unique.delete(pos)
        doAssert multi.toSeq == expected
        doAssert single.toSeq == unique
        doAssert multi.len == expected.len
        doAssert single.len == unique.len
    while expected.len > 0:
        doAssert multi.pop() == expected.pop()
        doAssert multi.toSeq == expected
    while unique.len > 0:
        doAssert single.pop(0) == unique[0]
        unique.delete(0)
        doAssert single.toSeq == unique
    multi.incl(7)
    single.incl(7)
    doAssert multi.toSeq == @[7]
    doAssert single.toSeq == @[7]

let strings = initAvlSortedMultiSet(@["z", "", "a", "a", "日本語"])
doAssert strings.toSeq == @["", "a", "a", "z", "日本語"]
doAssert $strings == " a a z 日本語"

type Key = object
    value, id: int
proc `<`(a, b: Key): bool = a.value < b.value
proc `<=`(a, b: Key): bool = a.value <= b.value
var tagged = initAvlSortedMultiSet[Key]()
for id in 0..<100: tagged.incl(Key(value: id mod 5, id: id))
var expectedKeys: seq[Key]
for value in 0..<5:
    for id in countdown(99, 0):
        if id mod 5 == value: expectedKeys.add(Key(value: value, id: id))
doAssert tagged.toSeq == expectedKeys

var large = initAvlSortedMultiSet[int]()
const largeN = 65537
for value in countdown(largeN - 1, 0): large.incl(value div 3)
var largeIndex = 0
for value in large:
    doAssert value == largeIndex div 3
    inc largeIndex
doAssert largeIndex == largeN

echo "Hello World"
