# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import os, strutils
import cplib/graph/graph
import cplib/graph/graph_debug

var g = initWeightedDirectedGraph(3)
g.add_edge(0, 1, 5)
g.add_edge(1, 2, 7)
let url = g.to_graph_graph(true)
assert url.contains("indexed=true")
assert url.contains("weighted=true")
assert url.contains("directed=true")
assert url.contains("%0A1+2+5")

let path = "/tmp/cplib_graph_debug_ai_test.txt"
var f = open(path, fmWrite)
g.dump_graph(f)
f.close()
assert readFile(path).strip == "3 2\n0 1 5\n1 2 7"

var ug = initUnWeightedUnDirectedGraph(3)
ug.add_edge(0, 2)
assert ug.to_graph_graph(false).contains("weighted=false")
removeFile(path)
