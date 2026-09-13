# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, bitops, sets
import cplib/graph/graph
import cplib/graph/general_matching

type Edge = tuple[u, v: int]

proc brute(n: int, edges: seq[Edge]): int =
    var adj = newSeq[int](n)
    for (u, v) in edges:
        if u == v: continue
        adj[u] = adj[u] or (1 shl v)
        adj[v] = adj[v] or (1 shl u)
    var dp = newSeq[int](1 shl n)
    for mask in 1..<dp.len:
        let u = countTrailingZeroBits(mask)
        let rest = mask xor (1 shl u)
        dp[mask] = dp[rest]
        var candidates = adj[u] and rest
        while candidates != 0:
            let v = countTrailingZeroBits(candidates)
            candidates = candidates and (candidates - 1)
            dp[mask] = max(dp[mask], 1 + dp[rest xor (1 shl v)])
    dp[^1]

proc validate(n: int, edges, answer: seq[Edge], want: int) =
    var edgeSet = initHashSet[Edge]()
    for (u, v) in edges: edgeSet.incl((min(u, v), max(u, v)))
    var used = newSeq[bool](n)
    for (u, v) in answer:
        doAssert u in 0..<n and v in 0..<n and u != v
        doAssert not used[u] and not used[v]
        doAssert (min(u, v), max(u, v)) in edgeSet
        used[u] = true
        used[v] = true
    doAssert answer.len == want, $n & " " & $edges & " got " & $answer & " want " & $want

proc check(n: int, edges: seq[Edge], expected = -1) =
    let want = if expected < 0: brute(n, edges) else: expected
    var g = initUnWeightedUnDirectedGraph(n)
    var sg = initUnWeightedUnDirectedStaticGraph(n)
    var wg = initWeightedUnDirectedGraph(n, int64)
    var wsg = initWeightedUnDirectedStaticGraph(n, float)
    for i, e in edges:
        let (u, v) = e
        g.add_edge(u, v)
        sg.add_edge(u, v)
        wg.add_edge(u, v, int64(i mod 7 - 3))
        wsg.add_edge(u, v, float(i mod 5 - 2))
    sg.build()
    wsg.build()
    let before = g.edges
    let answer = g.maximum_matching()
    validate(n, edges, answer, want)
    doAssert g.maximum_matching() == answer
    doAssert g.edges == before
    validate(n, edges, sg.maximum_matching(), want)
    validate(n, edges, wg.maximum_matching(), want)
    validate(n, edges, wsg.maximum_matching(), want)

static:
    doAssert not compiles(initUnWeightedDirectedGraph(2).maximum_matching())
    doAssert not compiles(initWeightedDirectedGraph(2).maximum_matching())
    doAssert not compiles(initUnWeightedDirectedStaticGraph(2).maximum_matching())
    doAssert not compiles(initWeightedDirectedStaticGraph(2).maximum_matching())

check(0, @[])
check(1, @[(0, 0)])
check(8, @[])
for n in 1..6:
    var all: seq[Edge]
    for u in 0..<n:
        for v in u+1..<n: all.add((u, v))
    for mask in 0..<(1 shl all.len):
        var edges: seq[Edge]
        for i, e in all:
            if (mask and (1 shl i)) != 0: edges.add(e)
        check(n, edges)

var rng = initRand(712367)
for trial in 0..<3000:
    let n = rng.rand(2..16)
    var edges: seq[Edge]
    let density = rng.rand(5..95)
    for u in 0..<n:
        for v in u..<n:
            if rng.rand(99) < density:
                edges.add((u, v))
                if rng.rand(9) == 0: edges.add((v, u))
    rng.shuffle(edges)
    check(n, edges)

block:
    var g = initUnWeightedUnDirectedGraph(4)
    g.add_edge(1, 2)
    doAssert g.maximum_matching().len == 1
    g.add_edge(0, 1)
    g.add_edge(2, 3)
    doAssert g.maximum_matching().len == 2

for n in [100, 1000, 10000]:
    var path, cycle, star, triangles: seq[Edge]
    for v in 1..<n:
        path.add((v - 1, v))
        star.add((0, v))
    cycle = path & @[(n - 1, 0)]
    for i in 0..<n div 3:
        let v = i * 3
        triangles.add((v, v + 1))
        triangles.add((v + 1, v + 2))
        triangles.add((v + 2, v))
        if i > 0: triangles.add((v - 1, v))
    check(n, path, n div 2)
    check(n, cycle, n div 2)
    check(n, star, 1)
    check(n, triangles, (n div 3 * 3) div 2)

block:
    let n = 100000
    var edges: seq[Edge]
    for v in countup(1, n - 3, 2): edges.add((v, v + 1))
    for v in countup(0, n - 2, 2): edges.add((v, v + 1))
    check(n, edges, n div 2)

block:
    var n = 0
    var edges, remaining: seq[Edge]
    for k in 1..50:
        for v in countup(1, 2*k - 3, 2): edges.add((n + v, n + v + 1))
        for v in countup(0, 2*k - 2, 2): remaining.add((n + v, n + v + 1))
        n += 2*k
    check(n, edges & remaining, n div 2)
check(100000, @[(99998, 99999), (2, 2)], 1)
echo "Hello World"
