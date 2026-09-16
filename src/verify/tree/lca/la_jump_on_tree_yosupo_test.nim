# verification-helper: PROBLEM https://judge.yosupo.jp/problem/jump_on_tree
import strutils
import cplib/graph/graph
import cplib/tree/lca

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld", addr result)

let n = ii()
let q = ii()
var g = initUnWeightedUnDirectedStaticGraph(n)
for i in 1..<n:
    g.add_edge(ii(), ii())
g.build()
let tree = initLCA(g, 0)
var ans = newSeq[int](q)
for i in 0..<q:
    let u = ii()
    let v = ii()
    let d = ii()
    ans[i] = tree.la(u, v, d)
echo ans.join("\n")
