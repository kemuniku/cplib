# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/5/GRL/all/GRL_5_A
import cplib/graph/graph
import cplib/tree/diameter
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var n = ii()
var g = initWeightedUnDirectedGraph(n)
for i in 0..<n-1:
    var a, b, c = ii()
    g.add_edge(a, b, c)
echo g.diameter