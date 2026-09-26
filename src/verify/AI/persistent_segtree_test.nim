# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, strutils
import cplib/collections/persistent_segtree

let st = initSegmentTree(@[1, 2, 3, 4], proc(l, r: int): int = l + r, 0)
doAssert st.query(0, 4) == 10
doAssert st.query(1, 3) == 5
let st2 = st.update(2, 10)
doAssert st.query(0, 4) == 10
doAssert st2.query(0, 4) == 17
doAssert st2.query(2, 3) == 10

block:
    var current = newSegWith([1, 2, 3, 4, 5], l + r, 0)
    let saved = current
    current[2] = 10
    current[^1] = 7
    doAssert current.len == 5
    doAssert current[^1] == 7
    doAssert current[^5] == 1
    doAssert current[1..3] == 16
    doAssert current.get(1..3) == 16
    doAssert current.get_all() == 24
    doAssert $current == "1 2 10 4 7"
    doAssert $saved == "1 2 3 4 5"
    doAssert current.max_right(0, proc(x: int): bool = x <= 13) == 3
    doAssert current.min_left(5, proc(x: int): bool = x <= 11) == 3
    let sized: PersistentSegmentTree[int] = initPersistentSegmentTree(5, (proc(l, r: int): int = min(l, r)), int.high)
    doAssert sized.get_all() == int.high
    doAssert sized[0] == int.high
    doAssert initSegmentTree[int](3, proc(l, r: int): int = l + r, 0).get_all() == 0
    doAssert newPersistentSegWith(3, l + r, 0).len == 3

block:
    type Value = object
        sum, size: int
    let v = [Value(sum: 2, size: 1), Value(sum: 5, size: 1)]
    let a = newPersistentSegWith(v,
        Value(sum: l.sum + r.sum, size: l.size + r.size), Value())
    let b = a.update(0, Value(sum: 9, size: 1))
    doAssert a.get_all() == Value(sum: 7, size: 2)
    doAssert b.get_all() == Value(sum: 14, size: 2)

block:
    type Box = ref object
        value: int
    let a = newPersistentSegWith([Box(value: 3), Box(value: 4)],
        Box(value: l.value + r.value), Box(value: 0))
    let b = a.update(0, Box(value: 8))
    doAssert a.get_all().value == 7
    doAssert b.get_all().value == 12

block:
    let a = newPersistentSegWith(["a", "b", "c", "d", "e", "f", "g"], l & r, "")
    let b = a.update(3, "X")
    doAssert a.get_all() == "abcdefg"
    doAssert b.get_all() == "abcXefg"
    let expected = "abcXefg"
    for l in 0..expected.len:
        for r in l..expected.len:
            let target = expected[l..<r]
            doAssert b.get(l, r) == target
            doAssert b.max_right(l, proc(x: string): bool = target.startsWith(x)) == r
            doAssert b.min_left(r, proc(x: string): bool = target.endsWith(x)) == l

proc check(st: PSegmentTree[int], expected: seq[int], rng: var Rand) =
    doAssert st.len == expected.len
    var total = 0
    for i, x in expected:
        doAssert st[i] == x
        total += x
    doAssert st.get_all() == total
    doAssert $st == expected.join(" ")
    for rep in 0..<5:
        var l = rng.rand(expected.len)
        var r = rng.rand(expected.len)
        if l > r: swap(l, r)
        var sum = 0
        for i in l..<r: sum += expected[i]
        doAssert st.query(l, r) == sum
        doAssert st[l..<r] == sum
        let limit = rng.rand(total + 1)
        let predicate = proc(x: int): bool = x <= limit
        var right = l
        sum = 0
        while right < expected.len and sum + expected[right] <= limit:
            sum += expected[right]
            inc right
        doAssert st.max_right(l, predicate) == right
        var left = r
        sum = 0
        while left > 0 and expected[left - 1] + sum <= limit:
            dec left
            sum += expected[left]
        doAssert st.min_left(r, predicate) == left

var rng = initRand(20260926)
for n in [0, 1, 2, 3, 7, 16, 31, 64]:
    var initial = newSeq[int](n)
    for x in initial.mitems: x = rng.rand(9)
    var versions = @[newPersistentSegWith(initial, l + r, 0)]
    var states = @[initial]
    check(versions[0], states[0], rng)
    if n == 0:
        doAssert initPersistentSegmentTree[int](0, proc(l, r: int): int = l + r, 0).len == 0
        continue
    for step in 0..<300:
        let parent = if step mod 3 == 0: versions.high else: rng.rand(versions.high)
        let p = rng.rand(n - 1)
        let value = rng.rand(20)
        var expected = newSeq[int](n)
        for i in 0..<n: expected[i] = states[parent][i]
        expected[p] = value
        var next = versions[parent]
        if step mod 2 == 0: next = next.update(p, value)
        else: next[p] = value
        versions.add(next)
        states.add(expected)
        check(next, expected, rng)
        check(versions[parent], states[parent], rng)
        let old = rng.rand(versions.high)
        check(versions[old], states[old], rng)
    for i in 0..<versions.len: check(versions[i], states[i], rng)

block:
    var calls = 0
    let merge = proc(l, r: int): int =
        inc calls
        l + r
    let tree = initPersistentSegmentTree(4097, merge, 0)
    calls = 0
    let changed = tree.update(2000, 1)
    doAssert calls < 100
    calls = 0
    doAssert changed.get(17, 4096) == 1
    doAssert calls < 100
    calls = 0
    doAssert changed.max_right(17, proc(x: int): bool = x == 0) == 2000
    doAssert calls < 100
    calls = 0
    doAssert changed.min_left(4096, proc(x: int): bool = x == 0) == 2001
    doAssert calls < 100

echo "Hello World"
