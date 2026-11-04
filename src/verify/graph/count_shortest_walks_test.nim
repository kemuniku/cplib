# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, algorithm
import cplib/graph/graph
import cplib/graph/count_shortest_walks
import cplib/modint/modint

type Arc = tuple[u, v, w: int]
type Oracle = tuple[distance: seq[int], status: seq[ShortestWalkStatus], count: seq[int64]]
const unreachable = 1000000
declarStaticBarrettModint(Mint2, 2u32)

proc oracle(n, source: int, arcs: seq[Arc]): Oracle =
    var best = newSeq[seq[int]](2 * n)
    var ways = newSeq[seq[int64]](2 * n)
    for k in 0..<2 * n:
        best[k] = newSeq[int](n)
        best[k].fill(unreachable)
        ways[k] = newSeq[int64](n)
    best[0][source] = 0
    ways[0][source] = 1
    for k in 1..<2 * n:
        for e in arcs:
            if best[k - 1][e.u] == unreachable: continue
            let d = best[k - 1][e.u] + e.w
            if d < best[k][e.v]:
                best[k][e.v] = d
                ways[k][e.v] = ways[k - 1][e.u]
            elif d == best[k][e.v]:
                ways[k][e.v] += ways[k - 1][e.u]
    result.distance = newSeq[int](n)
    result.status = newSeq[ShortestWalkStatus](n)
    result.count = newSeq[int64](n)
    for v in 0..<n:
        result.distance[v] = unreachable
        for k in 0..<n:
            result.distance[v] = min(result.distance[v], best[k][v])
        if result.distance[v] == unreachable: continue
        result.status[v] = shortestWalkFinite
        for k in n..<2 * n:
            if best[k][v] == result.distance[v]:
                result.status[v] = shortestWalkInfinite
        if result.status[v] == shortestWalkFinite:
            for k in 0..<n:
                if best[k][v] == result.distance[v]: result.count[v] += ways[k][v]

proc checkGraph[G](g: G, arcs: seq[Arc]) =
    for source in 0..<g.len:
        let expected = oracle(g.len, source, arcs)
        let actual = g.count_shortest_walks(source, 0i64, 1i64, unreachable)
        let modular = g.count_shortest_walks(source, Mint2.init(0), Mint2.init(1), unreachable)
        doAssert actual.distance == expected.distance
        doAssert actual.status == expected.status
        doAssert actual.count == expected.count
        doAssert modular.distance == expected.distance
        doAssert modular.status == expected.status
        for v in 0..<g.len: doAssert modular.count[v].val == int(expected.count[v] mod 2)

proc checkAll(n: int, edges: seq[Arc]) =
    var dg = initWeightedDirectedGraph(n)
    var ds = initWeightedDirectedStaticGraph(n)
    var ug = initWeightedUnDirectedGraph(n)
    var us = initWeightedUnDirectedStaticGraph(n)
    var nd = initUnWeightedDirectedGraph(n)
    var ns = initUnWeightedDirectedStaticGraph(n)
    var nu = initUnWeightedUnDirectedGraph(n)
    var nus = initUnWeightedUnDirectedStaticGraph(n)
    var undirected, unitDirected, unitUndirected: seq[Arc]
    for e in edges:
        dg.add_edge(e.u, e.v, e.w)
        ds.add_edge(e.u, e.v, e.w)
        ug.add_edge(e.u, e.v, e.w)
        us.add_edge(e.u, e.v, e.w)
        nd.add_edge(e.u, e.v)
        ns.add_edge(e.u, e.v)
        nu.add_edge(e.u, e.v)
        nus.add_edge(e.u, e.v)
        undirected.add(e)
        undirected.add((e.v, e.u, e.w))
        unitDirected.add((e.u, e.v, 1))
        unitUndirected.add((e.u, e.v, 1))
        unitUndirected.add((e.v, e.u, 1))
    ds.build()
    us.build()
    ns.build()
    nus.build()
    checkGraph(dg, edges)
    checkGraph(ds, edges)
    checkGraph(ug, undirected)
    checkGraph(us, undirected)
    checkGraph(nd, unitDirected)
    checkGraph(ns, unitDirected)
    checkGraph(nu, unitUndirected)
    checkGraph(nus, unitUndirected)

for mask in 0..<256:
    var bits = mask
    var arcs: seq[Arc]
    for u in 0..<2:
        for v in 0..<2:
            let digit = bits mod 4
            bits = bits div 4
            if digit != 0: arcs.add((u, v, digit - 1))
    checkAll(2, arcs)

var rng = initRand(471)
for trial in 0..<120:
    let n = rng.rand(1..6)
    var arcs: seq[Arc]
    for e in 0..<rng.rand(0..12):
        arcs.add((rng.rand(n - 1), rng.rand(n - 1), rng.rand(0..3)))
    checkAll(n, arcs)

checkAll(1, @[])
checkAll(1, @[(0, 0, 0), (0, 0, 0)])
checkAll(3, @[(0, 1, 0), (0, 1, 0), (1, 2, 0), (0, 2, 0)])
checkAll(5, @[(0, 1, 0), (1, 2, 0), (2, 1, 0), (2, 3, 2), (0, 4, 3)])
checkAll(5, @[(0, 1, 1), (1, 2, 0), (2, 1, 0), (0, 3, 1), (3, 4, 1), (2, 4, 1)])
checkAll(4, @[(0, 1, 1), (1, 0, 1), (1, 2, 1), (3, 3, 0)])
checkAll(4, @[(0, 1, 0), (1, 2, 0), (2, 3, 0), (3, 0, 1)])
checkAll(3, @[(0, 1, 1), (0, 2, 1), (1, 1, 0), (1, 2, 1)])

block:
    var g = initWeightedDirectedGraph(3)
    g.add_edge(2, 1, 0)
    g.add_edge(2, 1, 0)
    g.add_edge(1, 0, 0)
    let r = g.count_shortest_walks(2, Mint2.init(0), Mint2.init(1))
    doAssert r.status == @[shortestWalkFinite, shortestWalkFinite, shortestWalkFinite]
    doAssert r.count[0].val == 0 and r.count[1].val == 0 and r.count[2].val == 1

type CountBox = object
    value: int
proc `+=`(a: var CountBox, b: CountBox) = a.value += b.value
block:
    var g = initWeightedDirectedGraph(2)
    g.add_edge(0, 1, 0)
    g.add_edge(0, 1, 0)
    let r = g.count_shortest_walks(0, CountBox(value: 0), CountBox(value: 1))
    doAssert r.count[0].value == 1 and r.count[1].value == 2

echo "Hello World"
