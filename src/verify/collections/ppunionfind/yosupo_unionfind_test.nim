# verification-helper: PROBLEM https://judge.yosupo.jp/problem/unionfind
import cplib/collections/ppunionfind
import algorithm

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var N,Q = ii()
var UF = initPartialPersistentUnionFind(N)
for i in 0..<Q:
    var t,u,v = ii()
    if t == 0:
        UF.unite(u,v)
    else:
        echo if UF.issame(u,v): 1 else: 0