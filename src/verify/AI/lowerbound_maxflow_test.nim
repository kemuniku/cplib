# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/lowerbound_maxflow
import random

proc checkFlow[Cap](g: LowerBoundMaxFlow[Cap], n, src, dst: int, value: Cap) =
    var balance = newSeq[Cap](n)
    for i, e in g.get_edges():
        doAssert e == g.get_edge(i)
        doAssert e.lower <= e.flow and e.flow <= e.upper
        if e.src != e.dst:
            balance[e.src] -= e.flow
            balance[e.dst] += e.flow
    for v in 0..<n:
        doAssert balance[v] == (if v == src: -value elif v == dst: value else: Cap(0))

block:
    var g = initLowerBoundMaxFlow(3)
    doAssert g.add_edge(0, 1, 2, 5) == 0
    doAssert g.add_edge(1, 2, 3, 4) == 1
    doAssert g.add_edge(0, 2, 0, 2) == 2
    doAssert g.flow(0, 2) == 6
    g.checkFlow(3, 0, 2, 6)
    doAssert g.flow(0, 2) == 6
    g.add_edge(0, 2, 1, 3)
    doAssert g.flow(0, 2) == 9
    g.checkFlow(3, 0, 2, 9)
    doAssert g.flow(2, 0) == -1
    doAssert g.flow(0, 2) == 9
    g.checkFlow(3, 0, 2, 9)

block:
    var g = initLowerBoundMaxFlow[int32](3)
    g.add_edge(0, 1, 2, 2)
    doAssert g.flow(0, 2) == -1
    g.add_edge(1, 2, 0, 3)
    doAssert g.flow(0, 2) == 2
    g.checkFlow(3, 0, 2, 2'i32)

block:
    var g = initLowerBoundMaxFlow[int64](2)
    g.add_edge(0, 0, high(int64), high(int64))
    g.add_edge(0, 1, high(int64) - 1, high(int64))
    doAssert g.flow(0, 1) == high(int64)
    g.checkFlow(2, 0, 1, high(int64))

block:
    var g = initLowerBoundMaxFlow(4)
    g.add_edge(2, 3, 2, 3)
    doAssert g.flow(0, 1) == -1
    g.add_edge(3, 2, 1, 3)
    doAssert g.flow(0, 1) == 0
    g.checkFlow(4, 0, 1, 0)

block:
    var g = initLowerBoundMaxFlow(2)
    g.add_edge(1, 0, 2, 2)
    doAssert g.flow(0, 1) == -1
    g.add_edge(0, 1, 0, 2)
    doAssert g.flow(0, 1) == 0
    g.checkFlow(2, 0, 1, 0)

type Edge = tuple[src, dst, lower, upper: int]

proc bruteForce(n, src, dst: int, edges: seq[Edge]): int =
    var balance = newSeq[int](n)
    var best = -1
    proc dfs(i: int) =
        if i == edges.len:
            for v in 0..<n:
                if v != src and v != dst and balance[v] != 0:
                    return
            if balance[src] + balance[dst] == 0:
                best = max(best, balance[dst])
            return
        let e = edges[i]
        for amount in e.lower..e.upper:
            balance[e.src] -= amount
            balance[e.dst] += amount
            dfs(i + 1)
            balance[e.src] += amount
            balance[e.dst] -= amount
    dfs(0)
    best

var rng = initRand(20260914)
for trial in 0..<3000:
    let n = rng.rand(2..5)
    let src = rng.rand(0..<n)
    let dst = (src + rng.rand(1..<n)) mod n
    var edges: seq[Edge]
    var g = initLowerBoundMaxFlow(n)
    for i in 0..<rng.rand(0..7):
        let u = rng.rand(0..<n)
        let v = rng.rand(0..<n)
        let upper = rng.rand(0..3)
        let lower = rng.rand(0..upper)
        edges.add((u, v, lower, upper))
        doAssert g.add_edge(u, v, lower, upper) == i
    let expected = bruteForce(n, src, dst, edges)
    doAssert g.flow(src, dst) == expected
    if expected >= 0:
        g.checkFlow(n, src, dst, expected)
        for i, e in g.get_edges():
            doAssert (e.src, e.dst, e.lower, e.upper) == edges[i]
    doAssert g.flow(src, dst) == expected

echo "Hello World"
