# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, random
import cplib/collections/persistent_multiset

template rejects(body: untyped) =
    block:
        var caught = false
        try: body
        except ValueError: caught = true
        doAssert caught

proc check(s: PersistentMultiset[int], v: seq[int]) =
    doAssert s.len == v.len
    doAssert s.to_seq == v
    for i, value in v: doAssert s[i] == value and s.kth(i) == value
    for value in -12..12:
        var lower, upper = 0
        for x in v:
            if x < value: inc lower
            if x <= value: inc upper
        doAssert s.lower_bound(value) == lower
        doAssert s.upper_bound(value) == upper
        doAssert s.count(value) == upper - lower
        doAssert s.contains(value) == (upper != lower)

var rng = initRand(677339)
var versions = @[initPersistentMultiset(newSeq[int]())]
var expected = @[newSeq[int]()]
for step in 0..<1800:
    let source = rng.rand(versions.high)
    let old = versions[source]
    var v = @(expected[source])
    let value = rng.rand(-10..10)
    var current = old
    case step mod 5
    of 0, 1:
        current = old.insert(value)
        v.add(value)
        v.sort()
    of 2:
        current = old.erase(value)
        for i, x in v:
            if x == value:
                v.delete(i)
                break
    of 3:
        current = old.erase_all(value)
        var retained: seq[int]
        for x in v:
            if x != value: retained.add(x)
        v = retained
    else:
        let parts = old.split(value)
        current = parts.left.concat(parts.right)
    check(current, v)
    check(old, expected[source])
    versions.add(current)
    expected.add(v)
    for unused in 0..<3:
        let k = rng.rand(versions.high)
        check(versions[k], expected[k])
for k in 0..<versions.len: check(versions[k], expected[k])

block:
    var input = @[3, 1, 2, 1]
    let original = initPersistentMultiset(input)
    input[0] = 99
    check(original, @[1, 1, 2, 3])
    check(original.erase(1), @[1, 2, 3])
    check(original.erase_all(1), @[2, 3])
    check(original.erase(42), @[1, 1, 2, 3])
    let empty = original.split(low(int)).left
    let full = original.split(high(int)).left
    check(empty.concat(full), @[1, 1, 2, 3])
    rejects:
        discard original[-1]
    rejects:
        discard original[4]
    rejects:
        discard original.concat(original)
    rejects:
        discard empty.concat(initPersistentMultiset(newSeq[int]()))
    var uninitialized: PersistentMultiset[int]
    rejects:
        discard uninitialized.len
    rejects:
        discard uninitialized.insert(0)
    rejects:
        discard initPersistentMultiset(@[1], nil)
    let boundary = initPersistentMultiset(@[low(int), high(int), low(int), 0])
    doAssert boundary.lower_bound(low(int)) == 0
    doAssert boundary.upper_bound(low(int)) == 2
    doAssert boundary.lower_bound(high(int)) == 3
    doAssert boundary.upper_bound(high(int)) == 4
    doAssert boundary.erase_all(low(int)).to_seq == @[0, high(int)]

block:
    let descending = initPersistentMultiset(@[1, 2, 3, 2], proc(a, b: int): int = cmp(b, a))
    doAssert descending.to_seq == @[3, 2, 2, 1]
    doAssert descending.insert(4).to_seq == @[4, 3, 2, 2, 1]
    doAssert descending.lower_bound(2) == 1 and descending.upper_bound(2) == 3
    let parts = descending.split(2)
    doAssert parts.left.to_seq == @[3] and parts.right.to_seq == @[2, 2, 1]
    doAssert parts.left.concat(parts.right).to_seq == descending.to_seq
    let strings = initPersistentMultiset(@["a", "b", "", "a"])
    doAssert strings.to_seq == @["", "a", "a", "b"]
    doAssert strings.erase("a").to_seq == @["", "a", "b"]
    type Item = tuple[key, payload: int]
    let byKey = initPersistentMultiset(@[(2, 20), (1, 10), (2, 21)], proc(a, b: Item): int = cmp(a.key, b.key))
    let more = byKey.insert((2, 22))
    doAssert more.to_seq == @[(1, 10), (2, 20), (2, 21), (2, 22)]
    doAssert more.count((2, 99)) == 3
    doAssert more.erase((2, -1)).to_seq == @[(1, 10), (2, 21), (2, 22)]
    doAssert more.erase_all((2, -1)).to_seq == @[(1, 10)]
    doAssert byKey.to_seq == @[(1, 10), (2, 20), (2, 21)]

block:
    let single = initPersistentMultiset(@[7])
    var repeated = single
    for i in 0..<24: repeated = repeated.concat(repeated)
    doAssert repeated.len == 1 shl 24
    doAssert repeated.count(7) == repeated.len
    doAssert repeated.kth(repeated.len - 1) == 7
    doAssert repeated.erase(7).len == repeated.len - 1
    doAssert repeated.erase_all(7).len == 0
    doAssert single.len == 1

proc retained(): PersistentMultiset[int] =
    let source = initPersistentMultiset(@[1, 2, 2, 3])
    source.insert(2).split(2).right.erase(3)
block:
    let survivor = retained()
    when declared(GC_fullCollect): GC_fullCollect()
    check(survivor, @[2, 2, 2])

echo "Hello World"
