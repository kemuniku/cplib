# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/graph/graph
import cplib/graph/topologicalsort

var dag = initUnWeightedDirectedGraph(4)
dag.add_edge(0, 1)
dag.add_edge(0, 2)
dag.add_edge(1, 3)
dag.add_edge(2, 3)
let ord = dag.topologicalsort
assert ord.len == 4
assert ord.find(0) < ord.find(1)
assert ord.find(0) < ord.find(2)
assert ord.find(1) < ord.find(3)
assert dag.isDAG

var cyc = initUnWeightedDirectedGraph(2)
cyc.add_edge(0, 1)
cyc.add_edge(1, 0)
assert not cyc.isDAG
