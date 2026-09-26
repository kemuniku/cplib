# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, random, sequtils, sets
import cplib/collections/intset

proc checkState(actual: IntSet, expected: HashSet[int]) =
    doAssert actual.len == expected.len
    var seen = initHashSet[int]()
    for x in actual:
        doAssert seen.len < expected.len
        doAssert x in expected
        doAssert not seen.containsOrIncl(x)
        doAssert x in actual
    doAssert seen == expected
    for x in expected:
        doAssert actual.contains(x)

template expectError(errorType: typedesc, body: untyped) =
    block:
        var raised = false
        try:
            body
        except errorType:
            raised = true
        doAssert raised

block:
    var s: IntSet
    checkState(s, initHashSet[int]())
    doAssert $s == "{}"
    doAssert s == initIntSet(0)
    s.excl(0)
    s.clear()
    expectError(IndexDefect):
        s.incl(0)
    expectError(KeyError):
        discard s.pop()
    expectError(ValueError):
        discard initIntSet(-1)
    expectError(ValueError):
        discard initIntSet(low(int)..high(int))
    expectError(ValueError):
        discard initIntSet(0..high(int))
    for bounds in [0 .. -1, 10..9, high(int)..low(int)]:
        var empty = initIntSet(bounds)
        checkState(empty, initHashSet[int]())
        doAssert empty == s
        expectError(IndexDefect):
            empty.incl(bounds.a)

block:
    var s = initIntSet(257)
    var expected = initHashSet[int]()
    for x in [0, 63, 64, 127, 128, 191, 192, 255, 256]:
        doAssert s.containsOrIncl(x) == expected.containsOrIncl(x)
        doAssert s.containsOrIncl(x)
        checkState(s, expected)
    for x in [64, 127, 256, 0, 63, 128, 191, 255, 192]:
        doAssert s.missingOrExcl(x) == expected.missingOrExcl(x)
        doAssert s.missingOrExcl(x)
        checkState(s, expected)
    for cycle in 0..<3:
        for x in [256, 128, 0, 192, 64]:
            s.incl(x)
            expected.incl(x)
        checkState(s, expected)
        s.clear()
        expected.clear()
        checkState(s, expected)

for lower in [low(int), -129, 0, high(int) - 129]:
    var s = initIntSet(lower..lower + 129)
    var expected = initHashSet[int]()
    for offset in [0, 63, 64, 127, 128, 129]:
        let x = lower + offset
        s.incl(x)
        expected.incl(x)
    checkState(s, expected)
    for x in [low(int), high(int)]:
        if x notin expected:
            doAssert x notin s
            doAssert s.missingOrExcl(x)
            expectError(IndexDefect):
                s.incl(x)
    while s.len > 0:
        let x = s.pop()
        doAssert not expected.missingOrExcl(x)
        checkState(s, expected)

block:
    let a = toIntSet([0, 63, 64, 0], 129)
    let b = toIntSet([64, 63, 0], -100..200)
    doAssert a == b
    doAssert a != toIntSet([0, 63, 65], 129)
    doAssert a != toIntSet([0, 63], 129)
    doAssert toSeq(a.items).sorted() == @[0, 63, 64]
    doAssert $toIntSet([-3], -10..10) == "{-3}"
    var pairs = 0
    for x in a:
        for y in a:
            doAssert x in b and y in b
            inc pairs
    doAssert pairs == 9
    var copy = a
    copy.excl(0)
    copy.incl(128)
    doAssert a == b
    doAssert copy != a
    copy.clear()
    doAssert a == b
    expectError(IndexDefect):
        discard toIntSet([0, 129], 129)

var rng = initRand(843157)
for size in [0, 1, 2, 63, 64, 65, 127, 128, 129, 257, 513, 4097]:
    for lower in [-100, 0, 100]:
        var s = initIntSet(lower..<lower + size)
        var expected = initHashSet[int]()
        for offset in 0..<size:
            s.incl(lower + offset)
            expected.incl(lower + offset)
        checkState(s, expected)
        var order = toSeq(expected.items)
        rng.shuffle(order)
        for x in order:
            s.excl(x)
            expected.excl(x)
            if expected.len mod 64 == 0:
                checkState(s, expected)
        checkState(s, expected)
        for step in 0..<1500:
            let x = lower + rng.rand(size + 2) - 1
            let inRange = x >= lower and x < lower + size
            case rng.rand(9)
            of 0, 1:
                if inRange:
                    s.incl(x)
                    expected.incl(x)
                else:
                    expectError(IndexDefect):
                        s.incl(x)
            of 2:
                if inRange:
                    doAssert s.containsOrIncl(x) == expected.containsOrIncl(x)
                else:
                    expectError(IndexDefect):
                        discard s.containsOrIncl(x)
            of 3:
                s.excl(x)
                expected.excl(x)
            of 4:
                doAssert s.missingOrExcl(x) == expected.missingOrExcl(x)
            of 5, 6:
                doAssert (x in s) == (x in expected)
            of 7:
                if expected.len == 0:
                    expectError(KeyError):
                        discard s.pop()
                else:
                    let removed = s.pop()
                    doAssert not expected.missingOrExcl(removed)
            of 8:
                var copy = s
                copy.clear()
                if size > 0:
                    copy.incl(lower)
                    doAssert copy.len == 1 and lower in copy
                checkState(s, expected)
            else:
                if step mod 5 == 0:
                    s.clear()
                    expected.clear()
            checkState(s, expected)

block:
    const size = 1 shl 24
    var s = initIntSet(size)
    let values = [0, size div 2, size - 1]
    let expected = toHashSet(values)
    for round in 0..<1000:
        for x in values:
            s.incl(x)
        checkState(s, expected)
        for x in values:
            s.excl(x)
            s.incl(x)
        checkState(s, expected)
        s.clear()
        doAssert s.len == 0

echo "Hello World"
