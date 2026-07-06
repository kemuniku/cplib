# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/graph/graph
import cplib/graph/namori_forest
import cplib/utils/constants

var g = initUnWeightedUnDirectedGraph(6)
g.add_edge(0, 1)
g.add_edge(1, 2)
g.add_edge(2, 0)
g.add_edge(1, 3)
g.add_edge(4, 5)
let nf = initNamoriForest(g)
assert nf.incycle(0)
assert nf.incycle(1)
assert nf.incycle(2)
assert not nf.incycle(3)
assert nf.root(3) == 1
assert nf.same_tree(1, 3)
assert nf.same_component(0, 3)
assert not nf.same_component(0, 4)
assert nf.component(4) == nf.component(5)
assert nf.dist(0, 2) == (1, 2)
assert nf.dist(1, 3) == (1, INF64)
assert nf.dist(0, 4) == (INF64, INF64)
assert nf.dist(4, 5) == (1, INF64)
