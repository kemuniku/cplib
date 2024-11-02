# verification-helper: PROBLEM https://judge.yosupo.jp/problem/unionfind
import cplib/collections/group_unionfind

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var N, Q = ii()
var uf = initUnionFind(N)
for i in 0..<Q:
    var t, u, v = ii()
    if t == 0:
        uf.unite(u, v)
    else:
        if uf.issame(u, v):
            echo 1
        else:
            echo 0
