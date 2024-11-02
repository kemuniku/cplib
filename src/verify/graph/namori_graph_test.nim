# verification-helper: PROBLEM https://atcoder.jp/contests/abc266/tasks/abc266_f
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

import cplib/utils/constants
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
    var x,y = ii()-1
    var (_,a) = namori.dist(x,y)
    if a == INF64:
        echo "Yes"
    else:
        echo "No"
