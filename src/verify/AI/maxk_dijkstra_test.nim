# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/graph/graph
import cplib/graph/maxk_dijkstra

var g = initWeightedDirectedGraph(4)
g.add_edge(0, 1, 1)
g.add_edge(1, 2, 2)
g.add_edge(0, 2, 3)
g.add_edge(2, 3, 1)
assert g.maxk_dijkstra(0, 3)[3] == 4
let restored = g.restore_maxk_dijkstra(0, 3)
assert restored.costs[3] == 4
assert restored.prev[3] == 2
let sp = g.shortest_path_maxk_dijkstra(0, 3, 3)
assert sp.path == @[0, 2, 3]
assert sp.cost == 4
