# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sequtils
import cplib/tree/static_top_tree
import cplib/tree/static_top_tree_dp
import cplib/tree/rerooting_static_top_tree_dp

const modulus = 101
type
    Forward = object
        first, last, mul, add, count, sum: int
    Backward = object
        value: Forward

proc compress(l, r: Forward): Forward =
    assert l.last == r.first
    Forward(first: l.first, last: r.last, mul: l.mul * r.mul mod modulus,
        add: (l.mul * r.add + l.add) mod modulus, count: l.count + r.count,
        sum: (l.sum + l.mul * r.sum + l.add * r.count) mod modulus)

proc rake(l, r: Forward): Forward =
    assert l.first == r.first
    Forward(first: l.first, last: l.last, mul: l.mul, add: l.add,
        count: l.count + r.count, sum: (l.sum + r.sum) mod modulus)

proc compressReverse(l, r: Backward): Backward =
    Backward(value: compress(l.value, r.value))

proc rakeAtRoot(l: Backward, r: Forward): Backward =
    Backward(value: rake(l.value, r))

proc rakeAtEnd(l: Backward, r: Forward): Backward =
    result.value = compress(l.value, r)
    result.value.last = l.value.last
    result.value.mul = l.value.mul
    result.value.add = l.value.add

proc checkStructure(tree: StaticTopTree): int =
    let n = tree.numVertices
    assert tree.nodes.len == 2 * n - 1
    assert tree.root == tree.nodes.high
    assert tree.nodes[tree.root].parent == -1
    assert tree.nodes[tree.root].size == n
    var height = newSeq[int](tree.nodes.len)
    for i, x in tree.nodes:
        if i < n:
            assert x.kind == sttLeaf and x.lower == i and x.size == 1
            assert x.left == -1 and x.right == -1
        else:
            assert 0 <= x.left and x.left < i
            assert 0 <= x.right and x.right < i
            assert tree.nodes[x.left].parent == i
            assert tree.nodes[x.right].parent == i
            assert x.size == tree.nodes[x.left].size + tree.nodes[x.right].size
            height[i] = max(height[x.left], height[x.right]) + 1
        if i != tree.root:
            assert i < x.parent and x.parent < tree.nodes.len
    var logN = 0
    while (1 shl logN) < n:
        inc logN
    assert height[tree.root] <= 6 * logN
    return height[tree.root]

var rng = initRand(20260910)

proc checkSmall(parent: seq[int], root: int) =
    let n = parent.len
    let tree = initStaticTopTreeFromParent(parent, root)
    discard checkStructure(tree)
    var adj = newSeq[seq[int]](n)
    for v in 0..<n:
        if v != root:
            adj[v].add(parent[v])
            adj[parent[v]].add(v)
    var a, upMul, upAdd, downMul, downAdd = newSeq[int](n)
    for v in 0..<n:
        a[v] = rng.rand(modulus - 1)
        upMul[v] = rng.rand(modulus - 1)
        upAdd[v] = rng.rand(modulus - 1)
        downMul[v] = rng.rand(modulus - 1)
        downAdd[v] = rng.rand(modulus - 1)
    upMul[root] = 1
    downMul[root] = 1
    upAdd[root] = 0
    downAdd[root] = 0

    proc forward(v: int): Forward =
        Forward(first: tree.nodes[v].upper, last: v, mul: upMul[v], add: upAdd[v], count: 1,
            sum: (upMul[v] * a[v] + upAdd[v]) mod modulus)

    proc backward(v: int): Backward =
        Backward(value: Forward(first: v, last: tree.nodes[v].upper,
            mul: downMul[v], add: downAdd[v], count: 1, sum: a[v]))

    proc naive(v, p: int): tuple[count, sum: int] =
        result = (1, a[v])
        for u in adj[v]:
            if u == p:
                continue
            let sub = naive(u, v)
            result.count += sub.count
            if parent[u] == v:
                result.sum += upMul[u] * sub.sum + upAdd[u] * sub.count
            else:
                result.sum += downMul[v] * sub.sum + downAdd[v] * sub.count
            result.sum = result.sum mod modulus

    let fixed = initStaticTopTreeDP(tree, (0..<n).toSeq.mapIt(forward(it)), compress, rake)
    let reroot = initRerootingStaticTopTreeDP(tree,
        (0..<n).toSeq.mapIt(forward(it)), (0..<n).toSeq.mapIt(backward(it)),
        compress, rake, compressReverse, rakeAtRoot, rakeAtEnd)
    for step in 0..<20:
        for v in 0..<n:
            let answer = reroot.prod(v).value
            assert answer.first == v and answer.last == -1
            assert (answer.count, answer.sum) == naive(v, -1)
        assert fixed.getAll().count == n
        assert fixed.getAll().sum == naive(root, -1).sum
        assert fixed.getAll() == reroot.getAll()
        let v = rng.rand(n - 1)
        if step mod 2 == 0 or v == root:
            a[v] = rng.rand(modulus - 1)
        else:
            upMul[v] = rng.rand(modulus - 1)
            upAdd[v] = rng.rand(modulus - 1)
            downMul[v] = rng.rand(modulus - 1)
            downAdd[v] = rng.rand(modulus - 1)
            if step mod 4 == 1:
                upMul[v] = 0
                downMul[v] = 0
        fixed.set(v, forward(v))
        reroot.set(v, forward(v), backward(v))

checkSmall(@[-1], 0)
checkSmall(@[1, -1], 1)
checkSmall(@[-1, 0, 0, 0, 0, 0, 0, 0], 0)
checkSmall(@[-1, 0, 1, 2, 3, 4, 5, 6], 0)
checkSmall(@[-1, 0, 0, 1, 1, 2, 2], 0)
for trial in 0..<120:
    let n = rng.rand(1..45)
    var adj = newSeq[seq[int]](n)
    for v in 1..<n:
        let p = rng.rand(v - 1)
        adj[v].add(p)
        adj[p].add(v)
    let root = rng.rand(n - 1)
    var parent = newSeqWith(n, -1)
    var order = @[root]
    var i = 0
    while i < order.len:
        let v = order[i]
        for u in adj[v]:
            if u != parent[v]:
                parent[u] = v
                order.add(u)
        inc i
    checkSmall(parent, root)

proc checkLarge(parent: seq[int]) =
    let n = parent.len
    let tree = initStaticTopTreeFromParent(parent)
    let height = checkStructure(tree)
    var calls = 0
    proc merge(l, r: int): int =
        inc calls
        l + r
    let fixed = initStaticTopTreeDP(tree, newSeqWith(n, 1), merge, merge)
    let reroot = initRerootingStaticTopTreeDP(tree, newSeqWith(n, 1), newSeqWith(n, 1),
        merge, merge, merge, merge, merge)
    for v in [0, n div 3, n div 2, n - 1]:
        calls = 0
        fixed.set(v, 2)
        assert calls <= height
        assert fixed.getAll() == n + 1
        calls = 0
        reroot.set(v, 2, 2)
        assert calls <= 2 * height
        for r in [0, n div 2, n - 1]:
            calls = 0
            assert reroot.prod(r) == n + 1
            assert calls <= 2 * height + 2
        fixed.set(v, 1)
        reroot.set(v, 1, 1)

const largeN = 200000
block:
    var parent = newSeq[int](largeN)
    parent[0] = -1
    for v in 1..<largeN:
        parent[v] = v - 1
    checkLarge(parent)
block:
    var parent = newSeq[int](largeN)
    parent[0] = -1
    checkLarge(parent)
block:
    var parent = newSeq[int](largeN)
    parent[0] = -1
    for v in 1..<largeN:
        parent[v] = if v < largeN div 2: v - 1 else: v - largeN div 2
    checkLarge(parent)
block:
    var parent = @[-1]
    proc appendTree(root, size: int) =
        if size <= 1:
            return
        var v = root
        let chain = size div 2 + 1
        for i in 1..<chain:
            parent.add(v)
            v = parent.high
        if chain < size:
            parent.add(root)
            appendTree(parent.high, size - chain)
    appendTree(0, largeN)
    assert parent.len == largeN
    checkLarge(parent)

echo "Hello World"
