# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import std/math
import cplib/graph/bellmanford
import cplib/graph/dijkstra
import cplib/graph/graph
import cplib/graph/kruskal
import cplib/graph/maxk_dijkstra
import cplib/graph/reverse_edge
import cplib/graph/steiner_tree
import cplib/graph/topologicalsort
import cplib/graph/tsp
import cplib/graph/warshall_floyd
import cplib/tree/diameter
import cplib/tree/heavylightdecomposition

template assertClose(a, b: float) =
  assert abs(a - b) < 1e-9

var g = initWeightedDirectedGraph(4, float)
g.add_edge(0, 1, 1.5)
g.add_edge(1, 2, 2.25)
g.add_edge(0, 2, 10.0)
g.add_edge(2, 3, 0.5)
assertClose(g.dijkstra(0)[3], 4.25)
assertClose(g.bellmanford(0)[3], 4.25)
assertClose(g.shortest_path_dijkstra(0, 3).cost, 4.25)
assertClose(g.shortest_path_bellmanford(0, 3).cost, 4.25)
assertClose(g.warshall_floyd().d[0][3], 4.25)

let rg = g.reverse_edge()
assertClose(rg.to_adjacency_matrix(1e100)[1][0], 1.5)

let contracted = g.toContractionGraph(@[0, 2, 3])
assertClose(contracted.to_adjacency_matrix(1e100)[0][1], 3.75)

var dag = initWeightedDirectedGraph(3, float)
dag.add_edge(0, 1, 1.0)
dag.add_edge(1, 2, 2.0)
let ord = dag.topologicalsort()
assert ord.len == 3
assert ord.find(0) < ord.find(1)
assert ord.find(1) < ord.find(2)

var ug = initWeightedUnDirectedGraph(4, float)
ug.add_edge(0, 1, 1.5)
ug.add_edge(1, 2, 2.0)
ug.add_edge(1, 3, 0.75)
ug.add_edge(0, 3, 10.0)
assertClose(ug.get_MST_cost(), 4.25)
let mst = ug.to_MST_Graph()
assertClose(mst.get_MST_cost(), 4.25)
assertClose(ug.steiner_tree_mincost(@[0, 2, 3]), 4.25)
assertClose(ug.steiner_tree_mincost(@[0, 2, 3], 0.0, 1e100), 4.25)

var tree = initWeightedUnDirectedGraph(4, float)
tree.add_edge(0, 1, 1.0)
tree.add_edge(1, 2, 4.0)
tree.add_edge(1, 3, 6.0)
assertClose(tree.diameter(), 10.0)

let hld = tree.initHld(0)
assert hld.dist(2, 3) == 2
let aux = hld.initAuxiliaryWeightedTree(@[2, 3], float)
var auxCost = 0.0
for (_, c) in aux[1]:
  auxCost += c
assertClose(auxCost, 2.0)

var sg = initWeightedUnDirectedStaticGraph(3, int32)
sg.add_edge(0, 1, 2.int32)
sg.add_edge(1, 2, 3.int32)
sg.add_edge(0, 2, 10.int32)
sg.build()
assert sg.get_MST_cost() == 5.int32
assert sg.to_MST_Graph().get_MST_cost() == 5.int32
assert sg.steiner_tree_mincost(@[0, 2], 0.int32, 100.int32) == 5.int32

var kg = initWeightedDirectedGraph(3, int32)
kg.add_edge(0, 1, 1.int32)
kg.add_edge(1, 2, 2.int32)
kg.add_edge(0, 2, 4.int32)
assert kg.maxk_dijkstra(0, 4.int32)[2] == 3.int32
assert kg.shortest_path_maxk_dijkstra(0, 2, 4.int32).cost == 3.int32

let dist = @[
  @[0.0, 1.5, 3.0],
  @[1.5, 0.0, 2.0],
  @[3.0, 2.0, 0.0]
]
assertClose(tspPathCostFrom(dist, 0), 3.5)
assertClose(tspPathCostFromTo(dist, 0, 2), 3.5)
assertClose(tspPathAnyStart(dist), 3.5)
