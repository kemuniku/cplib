# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sequtils
import cplib/tree/euler_tour_tree
import cplib/tree/link_cut_tree

type Summary = tuple[sum: int64, count, minimum: int]
const identity: Summary = (0'i64, 0, int.high)
proc merge(l, r: Summary): Summary =
    (l.sum + r.sum, l.count + r.count, min(l.minimum, r.minimum))
proc value(x: int): Summary = (int64(x), 1, x)

proc component(adj: seq[seq[bool]], start: int): seq[int] =
    var seen = newSeq[bool](adj.len)
    seen[start] = true
    result = @[start]
    var head = 0
    while head < result.len:
        let u = result[head]
        inc head
        for v in 0..<adj.len:
            if adj[u][v] and not seen[v]:
                seen[v] = true
                result.add(v)

proc check(tree: EulerTourTree[Summary], adj: seq[seq[bool]], values: seq[int]) =
    doAssert tree.len == values.len
    var components = 0
    for u in 0..<values.len:
        let vertices = component(adj, u)
        var expected = identity
        var smallest = u
        for v in vertices:
            expected.sum += int64(values[v])
            inc expected.count
            expected.minimum = min(expected.minimum, values[v])
            smallest = min(smallest, v)
        if smallest == u: inc components
        doAssert tree[u] == value(values[u])
        doAssert tree.size(u) == vertices.len
        doAssert tree.componentProd(u) == expected
        for v in 0..<values.len:
            doAssert tree.connected(u, v) == (v in vertices)
            doAssert tree.contains(u, v) == adj[u][v]
    doAssert tree.count == components

proc insert(tree: EulerTourTree[Summary], adj: var seq[seq[bool]], u, v: int) =
    let accepted = v notin component(adj, u)
    doAssert tree.link(u, v) == accepted
    if accepted:
        adj[u][v] = true
        adj[v][u] = true

proc erase(tree: EulerTourTree[Summary], adj: var seq[seq[bool]], u, v: int) =
    doAssert tree.cut(u, v) == adj[u][v]
    adj[u][v] = false
    adj[v][u] = false

block:
    let empty = initEulerTourTree(0, merge, identity)
    empty.check(@[], @[])
    let neutral = newEulerTourTreeWith(3, min(l, r), int.high)
    doAssert neutral.componentProd(0) == int.high
    doAssert neutral.link(0, 1)
    doAssert neutral.link(2, 1)
    doAssert neutral.componentProd(2) == int.high
    neutral[1] = -11
    doAssert neutral.componentProd(0) == -11
    doAssert neutral.cut(1, 2)
    doAssert neutral.componentProd(2) == int.high

block:
    const n = 5
    var edges: seq[tuple[u, v: int]]
    for u in 0..<n:
        for v in u + 1..<n: edges.add((u, v))
    for mask in 0..<(1 shl edges.len):
        var values = @[3, -9, 2, 7, 3]
        let tree = initEulerTourTree(values.mapIt(value(it)), merge, identity)
        var adj = newSeqWith(n, newSeq[bool](n))
        for i, edge in edges:
            if (mask and (1 shl i)) != 0: tree.insert(adj, edge.u, edge.v)
        tree.check(adj, values)
        for u in 0..<n:
            for v in 0..<n:
                if v in component(adj, u): doAssert not tree.link(v, u)
        for u in 0..<n:
            values[u] = 100 + u
            tree.update(u, value(values[u]))
        tree.check(adj, values)
        for i in countdown(edges.high, 0):
            tree.erase(adj, edges[i].v, edges[i].u)
            tree.check(adj, values)

var rng = initRand(238870)
for n in [1, 2, 5, 13, 32, 65]:
    for trial in 0..<3:
        var values = newSeqWith(n, rng.rand(-1000..1000))
        let tree = initEulerTourTree(values.mapIt(value(it)), merge, identity)
        var adj = newSeqWith(n, newSeq[bool](n))
        for step in 0..<1000:
            let u = rng.rand(n - 1)
            let v = rng.rand(n - 1)
            case rng.rand(4)
            of 0, 1: tree.insert(adj, u, v)
            of 2: tree.erase(adj, u, v)
            of 3:
                let vertices = component(adj, u)
                doAssert tree.size(u) == vertices.len
                doAssert tree.connected(u, v) == (v in vertices)
            else:
                values[u] = rng.rand(-1000..1000)
                tree[u] = value(values[u])
            if step mod 29 == 0: tree.check(adj, values)
        tree.check(adj, values)
        for u in 0..<n:
            for v in u + 1..<n: tree.erase(adj, u, v)
        tree.check(adj, values)

block:
    var input = @[value(5), value(7), value(-2)]
    let first = initEulerTourTree(input, merge, identity)
    let other = initEulerTourTree(input, merge, identity)
    let alias = first
    input[0] = value(99)
    doAssert first[0] == value(5)
    doAssert other[0] == value(5)
    alias.link(0, 1)
    alias[1] = value(30)
    doAssert first.componentProd(0).sum == 35
    doAssert other.count == 3
    doAssert other[1] == value(7)

block:
    let ett = newEulerTourTreeWith(@[5, 7, -2], l + r, 0)
    let lct = newLinkCutTreeWith(@[5, 7, -2], l + r, 0, -x)
    for (u, v) in [(1, 0), (1, 2)]:
        ett.link(u, v)
        lct.link(u, v)
    ett[1] = 30
    lct[1] = 30
    for v in 0..<3: doAssert ett.componentProd(v) == lct.componentProd(v)
    ett.cut(2, 1)
    lct.cut(2, 1)
    for v in 0..<3: doAssert ett.componentProd(v) == lct.componentProd(v)

block:
    type Immutable = ref object
        bits: uint64
    proc union(l, r: Immutable): Immutable = Immutable(bits: l.bits or r.bits)
    let zero = Immutable(bits: 0)
    let inputs = @[Immutable(bits: 1), Immutable(bits: 2), Immutable(bits: 4)]
    let tree = initEulerTourTree(inputs, union, zero)
    tree.link(0, 1)
    tree.link(1, 2)
    let snapshot = tree.componentProd(0)
    tree[1] = Immutable(bits: 8)
    doAssert tree.componentProd(2).bits == 13
    tree.cut(0, 1)
    doAssert tree.componentProd(0).bits == 1
    doAssert tree.componentProd(2).bits == 12
    doAssert snapshot.bits == 7
    doAssert inputs[1].bits == 2
    doAssert zero.bits == 0

block:
    const n = 20000
    let tree = newEulerTourTreeWith(newSeqWith(n, 1'i64), l + r, 0'i64)
    for trial in 0..<4:
        for v in 1..<n: doAssert tree.link((if trial mod 2 == 0: v - 1 else: 0), v)
        doAssert tree.componentProd(n - 1) == int64(n)
        doAssert tree.size(n - 1) == n
        for v in countdown(n - 1, 1):
            doAssert tree.cut(v, (if trial mod 2 == 0: v - 1 else: 0))
            doAssert tree.size(v) == 1
            doAssert tree.componentProd(v) == 1
            doAssert tree.size(0) == v
            doAssert tree.componentProd(0) == int64(v)
        doAssert tree.count == n

block:
    const n = 256
    let tree = newEulerTourTreeWith(newSeqWith(n, 1), l + r, 0)
    for trial in 0..<8:
        for v in 1..<n: tree.link(v - 1, v)
        var width = n
        while width > 1:
            for left in countup(0, n - 1, width):
                let mid = left + width div 2
                doAssert tree.cut(mid - 1, mid)
                doAssert tree.size(left) == width div 2
                doAssert tree.componentProd(mid) == width div 2
                doAssert not tree.connected(left, mid)
            width = width div 2
        doAssert tree.count == n

when compileOption("assertions"):
    template rejects(action: untyped) =
        block:
            var rejected = false
            try: action
            except AssertionDefect: rejected = true
            doAssert rejected
    rejects:
        discard initEulerTourTree(-1, merge, identity)
    rejects:
        discard initEulerTourTree(int.high, merge, identity)
    let noMerge: proc(l, r: Summary): Summary = nil
    rejects:
        discard initEulerTourTree(0, noMerge, identity)
    let tree = initEulerTourTree(@[value(1), value(2)], merge, identity)
    for v in [-1, 2, int.high]:
        rejects:
            discard tree.connected(0, v)
        rejects:
            discard tree.size(v)
        rejects:
            discard tree.componentProd(v)
        rejects:
            discard tree[v]
        rejects:
            tree[v] = value(0)
        rejects:
            tree.update(v, value(0))
        rejects:
            discard tree.contains(v, 0)
        rejects:
            discard tree.link(v, 0)
        rejects:
            discard tree.cut(0, v)
        doAssert tree.count == 2
        doAssert tree[0] == value(1)
        doAssert tree[1] == value(2)

echo "Hello World"
