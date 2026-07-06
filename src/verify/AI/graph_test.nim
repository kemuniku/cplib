# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import sequtils
import cplib/graph/graph

var wd = initWeightedDirectedGraph(3)
wd.add_edge(0, 1, 5)
wd.add_edge(1, 2, 7)
assert wd.len == 3
assert toSeq(wd[0]) == @[(1, 5)]
assert toSeq(wd.to_and_cost(1)) == @[(2, 7)]

var wu = initWeightedUnDirectedGraph(2)
wu.add_edge(0, 1, 9)
assert toSeq(wu[0]) == @[(1, 9)]
assert toSeq(wu[1]) == @[(0, 9)]

var ud = initUnWeightedDirectedGraph(2)
ud.add_edge(0, 1)
assert toSeq(ud[0]) == @[1]
assert toSeq(ud.to_and_cost(0)) == @[(1, 1)]

var uu = initUnWeightedUnDirectedGraph(2)
uu.add_edge(0, 1)
assert toSeq(uu[0]) == @[1]
assert toSeq(uu[1]) == @[0]

var swd = initWeightedDirectedStaticGraph(3)
swd.add_edge(0, 1, 2)
swd.add_edge(0, 2, 4)
swd.build()
assert toSeq(swd[0]) == @[(1, 2), (2, 4)]
assert toSeq(swd.to_and_cost(0)) == @[(1, 2), (2, 4)]

var suu = initUnWeightedUnDirectedStaticGraph(2)
suu.add_edge(0, 1)
suu.build()
assert toSeq(suu[0]) == @[1]
assert toSeq(suu[1]) == @[0]

var tg = initWeightedDirectedTableGraph(@["a", "b"], int)
tg.add_edge("a", "b", 3)
assert toSeq(tg["a"]) == @[("b", 3)]
var tug = initUnWeightedUnDirectedTableGraph(@["x", "y"])
tug.add_edge("x", "y")
assert toSeq(tug["x"]) == @["y"]
