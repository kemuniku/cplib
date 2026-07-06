# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import algorithm
import cplib/graph/functional_graph
import cplib/graph/graph

var g = initUnWeightedDirectedGraph(4)
g.add_edge(0, 1)
g.add_edge(1, 2)
g.add_edge(2, 1)
g.add_edge(3, 2)
let fg = initFunctionalGraph(g)
assert not fg.incycle(0)
assert fg.incycle(1)
assert fg.incycle(2)
assert fg.movekth(0, 0) == 0
assert fg.movekth(0, 1) == 1
assert fg.movekth(0, 2) == 2
assert fg.movekth(0, 3) == 1
assert fg.cyclesize(0) == 2
assert fg.canmove_size(0) == 3
assert fg.depth(0) == 1
assert fg.dist(0, 2) == 2
assert fg.dist(2, 1) == 1
assert fg.get_cycle(0).sorted == @[1, 2]
assert fg.root(0) == 1
