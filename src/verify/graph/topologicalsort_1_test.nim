# verification-helper: PROBLEM https://atcoder.jp/contests/abc216/tasks/abc216_d
import cplib/graph/graph
import cplib/graph/topologicalsort
import sequtils, sets
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
var N, M = ii()
var G = initUnWeightedDirectedGraph(N)
for i in 0..<M:
    var K = ii()
    var A = newseqwith(K, ii())
    if len(A.toHashSet) != K:
        echo "No"
        quit()
    for i in 0..<K-1:
        G.add_edge(A[i]-1, A[i+1]-1)
if G.isDAG():
    echo "Yes"
else:
    echo "No"
