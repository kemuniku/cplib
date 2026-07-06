# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/graph/graph
import cplib/tree/rerooting

var g = initUnWeightedUnDirectedGraph(4)
g.add_edge(0, 1)
g.add_edge(1, 2)
g.add_edge(1, 3)

proc merge(a, b: int): int = max(a, b)
proc putEdge(x: int, u, v: int): int = x + 1
proc putVertex(x: int, v: int): int = x

assert g.solve_Rerooting_raw(merge, 0, putEdge, putVertex) == @[2, 1, 2, 2]
assert g.solve_Rerooting(merge, 0, putEdge, putVertex) == @[2, 1, 2, 2]
