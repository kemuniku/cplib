# verification-helper: PROBLEM https://judge.yosupo.jp/problem/vertex_add_subtree_sum
import sequtils, strutils, algorithm, sugar
import cplib/graph/graph
import cplib/collections/segtree
import cplib/tree/heavylightdecomposition
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var n, q = ii()
var a = newSeqWith(n, ii())
var g = initUnWeightedUnDirectedStaticGraph(n)
for i in 0..<n-1:
    var p = ii()
    g.add_edge(i+1, p)
g.build

var hld = initHld(g, 0)
var v = (0..<n).toSeq.mapIt(hld.toVtx(it)).mapIt(a[it])

var seg = newSegWith(v, l+r, 0)
var ans = newSeqOfCap[int](q)

for i in 0..<q:
    var t = ii()
    if t == 0:
        var u, x = ii()
        seg[hld.toSeq(u)] = seg[hld.toSeq(u)] + x
    else:
        var u = ii()
        var (l, r) = hld.subtree(u)
        var a = seg.get(l..<r)
        ans.add(a)
echo ans.join("\n")
