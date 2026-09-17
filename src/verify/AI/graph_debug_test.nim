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

proc checkDump(g: DirectedGraph or UnDirectedGraph, expected: string) =
    var f = open(path, fmWrite)
    g.dump_graph(1, f)
    f.close()
    assert readFile(path).strip == expected
    f = open(path, fmWrite)
    g.dump_graph(indexed = 1, output = f)
    f.close()
    assert readFile(path).strip == expected
    f = open(path, fmWrite)
    g.dump_graph(output = f)
    f.close()
    removeFile(path)

checkDump(g, "3 2\n1 2 5\n2 3 7")
checkDump(ug, "3 1\n1 3")
var ud = initUnWeightedDirectedGraph(3)
var wu = initWeightedUnDirectedGraph(3)
var uds = initUnWeightedDirectedStaticGraph(3)
var uus = initUnWeightedUnDirectedStaticGraph(3)
var wds = initWeightedDirectedStaticGraph(3)
var wus = initWeightedUnDirectedStaticGraph(3)
ud.add_edge(2, 0)
wu.add_edge(2, 0, 8)
uds.add_edge(2, 0)
uus.add_edge(2, 0)
wds.add_edge(2, 0, 8)
wus.add_edge(2, 0, 8)
uds.build()
uus.build()
wds.build()
wus.build()
checkDump(ud, "3 1\n3 1")
checkDump(wu, "3 1\n1 3 8")
checkDump(uds, "3 1\n3 1")
checkDump(uus, "3 1\n1 3")
checkDump(wds, "3 1\n3 1 8")
checkDump(wus, "3 1\n1 3 8")
f = open(path, fmWrite)
g.dump_graph(10, f)
f.close()
assert readFile(path).strip == "3 2\n10 11 5\n11 12 7"
removeFile(path)
