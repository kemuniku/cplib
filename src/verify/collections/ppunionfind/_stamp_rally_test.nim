# verification-helper: PROBLEM https://atcoder.jp/contests/agc002/tasks/agc002_d
import cplib/collections/ppunionfind
import cplib/utils/binary_search

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var N,M = ii()
var UF = initPartialPersistentUnionFind(N)
for i in 0..<(M):
    var a,b = ii()-1
    UF.unite(a,b,i+1)
var Q = ii()
for i in 0..<(Q):
    var x,y,z = ii()
    x -= 1
    y -= 1
    proc is_ok(arg:int):bool=
        if UF.issame(x,y,arg):
            return UF.size(x,arg) >= z
        else:
            return UF.size(x,arg)+UF.size(y,arg) >= z
    echo meguru_bisect(M,0,is_ok)

