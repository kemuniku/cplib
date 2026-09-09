# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, random, sequtils
import cplib/tree/link_cut_tree
import cplib/tree/lazy_subtree_link_cut_tree

type SumCount = tuple[sum: int64, count: int]
type Affine = tuple[a, b: int64]
const Mod = 998244353'i64

proc merge(l, r: SumCount): SumCount =
    (sum: l.sum + r.sum, count: l.count + r.count)
proc inverse(x: SumCount): SumCount =
    (sum: -x.sum, count: -x.count)
proc mapping(f: int64, x: SumCount): SumCount =
    (sum: x.sum + f * int64(x.count), count: x.count)
proc composition(f, g: int64): int64 = f + g
proc inverseAction(f: int64): int64 = -f
proc compose(l, r: Affine): Affine =
    (a: l.a * r.a mod Mod, b: (l.b * r.a + r.b) mod Mod)

proc vertices(adj: seq[seq[int]], start: int, blocked = -1): seq[int] =
    var seen = newSeq[bool](adj.len)
    if blocked >= 0: seen[blocked] = true
    seen[start] = true
    result = @[start]
    var i = 0
    while i < result.len:
        for v in adj[result[i]]:
            if not seen[v]:
                seen[v] = true
                result.add(v)
        inc i

proc path(adj: seq[seq[int]], u, v: int): seq[int] =
    var parent = newSeqWith(adj.len, -1)
    parent[u] = u
    var queue = @[u]
    var i = 0
    while i < queue.len:
        for x in adj[queue[i]]:
            if parent[x] == -1:
                parent[x] = queue[i]
                queue.add(x)
        inc i
    if parent[v] == -1: return
    var x = v
    while x != u:
        result.add(x)
        x = parent[x]
    result.add(u)
    result.reverse()

proc total(values: seq[int64], ids: seq[int]): SumCount =
    result.count = ids.len
    for v in ids: result.sum += values[v]

block:
    let empty = newLinkCutTreeWith(0, l + r, 0)
    doAssert empty.len == 0
    let single = newLinkCutTreeWith(1, l & r, "")
    single[0] = "abc"
    doAssert single.get(0, 0) == "abc"
    doAssert single.findRoot(0) == 0
    doAssert single.connected(0, 0)
    let sums = initLinkCutTree(3, merge, (sum: 0'i64, count: 0), inverse)
    sums.link(0, 1)
    sums.link(2, 1)
    sums.update(0, (sum: 1000000000000'i64, count: 1))
    doAssert sums.componentProd(2) == (sum: 1000000000000'i64, count: 1)

block:
    type Shift = object
        value: int64
    proc shiftedMerge(l, r: SumCount): SumCount =
        (sum: l.sum + r.sum - 11, count: l.count + r.count)
    proc shiftedInverse(x: SumCount): SumCount =
        (sum: 22 - x.sum, count: -x.count)
    proc shift(f: Shift, x: SumCount): SumCount =
        (sum: x.sum + (f.value - 7) * int64(x.count), count: x.count)
    proc shiftCompose(f, g: Shift): Shift = Shift(value: f.value + g.value - 7)
    proc shiftInverse(f: Shift): Shift = Shift(value: 14 - f.value)
    proc `==`(f, g: Shift): bool {.error: "作用に等値比較は不要".}

    let tree = initLazySubtreeLinkCutTree(
        3, shiftedMerge, (sum: 11'i64, count: 0), shift, shiftCompose,
        Shift(value: 7), shiftedInverse, shiftInverse
    )
    doAssert tree.len == 3
    tree[0] = (sum: 12'i64, count: 1)
    tree[1] = (sum: 13'i64, count: 1)
    tree[2] = (sum: 14'i64, count: 1)
    tree.link(0, 1)
    tree.componentApply(0, Shift(value: 17))
    tree.link(1, 2)
    doAssert tree[2] == (sum: 14'i64, count: 1)
    tree.subtreeApply(1, 0, Shift(value: 27))
    doAssert tree.componentProd(0) == (sum: 77'i64, count: 3)
    doAssert tree.subtreeProd(2, 1) == (sum: 34'i64, count: 1)
    tree.pathApply(0, 1, Shift(value: 12))
    tree.pathApply(1, 1, Shift(value: 4))
    doAssert tree.componentProd(0) == (sum: 84'i64, count: 3)
    doAssert tree.subtreeProd(2, 1) == (sum: 34'i64, count: 1)

block:
    let initial = (1..6).toSeq.mapIt((sum: int64(it), count: 1))
    let tree = initLazySubtreeLinkCutTree(initial, merge, (sum: 0'i64, count: 0),
        mapping, composition, 0'i64, inverse, inverseAction)
    for (u, v) in [(0, 1), (1, 2), (1, 3), (0, 4), (4, 5)]: tree.link(u, v)
    tree.pathApply(2, 5, 10)
    tree.subtreeApply(1, 0, 20)
    tree.componentApply(0, -5)
    tree.pathApply(3, 2, -7)
    tree.pathApply(2, 3, 3)
    tree[1] = (sum: 100'i64, count: 1)
    doAssert tree.pathProd(2, 5) == (sum: 151'i64, count: 5)
    doAssert tree.componentProd(0) == (sum: 166'i64, count: 6)
    doAssert tree.subtreeProd(1, 0) == (sum: 139'i64, count: 3)
    tree.cut(1, 0)
    tree.componentApply(0, 1000)
    tree.link(1, 5)
    tree.pathApply(0, 2, -2)
    tree.pathApply(2, 3, 0)
    let expected = [1004'i64, 98, 22, 15, 1008, 1009]
    for v in 0..<6: doAssert tree[v] == (sum: expected[v], count: 1)
    doAssert tree.subtreeProd(1, 5) == (sum: 135'i64, count: 3)
    doAssert tree.componentProd(0) == (sum: 3156'i64, count: 6)

block:
    let tree = newLazySubtreeLinkCutTreeWith(
        newSeqWith(8, (sum: 0'i64, count: 1)),
        (sum: l.sum + r.sum, count: l.count + r.count), (sum: 0'i64, count: 0),
        (sum: x.sum + f * int64(x.count), count: x.count), f + g, 0'i64,
        (sum: -x.sum, count: -x.count), -f
    )
    for v in 1..<8: tree.link(v, 0)
    for i in 0..<100:
        tree.componentApply(i mod 8, int64(i + 1))
    tree.cut(0, 1)
    tree.componentApply(0, 10000)
    tree.link(1, 7)
    doAssert tree[1].sum == 5050
    doAssert tree.subtreeProd(1, 7).sum == 5050
    doAssert tree.componentProd(1).sum == 5050 * 8 + 70000

var rng = initRand(840173)
for trial in 0..<24:
    let n = if trial == 0: 1 else: rng.rand(2..32)
    var adj = newSeq[seq[int]](n)
    var values = newSeqWith(n, int64(rng.rand(-100..100)))
    var functions = newSeqWith(n, (a: int64(rng.rand(0..100)), b: int64(rng.rand(0..100))))
    let initial = values.mapIt((sum: it, count: 1))
    let tree = initLinkCutTree(initial, merge, (sum: 0'i64, count: 0), inverse)
    let lazy = initLazySubtreeLinkCutTree(initial, merge, (sum: 0'i64, count: 0),
        mapping, composition, 0'i64, inverse, inverseAction)
    let affine = initLinkCutTree(functions, compose, (a: 1'i64, b: 0'i64))

    proc linkAll(u, v: int) =
        adj[u].add(v)
        adj[v].add(u)
        tree.link(u, v)
        lazy.link(u, v)
        affine.link(u, v)

    proc cutAll(u, v: int) =
        adj[u].delete(adj[u].find(v))
        adj[v].delete(adj[v].find(u))
        tree.cut(u, v)
        lazy.cut(u, v)
        affine.cut(u, v)

    proc checkPath(u, v: int) =
        let ids = path(adj, u, v)
        doAssert tree.connected(u, v) == (ids.len > 0)
        doAssert lazy.connected(u, v) == (ids.len > 0)
        doAssert affine.connected(u, v) == (ids.len > 0)
        if ids.len == 0: return
        let expected = total(values, ids)
        doAssert tree.pathProd(u, v) == expected
        doAssert lazy.pathProd(u, v) == expected
        var x = 12345'i64
        for id in ids: x = (functions[id].a * x + functions[id].b) mod Mod
        let f = affine.get(u, v)
        doAssert (f.a * 12345 + f.b) mod Mod == x

    for v in 1..<n:
        let p = if trial mod 3 == 0: 0 elif trial mod 3 == 1: v - 1 else: rng.rand(v - 1)
        linkAll(v, p)

    for step in 0..<800:
        let u = rng.rand(n - 1)
        let v = rng.rand(n - 1)
        case rng.rand(0..10)
        of 0:
            if path(adj, u, v).len == 0: linkAll(u, v)
        of 1:
            if adj[u].len > 0: cutAll(u, adj[u][rng.rand(adj[u].high)])
        of 2:
            values[u] = int64(rng.rand(-1000..1000))
            tree[u] = (sum: values[u], count: 1)
            lazy[u] = (sum: values[u], count: 1)
            functions[u] = (a: int64(rng.rand(0..100)), b: int64(rng.rand(0..100)))
            affine[u] = functions[u]
        of 3:
            let f = int64(rng.rand(-100..100))
            lazy.componentApply(u, f)
            for x in vertices(adj, u):
                values[x] += f
                tree[x] = (sum: values[x], count: 1)
        of 4:
            if adj[u].len > 0:
                let p = adj[u][rng.rand(adj[u].high)]
                let f = int64(rng.rand(-100..100))
                lazy.subtreeApply(u, p, f)
                for x in vertices(adj, u, p):
                    values[x] += f
                    tree[x] = (sum: values[x], count: 1)
        of 5, 6:
            checkPath(u, v)
            checkPath(v, u)
        of 7:
            tree.makeRoot(u)
            lazy.makeRoot(u)
            affine.makeRoot(u)
            for x in vertices(adj, u):
                doAssert tree.findRoot(x) == u
                doAssert lazy.findRoot(x) == u
                doAssert affine.findRoot(x) == u
        of 8, 9:
            let ids = path(adj, u, v)
            if ids.len > 0:
                let f = int64(rng.rand(-100..100))
                lazy.pathApply(u, v, f)
                for x in ids:
                    values[x] += f
                    tree[x] = (sum: values[x], count: 1)
        else:
            if adj[u].len > 0:
                let p = adj[u][rng.rand(adj[u].high)]
                let expected = total(values, vertices(adj, u, p))
                doAssert tree.subtreeProd(u, p) == expected
                doAssert lazy.subtreeProd(u, p) == expected

        if step mod 17 == 0:
            for x in 0..<n:
                doAssert tree[x] == (sum: values[x], count: 1)
                doAssert lazy[x] == (sum: values[x], count: 1)
                let expected = total(values, vertices(adj, x))
                doAssert tree.componentProd(x) == expected
                doAssert lazy.componentProd(x) == expected
    for u in 0..<n:
        for v in 0..<n: checkPath(u, v)

echo "Hello World"
