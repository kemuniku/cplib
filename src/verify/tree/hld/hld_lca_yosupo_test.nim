# verification-helper: PROBLEM https://judge.yosupo.jp/problem/lca
import strutils
import cplib/graph/graph
import cplib/tree/heavylightdecomposition
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var n, q = ii()
var g = initUnWeightedUnDirectedStaticGraph(n)
for i in 0..<n-1:
    var p = ii()
    g.add_edge(i+1, p)
g.build

var hld = initHld(g, 0)
var ans = newSeq[int](q)
for i in 0..<q:
    var u, v = ii()
    ans[i] = hld.lca(u, v)
echo ans.join("\n")
