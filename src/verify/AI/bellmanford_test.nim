# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/graph/bellmanford
import cplib/graph/graph

var g = initWeightedDirectedGraph(4)
g.add_edge(0, 1, 2)
g.add_edge(1, 2, -5)
g.add_edge(0, 2, 10)
g.add_edge(2, 3, 1)
assert g.bellmanford(0)[3] == -2
let restored = g.restore_bellmanford(0)
assert restored.costs[2] == -3
assert restored.prev[3] == 2
let sp = g.shortest_path_bellmanford(0, 3)
assert sp.path == @[0, 1, 2, 3]
assert sp.cost == -2

var ng = initWeightedDirectedGraph(3)
ng.add_edge(0, 1, 1)
ng.add_edge(1, 2, -3)
ng.add_edge(2, 1, 1)
assert ng.bellmanford(0)[1] < -1_000_000_000
