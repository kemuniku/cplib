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
        var next = versions[parent]
        if step mod 3 == 0:
            let source = rng.rand(versions.high)
            let l = rng.rand(n)
            let r = rng.rand(l..n)
            for i in l..<r: expected[i] = states[source][i]
            if step mod 2 == 0: next = next.copy_range(versions[source], l, r)
            else: next = next.copy_range(versions[source], l..<r)
            check(versions[source], states[source], rng)
        else:
            expected[p] = value
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

block:
    let empty = newPersistentSegWith(0, l + r, 0)
    doAssert empty.copy_range(empty, 0, 0).get_all() == 0
    doAssert empty.copy_range(empty, 0..<0).len == 0
    let a = newPersistentSegWith([1, 2, 3, 4, 5], l + r, 0)
    let b = newPersistentSegWith([6, 7, 8, 9, 10], l + r, 0)
    for l in 0..5:
        for r in l..5:
            let copied = a.copy_range(b, l, r)
            var expected = @[1, 2, 3, 4, 5]
            for i in l..<r: expected[i] = i + 6
            check(copied, expected, rng)
    check(a.copy_range(a, 1, 4), @[1, 2, 3, 4, 5], rng)
    check(a, @[1, 2, 3, 4, 5], rng)
    check(b, @[6, 7, 8, 9, 10], rng)
    doAssert newPersistentSegWith([1], l + r, 0).copy_range(
        newPersistentSegWith([2], l + r, 0), 0, 1)[0] == 2

block:
    # 別々に構築した木のコピーと、元の木の破棄後の寿命を検証する。
    proc makeCopied(full: bool): PSegmentTree[string] =
        let dest = newPersistentSegWith(["a", "b", "c", "d", "e"], l & r, "")
        let source = newPersistentSegWith(["v", "w", "x", "y", "z"], l & r, "")
        if full: dest.copy_range(source, 0, 5)
        else: dest.copy_range(source, 1..<4)
    let saved = makeCopied(false)
    let full = makeCopied(true)
    GC_fullCollect()
    doAssert saved.get_all() == "awxye"
    doAssert full.get_all() == "vwxyz"
    var tree = saved
    for i in 0..<3000:
        tree = tree.update(i mod 5, $char(ord('A') + i mod 26))
    GC_fullCollect()
    doAssert saved.get_all() == "awxye"
    for l in 0..5:
        for r in l..5:
            let target = "awxye"[l..<r]
            doAssert saved.get(l, r) == target
            doAssert saved.max_right(l, proc(x: string): bool = target.startsWith(x)) == r
            doAssert saved.min_left(r, proc(x: string): bool = target.endsWith(x)) == l

block:
    # 複数の独立した木を双方向にコピーし、所有領域の統合を検証する。
    var trees: seq[PSegmentTree[int]]
    var states: seq[seq[int]]
    for i in 0..<16:
        states.add(@[i, i + 1, i + 2, i + 3, i + 4])
        trees.add(newPersistentSegWith(states[^1], l + r, 0))
    for i in 0..<256:
        let d = rng.rand(15)
        let s = rng.rand(15)
        let l = rng.rand(4)
        let r = rng.rand(l..5)
        trees[d] = trees[d].copy_range(trees[s], l, r)
        for j in l..<r: states[d][j] = states[s][j]
        if i mod 16 == 0: GC_fullCollect()
        check(trees[d], states[d], rng)
    GC_fullCollect()
    for i in 0..<16: check(trees[i], states[i], rng)

block:
    # 独立した木から反復コピーしても、解放時の参照チェーンが深くならないこと。
    proc repeatedCopy() =
        var a = newPersistentSegWith([1, 2], l + r, 0)
        let b = newPersistentSegWith([3, 4], l + r, 0)
        for i in 0..<200000: a = a.copy_range(b, 0, 1)
        doAssert a.get_all() == 5
    repeatedCopy()
    GC_fullCollect()

block:
    var calls = 0
    let merge = proc(l, r: int): int =
        inc calls
        l + r
    let dest = initPersistentSegmentTree(4097, merge, 0)
    var values = newSeq[int](4097)
    for x in values.mitems: x = 1
    let source = initPersistentSegmentTree(values, merge, 0)
    calls = 0
    let copied = dest.copy_range(source, 17, 4096)
    doAssert copied.get_all() == 4096 - 17
    doAssert calls < 100
    calls = 0
    doAssert dest.copy_range(source, 0, 4097).get_all() == 4097
    doAssert calls == 0
    doAssert dest.get_all() == 0
    doAssert source.get_all() == 4097

echo "Hello World"
