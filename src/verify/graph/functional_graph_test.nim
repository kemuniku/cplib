# verification-helper: PROBLEM https://atcoder.jp/contests/abc357/tasks/abc357_e
import cplib/graph/graph
import sequtils
import cplib/graph/functional_graph
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var N = ii()
var A = newseqwith(N,ii()).mapit(it-1)
var G = initUnWeightedDirectedGraph(N)
for i in 0..<N:
    G.add_edge(i,A[i])
var f = G.initFunctionalGraph()
var ans = 0
for i in 0..<N:
    ans += f.cycle_size(i) + f.depth(i)
echo ans
