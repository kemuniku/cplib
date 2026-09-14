# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, random, sequtils
import cplib/graph/graph
import cplib/graph/biconnected_components
import cplib/graph/round_square_tree

type Edge = (int, int)

proc labels(g: UnWeightedUnDirectedGraph, removed = -1): seq[int] =
    result = newSeqWith(g.len, -1)
    for s in 0..<g.len:
        if s == removed or result[s] != -1: continue
        result[s] = s
        var stack = @[s]
        while stack.len > 0:
            let v = stack.pop()
            for to in g[v]:
                if to != removed and result[to] == -1:
                    result[to] = s
                    stack.add(to)

proc check(n: int, edges: seq[Edge]) =
    var g = initUnWeightedUnDirectedGraph(n)
    var sg = initUnWeightedUnDirectedStaticGraph(n)
    var wg = initWeightedUnDirectedGraph(n, float)
    var swg = initWeightedUnDirectedStaticGraph(n, float)
    for (u, v) in edges:
        g.add_edge(u, v)
        sg.add_edge(u, v)
        wg.add_edge(u, v, 2.5)
        swg.add_edge(u, v, -1.5)
    sg.build()
    swg.build()
    let bc = initBiconnectedComponents(g)
    let tree = initRoundSquareTree(bc)
    doAssert tree.len == n + bc.groups.len
    for other in [initRoundSquareTree(g), initRoundSquareTree(sg),
                  initRoundSquareTree(wg), initRoundSquareTree(swg)]:
        doAssert other.len == tree.len
        doAssert other.edges == tree.edges
        doAssert other.edge_info == tree.edge_info
    for i, group in bc.groups:
        doAssert toSeq(tree[n+i]).sorted() == group.sorted()
    var edgeCount = 0
    for v in 0..<n:
        var expected: seq[int]
        for i in bc.belong[v]: expected.add(n+i)
        doAssert toSeq(tree[v]).sorted() == expected.sorted()
        edgeCount += expected.len
    let original = labels(g)
    let mapped = labels(tree)
    var components = 0
    for v, c in mapped:
        if v == c: inc components
    doAssert edgeCount == tree.len - components
    for u in 0..<n:
        for v in 0..<n:
            doAssert (original[u] == original[v]) == (mapped[u] == mapped[v])
    for removed in 0..<n:
        let originalAfter = labels(g, removed)
        let mappedAfter = labels(tree, removed)
        for u in 0..<n:
            if u == removed: continue
            for v in 0..<n:
                if v == removed: continue
                doAssert (originalAfter[u] == originalAfter[v]) ==
                    (mappedAfter[u] == mappedAfter[v])

check(0, @[])
check(1, @[])
check(1, @[(0, 0), (0, 0)])
check(6, @[(0, 1), (1, 2), (2, 0), (2, 3), (3, 4), (4, 2)])
for n in 1..5:
    var possible: seq[Edge]
    for u in 0..<n:
        for v in u+1..<n: possible.add((u, v))
    for mask in 0..<(1 shl possible.len):
        var edges: seq[Edge]
        for i, e in possible:
            if (mask and (1 shl i)) != 0: edges.add(e)
        check(n, edges)
var rng = initRand(20260913)
for trial in 0..<300:
    let n = rng.rand(1..8)
    var edges: seq[Edge]
    for i in 0..<rng.rand(0..24):
        edges.add((rng.rand(n-1), rng.rand(n-1)))
    check(n, edges)

block:
    const n = 200000
    var g = initUnWeightedUnDirectedGraph(n)
    for v in 1..<n: g.add_edge(v-1, v)
    let tree = initRoundSquareTree(g)
    doAssert tree.len == 2*n-1
    doAssert tree.edge_info.len == 2*(n-1)
    for v in 0..<n:
        doAssert tree.edges[v].len == (if v == 0 or v == n-1: 1 else: 2)
    for v in n..<tree.len:
        doAssert tree.edges[v].len == 2

echo "Hello World"
