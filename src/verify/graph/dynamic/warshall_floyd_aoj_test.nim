# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/5/GRL/1/GRL_1_C
import sequtils, strutils
import cplib/graph/graph
import cplib/graph/warshall_floyd
import cplib/utils/constants
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var n, m = ii()
var g = initWeightedDirectedGraph(n, int)
for i in 0..<m:
    var u, v, c = ii()
    g.add_edge(u, v, c)
let d = g.warshall_floyd
if (0..<n).anyIt(d[it][it] == -INF64):
    echo "NEGATIVE CYCLE"
    quit()
for i in 0..<n:
    var d = d[i].mapIt(if it == INF64: "INF" else: ($it)).join(" ")
    echo d
