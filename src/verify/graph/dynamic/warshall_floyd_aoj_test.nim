# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/5/GRL/1/GRL_1_C
import sequtils, strutils
import cplib/graph/graph
import cplib/graph/warshall_floyd
import cplib/utils/infl
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var n, m = ii()
var g = initWeightedDirectedGraph(n, int)
for i in 0..<m:
    var u, v, c = ii()
    g.add_edge(u, v, c)
var (negative_cycle, d) = g.warshall_floyd
if negative_cycle:
    echo "NEGATIVE CYCLE"
    quit()
for i in 0..<n:
    var d = d[i].mapIt(if it == INFL: "INF" else: ($it)).join(" ")
    echo d
