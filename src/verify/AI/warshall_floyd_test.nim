# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/graph/graph
import cplib/graph/warshall_floyd

var g = initWeightedDirectedGraph(3)
g.add_edge(0, 1, 2)
g.add_edge(1, 2, 3)
g.add_edge(0, 2, 10)
let wf = g.warshall_floyd()
assert not wf.negative_cycle
assert wf.d[0][2] == 5

var ng = initWeightedDirectedGraph(2)
ng.add_edge(0, 1, -2)
ng.add_edge(1, 0, -2)
assert ng.warshall_floyd().negative_cycle
