# verification-helper: PROBLEM https://judge.yosupo.jp/problem/jump_on_tree
import strutils
import cplib/graph/graph
import cplib/tree/heavylightdecomposition
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var n, q = ii()
var g = initUnWeightedUnDirectedStaticGraph(n)
for i in 0..<n-1:
    var a, b = ii()
    g.add_edge(a, b)
g.build

var hld = initHld(g, 0)
var ans = newSeq[int](q)
for i in 0..<q:
    var s, t, k = ii()
    ans[i] = hld.la(s, t, k)
echo ans.join("\n")
