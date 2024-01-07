# verification-helper: PROBLEM https://atcoder.jp/contests/abc296/tasks/abc296_e
import cplib/graph/graph
import cplib/graph/SCC
import sequtils, math
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
var N = ii()
var A = newseqwith(N, ii())
var G = initUnWeightedDirectedGraph(N)
var ans = 0
for i in 0..<N:
    G.add_edge(i, A[i]-1)
    if i == A[i]-1:
        ans += 1
var (_, _, group) = G.SCC()
echo group.mapit(len(it)).filterIt(it >= 2).sum()+ans
