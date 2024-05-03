# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/5/GRL/all/GRL_1_B
import sequtils
import cplib/graph/graph
import cplib/graph/bellmanford
import cplib/utils/infl
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var v, e, r = ii()
var g = initWeightedDirectedStaticGraph(v, int)
for i in 0..<e:
    var s, t, d = ii()
    g.add_edge(s, t, d)
g.build
var cost = bellmanford(g, r)
if cost.min == -INFL:
    echo "NEGATIVE CYCLE"
else:
    for i in 0..<v:
        if cost[i] == INFL: echo "INF"
        else: echo cost[i]
