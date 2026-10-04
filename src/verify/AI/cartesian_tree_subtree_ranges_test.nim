# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/tree/cartesiantree

proc oracle(a: seq[int]): seq[tuple[l: int, r: int]] =
    result = newSeq[tuple[l: int, r: int]](a.len)
    proc build(l, r: int, ranges: var seq[tuple[l: int, r: int]]) =
        if l == r: return
        var best = l
        for i in l + 1..<r:
            if a[i] < a[best]: best = i
        ranges[best] = (l, r)
        build(l, best, ranges)
        build(best + 1, r, ranges)
    build(0, a.len, result)

proc check(a: seq[int]) =
    let original = @a
    let ranges = a.cartesian_tree_subtree_ranges()
    doAssert ranges == oracle(a)
    doAssert a == original
    let tree = a.cartesian_tree_tuple()
    for i, interval in ranges:
        doAssert 0 <= interval.l and interval.l <= i
        doAssert i < interval.r and interval.r <= a.len
        var descendants = @[i]
        var pos = 0
        while pos < descendants.len:
            let v = descendants[pos]
            if tree[v].l != -1: descendants.add(tree[v].l)
            if tree[v].r != -1: descendants.add(tree[v].r)
            inc pos
        doAssert descendants.len == interval.r - interval.l
        for v in descendants:
            doAssert interval.l <= v and v < interval.r

doAssert cartesian_tree_subtree_ranges(@[3, 1, 4, 2]) ==
    @[(0, 1), (0, 4), (2, 3), (2, 4)]
var checked = 0
for n in 0..9:
    var a = newSeq[int](n)
    var count = 1
    for i in 0..<n: count *= 3
    for code in 0..<count:
        var value = code
        for i in 0..<n:
            a[i] = value mod 3
            value = value div 3
        check(a)
        inc checked
doAssert checked == 29524
for a in [@[low(int), high(int), low(int), 0], @[-4, -2, -3, -3],
          @[high(int), high(int)], @[low(int)], @[high(int)]]:
    check(a)

var rng = initRand(553)
for trial in 0..<2000:
    var a = newSeq[int](rng.rand(80))
    for value in a.mitems: value = rng.rand(-10..10)
    check(a)

block:
    const n = 200000
    for mode in 0..3:
        var a = newSeq[int](n)
        for i in 0..<n:
            a[i] = if mode == 0: i elif mode == 1: n - i
                   elif mode == 2: 0 else: i mod 2
        let ranges = a.cartesian_tree_subtree_ranges()
        doAssert ranges.len == n
        for i in 0..<n:
            let expected = if mode == 1: (0, i + 1)
                           elif mode < 3: (i, n)
                           elif i mod 2 == 0: (max(0, i - 1), n)
                           else: (i, i + 1)
            doAssert ranges[i] == expected

echo "Hello World"
