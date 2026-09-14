# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sequtils
import cplib/graph/graph
import cplib/tree/lca
import cplib/tree/heavylightdecomposition

var rng = initRand(20260914)

proc naive(parent, depth: seq[int], u, v: int): int =
    var (a, b) = (u, v)
    while depth[a] > depth[b]: a = parent[a]
    while depth[b] > depth[a]: b = parent[b]
    while a != b:
        a = parent[a]
        b = parent[b]
    a

proc check(n: int, edges: seq[(int, int)], root: int, forest: bool) =
    var g = initUnWeightedUnDirectedStaticGraph(n)
    var gd = initUnWeightedUnDirectedGraph(n)
    var wg = initWeightedUnDirectedGraph(n)
    var ws = initWeightedUnDirectedStaticGraph(n)
    var dg = initUnWeightedDirectedGraph(n)
    var ds = initUnWeightedDirectedStaticGraph(n)
    var wd = initWeightedDirectedGraph(n)
    var wds = initWeightedDirectedStaticGraph(n)
    var adj = newSeq[seq[int]](n)
    for (u, v) in edges:
        g.add_edge(u, v)
        gd.add_edge(u, v)
        wg.add_edge(u, v, 7)
        ws.add_edge(u, v, -3)
        dg.add_edge(v, u)
        ds.add_edge(u, v)
        wd.add_edge(v, u, 4)
        wds.add_edge(u, v, 2)
        wds.add_edge(v, u, 8)
        adj[v].add(u)
    g.build()
    ws.build()
    ds.build()
    wds.build()
    var actual: seq[LowestCommonAncestor]
    var expected: HeavyLightDecomposition
    if forest:
        expected = g.initHldFromForest()
        actual = @[g.initLCAFromForest(), gd.initLCAFromForest(),
            wg.initLCAFromForest(), ws.initLCAFromForest(), dg.initLCAFromForest(),
            ds.initLCAFromForest(), wd.initLCAFromForest(), wds.initLCAFromForest(),
            adj.initLCAFromForest()]
    else:
        expected = g.initHld(root)
        actual = @[g.initLCA(root), gd.initLCA(root), wg.initLCA(root),
            ws.initLCA(root), dg.initLCA(root), ds.initLCA(root), wd.initLCA(root),
            wds.initLCA(root), adj.initLCA(root)]
    let count = expected.numVertices
    var parent = newSeq[int](count)
    var depths = newSeq[int](count)
    for v in 0..<count:
        parent[v] = expected.parentOf(v)
        depths[v] = expected.depth(v)
    let realRoot = if forest: n else: root
    parent[realRoot] = count + 100
    actual.add(initLCAFromParent(parent, realRoot))
    parent[realRoot] = -1
    for tree in actual:
        doAssert tree.numVertices == count
        for v in 0..<count:
            doAssert tree.parentOf(v) == parent[v]
            doAssert tree.depth(v) == depths[v]
        for trial in 0..<(if count <= 40: count * count else: 2000):
            let u = if count <= 40: trial div count else: rng.rand(count - 1)
            let v = if count <= 40: trial mod count else: rng.rand(count - 1)
            let ancestor = naive(parent, depths, u, v)
            doAssert tree.lca(u, v) == ancestor
            doAssert tree.dist(u, v) == depths[u] + depths[v] - 2 * depths[ancestor]
            let x = rng.rand(count - 1)
            doAssert tree.median(x, u, v) == expected.median(x, u, v)

check(0, @[], 0, true)
check(1, @[], 0, false)
check(15, @[], 0, true)
for n in 2..40:
    for trial in 0..<4:
        var labels = toSeq(0..<n)
        rng.shuffle(labels)
        var edges: seq[(int, int)]
        var forestEdges: seq[(int, int)]
        for v in 1..<n:
            let edge = (labels[v], labels[rng.rand(v - 1)])
            edges.add(edge)
            if rng.rand(2) != 0: forestEdges.add(edge)
        check(n, edges, rng.rand(n - 1), false)
        check(n, forestEdges, 0, true)
for n in [63, 64, 65, 127, 128, 129, 511, 512, 513, 2048]:
    var edges: seq[(int, int)]
    for v in 1..<n: edges.add((v, rng.rand(v - 1)))
    check(n, edges, rng.rand(n - 1), false)

for n in [255, 256, 257, 65535, 65536, 65537]:
    var parent = newSeq[int](n)
    var depths = newSeq[int](n)
    parent[0] = -1
    for v in 1..<n:
        parent[v] = rng.rand(v - 1)
        depths[v] = depths[parent[v]] + 1
    let tree = initLCAFromParent(parent, 0)
    for v in 0..<n:
        doAssert tree.lca(v, v) == v
        if v > 0: doAssert tree.lca(v, parent[v]) == parent[v]
    for trial in 0..<10000:
        let u = rng.rand(n - 1)
        let v = rng.rand(n - 1)
        doAssert tree.lca(u, v) == naive(parent, depths, u, v)

for badParent in [@[-1, 2, 1], @[-1, -1], @[-1, 2]]:
    var rejected = false
    try:
        discard initLCAFromParent(badParent, 0)
    except AssertionDefect:
        rejected = true
    doAssert rejected

let n = 200000
var parent = newSeq[int](n)
for v in 0..<n: parent[v] = v - 1
let path = initLCAFromParent(parent, 0)
for start in [0, 16, 32, n - 64]:
    for u in start..<start + 32:
        for v in start..<start + 64:
            doAssert path.lca(u, v) == min(u, v)
for trial in 0..<10000:
    let u = rng.rand(n - 1)
    let v = rng.rand(n - 1)
    doAssert path.lca(u, v) == min(u, v)
    doAssert path.dist(u, v) == abs(u - v)
for v in 0..<n: parent[v] = n - 1
let star = initLCAFromParent(parent, n - 1)
for trial in 0..<10000:
    let u = rng.rand(n - 1)
    let v = rng.rand(n - 1)
    doAssert star.lca(u, v) == (if u == v: u else: n - 1)
parent[0] = -1
var depths = newSeq[int](n)
for v in 1..<n:
    parent[v] = rng.rand(v - 1)
    depths[v] = depths[parent[v]] + 1
let randomTree = initLCAFromParent(parent, 0)
for trial in 0..<10000:
    let u = rng.rand(n - 1)
    let v = rng.rand(n - 1)
    doAssert randomTree.lca(u, v) == naive(parent, depths, u, v)
echo "Hello World"
