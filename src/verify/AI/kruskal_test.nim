# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/graph/graph
import cplib/graph/kruskal
import cplib/utils/constants

var g = initWeightedUnDirectedGraph(4)
g.add_edge(0, 1, 1)
g.add_edge(1, 2, 2)
g.add_edge(2, 3, 3)
g.add_edge(0, 3, 10)
g.add_edge(0, 2, 5)
assert g.get_MST_cost == 6

let mst = g.to_MST_Graph
var edgeCount = 0
var costSum = 0
for i in 0..<mst.len:
  for (j, c) in mst[i]:
    if i < j:
      edgeCount += 1
      costSum += c
assert edgeCount == 3
assert costSum == 6

var disconnected = initWeightedUnDirectedGraph(3)
disconnected.add_edge(0, 1, 1)
assert disconnected.get_MST_cost == INF64
