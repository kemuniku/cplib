# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/graph/graph
import cplib/graph/namori_graph
import cplib/utils/constants

var g = initUnWeightedUnDirectedGraph(4)
g.add_edge(0, 1)
g.add_edge(1, 2)
g.add_edge(2, 0)
g.add_edge(1, 3)
let ng = initNamoriGraph(g)
assert ng.incycle(0)
assert ng.incycle(1)
assert ng.incycle(2)
assert not ng.incycle(3)
assert ng.root(3) == 1
assert ng.same_tree(1, 3)
assert not ng.same_tree(0, 3)
assert ng.dist(0, 2) == (1, 2)
assert ng.dist(1, 3) == (1, INF64)
