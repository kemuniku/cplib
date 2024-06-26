# verification-helper: PROBLEM https://atcoder.jp/contests/past202004-open/tasks/past202004_o
import sequtils, tables, strutils, heapqueue, hashes
import cplib/graph/graph
import cplib/collections/unionfind
import cplib/collections/segtree
import cplib/utils/constants
import cplib/tree/heavylightdecomposition
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var n, m = ii()
var ans = newSeqWith(m, -1)
var hq = initHeapQueue[(int, int, int, int)]()
var e = initTable[(int, int), int](m)
var abc = newSeq[(int, int, int)]()
for i in 0..<m:
    var a, b = ii() - 1
    var c = ii()
    abc.add((a, b, c))
    e[(a, b)] = c
    e[(b, a)] = c
    hq.push((c, a, b, i))
var uf = initUnionFind(n)
var g = initUnWeightedUnDirectedGraph(n)

var ai = 0
while hq.len > 0:
    var (c, a, b, id) = hq.pop
    if uf.issame(a, b): continue
    uf.unite(a, b)
    g.add_edge(a, b)
    ans[id] = 0
    ai += c
for i in 0..<m:
    if ans[i] == 0: ans[i] = ai

var hld = initHld(g, 0)
var v = (0..<n).toSeq.mapIt(hld.toVtx(it)).mapIt(if hld.P[it] == -1: 0 else: e[(it, hld.P[it])])

var seg = newSegWith(v, max(l, r), -INF64)

for i in 0..<m:
    if ans[i] != -1: continue
    var (a, b, c) = abc[i]
    var l = hld.lca(a, b)
    var mx = -INF64
    for (l, r) in hld.path(l, a, false, false): mx = max(mx, seg.get(l..<r))
    for (l, r) in hld.path(l, b, false, false): mx = max(mx, seg.get(l..<r))
    ans[i] = ai - mx + c
echo ans.join("\n")
