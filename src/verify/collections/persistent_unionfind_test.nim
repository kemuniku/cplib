import cplib/collections/persistent_unionfind

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
import tables
var N,Q = ii()
var UFS : Table[int,PersistentUnionFind]
UFS[-1] = initPersistentUnionFind(N)
for i in 0..<Q:
    var t,k,u,v = ii()
    if t == 0:
        UFS[i] = UFS[k].unite(u,v)
    else:
        echo if UFS[k].issame(u,v):1 else:0
