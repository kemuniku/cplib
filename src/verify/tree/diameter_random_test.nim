# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sequtils
import cplib/graph/graph
import cplib/tree/diameter

proc checkSmall(g: UnDirectedGraph) =
    when g is WeightedGraph:
        type Cost = g.T
    else:
        type Cost = int
    let n = g.len
    var dist = newSeqWith(n, newSeqWith(n, Cost(1000000)))
    for x in 0..<n:
        dist[x][x] = Cost(0)
        for (y, cost) in g.to_and_cost(x):
            dist[x][y] = cost
    for k in 0..<n:
        for x in 0..<n:
            for y in 0..<n:
                dist[x][y] = min(dist[x][y], dist[x][k] + dist[k][y])
    var expected = Cost(0)
    for row in dist:
        for d in row: expected = max(expected, d)
    let (d, u, v) = g.diameter_and_edge()
    doAssert d is Cost
    doAssert d == expected
    doAssert u in 0..<n and v in 0..<n
    doAssert dist[u][v] == expected
    doAssert g.diameter() == expected
    let (pathDist, path) = g.diameter_path()
    doAssert pathDist is Cost
    doAssert pathDist == expected
    doAssert path.len > 0
    doAssert path[0] == u and path[^1] == v
    var seen = newSeq[bool](n)
    var total = Cost(0)
    for i, x in path:
        doAssert x in 0..<n
        doAssert not seen[x]
        seen[x] = true
        if i == 0: continue
        var found = false
        for (y, cost) in g.to_and_cost(x):
            if y == path[i - 1]:
                total += cost
                found = true
                break
        doAssert found
    doAssert total == expected

proc checkVariants(n: int, edges: seq[tuple[u, v, cost: int]]) =
    var wd = initWeightedUnDirectedGraph(n, int64)
    var ws = initWeightedUnDirectedStaticGraph(n, int32)
    var fd = initWeightedUnDirectedGraph(n, float)
    var fs = initWeightedUnDirectedStaticGraph(n, float)
    var ud = initUnWeightedUnDirectedGraph(n)
    var us = initUnWeightedUnDirectedStaticGraph(n)
    for (u, v, cost) in edges:
        wd.add_edge(u, v, cost.int64)
        ws.add_edge(u, v, cost.int32)
        fd.add_edge(u, v, cost.float / 4)
        fs.add_edge(u, v, cost.float / 4)
        ud.add_edge(u, v)
        us.add_edge(u, v)
    ws.build()
    fs.build()
    us.build()
    checkSmall(wd)
    checkSmall(ws)
    checkSmall(fd)
    checkSmall(fs)
    checkSmall(ud)
    checkSmall(us)

checkVariants(1, @[])
checkVariants(2, @[(0, 1, 0)])
checkVariants(2, @[(1, 0, 7)])
checkVariants(6, @[(0, 1, 0), (1, 2, 3), (1, 3, 3), (3, 4, 0), (3, 5, 0)])
checkVariants(7, @[(0, 1, 1), (1, 2, 1), (2, 3, 1), (3, 4, 10), (3, 5, 10), (3, 6, 0)])
for shape in 0..2:
    var edges: seq[tuple[u, v, cost: int]]
    for x in 1..<30:
        let p = if shape == 0: 0 elif shape == 1: x - 1 else: (x - 1) div 2
        edges.add((p, x, 0))
    checkVariants(30, edges)
    for e in edges.mitems: e.cost = 1
    checkVariants(30, edges)

var rng = initRand(20260930)
for trial in 0..<120:
    let n = rng.rand(1..30)
    var labels = toSeq(0..<n)
    rng.shuffle(labels)
    var edges: seq[tuple[u, v, cost: int]]
    for x in 1..<n:
        var u = labels[rng.rand(x - 1)]
        var v = labels[x]
        if rng.rand(1) == 0: swap(u, v)
        edges.add((u, v, rng.rand(20)))
    rng.shuffle(edges)
    checkVariants(n, edges)

proc checkChain(g: UnDirectedGraph, expected: auto) =
    doAssert g.diameter() == expected
    let (d, u, v) = g.diameter_and_edge()
    doAssert d == expected
    doAssert (u == 0 and v == g.len - 1) or (v == 0 and u == g.len - 1)
    let (pathDist, path) = g.diameter_path()
    doAssert pathDist == expected
    doAssert path.len == g.len
    doAssert path[0] == u and path[^1] == v
    for i, x in path:
        doAssert x == (if u == 0: i else: g.len - 1 - i)

block:
    const n = 200000
    const weight = 1000000000000'i64
    var g = initWeightedUnDirectedStaticGraph(n, int64, n - 1)
    for x in 1..<n: g.add_edge(x - 1, x, weight)
    g.build()
    checkChain(g, (n - 1).int64 * weight)

block:
    const n = 200000
    var g = initUnWeightedUnDirectedGraph(n, n - 1)
    for x in 1..<n: g.add_edge(x - 1, x)
    checkChain(g, n - 1)

echo "Hello World"
