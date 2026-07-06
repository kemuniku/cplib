# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/graph/dag_minimum_path_cover
import cplib/graph/graph

var g = initUnWeightedDirectedGraph(4)
g.add_edge(0, 1)
g.add_edge(1, 2)
g.add_edge(0, 3)
assert dag_minimum_path_cover(g) == 2

var chain = initUnWeightedDirectedGraph(3)
chain.add_edge(0, 1)
chain.add_edge(1, 2)
assert dag_minimum_path_cover(chain) == 1
