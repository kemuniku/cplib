# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import sequtils
import cplib/graph/graph
import cplib/graph/reverse_edge

var wg = initWeightedDirectedGraph(3)
wg.add_edge(0, 1, 5)
wg.add_edge(2, 1, 7)
let rwg = wg.reverse_edge
assert toSeq(rwg[1]) == @[(0, 5), (2, 7)]

var ug = initUnWeightedDirectedGraph(3)
ug.add_edge(0, 2)
ug.add_edge(1, 2)
let rug = ug.reverse_edge
assert toSeq(rug[2]) == @[0, 1]

var swg = initWeightedDirectedStaticGraph(3)
swg.add_edge(0, 1, 11)
swg.add_edge(1, 2, 13)
swg.build()
let rswg = swg.reverse_edge
assert toSeq(rswg[1]) == @[(0, 11)]
assert toSeq(rswg[2]) == @[(1, 13)]

var sug = initUnWeightedDirectedStaticGraph(3)
sug.add_edge(0, 1)
sug.add_edge(2, 1)
sug.build()
let rsug = sug.reverse_edge
assert toSeq(rsug[1]) == @[0, 2]
