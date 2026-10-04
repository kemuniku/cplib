# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, random, sets
include cplib/collections/persistent_sequence

template rejects(body: untyped) =
    block:
        var caught = false
        try: body
        except ValueError: caught = true
        doAssert caught

proc validate[T, F](s: PersistentSequence[T, F]) =
    var seen = initHashSet[pointer]()
    proc visit(n: PersistentSequenceNode[T, F]) =
        if n == nil or cast[pointer](n) in seen: return
        seen.incl(cast[pointer](n))
        doAssert abs(n.left.nodeHeight - n.right.nodeHeight) <= 1
        doAssert n.height == max(n.left.nodeHeight, n.right.nodeHeight) + 1
        doAssert n.size == n.left.nodeSize + 1 + n.right.nodeSize
        visit(n.left)
        visit(n.right)
    visit(s.root)

proc snapshot[T, F](s: PersistentSequence[T, F]): proc() =
    type Data = typeof(s.root[])
    var saved: seq[tuple[node: PersistentSequenceNode[T, F], data: Data]]
    var seen = initHashSet[pointer]()
    proc visit(n: PersistentSequenceNode[T, F]) =
        if n == nil or cast[pointer](n) in seen: return
        seen.incl(cast[pointer](n))
        saved.add((n, n[]))
        visit(n.left)
        visit(n.right)
    visit(s.root)
    result = proc() =
        for entry in saved: doAssert entry.node[] == entry.data

type Action = tuple[a, b: int64]
proc create(v: seq[int64]): PersistentSequence[int64, Action] =
    initPersistentLazySequence(v, proc(a, b: int64): int64 = a + b, 0'i64,
        proc(f: Action, x: int64): int64 = f.a * x + f.b,
        proc(f: Action, x: int64, length: int): int64 = f.a * x + f.b * length.int64,
        proc(f, g: Action): Action = (f.a * g.a, f.a * g.b + f.b), (1'i64, 0'i64))

proc check(s: PersistentSequence[int64, Action], v: seq[int64]) =
    let immutable = snapshot(s)
    s.validate
    doAssert s.len == v.len
    doAssert s.to_seq == v
    var total = 0'i64
    for x in v: total += x
    doAssert s.get_all == total
    for i, x in v: doAssert s[i] == x
    for l in 0..v.len:
        var sum = 0'i64
        for r in l..v.len:
            doAssert s.prod(l, r) == sum
            if r < v.len: sum += v[r]
    immutable()

block:
    let empty = create(@[])
    check(empty, @[])
    let singleton = empty.insert(0, 5)
    check(singleton, @[5'i64])
    check(singleton.erase(0), @[])
    doAssert empty.split(0).left.len == 0
    doAssert empty.reverse(0, 0).len == 0
    doAssert empty.apply(0, 0, (0'i64, 9'i64)).len == 0
    doAssert empty.concat(singleton).to_seq == @[5'i64]
    doAssert singleton.concat(empty).to_seq == @[5'i64]
    rejects:
        discard empty[0]
    rejects:
        discard empty.erase(0)
    rejects:
        discard empty.update(0, 7)
    rejects:
        discard singleton[high(int)]
    rejects:
        discard singleton[-1]
    rejects:
        discard singleton.split(-1)
    rejects:
        discard singleton.split(2)
    rejects:
        discard singleton.insert(2, 1)
    rejects:
        discard singleton.insert(-1, 1)
    for bounds in [(-1, 0), (1, 0), (0, 2), (0, high(int))]:
        rejects:
            discard singleton.erase(bounds[0], bounds[1])
        rejects:
            discard singleton.slice(bounds[0], bounds[1])
        rejects:
            discard singleton.prod(bounds[0], bounds[1])
        rejects:
            discard singleton.reverse(bounds[0], bounds[1])
        rejects:
            discard singleton.apply(bounds[0], bounds[1], (1'i64, 2'i64))
    rejects:
        discard singleton.concat(create(@[1'i64]))
    var uninitialized: PersistentSequence[int64, Action]
    rejects:
        discard uninitialized.len
    rejects:
        discard uninitialized.to_seq
    rejects:
        discard uninitialized.get_all
    rejects:
        discard uninitialized.concat(singleton)

block:
    var input = @[1, 2, 3]
    let original = initPersistentSequence(input)
    input[0] = 99
    doAssert original.to_seq == @[1, 2, 3]
    let reversed = original.reverse(0, 3)
    doAssert reversed.to_seq == @[3, 2, 1]
    let parts = reversed.split(1)
    doAssert parts.left.concat(parts.right).to_seq == @[3, 2, 1]
    doAssert original.concat(original).to_seq == @[1, 2, 3, 1, 2, 3]
    let fresh = original.from_seq(@[4, 5])
    doAssert original.concat(fresh).to_seq == @[1, 2, 3, 4, 5]
    var changed = original
    changed[1] = 7
    doAssert changed.to_seq == @[1, 7, 3]
    doAssert original.to_seq == @[1, 2, 3]
    rejects:
        discard original.prod(0, 0)
    rejects:
        discard original.get_all
    doAssert initPersistentSequence(newSeq[string]()).len == 0
    let text = initPersistentSequence(@["aa", "", "b"])
    doAssert text.erase(1).to_seq == @["aa", "b"]

block:
    for length in [0, 1, 2, 3, 7, 8, 9, 31, 32, 33, 63, 64, 65, 127, 128, 129]:
        var v: seq[int64]
        for i in 0..<length: v.add(i.int64)
        let original = create(v)
        let delayed = original.apply(0, length, (2'i64, 1'i64)).reverse(0, length)
        var expected: seq[int64]
        for i in countdown(length - 1, 0): expected.add(2'i64 * i.int64 + 1)
        for boundary in 0..length:
            let immutable = snapshot(delayed)
            let parts = delayed.split(boundary)
            doAssert parts.left.to_seq == expected[0..<boundary]
            doAssert parts.right.to_seq == expected[boundary..<length]
            let restored = parts.left.concat(parts.right)
            restored.validate
            doAssert restored.to_seq == expected
            immutable()
        doAssert original.to_seq == v
    let monoid = initPersistentSequence(@["ab", "", "cd"], proc(a, b: string): string = a & b, "")
    doAssert monoid.get_all == "abcd"
    doAssert monoid.reverse(0, 3).prod(0, 3) == "cdab"
    let added = create(@[-2'i64, -1, 0, 1, 2]).apply(0, 5, (1'i64, 10'i64))
    for x in 7..13:
        doAssert added.partition_point(proc(y: int64): bool = y < x.int64) == max(0, min(5, x - 8))
    rejects:
        discard monoid.partition_point(nil)
    rejects:
        discard initPersistentSequence(@[1], nil, 0)

var rng = initRand(6772026)
var trees = @[create(@[])]
var oracles = @[newSeq[int64]()]
for step in 0..<1600:
    let source = rng.rand(trees.high)
    let old = trees[source]
    let immutable = snapshot(old)
    var v = @(oracles[source])
    var current = old
    let l = rng.rand(v.len)
    let r = rng.rand(l..v.len)
    case rng.rand(0..9)
    of 0:
        let value = rng.rand(-10..10).int64
        current = old.insert(l, value)
        v.insert(value, l)
    of 1:
        current = old.erase(l, r)
        v = v[0..<l] & v[r..<v.len]
    of 2:
        current = old.reverse(l, r)
        if l < r: v.reverse(l, r - 1)
    of 3:
        let f: Action = (rng.rand(-1..1).int64, rng.rand(-3..3).int64)
        current = old.apply(l, r, f)
        for i in l..<r: v[i] = f.a * v[i] + f.b
    of 4:
        if v.len > 0:
            let k = rng.rand(v.high)
            current = old.update(k, step.int64)
            v[k] = step.int64
    of 5:
        current = old.slice(l, r)
        v = v[l..<r]
    of 6:
        let parts = old.split(l)
        current = parts.right.concat(parts.left)
        v = v[l..<v.len] & v[0..<l]
    of 7:
        current = old.concat(old)
        v = v & v
    of 8:
        let piece = old.reverse(l, r).slice(l, r)
        current = old.slice(0, l).concat(piece).concat(old.slice(r, old.len))
        if l < r: v.reverse(l, r - 1)
    else:
        let other = old.from_seq(@[step.int64, -step.int64])
        current = old.concat(other)
        v.add(@[step.int64, -step.int64])
    if v.len > 64:
        current = current.slice(0, 64)
        v.setLen(64)
    immutable()
    check(current, v)
    check(old, oracles[source])
    trees.add(current)
    oracles.add(v)
    for unused in 0..<3:
        let k = rng.rand(trees.high)
        check(trees[k], oracles[k])
for k in 0..<trees.len: check(trees[k], oracles[k])

block:
    type Substitution = array[3, char]
    let identity: Substitution = ['a', 'b', 'c']
    proc substitute(f: Substitution, x: string): string =
        for ch in x: result.add(f[ord(ch) - ord('a')])
    proc combine(f, g: Substitution): Substitution =
        for i in 0..2: result[i] = f[ord(g[i]) - ord('a')]
    let prototype = initPersistentLazySequence(newSeq[string](), proc(a, b: string): string = a & b, "",
        substitute, proc(f: Substitution, x: string, length: int): string = substitute(f, x), combine, identity)
    var versions = @[prototype.from_seq(@["a", "b", "c", "a", "b", "c", "b"])]
    var expected = @[@["a", "b", "c", "a", "b", "c", "b"]]
    let actions: array[3, Substitution] = [identity, ['b', 'a', 'c'], ['a', 'c', 'b']]
    for step in 0..<400:
        let source = rng.rand(versions.high)
        let old = versions[source]
        let immutable = snapshot(old)
        var v = @(expected[source])
        let l = rng.rand(v.len)
        let r = rng.rand(l..v.len)
        var current = old
        case step mod 5
        of 0:
            let f = actions[rng.rand(2)]
            current = old.apply(l, r, f)
            for i in l..<r: v[i] = substitute(f, v[i])
        of 1:
            current = old.reverse(l, r)
            if l < r: v.reverse(l, r - 1)
        of 2:
            let parts = old.split(l)
            current = parts.right.concat(parts.left)
            v = v[l..<v.len] & v[0..<l]
        of 3:
            current = old.insert(l, "a")
            v.insert("a", l)
        else:
            current = old.erase(l, r)
            v = v[0..<l] & v[r..<v.len]
        immutable()
        current.validate
        versions.add(current)
        expected.add(v)
        for k in [source, versions.high]:
            doAssert versions[k].to_seq == expected[k]
            for a in 0..expected[k].len:
                var product = ""
                for b in a..expected[k].len:
                    doAssert versions[k].prod(a, b) == product
                    if b < expected[k].len: product.add(expected[k][b])
    for k in 0..<versions.len: doAssert versions[k].to_seq == expected[k]

block:
    let original = create(@[1'i64, 2, 3, 4, 5, 6, 7, 8])
    let first = original.apply(0, 8, (2'i64, 1'i64))
    let second = first.apply(1, 7, (3'i64, 2'i64)).reverse(0, 8)
    let third = second.apply(0, 8, (0'i64, 9'i64))
    check(original, @[1'i64, 2, 3, 4, 5, 6, 7, 8])
    check(first, @[3'i64, 5, 7, 9, 11, 13, 15, 17])
    check(second, @[17'i64, 47, 41, 35, 29, 23, 17, 3])
    check(third, @[9'i64, 9, 9, 9, 9, 9, 9, 9])

block:
    var big = create(@[1'i64])
    for i in 0..<30:
        big = big.concat(big)
        big.validate
    doAssert big.len == 1 shl 30
    doAssert big.prod(0, big.len) == big.len.int64
    doAssert big.reverse(0, big.len)[big.len - 1] == 1
    let changed = big.apply(1, big.len - 1, (1'i64, 2'i64))
    changed.validate
    doAssert changed.get_all == 3'i64 * big.len.int64 - 4
    doAssert big[big.len div 2] == 1
    doAssert changed[big.len div 2] == 3
    let parts = changed.split(changed.len div 2)
    doAssert parts.left.concat(parts.right).get_all == changed.get_all
    var huge = initPersistentSequence(@[1])
    for i in 0..<(sizeof(int) * 8 - 2): huge = huge.concat(huge)
    huge.validate
    doAssert huge.len == 1 shl (sizeof(int) * 8 - 2)
    rejects:
        discard huge.concat(huge)
    let almost = huge.concat(huge.erase(huge.len - 1))
    doAssert almost.len == high(int)
    almost.validate
    doAssert almost[almost.len - 1] == 1
    rejects:
        discard almost.insert(0, 2)

block:
    var s = initPersistentSequence(newSeq[int]())
    for i in 0..<20000: s = s.insert(s.len, i)
    s.validate
    let previous = s
    for i in 0..<10000: s = s.erase(0)
    s.validate
    doAssert s.len == 10000 and s[0] == 10000 and previous[0] == 0
    let sorted = initPersistentSequence(@[-3, -1, 0, 2, 2, 5])
    for x in -5..7:
        var boundary = 0
        while boundary < sorted.len and sorted[boundary] < x: inc boundary
        doAssert sorted.partition_point(proc(y: int): bool = y < x) == boundary

proc retained(): PersistentSequence[int64, Action] =
    let source = create(@[1'i64, 2, 3, 4]).apply(0, 4, (2'i64, 3'i64)).reverse(0, 4)
    let part = source.slice(1, 3)
    part.concat(part)
block:
    let survivor = retained()
    when declared(GC_fullCollect): GC_fullCollect()
    check(survivor, @[9'i64, 7, 9, 7])

echo "Hello World"
