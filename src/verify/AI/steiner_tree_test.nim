# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/graph/graph
import cplib/graph/steiner_tree
import cplib/utils/constants

var g = initWeightedUnDirectedGraph(4)
g.add_edge(0, 1, 1)
g.add_edge(1, 2, 2)
g.add_edge(1, 3, 3)
g.add_edge(0, 3, 10)
let dp = g.steiner_tree_dp(@[0, 2, 3], INF64)
assert dp[(1 shl 3) - 1][0] == 6
assert g.steiner_tree_mincost(@[0, 2, 3]) == 6
assert g.steiner_tree_mincost(@[0, 2, 3], INF64) == 6
assert g.steiner_tree_mincost(@[0, 2, 3], 0, INF64) == 6
