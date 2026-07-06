# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/graph/graph
import cplib/graph/tsp
import cplib/utils/constants

let dist = @[
  @[0, 1, 4],
  @[1, 0, 2],
  @[4, 2, 0],
]
assert tspPathAnyStart(dist, false) == 3
assert tspPathCostFrom(dist, 0, false) == 3
assert tspPathCostFromTo(dist, 0, 0, false) == 7
assert tspPathCostFromTo(dist, 0, 0, true) == 6

var g = initWeightedUnDirectedGraph(3)
g.add_edge(0, 1, 2)
g.add_edge(1, 2, 3)
g.add_edge(0, 2, 10)
let cg = g.toContractionGraph(@[0, 2])
assert cg.to_adjacency_matrix()[0][1] == 5

var dg = initWeightedDirectedGraph(3)
dg.add_edge(0, 1, 10)
dg.add_edge(0, 1, 4)
dg.add_edge(1, 2, 8)
let mat = dg.to_adjacency_matrix()
assert mat[0][1] == 4
assert mat[0][2] == INF64
