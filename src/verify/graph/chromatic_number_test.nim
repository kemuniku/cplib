# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/graph
import cplib/graph/chromatic_number
import random

type TestEdge = tuple[u, v: int]

proc oracle(n: int, edges: seq[TestEdge]): int =
    if n == 0: return 0
    var adjacent = newSeq[seq[bool]](n)
    for row in adjacent.mitems: row = newSeq[bool](n)
    for (u, v) in edges:
        if u == v: return -1
        adjacent[u][v] = true
        adjacent[v][u] = true
    var colors = newSeq[int](n)
    proc search(v, used, limit: int): bool =
        if v == n: return true
        for c in 0..<min(used + 1, limit):
            var valid = true
            for u in 0..<v:
                if adjacent[u][v] and colors[u] == c:
                    valid = false
                    break
            if valid:
                colors[v] = c
                if search(v + 1, max(used, c + 1), limit): return true
        false
    for k in 1..n:
        if search(0, 0, k): return k

proc check(g: UnDirectedGraph, edges: seq[TestEdge], expected: int) =
    var before: seq[typeof(g.edge_info[0])]
    for e in g.edge_info: before.add(e)
    doAssert g.chromatic_number() == expected
    let answer = g.chromatic_number_with_coloring()
    doAssert answer.chromaticNumber == expected
    doAssert g.edge_info == before
    if expected < 0:
        doAssert answer.colors.len == 0
        return
    doAssert answer.colors.len == g.len
    var seen = newSeq[bool](expected)
    for c in answer.colors:
        doAssert c >= 0 and c < expected
        seen[c] = true
    for used in seen: doAssert used
    for (u, v) in edges: doAssert answer.colors[u] != answer.colors[v]

proc checkGraph(n: int, edges: seq[TestEdge], expected: int, allTypes = false) =
    var g = initUnWeightedUnDirectedGraph(n)
    for (u, v) in edges: g.add_edge(u, v)
    check(g, edges, expected)
    if allTypes:
        var weighted = initWeightedUnDirectedGraph(n, int64)
        var csr = initUnWeightedUnDirectedStaticGraph(n)
        var weightedCsr = initWeightedUnDirectedStaticGraph(n, int64)
        for i, e in edges:
            weighted.add_edge(e.u, e.v, if i mod 2 == 0: low(int64) else: high(int64))
            csr.add_edge(e.u, e.v)
            weightedCsr.add_edge(e.u, e.v, -i.int64)
        csr.build()
        weightedCsr.build()
        check(weighted, edges, expected)
        check(csr, edges, expected)
        check(weightedCsr, edges, expected)

for n in 0..6:
    var possible: seq[TestEdge]
    for u in 0..<n:
        for v in u + 1..<n: possible.add((u, v))
    for mask in 0..<(1 shl possible.len):
        var edges: seq[TestEdge]
        for i, e in possible:
            if (mask and (1 shl i)) != 0: edges.add(e)
        checkGraph(n, edges, oracle(n, edges), n <= 4)

var rng = initRand(371)
for n in 7..10:
    for iteration in 0..<100:
        var edges: seq[TestEdge]
        let density = iteration mod 5
        for u in 0..<n:
            for v in u + 1..<n:
                if rng.rand(4) <= density:
                    edges.add((u, v))
                    if rng.rand(3) == 0:
                        edges.add((v, u))
                        edges.add((u, v))
        checkGraph(n, edges, oracle(n, edges), true)

checkGraph(1, @[(0, 0)], -1, true)
checkGraph(5, @[(0, 1), (4, 4), (4, 4)], -1, true)
checkGraph(1, @[], 1, true)
checkGraph(0, @[], 0, true)
checkGraph(18, @[], 1, true)

block:
    var clique: seq[TestEdge]
    for u in 0..<18:
        for v in u + 1..<18: clique.add((u, v))
    checkGraph(18, clique, 18, true)
block:
    var cycle: seq[TestEdge]
    for u in 0..<17: cycle.add((u, (u + 1) mod 17))
    checkGraph(18, cycle, 3, true)
block:
    var bipartite: seq[TestEdge]
    for u in 0..<9:
        for v in 9..<18: bipartite.add((u, v))
    checkGraph(18, bipartite, 2, true)
block:
    var disconnected: seq[TestEdge]
    for u in 0..<7:
        for v in u + 1..<7: disconnected.add((u, v))
    for u in 7..<16: disconnected.add((u, u + 1))
    checkGraph(18, disconnected, 7, true)

proc checkLimit(g: UnDirectedGraph) =
    var numberRejected, coloringRejected = false
    try: discard g.chromatic_number()
    except ValueError: numberRejected = true
    try: discard g.chromatic_number_with_coloring()
    except ValueError: coloringRejected = true
    doAssert numberRejected and coloringRejected

block:
    var g = initUnWeightedUnDirectedGraph(19)
    g.add_edge(0, 0)
    checkLimit(g)
    checkLimit(initWeightedUnDirectedGraph(19))
    var csr = initUnWeightedUnDirectedStaticGraph(19)
    csr.build()
    checkLimit(csr)
    var weightedCsr = initWeightedUnDirectedStaticGraph(19)
    weightedCsr.build()
    checkLimit(weightedCsr)
    g.len = -1
    checkLimit(g)

when compileOption("assertions"):
    block:
        var csr = initUnWeightedUnDirectedStaticGraph(0)
        var rejected = false
        try: discard csr.chromatic_number_with_coloring()
        except AssertionDefect: rejected = true
        doAssert rejected
        csr.build()
        doAssert csr.chromatic_number() == 0

block:
    var g = initWeightedUnDirectedGraph(3, float)
    g.add_edge(0, 1, -0.5)
    g.add_edge(1, 2, Inf)
    g.add_edge(2, 0, 1.5)
    check(g, @[(0, 1), (1, 2), (2, 0)], 3)

static:
    doAssert not compiles(chromatic_number(initUnWeightedDirectedGraph(2)))
    doAssert not compiles(chromatic_number_with_coloring(initWeightedDirectedStaticGraph(2)))

echo "Hello World"
