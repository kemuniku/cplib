# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, bitops, tables
import cplib/graph/graph
import cplib/graph/general_weighted_matching
import cplib/graph/general_weighted_matching_sparse
import cplib/graph/general_matching

type Edge = tuple[u, v: int, w: int64]

proc brute(n: int, edges: seq[Edge]): int64 =
    var weights = newSeq[seq[int64]](n)
    for row in weights.mitems: row = newSeq[int64](n)
    for (u, v, w) in edges:
        if u == v: continue
        weights[u][v] = max(weights[u][v], w)
        weights[v][u] = max(weights[v][u], w)
    var dp = newSeq[int64](1 shl n)
    for mask in 1..<dp.len:
        let u = countTrailingZeroBits(mask)
        let rest = mask xor (1 shl u)
        dp[mask] = dp[rest]
        var candidates = rest
        while candidates != 0:
            let v = countTrailingZeroBits(candidates)
            candidates = candidates and (candidates - 1)
            dp[mask] = max(dp[mask], weights[u][v] + dp[rest xor (1 shl v)])
    dp[^1]

proc validate(n: int, edges: seq[Edge], answer: tuple[weight: int64, matching: seq[tuple[u, v: int]]], want: int64) =
    var weights = initTable[(int, int), int64]()
    for (u, v, w) in edges:
        let key = (min(u, v), max(u, v))
        weights[key] = max(weights.getOrDefault(key), w)
    var used = newSeq[bool](n)
    var total = 0'i64
    for (u, v) in answer.matching:
        doAssert u in 0..<n and v in 0..<n and u < v
        doAssert not used[u] and not used[v]
        doAssert (u, v) in weights and weights[(u, v)] > 0
        used[u] = true
        used[v] = true
        total += weights[(u, v)]
    doAssert total == answer.weight
    doAssert answer.weight == want, $n & " " & $edges & " got " & $answer & " want " & $want

proc check(n: int, edges: seq[Edge], expected = -1'i64) =
    let want = if expected < 0: brute(n, edges) else: expected
    var g = initWeightedUnDirectedGraph(n, int64)
    var sg = initWeightedUnDirectedStaticGraph(n, int64)
    for (u, v, w) in edges:
        g.add_edge(u, v, w)
        sg.add_edge(u, v, w)
    sg.build()
    let before = g.edges
    let infoBefore = g.edge_info
    let staticBefore = sg.elist
    let answer = g.maximum_weight_matching_sparse()
    validate(n, edges, answer, want)
    validate(n, edges, g.maximum_weight_matching(), want)
    validate(n, edges, sg.maximum_weight_matching_sparse(), want)
    doAssert g.maximum_weight_matching_sparse() == answer
    doAssert g.edges == before and g.edge_info == infoBefore
    doAssert sg.elist == staticBefore and sg.edge_info == infoBefore

static:
    doAssert not compiles(initWeightedDirectedGraph(2).maximum_weight_matching_sparse())
    doAssert not compiles(initWeightedDirectedStaticGraph(2).maximum_weight_matching_sparse())
    doAssert not compiles(initUnWeightedUnDirectedGraph(2).maximum_weight_matching_sparse())
    doAssert not compiles(initWeightedUnDirectedGraph(2, float).maximum_weight_matching_sparse())
    doAssert not compiles(initWeightedUnDirectedGraph(2, uint64).maximum_weight_matching_sparse())

check(0, @[])
check(1, @[(0, 0, high(int64))])
check(9, @[])
check(3, @[(0, 1, low(int64)), (1, 2, 0'i64), (0, 0, 7'i64)])
check(4, @[(0, 1, 10'i64), (1, 2, 25'i64), (2, 3, 10'i64)], 25)
check(4, @[(0, 1, 10'i64), (1, 2, 19'i64), (2, 3, 10'i64)], 20)
check(4, @[(0, 1, 5'i64), (1, 0, 20'i64), (0, 1, 7'i64), (2, 3, 11'i64)], 31)
check(6, @[(0, 1, 8'i64), (1, 2, 8'i64), (2, 0, 8'i64),
    (0, 3, 7'i64), (1, 4, 7'i64), (2, 5, 7'i64)], 21)
check(10, @[(0, 1, 20'i64), (1, 2, 20'i64), (2, 0, 20'i64),
    (2, 3, 19'i64), (3, 4, 19'i64), (4, 0, 19'i64),
    (0, 5, 18'i64), (1, 6, 18'i64), (2, 7, 18'i64),
    (3, 8, 18'i64), (4, 9, 18'i64)])
block:
    let w = high(int64) div 4 div 6
    check(6, @[(0, 1, w), (1, 2, w - 1), (2, 0, w - 2),
        (0, 3, w - 3), (1, 4, w - 4), (2, 5, w - 5)])

for mask in 0..<4096:
    var code = mask
    var edges: seq[Edge]
    for u in 0..<4:
        for v in u + 1..<4:
            let digit = code mod 4
            code = code div 4
            if digit > 0: edges.add((u, v, [-2'i64, 1, 4][digit - 1]))
    check(4, edges)

var rng = initRand(981723)
for trial in 0..<2500:
    let n = rng.rand(2..14)
    let density = rng.rand(5..100)
    let scale = if trial mod 4 == 0: 100000000003'i64 else: 1'i64
    var edges: seq[Edge]
    for u in 0..<n:
        for v in u..<n:
            if rng.rand(99) < density:
                edges.add((u, v, int64(rng.rand(-10..30)) * scale))
                if rng.rand(9) == 0:
                    edges.add((v, u, int64(rng.rand(-10..30)) * scale))
    rng.shuffle(edges)
    check(n, edges)

for n in [30, 70, 120]:
    var g = initWeightedUnDirectedGraph(n)
    var edges: seq[Edge]
    for u in 0..<n:
        for v in u + 1..<n:
            if rng.rand(99) < 15:
                g.add_edge(u, v, 17)
                edges.add((u, v, 17'i64))
    validate(n, edges, g.maximum_weight_matching_sparse(), 17'i64 * int64(g.maximum_matching().len))

block:
    var g = initWeightedUnDirectedGraph(4, int32)
    g.add_edge(1, 2, 2000000000'i32)
    doAssert g.maximum_weight_matching_sparse().weight == 2000000000'i64
    g.add_edge(0, 1, 1500000000'i32)
    g.add_edge(2, 3, 1500000000'i32)
    doAssert g.maximum_weight_matching_sparse().weight == 3000000000'i64
block:
    var g = initWeightedUnDirectedStaticGraph(3, int16)
    g.add_edge(0, 1, 13'i16)
    g.add_edge(1, 2, 17'i16)
    g.build()
    doAssert g.maximum_weight_matching_sparse().weight == 17
    g.add_edge(2, 0, 21'i16)
    g.build()
    doAssert g.maximum_weight_matching_sparse().weight == 21
block:
    var g = initWeightedUnDirectedGraph(2, int8)
    g.add_edge(1, 0, 127'i8)
    doAssert g.maximum_weight_matching_sparse() == (127'i64, @[(0, 1)])

check(100000, @[(99999, 99998, 27'i64), (4, 5, -1'i64), (0, 0, 100'i64)], 27)
for trial in 0..<150:
    let n = rng.rand(20..100)
    var g = initWeightedUnDirectedGraph(n, int64)
    var edges: seq[Edge]
    for u in 0..<n:
        for v in u + 1..<n:
            if rng.rand(99) < 25:
                let w = if trial mod 3 == 0: int64(rng.rand(999990..1000000)) else: int64(rng.rand(1..1000000))
                g.add_edge(u, v, w)
                edges.add((u, v, w))
    validate(n, edges, g.maximum_weight_matching_sparse(), g.maximum_weight_matching().weight)

for n in [1000, 10000]:
    var g = initWeightedUnDirectedGraph(n)
    for v in 1..<n: g.add_edge(v - 1, v, 23)
    doAssert g.maximum_weight_matching_sparse().weight == int64(n div 2) * 23

block:
    var g = initWeightedUnDirectedGraph(3)
    for w in 1..10000:
        g.add_edge(0, 1, w)
        g.add_edge(1, 2, w + 1)
        g.add_edge(2, 0, w + 2)
    doAssert g.maximum_weight_matching_sparse().weight == 10002

block:
    let count = 2100
    var g = initWeightedUnDirectedGraph(2 * count + 1)
    for i in 0..<count:
        let a = 2 * i + 1
        let b = a + 1
        g.add_edge(0, a, 1)
        g.add_edge(a, b, 1)
        g.add_edge(b, 0, 1)
    doAssert g.maximum_weight_matching_sparse().weight == int64(count)

echo "Hello World"
