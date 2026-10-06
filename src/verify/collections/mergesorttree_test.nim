# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/mergesorttree
import cplib/collections/dynamic_mergesorttree
import algorithm, options, random, strutils

type Key = object
    text: string
    number: int

type LessOnly = object
    word: string

proc `<`(a, b: Key): bool =
    a.text < b.text or (a.text == b.text and a.number < b.number)
proc `<=`(a, b: Key): bool = not (b < a)
proc `==`(a, b: Key): bool = a.text == b.text and a.number == b.number
proc `<`(a, b: LessOnly): bool =
    a.word.len < b.word.len or (a.word.len == b.word.len and a.word < b.word)

proc check[T, Tree](a: seq[T], tree: Tree, l, r: int, x, low, high: T, k = -1) =
    var less, lessEqual, equal, freq: int
    var prev, next = none(T)
    for i in l..<r:
        let value = a[i]
        if value < x:
            inc less
            if prev.isNone or prev.get < value: prev = some(value)
        else:
            if next.isNone or value < next.get: next = some(value)
        if not (x < value): inc lessEqual
        if value == x: inc equal
        if not (value < low) and value < high: inc freq
    doAssert tree.len == a.len
    doAssert tree.range_lowerbound(l, r, x) == less
    doAssert tree.range_upperbound(l, r, x) == lessEqual
    doAssert tree.count(l, r, x) == equal
    doAssert tree.range_freq(l, r, low, high) == freq, "range=" & $l & ":" &
            $r & " bounds=" & $low & ":" & $high & " expected=" & $freq &
            " actual=" & $tree.range_freq(l, r, low, high)
    doAssert tree.prev_value(l, r, x) == prev
    doAssert tree.next_value(l, r, x) == next
    if k >= 0:
        var ordered: seq[T]
        for i in l..<r: ordered.add(a[i])
        ordered.sort(proc(a, b: T): int =
            if a < b: -1
            elif b < a: 1
            else: 0)
        doAssert tree.kth_smallest(l, r, k) == ordered[k]
        doAssert tree.kth_largest(l, r, k) == ordered[ordered.len - 1 - k]

proc checkAll[T](a, bounds: seq[T]) =
    let st = initMergeSortTree(a)
    let dt = initDynamicMergeSortTree(a)
    for i, value in a:
        doAssert st[i] == value and dt.get(i) == value
        dt.update(i, value)
        dt[i] = value
    for l in 0..a.len:
        for r in l..a.len:
            for x in bounds:
                for low in bounds:
                    for high in bounds:
                        check(a, st, l, r, x, low, high)
                        check(a, dt, l, r, x, low, high)
                for k in 0..<r-l:
                    check(a, st, l, r, x, x, x, k)
                    check(a, dt, l, r, x, x, x, k)

for a in [newSeq[int](), @[5], @[2, 2, 2, 2], @[-7, -3, -7, 0, 6],
          @[low(int), 0, high(int), low(int), high(int)], @[4, 3, 2, 1, 0]]:
    checkAll(a, @[low(int), -8, -3, 0, 2, 5, 8, high(int)])

checkAll(@["", "ba", "a", "ba", "z"], @["", "a", "b", "ba", "zz"])
checkAll(@[low(int64), -5'i64, 0'i64, high(int64)],
         @[low(int64), -6'i64, -5'i64, 1'i64, high(int64)])
checkAll(@[-1.5, 0.0, -1.5, 3.25], @[-2.0, -1.5, 0.0, 3.0, 4.0])
checkAll(@[Key(text: "b", number: 1), Key(text: "a", number: 2),
           Key(text: "a", number: 2), Key(text: "a", number: -1)],
         @[Key(text: "", number: 0), Key(text: "a", number: 0),
           Key(text: "a", number: 2), Key(text: "z", number: 10)])

block:
    let a = @[LessOnly(word: "long"), LessOnly(word: "z"), LessOnly(word: "bb")]
    let st = initMergeSortTree(a)
    check(a, st, 0, 3, LessOnly(word: "bb"), LessOnly(word: ""), LessOnly(
            word: "long"), 1)
    var current = @a
    let dt = initDynamicMergeSortTree(current)
    current[1] = LessOnly(word: "unregistered")
    dt[1] = current[1]
    check(current, dt, 0, 3, LessOnly(word: "bb"), LessOnly(word: ""),
            LessOnly(word: "unregistered"), 1)

block:
    var input = @[3, 1, 3, 2]
    let st = initMergeSortTree(input)
    let dt = initDynamicMergeSortTree(input)
    input[0] = 99
    doAssert st[0] == 3 and dt[0] == 3
    var oracle = @[3, 1, 3, 2]
    for value in [3, 3, -999, -999, 1000000, 3, 2, 2, 3]:
        dt[0] = value
        oracle[0] = value
        for l in 0..oracle.len:
            for r in l..oracle.len:
                check(oracle, dt, l, r, 3, -1000, 1000001, (if l <
                        r: 0 else: -1))
    doAssert st.count(0, 4, 3) == 2
    doAssert input == @[99, 1, 3, 2]

block:
    var a = @["a", "b", "a"]
    let dt = initDynamicMergeSortTree(a)
    for i, value in @["z", "", "new", "new", "a", "a"]:
        dt.update(i mod a.len, value)
        a[i mod a.len] = value
        check(a, dt, 0, a.len, "b", "", "zz", 1)
    var keys = @[Key(text: "a", number: 1), Key(text: "a", number: 1)]
    let generic = initDynamicMergeSortTree(keys)
    let fresh = Key(text: "unregistered", number: -100)
    generic[0] = fresh
    keys[0] = fresh
    check(keys, generic, 0, 2, fresh, Key(text: "", number: 0), fresh, 1)

block:
    var a = newSeq[string](33)
    for i in 0..<a.len: a[i] = repeat($(i mod 5), 16)
    let initial = @a
    let st = initMergeSortTree(a)
    let dt = initDynamicMergeSortTree(a)
    for step in 0..<2000:
        let i = (step * 17) mod a.len
        let value = if step mod 7 == 0: a[i] else: repeat($(step mod 29), 16)
        dt[i] = value
        a[i] = value
        if step mod 37 == 0: GC_fullCollect()
        let l = step mod a.len
        let r = min(a.len, l + 1 + step mod 9)
        check(a, dt, l, r, value, "", "zz", (r-l) div 2)
        check(initial, st, l, r, value, "", "zz", 0)

template rejects(body: untyped) =
    block:
        var caught = false
        try: body
        except AssertionDefect: caught = true
        doAssert caught

when compileOption("assertions"):
    for a in [newSeq[int](), @[3], @[1, 2, 3]]:
        let st = initMergeSortTree(a)
        let dt = initDynamicMergeSortTree(a)
        for tree in [st]:
            rejects: discard tree.range_lowerbound(-1, 0, 0)
            rejects: discard tree.range_upperbound(0, a.len + 1, 0)
            rejects: discard tree.count(1, 0, 0)
            rejects: discard tree.range_freq(-1, 0, 1, 1)
            rejects: discard tree.prev_value(0, a.len + 1, 0)
            rejects: discard tree.next_value(-1, 0, 0)
            rejects: discard tree.kth_smallest(0, a.len, -1)
            rejects: discard tree.kth_smallest(0, a.len, a.len)
            rejects: discard tree.kth_largest(0, a.len, -1)
            rejects: discard tree.kth_largest(0, a.len, a.len)
            rejects: discard tree[-1]
            rejects: discard tree.get(a.len)
        rejects: discard dt.range_lowerbound(-1, 0, 0)
        rejects: discard dt.range_upperbound(0, a.len + 1, 0)
        rejects: discard dt.count(1, 0, 0)
        rejects: discard dt.range_freq(-1, 0, 1, 1)
        rejects: discard dt.prev_value(0, a.len + 1, 0)
        rejects: discard dt.next_value(-1, 0, 0)
        rejects: discard dt.kth_smallest(0, a.len, -1)
        rejects: discard dt.kth_smallest(0, a.len, a.len)
        rejects: discard dt.kth_largest(0, a.len, -1)
        rejects: discard dt.kth_largest(0, a.len, a.len)
        rejects: discard dt[-1]
        rejects: discard dt.get(a.len)
        rejects: dt[-1] = 9
        rejects: dt.update(a.len, 9)
        for i, x in a: doAssert dt[i] == x

block:
    const sizes = [0, 1, 2, 3, 4, 5, 7, 8, 9, 16, 17, 31, 32, 33, 63, 64, 65, 127]
    for seed in 0..<48:
        var rng = initRand(20261004 + seed)
        let n = sizes[seed mod sizes.len]
        var a = newSeq[int](n)
        for i in 0..<n: a[i] = rng.rand(-8..8)
        let st = initMergeSortTree(a)
        let dt = initDynamicMergeSortTree(a)
        for step in 0..<200:
            let l = rng.rand(n)
            let r = rng.rand(l..n)
            let x = rng.rand(-12..12)
            check(a, st, l, r, x, rng.rand(-12..12), rng.rand(-12..12),
                  (if l < r: rng.rand(r-l-1) else: -1))
        for step in 0..<600:
            if n > 0 and rng.rand(2) != 0:
                let i = if step mod 3 == 0: 0 elif step mod 3 ==
                        1: n-1 else: rng.rand(n-1)
                let value = if step mod 5 == 0: a[i] else: rng.rand(-10000..10000)
                if step mod 2 == 0: dt[i] = value
                else: dt.update(i, value)
                a[i] = value
                doAssert dt[i] == value and dt.get(i) == value
            let l = rng.rand(n)
            let r = rng.rand(l..n)
            let x = rng.rand(-10001..10001)
            check(a, dt, l, r, x, rng.rand(-10001..10001), rng.rand(
                    -10001..10001),
                  (if l < r: rng.rand(r-l-1) else: -1))

block:
    when defined(mergeSortTreeStress):
        const n = 65537
        const steps = 2000
    else:
        const n = 4097
        const steps = 500
    var rng = initRand(730151)
    var a = newSeq[int](n)
    for i in 0..<n: a[i] = (i * 17 mod 31) - 15
    let initial = @a
    let st = initMergeSortTree(a)
    let dt = initDynamicMergeSortTree(a)
    for step in 0..<steps:
        let l = rng.rand(n)
        let r = rng.rand(l..n)
        let x = rng.rand(-20..20)
        if step < 20:
            check(initial, st, l, r, x, -11, 11, (if l < r: rng.rand(
                    r-l-1) else: -1))
        let i = rng.rand(n-1)
        a[i] = rng.rand(-100000..100000)
        dt[i] = a[i]
        check(a, dt, l, r, x, -11, 11, (if l < r: rng.rand(r-l-1) else: -1))

block:
    const sizes = [0, 1, 2, 7, 65, 257]
    for seed in 0..<24:
        var rng = initRand(20261004 + seed)
        let n = sizes[seed mod sizes.len]
        var initial = newSeq[int](n)
        for i in 0..<n: initial[i] = rng.rand(-4..4)
        var current = @initial
        let st = initMergeSortTree(initial)
        let dt = initDynamicMergeSortTree(current)
        for step in 0..<2000:
            if n > 0 and rng.rand(2) == 0:
                let i = if step mod 3 == 0: 0
                        elif step mod 3 == 1: n - 1
                        else: rng.rand(n - 1)
                let value = if step mod 7 == 0: current[i]
                            else: rng.rand(-int(min(1000000000000'i64, int64(
                                    high(int))))..int(min(1000000000000'i64,
                                    int64(high(int)))))
                dt[i] = value
                current[i] = value
                doAssert dt.get(i) == value
            else:
                let l = rng.rand(n)
                let r = rng.rand(l..n)
                let choices = [low(int), high(int), rng.rand(-6..6),
                               (if l < r: current[rng.rand(l..r-1)] else: 0)]
                let x = choices[rng.rand(choices.high)]
                let lo = rng.rand(-6..6)
                let hi = rng.rand(-6..6)
                let k = if l < r: rng.rand(r-l-1) else: -1
                check(initial, st, l, r, x, lo, hi, k)
                check(current, dt, l, r, x, lo, hi, k)

echo "Hello World"
