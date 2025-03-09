# verification-helper: PROBLEM https://atcoder.jp/contests/abc302/tasks/abc302_ex
import sequtils, strutils
import cplib/graph/graph
import cplib/collections/rollback_unionfind
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var n = ii()
var ab = newSeqWith(n, (ii()-1, ii()-1))
var g = initUnWeightedUnDirectedStaticGraph(n)
for i in 0..<n-1:
    var u, v = ii() - 1
    g.add_edge(u, v)
g.build

var es = newSeqWith(n, (0, 1))
var uf = initRollbackUnionFind(n)
var cur = 0
var ans = newSeq[int](n-1)
proc dfs(x, par: int) =
    var (a, b) = ab[x]
    a = uf.root(a)
    b = uf.root(b)
    var merge = false
    var (ea, sa) = es[a]
    var (eb, sb) = es[b]
    if not uf.issame(a, b):
        uf.unite(a, b)
        es[uf.root(a)] = (ea+eb+1, sa+sb)
        cur -= min(ea, sa) + min(eb, sb)
        cur += min(ea+eb+1, sa+sb)
        merge = true
    else:
        var (e, s) = es[uf.root(a)]
        cur -= min(e, s)
        es[uf.root(a)] = (e+1, s)
        cur += min(e+1, s)
    if x != 0: ans[x-1] = cur
    for y in g[x]:
        if y == par: continue
        dfs(y, x)
    if merge:
        var (e, s) = es[uf.root(a)]
        cur -= min(e, s)
        uf.undo()
        es[a] = (ea, sa)
        es[b] = (eb, sb)
        cur += min(ea, sa) + min(eb, sb)
    else:
        var (e, s) = es[uf.root(a)]
        cur -= min(e, s)
        es[uf.root(a)] = (e-1, s)
        cur += min(e-1, s)
dfs(0, -1)
echo ans.join(" ")
