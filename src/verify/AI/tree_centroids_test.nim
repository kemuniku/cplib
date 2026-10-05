# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/tree/tree_centroids
import cplib/graph/graph
import random, algorithm

type Edge = tuple[u, v: int]

proc oracle(n: int, edges: seq[Edge]): seq[int] =
    var adjacent = newSeq[seq[int]](n)
    for (u, v) in edges:
        adjacent[u].add(v)
        adjacent[v].add(u)
    for removed in 0..<n:
        var seen = newSeq[bool](n)
        seen[removed] = true
        var largest = 0
        for start in 0..<n:
            if seen[start]: continue
            var component = @[start]
            seen[start] = true
            var index = 0
            while index < component.len:
                let u = component[index]
                inc index
                for v in adjacent[u]:
                    if not seen[v]:
                        seen[v] = true
                        component.add(v)
            largest = max(largest, component.len)
        if largest <= n div 2: result.add(removed)

proc check(n: int, edges: seq[Edge], expected: seq[int]) =
    var dynamic = initUnWeightedUnDirectedGraph(n)
    var staticG = initUnWeightedUnDirectedStaticGraph(n)
    var weighted = initWeightedUnDirectedGraph(n, float)
    var weightedStatic = initWeightedUnDirectedStaticGraph(n, int64)
    for i, edge in edges:
        let (u, v) = edge
        dynamic.add_edge(u, v)
        staticG.add_edge(u, v)
        weighted.add_edge(u, v, if i mod 2 == 0: -1.0e100 else: 0.0)
        weightedStatic.add_edge(u, v, if i mod 2 == 0: int64.low else: int64.high)
    staticG.build()
    weightedStatic.build()
    let beforeDynamic = dynamic.edges
    let beforeEdges = dynamic.edge_info
    let beforeStatic = staticG.elist
    let beforeStart = staticG.start
    let beforeStaticEdges = staticG.edge_info
    let beforeWeighted = weighted.edges
    let beforeWeightedEdges = weighted.edge_info
    let beforeWeightedStatic = weightedStatic.elist
    let beforeWeightedStart = weightedStatic.start
    let beforeWeightedStaticEdges = weightedStatic.edge_info
    doAssert dynamic.tree_centroids() == expected
    doAssert staticG.tree_centroids() == expected
    doAssert weighted.tree_centroids() == expected
    doAssert weightedStatic.tree_centroids() == expected
    doAssert dynamic.tree_centroids() == expected
    doAssert dynamic.edges == beforeDynamic
    doAssert dynamic.edge_info == beforeEdges
    doAssert staticG.elist == beforeStatic
    doAssert staticG.start == beforeStart
    doAssert staticG.edge_info == beforeStaticEdges
    doAssert weighted.edges == beforeWeighted
    doAssert weighted.edge_info == beforeWeightedEdges
    doAssert weightedStatic.elist == beforeWeightedStatic
    doAssert weightedStatic.start == beforeWeightedStart
    doAssert weightedStatic.edge_info == beforeWeightedStaticEdges
    if n > 0: doAssert expected.len in 1..2

proc checkOracle(n: int, edges: seq[Edge]) =
    check(n, edges, oracle(n, edges))

check(0, @[], @[])
check(1, @[], @[0])
check(2, @[(0, 1)], @[0, 1])
check(5, @[(0, 1), (1, 2), (2, 3), (3, 4)], @[2])
check(6, @[(0, 1), (1, 2), (2, 3), (3, 4), (4, 5)], @[2, 3])
check(7, @[(6, 0), (6, 1), (6, 2), (6, 3), (6, 4), (6, 5)], @[6])
check(7, @[(4, 0), (4, 1), (4, 6), (4, 2), (2, 3), (3, 5)], @[4])

for n in 2..6:
    var count = 1
    for i in 0..<n - 2: count *= n
    for code in 0..<count:
        var digits = code
        var sequence = newSeq[int](n - 2)
        var degree = newSeq[int](n)
        for v in 0..<n: degree[v] = 1
        for i in 0..<sequence.len:
            sequence[i] = digits mod n
            digits = digits div n
            inc degree[sequence[i]]
        var edges: seq[Edge]
        for v in sequence:
            var leaf = 0
            while degree[leaf] != 1: inc leaf
            edges.add((leaf, v))
            dec degree[leaf]
            dec degree[v]
        var last: seq[int]
        for v in 0..<n:
            if degree[v] == 1: last.add(v)
        edges.add((last[0], last[1]))
        checkOracle(n, edges)

var rng = initRand(288)
for n in 1..80:
    for trial in 0..<8:
        var labels = newSeq[int](n)
        for v in 0..<n: labels[v] = v
        rng.shuffle(labels)
        var edges: seq[Edge]
        for v in 1..<n:
            edges.add((labels[v], labels[rng.rand(v - 1)]))
        rng.shuffle(edges)
        checkOracle(n, edges)
        edges.reverse()
        for edge in edges.mitems: swap(edge.u, edge.v)
        checkOracle(n, edges)

block:
    const n = 200000
    var path, star: seq[Edge]
    for v in 1..<n:
        path.add((v - 1, v))
        star.add((n - 1, v - 1))
    check(n, path, @[n div 2 - 1, n div 2])
    path.setLen(n - 2)
    check(n - 1, path, @[(n - 1) div 2])
    check(n, star, @[n - 1])

when compileOption("assertions"):
    block:
        var cycle = initUnWeightedUnDirectedGraph(4)
        cycle.add_edge(0, 1)
        cycle.add_edge(1, 2)
        cycle.add_edge(2, 0)
        var rejected = false
        try: discard cycle.tree_centroids()
        except AssertionDefect: rejected = true
        doAssert rejected
    block:
        var disconnected = initUnWeightedUnDirectedGraph(4)
        disconnected.add_edge(0, 1)
        disconnected.add_edge(2, 3)
        disconnected.add_edge(2, 3)
        var rejected = false
        try: discard disconnected.tree_centroids()
        except AssertionDefect: rejected = true
        doAssert rejected
    block:
        var unbuilt = initUnWeightedUnDirectedStaticGraph(1)
        var rejected = false
        try: discard unbuilt.tree_centroids()
        except AssertionDefect: rejected = true
        doAssert rejected

echo "Hello World"
