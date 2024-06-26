# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/5/GRL/all/GRL_1_B
import sequtils
import cplib/graph/graph
import cplib/graph/bellmanford
import cplib/utils/constants
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var v, e, r = ii()
var g = initWeightedDirectedGraph(v, int)
for i in 0..<e:
    var s, t, d = ii()
    g.add_edge(s, t, d)
var cost = bellmanford(g, r)
if cost.min == -INF64:
    echo "NEGATIVE CYCLE"
else:
    for i in 0..<v:
        if cost[i] == INF64: echo "INF"
        else: echo cost[i]
