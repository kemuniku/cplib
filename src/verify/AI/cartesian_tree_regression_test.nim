# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import sequtils
import cplib/tree/cartesiantree

proc oracle(a: seq[int]): seq[tuple[p, l, r: int]] =
    result = newSeqWith(a.len, (-1, -1, -1))
    proc build(l, r, parent: int, tree: var seq[tuple[p, l, r: int]]): int =
        if l == r: return -1
        var best = l
        for i in l + 1..<r:
            if a[i] < a[best]: best = i
        tree[best].p = parent
        tree[best].l = build(l, best, best, tree)
        tree[best].r = build(best + 1, r, best, tree)
        best
    discard build(0, a.len, -1, result)

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
        let original = @a
        doAssert a.cartesian_tree_tuple() == oracle(a)
        doAssert a == original
        inc checked
doAssert checked == 29524
for a in [@[low(int), high(int), low(int), 0], @[-4, -2, -3, -3],
          @[high(int), high(int)]]:
    doAssert a.cartesian_tree_tuple() == oracle(a)

block:
    const n = 200000
    for mode in 0..2:
        var a = newSeq[int](n)
        for i in 0..<n:
            a[i] = if mode == 0: i elif mode == 1: n - i else: 0
        let tree = a.cartesian_tree_tuple()
        for i in 0..<n:
            if mode == 1:
                doAssert tree[i] == ((if i == n - 1: -1 else: i + 1),
                                    (if i == 0: -1 else: i - 1), -1)
            else:
                doAssert tree[i] == ((if i == 0: -1 else: i - 1), -1,
                                    (if i == n - 1: -1 else: i + 1))

echo "Hello World"
