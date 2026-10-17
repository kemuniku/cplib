# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/graph/graph
import cplib/graph/transitive_closure

proc oracle(g: UnWeightedDirectedGraph): seq[seq[bool]] =
    result = newSeq[seq[bool]](g.len)
    for v in 0..<g.len: result[v] = newSeq[bool](g.len)
    for e in g.edge_info: result[e.src][e.dst] = true
    for k in 0..<g.len:
        for i in 0..<g.len:
            for j in 0..<g.len:
                result[i][j] = result[i][j] or (result[i][k] and result[k][j])

proc checkResult(g: UnWeightedDirectedGraph, expected: seq[seq[bool]],
        reflexive: bool) =
    doAssert g.len == expected.len
    var count = 0
    for src in 0..<g.len:
        var found = newSeq[bool](g.len)
        for (dst, id) in g.to_and_id(src):
            doAssert dst >= 0 and dst < g.len
            doAssert not found[dst]
            found[dst] = true
            doAssert g.edge_info[id].src == src and g.edge_info[id].dst == dst
            inc count
        for dst in 0..<g.len:
            doAssert found[dst] == (expected[src][dst] or (reflexive and src == dst))
    doAssert count == g.edge_info.len

proc check(g: UnWeightedDirectedGraph) =
    let expected = oracle(g)
    let before = g.edge_info
    var s = initUnWeightedDirectedStaticGraph(g.len)
    for e in g.edge_info: s.add_edge(e.src, e.dst)
    s.build()
    for reflexive in [false, true]:
        let a = g.transitive_closure(reflexive)
        let b = s.transitive_closure(reflexive)
        a.checkResult(expected, reflexive)
        b.checkResult(expected, reflexive)
        doAssert a != g
    g.make_can_move_graph().checkResult(expected, false)
    s.make_can_move_graph().checkResult(expected, false)
    doAssert g.edge_info == before and s.edge_info == before

for n in 0..4:
    for mask in 0..<(1 shl (n * n)):
        var g = initUnWeightedDirectedGraph(n)
        for i in 0..<n:
            for j in 0..<n:
                if (mask and (1 shl (i * n + j))) != 0: g.add_edge(i, j)
        g.check()

var rng = initRand(438)
for trial in 0..<300:
    let n = rng.rand(0..30)
    var g = initUnWeightedDirectedGraph(n)
    for edge in 0..<rng.rand(0..(n * n * 2)):
        if n > 0: g.add_edge(rng.rand(n - 1), rng.rand(n - 1))
    g.check()

block:
    var g = initUnWeightedDirectedGraph(8)
    for (u, v) in [(0, 1), (0, 2), (1, 3), (2, 3), (3, 4), (4, 3),
            (4, 5), (6, 6), (0, 1), (3, 4), (6, 6)]:
        g.add_edge(u, v)
    g.check()
    var c = g.transitive_closure()
    c.add_edge(7, 0)
    doAssert g.edge_info.len == 11

block:
    let n = 1200
    var g = initUnWeightedDirectedGraph(n)
    for i in 1..<n: g.add_edge(i - 1, i)
    let c = g.transitive_closure()
    doAssert c.edge_info.len == n * (n - 1) div 2
    for src in 0..<n:
        var count = 0
        for dst in c[src]:
            doAssert dst > src
            inc count
        doAssert count == n - src - 1

block:
    let n = 700
    var g = initUnWeightedDirectedGraph(n)
    for i in 0..<n: g.add_edge(i, (i + 1) mod n)
    let c = g.transitive_closure()
    doAssert c.edge_info.len == n * n
    for src in 0..<n:
        var seen = newSeq[bool](n)
        for dst in c[src]:
            doAssert not seen[dst]
            seen[dst] = true
        for dst in 0..<n: doAssert seen[dst]

block:
    let n = 100000
    var g = initUnWeightedDirectedGraph(n)
    doAssert g.transitive_closure().edge_info.len == 0
    let c = g.transitive_closure(true)
    doAssert c.edge_info.len == n
    for i, e in c.edge_info: doAssert e.src == i and e.dst == i

echo "Hello World"
