# verification-helper: PROBLEM https://judge.yosupo.jp/problem/persistent_unionfind
import sequtils, strutils
import cplib/collections/rollback_unionfind
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var n, q = ii()
var g = newSeqWith(q, newseq[(int, int, int)]())
var query = newSeqWith(q, newSeq[(int, int, int)]())
var ans = newSeq[int]()
for i in 0..<q:
    var t, k, u, v = ii()
    k += 1
    if t == 0:
        g[k].add((i+1, u, v))
    else:
        query[k].add((ans.len, u, v))
        ans.add(-1)
var uf = initRollbackUnionFind(n)
proc dfs(x: int) =
    for (id, u, v) in query[x]:
        ans[id] = int(uf.issame(u, v))
    for (y, u, v) in g[x]:
        uf.unite(u, v)
        dfs(y)
        uf.undo()
dfs(0)
echo ans.join("\n")
