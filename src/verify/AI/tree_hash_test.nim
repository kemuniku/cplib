# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
include cplib/tree/tree_hash
import algorithm, tables

proc slowMul(a, b: uint64): uint64 =
    ## 加算だけで剰余乗算の正解を求める。
    var a = a
    var b = b
    while b > 0:
        if (b and 1) != 0: result = (result + a) mod TREE_HASH_MOD
        a = (a + a) mod TREE_HASH_MOD
        b = b shr 1

proc canonical(g: UnWeightedUnDirectedGraph, u, p: int): string =
    ## 子の表現をソートして根付き木の同型を厳密に判定する。
    var children: seq[string]
    for v in g[u]:
        if v != p: children.add(canonical(g, v, u))
    children.sort()
    result = "("
    for child in children: result.add(child)
    result.add(")")

proc naive(g: UnWeightedUnDirectedGraph, u, p: int,
           hashes: var seq[uint64]): int =
    ## 元コードの再帰と独立した剰余乗算で部分木ハッシュを求める。
    var product = 1'u64
    for v in g[u]:
        if v == p: continue
        result = max(result, naive(g, v, u, hashes) + 1)
        product = slowMul(product, hashes[v])
    hashes[u] = (product + treeHashDepth[result]) mod TREE_HASH_MOD

var rng = initRand(20260906)
let limits = @[0'u64, 1'u64, TREE_HASH_MOD - 2, TREE_HASH_MOD - 1]
for a in limits:
    for b in limits: doAssert treeHashMul(a, b) == slowMul(a, b)
for i in 0..<1000:
    let a = rng.rand(0'u64..TREE_HASH_MOD - 1)
    let b = rng.rand(0'u64..TREE_HASH_MOD - 1)
    doAssert treeHashMul(a, b) == slowMul(a, b)

doAssert initUnWeightedUnDirectedGraph(0).tree_hash() ==
    (newSeq[uint64](), newSeq[uint64]())
var shapeToHash = initTable[string, uint64]()
var hashToShape = initTable[uint64, string]()
for n in 1..35:
    for trial in 0..<8:
        var g = initUnWeightedUnDirectedGraph(n)
        var directed = initUnWeightedDirectedGraph(n)
        var staticG = initUnWeightedUnDirectedStaticGraph(n)
        var weighted = initWeightedUnDirectedGraph(n, float)
        var weightedStatic = initWeightedUnDirectedStaticGraph(n, int64)
        var directedStatic = initUnWeightedDirectedStaticGraph(n)
        var weightedDirected = initWeightedDirectedGraph(n)
        var weightedDirectedStatic = initWeightedDirectedStaticGraph(n)
        for v in 1..<n:
            let p = rng.rand(v - 1)
            g.add_edge(p, v)
            directed.add_edge(p, v)
            staticG.add_edge(p, v)
            weighted.add_edge(p, v, float(v))
            weightedStatic.add_edge(p, v, int64(v))
            directedStatic.add_edge(p, v)
            weightedDirected.add_edge(p, v, v)
            weightedDirectedStatic.add_edge(p, v, v)
        staticG.build()
        weightedStatic.build()
        directedStatic.build()
        weightedDirectedStatic.build()
        let hashes = g.tree_hash()
        doAssert hashes.subtree == directed.subtree_hash()
        doAssert hashes.subtree == directedStatic.subtree_hash()
        doAssert hashes.subtree == weightedDirected.subtree_hash()
        doAssert hashes.subtree == weightedDirectedStatic.subtree_hash()
        doAssert hashes == staticG.tree_hash()
        doAssert hashes == weighted.tree_hash()
        doAssert hashes == weightedStatic.tree_hash()
        for root in 0..<n:
            let actual = g.tree_hash(root)
            var expected = newSeq[uint64](n)
            discard naive(g, root, -1, expected)
            doAssert actual.subtree == expected
            doAssert actual.subtree == g.subtree_hash(root)
            doAssert actual.all_roots == hashes.all_roots
            doAssert actual.all_roots[root] == expected[root]
            let shape = canonical(g, root, -1)
            let hash = actual.all_roots[root]
            if shape in shapeToHash: doAssert shapeToHash[shape] == hash
            if hash in hashToShape: doAssert hashToShape[hash] == shape
            shapeToHash[shape] = hash
            hashToShape[hash] = shape
        var reversed = initUnWeightedUnDirectedGraph(n)
        for u in countdown(n - 1, 0):
            for v in g[u]:
                if u < v: reversed.add_edge(n - 1 - v, n - 1 - u)
        let reversedHashes = reversed.all_roots_hash(n - 1)
        for v in 0..<n:
            doAssert reversedHashes[n - 1 - v] == hashes.all_roots[v]

block:
    let saved = treeHashDepth[0]
    treeHashDepth[0] = TREE_HASH_MOD - 1
    var g = initUnWeightedUnDirectedGraph(5)
    for v in 1..<5: g.add_edge(0, v)
    let hashes = g.tree_hash()
    doAssert hashes.subtree[1] == 0
    for root in 0..<5:
        var expected = newSeq[uint64](5)
        discard naive(g, root, -1, expected)
        doAssert hashes.all_roots[root] == expected[root]
    treeHashDepth[0] = saved

block:
    const n = 200000
    var path = initUnWeightedUnDirectedGraph(n)
    var star = initUnWeightedUnDirectedGraph(n)
    for v in 1..<n:
        path.add_edge(v - 1, v)
        star.add_edge(0, v)
    let pathHashes = path.all_roots_hash()
    for v in 0..<n: doAssert pathHashes[v] == pathHashes[n - 1 - v]
    let starHashes = star.all_roots_hash(n - 1)
    for v in 2..<n: doAssert starHashes[v] == starHashes[1]

echo "Hello World"
