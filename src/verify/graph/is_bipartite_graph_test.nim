# verification-helper: PROBLEMhttps://atcoder.jp/contests/abc327/tasks/abc327_d
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
import cplib/graph/bipartite_graph
import sequtils
import cplib/graph/graph

var N,M = ii()
var A = newseqwith(M,ii())
var B = newseqwith(M,ii())
var G = initUnWeightedUnDirectedGraph(N)
for i in 0..<(M):
    G.add_edge(A[i]-1,B[i]-1)
if G.is_bipartite_graph():
    echo "Yes"
else:
    echo "No"