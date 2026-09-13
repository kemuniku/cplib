# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/graph
import cplib/graph/k_shortest_walk
import cplib/utils/constants
import heapqueue, random, sequtils

proc naive(g: WeightedDirectedGraph[int], s, t, k: int): seq[int] =
    var queue = initHeapQueue[(int, int)]()
    var count = newSeq[int](g.len)
    queue.push((0, s))
    while queue.len > 0 and result.len < k:
        let (cost, u) = queue.pop()
        if count[u] == k: continue
        inc count[u]
        if u == t: result.add(cost)
        for (v, w) in g.to_and_cost(u):
            if count[v] < k: queue.push((cost + w, v))
    while result.len < k: result.add(INF64)

block:
    var g = initWeightedDirectedGraph(3)
    doAssert g.k_shortest_walk(0, 0, 5) == @[0, INF64, INF64, INF64, INF64]
    doAssert g.k_shortest_walk(0, 2, 5) == newSeqWith(5, INF64)
    doAssert g.k_shortest_walk(0, 2, 1) == @[INF64]
    doAssert g.k_shortest_walk(0, 0, 1) == @[0]
    doAssert g.k_shortest_walk(0, 2, 3, INF = 100) == @[100, 100, 100]
    doAssert g.k_shortest_walk(0, 0, 0) == newSeq[int]()
    g.add_edge(0, 1, 2)
    g.add_edge(0, 1, 2)
    g.add_edge(1, 2, 3)
    doAssert g.k_shortest_walk(0, 2, 5) == @[5, 5, INF64, INF64, INF64]
    doAssert g.k_shortest_walk(0, 2, 3, INF = 100) == @[5, 5, 100]
    g.add_edge(2, 2, 0)
    doAssert g.k_shortest_walk(0, 2, 20) == newSeqWith(20, 5)

block:
    var g = initWeightedDirectedGraph(3)
    g.add_edge(0, 1, 0)
    g.add_edge(1, 0, 0)
    g.add_edge(0, 2, 1)
    g.add_edge(1, 2, 1)
    doAssert g.k_shortest_walk(0, 2, 20) == newSeqWith(20, 1)
    doAssert g.k_shortest_walk(0, 0, 20) == newSeqWith(20, 0)

block:
    var g = initWeightedDirectedGraph(2)
    g.add_edge(0, 1, 3)
    g.add_edge(1, 0, 4)
    doAssert g.k_shortest_walk(0, 1, 4) == @[3, 10, 17, 24]

var rng = initRand(712398)
for trial in 0..<1000:
    let n = rng.rand(1..7)
    var g = initWeightedDirectedGraph(n)
    var gs = initWeightedDirectedStaticGraph(n)
    for _ in 0..<rng.rand(0..40):
        let u = rng.rand(n - 1)
        let v = rng.rand(n - 1)
        let w = rng.rand(0..9)
        g.add_edge(u, v, w)
        gs.add_edge(u, v, w)
    gs.build()
    for s in 0..<n:
        for t in 0..<n:
            let k = rng.rand(0..20)
            let expected = naive(g, s, t, k)
            doAssert g.k_shortest_walk(s, t, k) == expected
            doAssert gs.k_shortest_walk(s, t, k) == expected

block:
    var g = initWeightedDirectedGraph(2, int64)
    g.add_edge(0, 1, 3_000_000_000'i64)
    g.add_edge(1, 1, 1'i64)
    doAssert g.k_shortest_walk(0, 1, 2) == @[3_000_000_000'i64, 3_000_000_001'i64]
    doAssert g.k_shortest_walk(1, 0, 2) == @[int64(INF64), int64(INF64)]
    var small = initWeightedDirectedStaticGraph(2, int32)
    small.add_edge(0, 1, 5'i32)
    small.build()
    doAssert small.k_shortest_walk(0, 1, 2) == @[5'i32, INF32]
    doAssert small.k_shortest_walk(0, 1, 2, INF = 100'i32) == @[5'i32, 100'i32]
    var unweighted = initUnWeightedUnDirectedGraph(2)
    unweighted.add_edge(0, 1)
    doAssert unweighted.k_shortest_walk(0, 1, 3) == @[1, 3, 5]

block:
    let n = 20_000
    var g = initWeightedDirectedGraph(n)
    for u in 0..<n:
        g.add_edge(u, u, 1)
        if u + 1 < n: g.add_edge(u, u + 1, 1)
    let lengths = g.k_shortest_walk(0, n - 1, n + 2)
    doAssert lengths.len == n + 2
    doAssert lengths[0] == n - 1
    for i in 1..n: doAssert lengths[i] == n
    doAssert lengths[^1] == n + 1

block:
    var g = initWeightedDirectedGraph(2)
    for w in countdown(100_000, 1): g.add_edge(0, 1, w)
    doAssert g.k_shortest_walk(0, 1, 100_001) == toSeq(1..100_000) & @[INF64]

echo "Hello World"
