# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sets, strutils
include cplib/collections/dynamic_lazysegtree

type
    S = tuple[sum, size: int]
    F = tuple[a, b: int]

proc makeTree(n: int): DynamicLazySegmentTree[S, F] =
    newDynamicLazySegWith(n, (l.sum + r.sum, l.size + r.size), (sum: 0, size: 0),
        (f.a * x.sum + f.b * x.size, x.size),
        (f.a * g.a, f.a * g.b + f.b), (a: 1, b: 0),
        ((l + r - 1) * (r - l) div 2, r - l))

proc checkTree[S, F](node: DynamicLazySegmentTreeNode[S, F]): int =
    if node == nil: return 0
    assert node.a < node.b
    assert node.height == max(height(node.left), height(node.right)) + 1
    assert abs(height(node.left) - height(node.right)) <= 1
    if node.left != nil:
        assert node.left.hi == node.a
        assert node.lo == node.left.lo
    else:
        assert node.lo == node.a
    if node.right != nil:
        assert node.b == node.right.lo
        assert node.hi == node.right.hi
    else:
        assert node.hi == node.b
    1 + checkTree(node.left) + checkTree(node.right)

var rng = initRand(20260912)
for n in [0, 1, 2, 3, 17, 64, 99]:
    let st = makeTree(n)
    assert st.len == n
    var expected = newSeq[int](n)
    for i in 0..<n: expected[i] = i
    var boundaries = initHashSet[int]()
    boundaries.incl(0)
    boundaries.incl(n)
    for step in 0..<2000:
        var l = rng.rand(n)
        var r = rng.rand(n)
        if l > r: swap(l, r)
        if n > 0 and step mod 7 == 0:
            let p = rng.rand(n - 1)
            let value = rng.rand(-100..100)
            st[p] = (value, 1)
            expected[p] = value
            boundaries.incl(p)
            boundaries.incl(p + 1)
        else:
            let f: F = (rng.rand(-1..1), rng.rand(-10..10))
            st.apply(l..<r, f)
            for i in l..<r: expected[i] = f.a * expected[i] + f.b
            if l < r:
                boundaries.incl(l)
                boundaries.incl(r)
        assert st.node_count == boundaries.len - 1
        assert checkTree(st.root) == st.node_count
        var total = 0
        for i in 0..<n:
            total += expected[i]
            assert st[i] == (expected[i], 1)
        assert st.get_all() == (total, n)
        for rep in 0..<5:
            var a = rng.rand(n)
            var b = rng.rand(n)
            if a > b: swap(a, b)
            var part = 0
            for i in a..<b: part += expected[i]
            assert st[a..<b] == (part, b - a)
        assert st.node_count == boundaries.len - 1

block:
    let n = 1001
    let st = makeTree(n)
    var expected = newSeq[int](n)
    for i in 0..<n: expected[i] = i
    for step in 0..<500:
        st.apply(0, n, (-1, 3))
        for i in 0..<n: expected[i] = -expected[i] + 3
        let p = (step * 173) mod n
        st.apply(p, n, (1, 2))
        for i in p..<n: expected[i] += 2
        if step mod 11 == 0:
            st[p] = (17, 1)
            expected[p] = 17
        assert checkTree(st.root) == st.node_count
    for i in 0..<n: assert st[i] == (expected[i], 1)

block:
    let n = 53
    let st = newDynamicLazySegWith(n, l & r, "",
        (if f == '\0': x else: repeat(f, x.len)),
        (if f == '\0': g else: f), '\0', repeat('a', r - l))
    var expected = repeat('a', n)
    for step in 0..<500:
        let f = char(ord('a') + rng.rand(25))
        var a = rng.rand(n)
        var b = rng.rand(n)
        if a > b: swap(a, b)
        st.apply(a, b, f)
        for i in a..<b: expected[i] = f
        if step mod 3 == 0:
            let p = rng.rand(n - 1)
            st[p] = "Z"
            expected[p] = 'Z'
        assert st.get_all() == expected
        for i in 0..n:
            assert st.get(i, n) == expected[i..<n]
        assert checkTree(st.root) == st.node_count

block:
    let n = int.high
    let st = newDynamicLazySegWith(n, min(l, r), int.high,
        min(f, x), min(f, g), int.high, 100)
    st.apply(0, n, 50)
    assert st.node_count == 1
    assert st.get(1, n - 1) == 50
    assert st.node_count == 1
    st[n - 1] = 80
    st[0] = 70
    assert st.node_count == 3
    assert st.get(0, 1) == 70
    assert st[n - 1] == 80
    assert st.get(1, n - 1) == 50
    for step in 0..<1000:
        st.apply(1, n - 1, 40)
        assert st.node_count == 3
    assert st.get_all() == 40
    assert checkTree(st.root) == 3

for descending in [false, true]:
    let n = int.high
    let st = newDynamicLazySegWith(n, l + r, 0, x, 0, 0, 0)
    for i in 0..<5000:
        let p = if descending: n - 1 - i else: i
        st[p] = 1
        if i mod 100 == 0:
            st.apply(0, n, 0)
            assert checkTree(st.root) == st.node_count
    assert st.get_all() == 5000
    assert st.node_count == 5001
    assert checkTree(st.root) == 5001

echo "Hello World"
