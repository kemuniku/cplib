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
        if step mod 3 == 0:
            let source = rng.rand(versions.high)
            var l = rng.rand(n)
            var r = rng.rand(n)
            if l > r: swap(l, r)
            if step mod 5 == 0:
                l = 0
                r = n
            for i in l..<r: expected[i] = states[source][i]
            if step mod 2 == 0: next = next.copy_range(versions[source], l, r)
            else: next = next.copy_range(versions[source], l..<r)
            check(versions[source], states[source], rng)
        elif n > 0 and step mod 4 == 0:
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
    let source = tree.apply(0, 4097, (2, 1))
    calls = 0
    let copied = changed.copy_range(source, 17, 4096)
    doAssert calls < 500
    doAssert copied.get_all().sum == 18 * 4 + (4096 - 17) * 3
    calls = 0
    doAssert changed.get(17, 4096).sum == (4096 - 17 - 1) * 4
    doAssert calls < 500
    calls = 0
    doAssert changed.max_right(17, proc(x: Value): bool = x.sum <= 400) == 117
    doAssert calls < 500
    calls = 0
    doAssert changed.min_left(4096, proc(x: Value): bool = x.sum <= 400) == 3996
    doAssert calls < 500

block:
    # 独立に構築した木のコピーと、元の木を破棄した後の領域の寿命を検証する。
    proc copiedTree(): PersistentLazySegmentTree[Value, Affine] =
        let dest = makeTree([1, 2, 3, 4, 5]).apply(0, 5, (2, 1))
        let source = makeTree([10, 20, 30, 40, 50]).apply(0, 5, (3, 2))
        result = dest.copy_range(source, 1, 4)
        result = result.copy_range(makeTree([7, 8, 9, 10, 11]), 2, 3)
    let saved = copiedTree()
    GC_fullCollect()
    check(saved, @[3, 62, 9, 122, 11], rng)
    let next = saved.apply(0, 5, (0, 7)).update(2, Value(sum: 100, size: 1))
    GC_fullCollect()
    check(next, @[7, 7, 100, 7, 7], rng)
    check(saved, @[3, 62, 9, 122, 11], rng)
    let full = makeTree([0, 0, 0, 0, 0]).copy_range(copiedTree(), 0, 5)
    GC_fullCollect()
    check(full, @[3, 62, 9, 122, 11], rng)

block:
    # ノード領域の追加をまたぎ、参照を含む値と異なる所有領域を検証する。
    proc stringTree(c: char): PersistentLazySegmentTree[string, char] =
        newPersistentLazySegWith([repeat(c, 1), repeat(c, 1), repeat(c, 1)], l & r, "",
            (if f == '\0': x else: repeat(f, x.len)), (if f == '\0': g else: f), '\0')
    var tree = stringTree('a')
    let old = tree
    for i in 0..<3000:
        tree = tree.apply(0, 3, char(ord('a') + i mod 26))
        if i mod 100 == 0:
            tree = tree.copy_range(stringTree('X'), 1, 2)
            GC_fullCollect()
            doAssert tree[1] == "X"
    doAssert tree.get_all() == repeat(char(ord('a') + 2999 mod 26), 3)
    doAssert old.get_all() == "aaa"

block:
    # 独立した木からの反復コピー後に、所有関係を深い再帰なしで解放できること。
    proc repeatedCopy() =
        var dest = makeTree([1, 2])
        let source = makeTree([3, 4])
        for i in 0..<200000:
            dest = dest.copy_range(source, 0, 1)
        doAssert dest.get_all().sum == 5
    repeatedCopy()
    GC_fullCollect()

block:
    # 複数の独立した木を双方向にコピーして所有領域を統合する。
    var trees: seq[PersistentLazySegmentTree[Value, Affine]]
    var states: seq[seq[int]]
    for i in 0..<16:
        states.add(@[i, i + 1, i + 2, i + 3, i + 4])
        trees.add(makeTree(states[^1]))
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

echo "Hello World"
