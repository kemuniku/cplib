# verification-helper: PROBLEM https://atcoder.jp/contests/abc061/tasks/abc061_d
import sequtils
import cplib/graph/graph
import cplib/graph/bellmanford
import cplib/utils/infl
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var n, m = ii()
var g = initWeightedDirectedGraph(n, int)
for i in 0..<m:
    var a, b = ii() - 1
    var c = ii()
    g.add_edge(a, b, -c)
var (costs, _) = restore_bellmanford(g, 0)
if costs[^1] == -INFL: echo "inf"
else: echo -costs[^1]
