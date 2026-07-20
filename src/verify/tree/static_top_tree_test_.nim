# Randomized structural and update test for Static Top Tree.
import std/[random, sequtils]
import cplib/graph/graph
import cplib/tree/static_top_tree

randomize(20260713)
for n in 1..100:
    var g = initUnWeightedUnDirectedGraph(n)
    for v in 1..<n: g.add_edge(v, rand(v - 1))
    var value = newSeqWith(n, rand(1000))
    proc single(v: int): int = value[v]
    proc add(a, b: int): int = a + b
    var dp = initStaticTopTreeDP(g, single, add, add)
    doAssert dp.prodAll == value.foldl(a + b)
    for step in 0..<100:
        let v = rand(n - 1)
        value[v] = rand(1000)
        dp.set(v, value[v])
        doAssert dp.prodAll == value.foldl(a + b)
