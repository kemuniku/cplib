# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, random, sequtils
import cplib/collections/avlmap

proc check(m: AvlMap[int, int], oracle: seq[tuple[key, value: int]]) =
    var ordered = @oracle
    ordered.sort(proc(a, b: tuple[key, value: int]): int = cmp(a.key, b.key))
    doAssert m.len == ordered.len
    doAssert toSeq(m.pairs) == ordered
    doAssert toSeq(m.keys) == ordered.mapIt(it.key)
    doAssert toSeq(m.values) == ordered.mapIt(it.value)
    for key in -105..105:
        var lower, upper = 0
        var found = false
        var value = -987654
        for pair in oracle:
            if pair.key < key: inc lower
            if pair.key <= key: inc upper
            if pair.key == key:
                found = true
                value = pair.value
        doAssert m.lowerBound(key) == lower
        doAssert m.upperBound(key) == upper
        doAssert m.contains(key) == found
        doAssert m.getOrDefault(key, -987654) == value
        if found: doAssert m[key] == value

block:
    var m: AvlMap[int, int]
    check(m, @[])
    doAssert m.getOrDefault(0) == 0
    doAssert not m.del(0)
    var rejected = false
    try: discard m[0]
    except KeyError: rejected = true
    doAssert rejected
    m[0] = 1
    m[0] = 2
    check(m, @[(0, 2)])
    doAssert m.del(0)
    check(m, @[])
    doAssert not m.del(0)
    var initialized = initAvlMap[int, int](@[(3, 1), (1, 4), (3, 9)])
    check(initialized, @[(1, 4), (3, 9)])
    doAssert initAvlMap[int, int]().len == 0
    for key in [low(int), high(int), 0, -1, 1]: m[key] = key
    doAssert toSeq(m.keys) == @[low(int), -1, 0, 1, high(int)]
    doAssert m.lowerBound(low(int)) == 0 and m.upperBound(low(int)) == 1
    doAssert m.lowerBound(high(int)) == 4 and m.upperBound(high(int)) == 5
    for key in [0, high(int), low(int), -1, 1]:
        doAssert m[key] == key
        doAssert m.del(key)
    doAssert m.len == 0

for seed in 0..<32:
    var rng = initRand(seed)
    var m = initAvlMap[int, int]()
    var oracle: seq[tuple[key, value: int]]
    for step in 0..<2000:
        let key = rng.rand(-100..100)
        var idx = -1
        for i, pair in oracle:
            if pair.key == key: idx = i
        case rng.rand(0..4)
        of 0, 1:
            let value = rng.rand(-100000..100000)
            m[key] = value
            if idx == -1: oracle.add((key, value))
            else: oracle[idx].value = value
        of 2:
            doAssert m.del(key) == (idx != -1)
            if idx != -1: oracle.delete(idx)
        else:
            doAssert m.contains(key) == (idx != -1)
            doAssert m.getOrDefault(key, -987654) ==
                (if idx == -1: -987654 else: oracle[idx].value)
        doAssert m.len == oracle.len
        if step mod 50 == 0: check(m, oracle)
    check(m, oracle)

block:
    var permutation = @[0, 1, 2, 3, 4, 5]
    var checked = 0
    while true:
        for mode in 0..2:
            var m = initAvlMap[int, int]()
            var oracle: seq[tuple[key, value: int]]
            for key in permutation:
                m[key] = key * 10
                oracle.add((key, key * 10))
            var deletion = @permutation
            if mode == 1: deletion.reverse()
            if mode == 2: deletion = @[2, 3, 1, 4, 0, 5]
            for key in deletion:
                doAssert m.del(key)
                for i, pair in oracle:
                    if pair.key == key:
                        oracle.delete(i)
                        break
                check(m, oracle)
        inc checked
        if not permutation.nextPermutation(): break
    doAssert checked == 720

type
    Key = object
        order: int
        tag: string
    Value = object
        payload: seq[int]

var comparisons = 0
proc `<`(a, b: Key): bool =
    inc comparisons
    a.order < b.order
proc `<=`(a, b: Key): bool {.error: "Kの<=は不要".}
proc `==`(a, b: Key): bool {.error: "Kの==は不要".}
proc `<`(a, b: Value): bool {.error: "Vの比較は禁止".}
proc `<=`(a, b: Value): bool {.error: "Vの比較は禁止".}
proc `==`(a, b: Value): bool {.error: "Vの比較は禁止".}

block:
    var m = initAvlMap[Key, Value]()
    m[Key(order: 2, tag: "original")] = Value(payload: @[1])
    m[Key(order: 2, tag: "replacement")] = Value(payload: @[7, 8])
    doAssert m.len == 1
    doAssert m[Key(order: 2)].payload == @[7, 8]
    doAssert toSeq(m.keys)[0].tag == "original"
    doAssert m.lowerBound(Key(order: 2)) == 0
    doAssert m.upperBound(Key(order: 2)) == 1
    var detached = toSeq(m.keys)[0]
    detached.order = -100
    doAssert m.contains(Key(order: 2))
    let saved = m[Key(order: 2)]
    doAssert m.del(Key(order: 2))
    doAssert saved.payload == @[7, 8]
    doAssert m.getOrDefault(Key(order: 2)).payload.len == 0

block:
    const n = 32769
    for mode in 0..2:
        var m = initAvlMap[Key, int]()
        for i in 0..<n:
            let key = if mode == 0: i elif mode == 1: n - 1 - i
                      elif i mod 2 == 0: i div 2 else: n - 1 - i div 2
            comparisons = 0
            m[Key(order: key)] = key
            doAssert comparisons <= 160
        doAssert m.len == n
        comparisons = 0
        var i = 0
        for key, value in m.pairs:
            doAssert key.order == i and value == i
            inc i
        doAssert i == n and comparisons == 0
        for key in 0..<n:
            comparisons = 0
            doAssert m.lowerBound(Key(order: key)) == key
            doAssert m.upperBound(Key(order: key)) == key + 1
            doAssert m[Key(order: key)] == key
            doAssert comparisons <= 160
        for i in 0..<n:
            let key = if mode == 0: i elif mode == 1: n - 1 - i
                      elif i mod 2 == 0: i div 2 else: n - 1 - i div 2
            comparisons = 0
            doAssert m.del(Key(order: key))
            doAssert comparisons <= 160
            doAssert m.len == n - 1 - i
        doAssert toSeq(m.pairs).len == 0

block:
    var m = initAvlMap[string, seq[int]](@[("", @[1]), ("z", @[2]), ("a", @[3])])
    doAssert toSeq(m.keys) == @["", "a", "z"]
    m[""] = @[4]
    doAssert m[""] == @[4]
    doAssert m.lowerBound("b") == 2 and m.upperBound("z") == 3
    doAssert m.del("a")
    doAssert toSeq(m.values) == @[@[4], @[2]]
    var wide = initAvlMap[int64, string](@[(low(int64), "low"), (high(int64), "high")])
    doAssert wide[low(int64)] == "low" and wide[high(int64)] == "high"

static:
    when defined(avlMapCheckPrivacy):
        doAssert not compiles((block:
            var m: AvlMap[int, int]
            discard m.root))
    doAssert not compiles((block:
        var m: AvlMap[int, int]
        m[0] = 1
        m[0] += 1))

block:
    type Box = ref object
        x: int
    var m = initAvlMap[int, Box]()
    m[1] = Box(x: 7)
    let saved = m[1]
    doAssert m.del(1)
    doAssert saved.x == 7
    doAssert m.getOrDefault(1).isNil
    var source = initAvlMap[int, int](@[(1, 2), (3, 4)])
    var copied = initAvlMap[int, int](toSeq(source.pairs))
    copied[1] = 9
    doAssert copied.del(3)
    doAssert source[1] == 2 and source[3] == 4

echo "Hello World"
