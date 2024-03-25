# verification-helper: PROBLEM https://judge.yosupo.jp/problem/vertex_add_path_sum
import sequtils, strutils, sugar
import cplib/graph/graph
import cplib/collections/segtree
import cplib/tree/heavylightdecomposition
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var n, q = ii()
var a = newSeqWith(n, ii())
var g = initUnWeightedUnDirectedStaticGraph(n)
for i in 0..<n-1:
    var u, v = ii()
    g.add_edge(u, v)
g.build

var hld = initHld(g, 0)
var v = (0..<n).toSeq.mapIt(hld.toVtx(it)).mapIt(a[it])

var seg = newSegWith(v, l+r, 0)
var ans = newSeqOfCap[int](q)

for i in 0..<q:
    var t = ii()
    if t == 0:
        var p, x = ii()
        seg[hld.toSeq(p)] = seg[hld.toSeq(p)] + x
    else:
        var u, v = ii()
        var l = hld.lca(u, v)
        var a = 0
        for (l, r) in hld.path(l, u, true, false): a += seg.get(l..<r)
        for (l, r) in hld.path(l, v, false, false): a += seg.get(l..<r)
        ans.add(a)
echo ans.join("\n")
