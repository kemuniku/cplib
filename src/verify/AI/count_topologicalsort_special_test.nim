# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sequtils
import cplib/graph/graph
import cplib/graph/count_topologicalsort
import cplib/math/combination
import cplib/modint/modint

type Mint = modint998244353_barrett
type Montgomery = modint998244353_montgomery
var rng = initRand(20261113)

template expectAssertion(body: untyped) =
    block:
        var raised = false
        try:
            body
        except AssertionDefect:
            raised = true
        doAssert raised

proc checkGeneral[T](g: UnWeightedDirectedGraph) =
    let expected = T.init(g.count_topologicalsort())
    doAssert g.count_topologicalsort(T) == expected
    doAssert count_topologicalsort_components[T](g) == expected

proc checkForest(g: UnWeightedDirectedGraph) =
    let expected = Mint.init(g.count_topologicalsort())
    doAssert count_topologicalsort_forest[Mint](g) == expected
    doAssert count_topologicalsort_forest[Montgomery](g).val == expected.val

proc rootedGraph(g: UnWeightedUnDirectedGraph, root: int, inward: bool): UnWeightedDirectedGraph =
    result = initUnWeightedDirectedGraph(g.len)
    var parent = newSeqWith(g.len, -2)
    parent[root] = -1
    var queue = @[root]
    var head = 0
    while head < queue.len:
        let u = queue[head]
        inc head
        for v in g[u]:
            if v == parent[u]: continue
            parent[v] = u
            queue.add(v)
            if inward: result.add_edge(v, u)
            else: result.add_edge(u, v)

for n in 0..9:
    for trial in 0..<35:
        var permutation = toSeq(0..<n)
        rng.shuffle(permutation)
        var g = initUnWeightedDirectedGraph(n)
        for i in 0..<n:
            for j in i+1..<n:
                if rng.rand(4) == 0:
                    g.add_edge(permutation[i], permutation[j])
                    if rng.rand(2) == 0: g.add_edge(permutation[i], permutation[j])
        checkGeneral[Mint](g)
        checkGeneral[Montgomery](g)
        var singletonChains: seq[seq[int]]
        for v in permutation: singletonChains.add(@[v])
        doAssert count_topologicalsort_chains[Mint](g, singletonChains) == Mint.init(g.count_topologicalsort())

for n in 0..9:
    for trial in 0..<50:
        var permutation = toSeq(0..<n)
        rng.shuffle(permutation)
        var g = initUnWeightedDirectedGraph(n)
        for v in 1..<n:
            if rng.rand(3) == 0: continue
            let p = rng.rand(v - 1)
            if rng.rand(1) == 0:
                g.add_edge(permutation[p], permutation[v])
                if rng.rand(2) == 0: g.add_edge(permutation[p], permutation[v])
            else:
                g.add_edge(permutation[v], permutation[p])
        checkForest(g)

for n in 1..9:
    for trial in 0..<15:
        var tree = initUnWeightedUnDirectedGraph(n)
        for v in 1..<n: tree.add_edge(rng.rand(v - 1), v)
        let counts = count_topologicalsort_all_roots[Mint](tree)
        for root in 0..<n:
            for inward in [false, true]:
                let g = rootedGraph(tree, root, inward)
                let expected = Mint.init(g.count_topologicalsort())
                doAssert count_topologicalsort_rooted_forest[Mint](g, inward) == expected
                doAssert count_topologicalsort_rooted_forest[Mint](g) == expected
                doAssert counts[root] == expected

for n in 0..9:
    for inward in [false, true]:
        var g = initUnWeightedDirectedGraph(n)
        for v in 1..<n:
            if v mod 3 == 0: continue
            let p = rng.rand(v - 1)
            if inward: g.add_edge(v, p)
            else: g.add_edge(p, v)
        doAssert count_topologicalsort_rooted_forest[Mint](g, inward) == Mint.init(g.count_topologicalsort())

block:
    var g = initUnWeightedDirectedGraph(7)
    var sg = initUnWeightedDirectedStaticGraph(7)
    var wg = initWeightedDirectedGraph(7, float)
    var swg = initWeightedDirectedStaticGraph(7, int64)
    for (u, v) in [(0, 1), (0, 2), (0, 2), (4, 3), (5, 3), (5, 3)]:
        g.add_edge(u, v)
        sg.add_edge(u, v)
        wg.add_edge(u, v, -0.5)
        swg.add_edge(u, v, -7)
    sg.build()
    swg.build()
    doAssert g.count_topologicalsort() == 560
    template checkMixed(graph: untyped) =
        doAssert count_topologicalsort_rooted_forest[Mint](graph) == Mint.init(560)
        doAssert count_topologicalsort_rooted_forest[Montgomery](graph).val == 560
        expectAssertion:
            discard count_topologicalsort_rooted_forest[Mint](graph, inward = false)
        expectAssertion:
            discard count_topologicalsort_rooted_forest[Mint](graph, inward = true)
    checkMixed(g)
    checkMixed(sg)
    checkMixed(wg)
    checkMixed(swg)
    for modulus in [11, 17, 101]:
        modint_barrett.setMod(modulus)
        doAssert count_topologicalsort_rooted_forest[modint_barrett](g).val == 560 mod modulus

for n in 0..10:
    for trial in 0..<40:
        var permutation = toSeq(0..<n)
        rng.shuffle(permutation)
        var g = initUnWeightedDirectedGraph(n)
        var first = 0
        while first < n:
            let length = rng.rand(1..min(5, n - first))
            let inward = rng.rand(1) == 0
            var tree = initUnWeightedUnDirectedGraph(length)
            for v in 1..<length: tree.add_edge(rng.rand(v - 1), v)
            let component = rootedGraph(tree, rng.rand(length - 1), inward)
            for u in 0..<length:
                for v in component[u]:
                    g.add_edge(permutation[first + u], permutation[first + v])
                    if rng.rand(2) == 0:
                        g.add_edge(permutation[first + u], permutation[first + v])
            first += length
        let expected = g.count_topologicalsort()
        doAssert count_topologicalsort_rooted_forest[Mint](g).val == expected
        doAssert count_topologicalsort_rooted_forest[Montgomery](g).val == expected

block:
    var g = initUnWeightedDirectedGraph(4)
    for (u, v) in [(0, 1), (2, 1), (2, 3)]: g.add_edge(u, v)
    expectAssertion:
        discard count_topologicalsort_rooted_forest[Mint](g)
    doAssert count_topologicalsort_forest[Mint](g) == Mint.init(g.count_topologicalsort())

for n in 0..10:
    for trial in 0..<40:
        var permutation = toSeq(0..<n)
        rng.shuffle(permutation)
        var chains = newSeq[seq[int]](3)
        var g = initUnWeightedDirectedGraph(n)
        for u in permutation:
            let c = rng.rand(2)
            if chains[c].len > 0: g.add_edge(chains[c][^1], u)
            chains[c].add(u)
        for i in 0..<n:
            for j in i+1..<n:
                if rng.rand(5) == 0: g.add_edge(permutation[i], permutation[j])
        doAssert count_topologicalsort_chains[Mint](g, chains) == Mint.init(g.count_topologicalsort())

block:
    var g = initUnWeightedDirectedGraph(4)
    g.add_edge(0, 1)
    g.add_edge(1, 2)
    g.add_edge(2, 3)
    doAssert count_topologicalsort_two_chains[Mint](g, [0, 2], [1, 3]) == Mint.init(1)
    doAssert count_topologicalsort_two_chains[Mint](g, [0, 1, 2, 3], []) == Mint.init(1)
    expectAssertion:
        discard count_topologicalsort_two_chains[Mint](g, [1, 0], [2, 3])
    expectAssertion:
        discard count_topologicalsort_two_chains[Mint](g, [0, 1], [1, 2, 3])
    expectAssertion:
        discard count_topologicalsort_two_chains[Mint](g, [0], [2, 3])
    expectAssertion:
        discard count_topologicalsort_two_chains[Mint](g, [-1, 0], [1, 2, 3])

for n in 1..9:
    for trial in 0..<50:
        var nodes: seq[TopologicalSortSPNode]
        var groups: seq[tuple[node: int, vertices: seq[int]]]
        var g = initUnWeightedDirectedGraph(n)
        for u in 0..<n:
            nodes.add(TopologicalSortSPNode(kind: tspVertex))
            groups.add((u, @[u]))
        while groups.len > 1:
            rng.shuffle(groups)
            let a = groups.pop()
            let b = groups.pop()
            let kind = if rng.rand(1) == 0: tspSeries else: tspParallel
            if kind == tspSeries:
                for u in a.vertices:
                    for v in b.vertices: g.add_edge(u, v)
            nodes.add(TopologicalSortSPNode(kind: kind, left: a.node, right: b.node))
            groups.add((nodes.len - 1, a.vertices & b.vertices))
        doAssert count_topologicalsort_series_parallel[Mint](nodes) == Mint.init(g.count_topologicalsort())

proc checkYoung(rows: seq[int]) =
    var vertices = newSeq[seq[int]](rows.len)
    var n = 0
    for i, length in rows:
        for j in 0..<length:
            vertices[i].add(n)
            inc n
    var g = initUnWeightedDirectedGraph(n)
    for i, row in vertices:
        for j, u in row:
            if j + 1 < row.len: g.add_edge(u, row[j + 1])
            if i + 1 < rows.len and j < rows[i + 1]: g.add_edge(u, vertices[i + 1][j])
    doAssert count_topologicalsort_young[Mint](rows) == Mint.init(g.count_topologicalsort())

proc partitions(remaining, limit: int, rows: seq[int]) =
    if remaining == 0:
        checkYoung(rows)
    else:
        for length in 1..min(limit, remaining):
            partitions(remaining - length, length, rows & @[length])

for n in 0..12: partitions(n, n, @[])
checkYoung(@[3, 2, 0, 0])
expectAssertion:
    discard count_topologicalsort_young[Mint]([2, 3])
expectAssertion:
    discard count_topologicalsort_young[Mint]([-1])

block:
    let empty = initUnWeightedDirectedGraph(0)
    doAssert count_topologicalsort_rooted_forest[Mint](empty) == Mint.init(1)
    doAssert count_topologicalsort_chains[Mint](empty, []) == Mint.init(1)
    doAssert count_topologicalsort_series_parallel[Mint]([]) == Mint.init(1)
    doAssert count_topologicalsort_all_roots[Mint](initUnWeightedUnDirectedGraph(0)).len == 0
    expectAssertion:
        discard count_topologicalsort_series_parallel[Mint]([
            TopologicalSortSPNode(kind: tspVertex), TopologicalSortSPNode(kind: tspVertex)])
    expectAssertion:
        discard count_topologicalsort_series_parallel[Mint]([
            TopologicalSortSPNode(kind: tspVertex),
            TopologicalSortSPNode(kind: tspParallel, left: 0, right: 0)])

for edges in [@[(0, 0)], @[(0, 1), (1, 0)], @[(0, 1), (1, 2), (2, 0)]]:
    var g = initUnWeightedDirectedGraph(3)
    for (u, v) in edges: g.add_edge(u, v)
    checkGeneral[Mint](g)
    checkForest(g)
    doAssert count_topologicalsort_rooted_forest[Mint](g) == Mint.init(0)
    doAssert count_topologicalsort_chains[Mint](g, [@[0], @[1], @[2]]) == Mint.init(0)

block:
    var triangle = initUnWeightedDirectedGraph(3)
    triangle.add_edge(0, 1)
    triangle.add_edge(1, 2)
    triangle.add_edge(0, 2)
    expectAssertion:
        discard count_topologicalsort_forest[Mint](triangle)
    expectAssertion:
        discard count_topologicalsort_rooted_forest[Mint](triangle)
    expectAssertion:
        discard count_topologicalsort_all_roots[Mint](initUnWeightedUnDirectedGraph(2))

block:
    var sg = initUnWeightedDirectedStaticGraph(5)
    var wg = initWeightedDirectedGraph(5, float)
    var swg = initWeightedDirectedStaticGraph(5, int64)
    for (u, v) in [(0, 1), (0, 1), (1, 2), (3, 4)]:
        sg.add_edge(u, v)
        wg.add_edge(u, v, -0.5)
        swg.add_edge(u, v, -7)
    sg.build()
    swg.build()
    template checkType(g: untyped) =
        doAssert g.count_topologicalsort(Mint) == Mint.init(10)
        doAssert count_topologicalsort_components[Mint](g) == Mint.init(10)
        doAssert count_topologicalsort_rooted_forest[Mint](g) == Mint.init(10)
        doAssert count_topologicalsort_forest[Mint](g) == Mint.init(10)
        doAssert count_topologicalsort_two_chains[Mint](g, [0, 1, 2], [3, 4]) == Mint.init(10)
    checkType(sg)
    checkType(wg)
    checkType(swg)
    var tree = initWeightedUnDirectedStaticGraph(4, float)
    for v in 1..3: tree.add_edge(0, v, -1.0)
    tree.build()
    doAssert count_topologicalsort_all_roots[Mint](tree).mapIt(it.val) == @[6, 2, 2, 2]

block:
    type Dynamic = modint_barrett
    for modulus in [17, 101, 1000000007]:
        Dynamic.setMod(modulus)
        var g = initUnWeightedDirectedGraph(8)
        for v in 1..<8: g.add_edge(0, v)
        checkGeneral[Dynamic](g)
        doAssert count_topologicalsort_rooted_forest[Dynamic](g).val == int(5040 mod modulus)
        doAssert count_topologicalsort_forest[Dynamic](g).val == int(5040 mod modulus)
        doAssert count_topologicalsort_young[Dynamic]([3, 2]).val == 5
    Dynamic.setMod(6)
    let g = initUnWeightedDirectedGraph(8)
    doAssert g.count_topologicalsort(Dynamic).val == 0
    doAssert count_topologicalsort_chains[Dynamic](g, toSeq(0..<8).mapIt(@[it])).val == 0
    Dynamic.setMod(7)
    expectAssertion:
        discard count_topologicalsort_components[Dynamic](g)

block:
    let n = 100000
    let comb = initCombination[Mint](n)
    var g = initUnWeightedDirectedGraph(n)
    var tree = initUnWeightedUnDirectedGraph(n)
    for v in 1..<n:
        g.add_edge(v - 1, v)
        tree.add_edge(v - 1, v)
    doAssert count_topologicalsort_rooted_forest[Mint](g) == Mint.init(1)
    let counts = count_topologicalsort_all_roots[Mint](tree)
    for root in [0, 1, n div 2, n - 1]:
        doAssert counts[root] == comb.ncr(n - 1, root)
    let isolated = initUnWeightedDirectedGraph(n)
    doAssert count_topologicalsort_components[Mint](isolated) == comb.fact[n]
    doAssert count_topologicalsort_rooted_forest[Mint](isolated) == comb.fact[n]
    var pairs = initUnWeightedDirectedGraph(n)
    for u in countup(0, n - 2, 2): pairs.add_edge(u, u + 1)
    doAssert count_topologicalsort_components[Mint](pairs) == comb.fact[n] * Mint.init(2).inv.pow(n div 2)
    var mixed = initUnWeightedDirectedGraph(n)
    for first in countup(0, n - 3, 3):
        if first mod 2 == 0:
            mixed.add_edge(first, first + 1)
            mixed.add_edge(first, first + 2)
        else:
            mixed.add_edge(first + 1, first)
            mixed.add_edge(first + 2, first)
    doAssert count_topologicalsort_rooted_forest[Mint](mixed) == comb.fact[n] * comb.inv[3].pow(n div 3)

block:
    let n = 400
    let comb = initCombination[Mint](n)
    var path = initUnWeightedDirectedGraph(n)
    var star = initUnWeightedDirectedGraph(n)
    var twoChains = initUnWeightedDirectedGraph(n)
    for v in 1..<n:
        path.add_edge(v - 1, v)
        if v < n div 2: star.add_edge(v, 0)
        else: star.add_edge(0, v)
        if v != n div 2: twoChains.add_edge(v - 1, v)
    doAssert count_topologicalsort_forest[Mint](path) == Mint.init(1)
    doAssert count_topologicalsort_forest[Mint](star) == comb.fact[n div 2 - 1] * comb.fact[n div 2]
    doAssert count_topologicalsort_two_chains[Mint](twoChains, toSeq(0..<n div 2), toSeq(n div 2..<n)) == comb.ncr(n, n div 2)

echo "Hello World"
