# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/graph/graph
import cplib/tree/diameter

var g = initWeightedUnDirectedGraph(4, int)
g.add_edge(0, 1, 2)
g.add_edge(1, 2, 3)
g.add_edge(1, 3, 4)

let (dist, u, v) = g.diameter_and_edge()
assert dist == 7
assert {u, v} == {2, 3}
assert g.diameter() == 7

let (pathDist, path) = g.diameter_path()
assert pathDist == 7
assert path.len == 3
assert {path[0], path[^1]} == {2, 3}
assert path[1] == 1

var ug = initUnWeightedUnDirectedGraph(5)
ug.add_edge(0, 1)
ug.add_edge(1, 2)
ug.add_edge(2, 3)
ug.add_edge(1, 4)
assert ug.diameter() == 3
