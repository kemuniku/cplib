# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, strutils
import cplib/collections/persistent_lazysegtree

type
    Value = object
        sum, size: int
    Affine = tuple[a, b: int]

proc merge(l, r: Value): Value = Value(sum: l.sum + r.sum, size: l.size + r.size)
proc mapping(f: Affine, x: Value): Value = Value(sum: f.a * x.sum + f.b * x.size, size: x.size)
proc composition(f, g: Affine): Affine = (f.a * g.a, f.a * g.b + f.b)
proc makeTree(values: openArray[int]): PersistentLazySegmentTree[Value, Affine] =
    var initial: seq[Value]
    for x in values: initial.add(Value(sum: x, size: 1))
    initPersistentLazySegmentTree(initial, merge, Value(), mapping, composition, (1, 0))

block:
    let base = makeTree([1, 2, 3, 4, 5])
    let added = base.apply(0, 5, (1, 3))
    let multiplied = added.apply(0..<5, (2, 0))
    let branch = added.apply(1, 4, (0, 7))
    var assigned = multiplied.update(2, Value(sum: 100, size: 1))
    let saved = assigned
    assigned[^1] = Value(sum: 9, size: 1)
    assigned[0] = Value(sum: 20, size: 1)
    doAssert base.get_all() == Value(sum: 15, size: 5)
    doAssert added.get_all() == Value(sum: 30, size: 5)
    doAssert multiplied.get_all() == Value(sum: 60, size: 5)
    doAssert branch.get_all() == Value(sum: 33, size: 5)
    doAssert saved[^1] == Value(sum: 16, size: 1)
    doAssert saved[0] == Value(sum: 8, size: 1)
    doAssert assigned.get_all() == Value(sum: 153, size: 5)
    doAssert assigned[1..3] == Value(sum: 124, size: 3)
    doAssert assigned.get(1..3) == Value(sum: 124, size: 3)
    doAssert assigned.query(1, 4) == Value(sum: 124, size: 3)
    doAssert assigned.apply(2..<2, (0, 999)).get_all() == assigned.get_all()
    doAssert multiplied[2] == Value(sum: 12, size: 1)

block:
    let tree = newLazySegWith([1, 2, 3, 4, 5], min(l, r), int.high, f + x, f + g, 0)
    let next = tree.apply(0, 5, 7)
    doAssert $tree == "1 2 3 4 5"
    doAssert $next == "8 9 10 11 12"
    doAssert next[^5] == 8
    let sized: PLazySegmentTree[int, int] = initLazySegmentTree(3, (proc(l, r: int): int = min(l, r)), int.high,
        proc(f, x: int): int = min(f, x), proc(f, g: int): int = min(f, g), int.high)
    doAssert sized.apply(0, 3, 10).get_all() == 10
    doAssert sized.get_all() == int.high
    let viaSeq = initLazySegmentTree(@[3, 2, 1], (proc(l, r: int): int = min(l, r)), int.high,
        proc(f, x: int): int = min(f, x), proc(f, g: int): int = min(f, g), int.high)
    doAssert viaSeq.len == 3
    doAssert viaSeq[1] == 2
    let templated = newPersistentLazySegWith(3, min(l, r), int.high,
        min(f, x), min(f, g), int.high)
    doAssert templated[0] == int.high
    let empty = newPersistentLazySegWith(0, l + r, 0, x, 0, 0)
    doAssert empty.len == 0
    doAssert empty.get_all() == 0
    doAssert empty[0..<0] == 0
    doAssert $empty == ""
    doAssert empty.max_right(0, proc(x: int): bool = x == 0) == 0
    doAssert empty.min_left(0, proc(x: int): bool = x == 0) == 0
    doAssert empty.apply(0, 0, 1).get_all() == 0

proc check(tree: PersistentLazySegmentTree[Value, Affine], expected: seq[int], rng: var Rand) =
    doAssert tree.len == expected.len
    var total = 0
    var rendered: seq[string]
    for i, x in expected:
        let value = Value(sum: x, size: 1)
        doAssert tree[i] == value
        rendered.add($value)
        total += x
    doAssert tree.get_all() == Value(sum: total, size: expected.len)
    doAssert $tree == rendered.join(" ")
    for rep in 0..<5:
        var l = rng.rand(expected.len)
        var r = rng.rand(expected.len)
        if l > r: swap(l, r)
        var sum = 0
        for i in l..<r: sum += expected[i]
        doAssert tree.get(l, r) == Value(sum: sum, size: r - l)
        doAssert tree[l..<r] == Value(sum: sum, size: r - l)
        let limit = rng.rand(total + 1)
        let predicate = proc(x: Value): bool = x.sum <= limit
        var right = l
        sum = 0
        while right < expected.len and sum + expected[right] <= limit:
            sum += expected[right]
            inc right
        doAssert tree.max_right(l, predicate) == right
        var left = r
        sum = 0
        while left > 0 and expected[left - 1] + sum <= limit:
            dec left
            sum += expected[left]
        doAssert tree.min_left(r, predicate) == left

var rng = initRand(20260927)
for n in [0, 1, 2, 3, 7, 16, 31, 64]:
    var initial = newSeq[int](n)
    for x in initial.mitems: x = rng.rand(9)
    var versions = @[makeTree(initial)]
    var states = @[initial]
    for step in 0..<400:
        let parent = if step mod 3 == 0: rng.rand(versions.high) else: versions.high
        var expected = newSeq[int](n)
        for i in 0..<n: expected[i] = states[parent][i]
        var next = versions[parent]
        if n > 0 and step mod 4 == 0:
            let p = rng.rand(n - 1)
            let value = rng.rand(20)
            expected[p] = value
            if step mod 8 == 0: next[p] = Value(sum: value, size: 1)
            else: next = next.update(p, Value(sum: value, size: 1))
        else:
            var l = rng.rand(n)
            var r = rng.rand(n)
            if l > r: swap(l, r)
            if step mod 5 == 0:
                l = 0
                r = n
            let f: Affine = (rng.rand(1), rng.rand(5))
            for i in l..<r: expected[i] = f.a * expected[i] + f.b
            if step mod 2 == 0: next = next.apply(l, r, f)
            else: next = next.apply(l..<r, f)
        versions.add(next)
        states.add(expected)
        check(next, expected, rng)
        check(versions[parent], states[parent], rng)
        let old = rng.rand(versions.high)
        check(versions[old], states[old], rng)
    for i in 0..<versions.len: check(versions[i], states[i], rng)

block:
    let base = newPersistentLazySegWith(["a", "b", "c", "d", "e", "f", "g"], l & r, "",
        (if f == '\0': x else: repeat(f, x.len)), (if f == '\0': g else: f), '\0')
    let versions = @[base, base.apply(0, 7, 'x'), base.apply(1, 6, 'y'),
        base.apply(0, 7, 'x').apply(2, 5, 'z').update(3, "A")]
    let states = @["abcdefg", "xxxxxxx", "ayyyyyg", "xxzAzxx"]
    for i, tree in versions:
        doAssert tree.get_all() == states[i]
        for l in 0..7:
            for r in l..7:
                let target = states[i][l..<r]
                doAssert tree.get(l, r) == target
                doAssert tree.max_right(l, proc(x: string): bool = target.startsWith(x)) == r
                doAssert tree.min_left(r, proc(x: string): bool = target.endsWith(x)) == l

block:
    type Action = proc(x: int): int
    let identity: Action = proc(x: int): int = x
    let twice: Action = proc(x: int): int = x * 2
    let tree = newPersistentLazySegWith([1, 2, 3], l + r, 0,
        f(x), (proc(x: int): int = f(g(x))), identity)
    let next = tree.apply(0, 3, twice)
    doAssert next.get_all() == 12
    doAssert next[1] == 4
    doAssert tree[1] == 2

block:
    var calls = 0
    let countedMerge = proc(l, r: Value): Value =
        inc calls
        merge(l, r)
    let countedMapping = proc(f: Affine, x: Value): Value =
        inc calls
        mapping(f, x)
    let countedComposition = proc(f, g: Affine): Affine =
        inc calls
        composition(f, g)
    var initial = newSeq[Value](4097)
    for x in initial.mitems: x = Value(sum: 1, size: 1)
    let tree = initPersistentLazySegmentTree(initial, countedMerge, Value(),
        countedMapping, countedComposition, (1, 0))
    calls = 0
    let added = tree.apply(0, 4097, (1, 3))
    doAssert calls < 500
    calls = 0
    let changed = added.update(2000, Value(sum: 0, size: 1))
    doAssert calls < 500
    calls = 0
    doAssert changed.get(17, 4096).sum == (4096 - 17 - 1) * 4
    doAssert calls < 500
    calls = 0
    doAssert changed.max_right(17, proc(x: Value): bool = x.sum <= 400) == 117
    doAssert calls < 500
    calls = 0
    doAssert changed.min_left(4096, proc(x: Value): bool = x.sum <= 400) == 3996
    doAssert calls < 500

echo "Hello World"
