# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/meldable_multiset
import algorithm, random, sequtils

type Key = object
    order, payload: int
proc `<`(a, b: Key): bool = a.order < b.order

template expectError(kind: typedesc, body: untyped) =
    block:
        var caught = false
        try: body
        except kind: caught = true
        doAssert caught

proc check(s: MeldableMultiSet[int], values: seq[int]) =
    var sorted = values
    sorted.sort()
    doAssert s.len == sorted.len
    doAssert toSeq(s.items) == sorted
    for i, x in sorted:
        doAssert s.kth(i) == x
        doAssert s[i] == x
    for x in -7..7:
        var less, lessEqual, equal = 0
        for y in values:
            if y < x: inc less
            if y <= x: inc lessEqual
            if y == x: inc equal
        doAssert s.lowerBound(x) == less
        doAssert s.upperBound(x) == lessEqual
        doAssert s.count(x) == equal
        doAssert s.contains(x) == (equal != 0)
    expectError(IndexDefect): discard s.kth(-1)
    expectError(IndexDefect): discard s.kth(s.len)

block:
    var inputs: seq[seq[int]] = @[@[]]
    for length in 1..3:
        let previous = inputs
        for v in previous:
            if v.len == length - 1:
                for x in -1..1: inputs.add(v & @[x])
    for av in inputs:
        for bv in inputs:
            for reverse in [false, true]:
                let a = initMeldableMultiSet(av)
                let b = initMeldableMultiSet(bv)
                let aliasA = a
                let aliasB = b
                if reverse:
                    b.meld(a)
                    check(aliasB, av & bv)
                    check(aliasA, @[])
                else:
                    a.meld(b)
                    check(aliasA, av & bv)
                    check(aliasB, @[])
                a.meld(aliasA)
                b.meld(aliasB)
                let destination = if reverse: b else: a
                var expected = av & bv
                for x in -2..2:
                    var at = -1
                    for i, y in expected:
                        if x == y:
                            at = i
                            break
                    doAssert destination.excl(x) == (at != -1)
                    if at != -1: expected.delete(at)
                    check(destination, expected)
                a.incl(7)
                b.incl(-7)
                if reverse:
                    check(a, @[7])
                    check(b, expected & @[-7])
                else:
                    check(a, expected & @[7])
                    check(b, @[-7])

block:
    var rng = initRand(402)
    randomize(402)
    var sets: array[12, MeldableMultiSet[int]]
    var oracle: array[12, seq[int]]
    for s in sets.mitems: s = initMeldableMultiSet[int]()
    for step in 0..<18000:
        let a = rng.rand(sets.high)
        case rng.rand(0..5)
        of 0, 1:
            let x = rng.rand(-7..7)
            sets[a].incl(x)
            oracle[a].add(x)
        of 2:
            let x = rng.rand(-7..7)
            var at = -1
            for i, y in oracle[a]:
                if y == x:
                    at = i
                    break
            doAssert sets[a].excl(x) == (at >= 0)
            if at >= 0: oracle[a].delete(at)
        of 3:
            let b = rng.rand(sets.high)
            sets[a].meld(sets[b])
            if a != b:
                oracle[a].add(oracle[b])
                oracle[b] = @[]
        of 4:
            let copy = initMeldableMultiSet(oracle[a])
            copy.incl(99)
            doAssert copy.len == sets[a].len + 1
        else:
            let alias = sets[a]
            sets[a].meld(alias)
        check(sets[a], oracle[a])
        for i in 0..sets.high: doAssert sets[i].len == oracle[i].len
        if step mod 100 == 0:
            for i in 0..sets.high: check(sets[i], oracle[i])
        if sets[a].len > 500:
            for x in oracle[a]: doAssert sets[a].excl(x)
            oracle[a] = @[]
    for i in 0..sets.high: check(sets[i], oracle[i])

block:
    var input = @[high(int), low(int), 0, high(int), low(int)]
    let a = initMeldableMultiSet(input)
    input[0] = 123
    doAssert toSeq(a.items) == @[low(int), low(int), 0, high(int), high(int)]
    doAssert a.lowerBound(low(int)) == 0 and a.upperBound(low(int)) == 2
    doAssert a.lowerBound(high(int)) == 3 and a.upperBound(high(int)) == 5
    doAssert a.excl(low(int)) and a.excl(high(int))
    doAssert a.count(low(int)) == 1 and a.count(high(int)) == 1
    let u = initMeldableMultiSet([0'u64, high(uint64), high(uint64)])
    u.meld(initMeldableMultiSet([high(uint64), 1'u64]))
    doAssert toSeq(u.items) == @[0'u64, 1'u64, high(uint64), high(uint64), high(uint64)]
    let words = initMeldableMultiSet(["", "b", "a", "", "\0"])
    words.meld(initMeldableMultiSet(["a", "", "z"]))
    doAssert toSeq(words.items) == @["", "", "", "\0", "a", "a", "b", "z"]
    doAssert words.count("") == 3 and words.excl("")
    let pairs = initMeldableMultiSet([(1, "b"), (1, "a"), (0, "z")])
    doAssert pairs.kth(0) == (0, "z")

block:
    let a = initMeldableMultiSet([Key(order: 1, payload: 10), Key(order: 1, payload: 20)])
    let b = initMeldableMultiSet([Key(order: 0, payload: 30), Key(order: 1, payload: 40)])
    a.meld(b)
    doAssert a.count(Key(order: 1, payload: -999)) == 3
    var payloads: seq[int]
    for x in a.items: payloads.add(x.payload)
    doAssert payloads == @[30, 10, 20, 40]
    doAssert a.excl(Key(order: 1))
    doAssert a.count(Key(order: 1)) == 2 and b.len == 0
    doAssert a.lowerBound(Key(order: 1)) == 1 and a.upperBound(Key(order: 1)) == 3

block:
    let empty = initMeldableMultiSet[int]()
    check(empty, @[])
    doAssert not empty.excl(0)
    var uninitialized: MeldableMultiSet[int]
    expectError(ValueError): discard uninitialized.len
    expectError(ValueError): uninitialized.incl(1)
    expectError(ValueError): discard uninitialized.excl(1)
    expectError(ValueError): discard uninitialized.count(1)
    expectError(ValueError): discard uninitialized.lowerBound(1)
    expectError(ValueError): discard uninitialized.upperBound(1)
    expectError(ValueError): discard uninitialized.kth(0)
    expectError(ValueError): discard uninitialized.contains(0)
    expectError(ValueError):
        for x in uninitialized.items: discard x
    expectError(ValueError): empty.meld(uninitialized)
    expectError(ValueError): uninitialized.meld(empty)
    doAssert empty.len == 0

block:
    let a = initMeldableMultiSet[int]()
    let b = initMeldableMultiSet[int]()
    for i in 0..<128:
        randomize(1234)
        a.incl(2 * i)
        randomize(1234)
        b.incl(2 * i + 1)
    a.meld(b)
    check(a, toSeq(0..<256))
    doAssert b.len == 0
    for i in 0..<256: doAssert a.excl(i)
    check(a, @[])
    randomize(402)

block:
    let a = initMeldableMultiSet[int]()
    let b = initMeldableMultiSet[int]()
    for i in 0..<20000:
        a.incl(2 * i)
        b.incl(2 * i + 1)
    a.meld(b)
    doAssert b.len == 0 and a.len == 40000
    for i in 0..<40000: doAssert a.kth(i) == i
    for i in countdown(39999, 0): doAssert a.excl(i)
    doAssert a.len == 0
    for i in 0..<20000:
        a.incl(4)
        b.incl(4)
    a.meld(b)
    doAssert a.len == 40000 and a.count(4) == 40000 and b.len == 0
    let tiny = initMeldableMultiSet([-1, 4, 4, 4, 9])
    tiny.meld(a)
    doAssert tiny.len == 40005 and tiny.count(4) == 40003
    doAssert tiny.kth(0) == -1 and tiny.kth(40004) == 9 and a.len == 0
    for i in 0..<1500: b.meld(initMeldableMultiSet([i mod 5]))
    for x in 0..<5: doAssert b.count(x) == 300
    var visited = 0
    for x in tiny.items:
        inc visited
        if visited == 10: break
    doAssert visited == 10

echo "Hello World"
