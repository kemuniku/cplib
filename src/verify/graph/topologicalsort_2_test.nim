# verification-helper: PROBLEM https://atcoder.jp/contests/abc245/tasks/abc245_f
import cplib/graph/graph
import cplib/graph/topologicalsort
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
var N, M = ii()
var G = initUnWeightedDirectedGraph(N)
for i in 0..<M:
    var U, V = ii()-1
    G.add_edge(V, U)
echo N-len(G.topologicalsort())
