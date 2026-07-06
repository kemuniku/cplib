# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/graph/bipartite_graph
import cplib/graph/graph

var g = initUnWeightedUnDirectedGraph(4)
g.add_edge(0, 1)
g.add_edge(1, 2)
g.add_edge(2, 3)
assert g.is_bipartite_graph
g.add_edge(3, 1)
assert not g.is_bipartite_graph
