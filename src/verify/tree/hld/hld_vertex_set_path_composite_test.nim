# verification-helper: PROBLEM https://judge.yosupo.jp/problem/vertex_set_path_composite
import sequtils, strutils, algorithm
import cplib/graph/graph
import cplib/collections/segtree
import cplib/tree/heavylightdecomposition
include atcoder/modint
type mint = modint998244353
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var n, q = ii()
var a = newSeqWith(n, (mint(ii()), mint(ii())))
var g = initUnWeightedUnDirectedStaticGraph(n)
for i in 0..<n-1:
    var u, v = ii()
    g.add_edge(u, v)
g.build

var hld = initHld(g, 0)
var v = (0..<n).toSeq.mapIt(hld.toVtx(it)).mapIt(a[it])
proc op(x, y: (mint, mint)): (mint, mint) =
    var (a, b) = x
    var (c, d) = y
    return (a*c, c*b+d)

var seg = initSegmentTree[(mint, mint)](v, op, (mint(1), mint(0)))
var segr = initSegmentTree[(mint, mint)](v.reversed, op, (mint(1), mint(0)))
var ans = newSeqOfCap[int](q)

for i in 0..<q:
    var t = ii()
    if t == 0:
        var p, c, d = ii()
        seg[hld.toSeq(p)] = (mint(c), mint(d))
        segr[n - 1 - hld.toSeq(p)] = (mint(c), mint(d))
    else:
        var u, v, x = ii()
        var l = hld.lca(u, v)
        var a = (mint(1), mint(0))
        for (l, r) in hld.path(l, u, true, true): a = op(a, segr.get(l..<r))
        for (l, r) in hld.path(l, v, false, false): a = op(a, seg.get(l..<r))
        ans.add((a[0] * x + a[1]).val)
echo ans.join("\n")
