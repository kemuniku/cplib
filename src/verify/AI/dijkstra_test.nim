# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/graph/dijkstra
import cplib/graph/graph

var g = initWeightedDirectedGraph(4)
g.add_edge(0, 1, 2)
g.add_edge(0, 2, 5)
g.add_edge(1, 2, 1)
g.add_edge(2, 3, 3)
assert g.dijkstra(0)[3] == 6
assert g.dijkstra(@[0, 1])[2] == 1
let restored = g.restore_dijkstra(0)
assert restored.costs[3] == 6
assert restored.prev[3] == 2
let sp = g.shortest_path_dijkstra(0, 3)
assert sp.cost == 6
assert sp.path == @[0, 1, 2, 3]
