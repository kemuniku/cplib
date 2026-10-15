# verification-helper: PROBLEM https://judge.yosupo.jp/problem/unionfind_with_potential
import strutils
import cplib/collections/weightedunionfind
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)


var N,Q = ii()
import cplib/modint/modint
type mint = modint998244353_barrett
var uf = initWeightedUnionFind(N,mint)
for i in 0..<Q:
    var t = ii()
    if t == 0:
        var u,v,x = ii()
        if uf.unite(u,v,x):
            echo 1
        else:
            echo 0
    else:
        var u,v = ii()
        if uf.issame(u,v):
            echo uf.diff(u,v)
        else:
            echo -1
