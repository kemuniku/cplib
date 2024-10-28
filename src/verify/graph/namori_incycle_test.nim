# verification-helper: PROBLEM https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=2891
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

import cplib/graph/graph
import cplib/graph/namori_graph

var N = ii()
var G = initUnWeightedUnDirectedGraph(N)
for i in 0..<N:
    var u,v = ii()-1
    G.add_edge(u,v)
var namori = G.initNamoriGraph()
var Q = ii()
for i in 0..<Q:
    var a,b = ii()-1
    if namori.incycle(a) and namori.incycle(b):
        echo 2
    else:
        echo 1
