# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import algorithm, sequtils
import cplib/graph/SCC
import cplib/graph/graph

var g = initUnWeightedDirectedGraph(4)
g.add_edge(0, 1)
g.add_edge(1, 0)
g.add_edge(1, 2)
g.add_edge(2, 3)
g.add_edge(3, 2)
let comps = g.SCC.mapIt(it.sorted)
assert comps == @[@[0, 1], @[2, 3]]
let (cg, toGroup, groups) = g.SCCG
assert groups.mapIt(it.sorted) == @[@[0, 1], @[2, 3]]
assert toGroup[0] == toGroup[1]
assert toGroup[2] == toGroup[3]
assert cg.len == 2
assert toSeq(cg[toGroup[1]]) == @[toGroup[2]]
