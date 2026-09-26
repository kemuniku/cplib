# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, random
import cplib/collections/range_sort_segtree

const MOD = 998244353
type
    Affine = tuple[a, b: int]
    Item[T] = tuple[key: int, value: T]

proc compose(f, g: Affine): Affine =
    (g.a * f.a mod MOD, (g.a * f.b + g.b) mod MOD)

proc concat(a, b: string): string = a & b
proc add(a, b: int): int = a + b

proc sortRange[T](items: var seq[Item[T]], l, r: int, order: SortOrder) =
    var part = items[l..<r]
    part.sort(proc(a, b: Item[T]): int = cmp(a.key, b.key), order)
    for i, item in part:
        items[l + i] = item

proc checkStrings(seg: RangeSortSegmentTree[string], items: seq[Item[string]]) =
    doAssert seg.len == items.len
    var all = ""
    for i, item in items:
        doAssert seg.key(i) == item.key
        doAssert seg[i] == item.value
        all.add(item.value)
    doAssert seg.get_all() == all
    for l in 0..items.len:
        var expected = ""
        for r in l..items.len:
            doAssert seg.get(l, r) == expected
            doAssert seg[l..<r] == expected
            if r < items.len: expected.add(items[r].value)

block:
    let seg = initRangeSortSegmentTree(newSeq[int](), newSeq[string](), 0, concat, "")
    doAssert seg.len == 0
    doAssert seg.get_all() == ""
    doAssert seg.get(0, 0) == ""
    doAssert seg[0..<0] == ""
    seg.sort(0, 0)
    seg.sort(0..<0, Descending)

block:
    let seg = initRangeSortSegmentTree([0], ["a"], 1, concat, "")
    seg.sort(0, 1, Descending)
    doAssert seg.key(0) == 0
    doAssert seg[^1] == "a"
    seg[^1] = "b"
    doAssert seg.get_all() == "b"
    seg.update(0, 0, "")
    doAssert seg[0..0] == ""
    seg.update(0, "c")
    doAssert seg.get(0, 1) == "c"

block:
    var items: seq[Item[string]] = @[
        (9, "A"), (0, "B"), (6, ""), (2, "CD"), (10, "E"), (4, "F"), (7, "G")]
    let seg = initRangeSortSegmentTree([9, 0, 6, 2, 10, 4, 7],
        ["A", "B", "", "CD", "E", "F", "G"], 11, concat, "")
    seg.checkStrings(items)
    for order in [Descending, Ascending, Descending]:
        seg.sort(0, seg.len, order)
        items.sortRange(0, items.len, order)
        doAssert seg.get_all() == (if order == Ascending: "BCDFGAE" else: "EAGFCDB")
        seg.checkStrings(items)
        for l in 0..seg.len:
            for r in l..seg.len:
                seg.sort(l..<r, order)
                items.sortRange(l, r, order)
                seg.checkStrings(items)
    seg.sort(0, seg.len, Descending)
    items.sortRange(0, items.len, Descending)
    seg.update(2, "xy")
    items[2].value = "xy"
    seg.update(3, 3, "Z")
    items[3] = (3, "Z")
    seg.update(3, 6, "W")
    items[3] = (6, "W")
    seg.checkStrings(items)

block:
    let keys = [int.high - 1, 0, int.high div 2, 1, int.high - 2]
    var items: seq[Item[string]]
    for i, key in keys: items.add((key, $i))
    let seg = initRangeSortSegmentTree(keys, ["0", "1", "2", "3", "4"], int.high, concat, "")
    for _ in 0..<20:
        for order in [Ascending, Descending]:
            seg.sort(0, seg.len, order)
            items.sortRange(0, items.len, order)
            seg.checkStrings(items)
    seg.update(0, 2, "new")
    items[0] = (2, "new")
    seg.checkStrings(items)

var rng = initRand(20260926)
for n in [1, 2, 3, 7, 16, 31, 64]:
    let limit = n * 4 + 7
    var keys = newSeq[int](n)
    var values = newSeq[Affine](n)
    var items = newSeq[Item[Affine]](n)
    for i in 0..<n:
        keys[i] = 2 * i + 1
    rng.shuffle(keys)
    for i in 0..<n:
        values[i] = (rng.rand(MOD - 1), rng.rand(MOD - 1))
        items[i] = (keys[i], values[i])
    let seg = initRangeSortSegmentTree(keys, values, limit, compose, (1, 0))
    for step in 0..<1500:
        var l = rng.rand(n)
        var r = rng.rand(n)
        if l > r: swap(l, r)
        let index = rng.rand(n - 1)
        let value: Affine = (rng.rand(MOD - 1), rng.rand(MOD - 1))
        case rng.rand(5)
        of 0, 1:
            let order = if step mod 2 == 0: Ascending else: Descending
            if step mod 3 == 0:
                l = 0
                r = n
            if step mod 2 == 0: seg.sort(l, r, order)
            else: seg.sort(l..<r, order)
            items.sortRange(l, r, order)
        of 2:
            var key = rng.rand(limit - 1)
            while true:
                var occupied = false
                for i, item in items:
                    if i != index and item.key == key: occupied = true
                if not occupied: break
                key = rng.rand(limit - 1)
            seg.update(index, key, value)
            items[index] = (key, value)
        of 3:
            seg[index] = value
            items[index].value = value
        of 4:
            seg.update(index, value)
            items[index].value = value
        else:
            discard
        var all: Affine = (1, 0)
        for i, item in items:
            doAssert seg.key(i) == item.key
            doAssert seg[i] == item.value
            all = compose(all, item.value)
        doAssert seg.get_all() == all
        let x = rng.rand(MOD - 1)
        var expected = x
        for i in l..<r:
            expected = (items[i].value.a * expected + items[i].value.b) mod MOD
        let f = seg.get(l, r)
        doAssert (f.a * x + f.b) mod MOD == expected
        doAssert seg[l..<r] == f
        doAssert seg.get_all() == all

block:
    let seg = initRangeSortSegmentTree([4, 1, 3, 0, 2], [4, 1, 3, 0, 2], 5, add, 0)
    for step in 0..<10000:
        seg.sort(0, 5, if step mod 2 == 0: Ascending else: Descending)
        doAssert seg.get(1, 4) == 6
        doAssert seg.get_all() == 10

when compileOption("assertions"):
    block:
        var rejected = false
        try:
            discard initRangeSortSegmentTree([1, 1], [2, 3], 2, add, 0)
        except AssertionDefect:
            rejected = true
        doAssert rejected
    block:
        let seg = initRangeSortSegmentTree([2, 0, 1], [2, 0, 1], 3, add, 0)
        seg.sort(0, 3, Descending)
        var rejected = false
        try:
            seg.update(1, 2, 9)
        except AssertionDefect:
            rejected = true
        doAssert rejected
        doAssert seg.key(1) == 1
        doAssert seg[1] == 1
        doAssert seg.get_all() == 3
        seg.update(1, 1, 9)
        doAssert seg[1] == 9

echo "Hello World"
