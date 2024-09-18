# verification-helper: PROBLEM https://atcoder.jp/contests/past202004-open/tasks/past202004_o
import cplib/collections/ppunionfind
import algorithm

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var N,M = ii()
var UF = initPartialPersistentUnionFind(N)

var edges : seq[(int,int,int)]
for i in 0..<(M):
    var a,b  = ii()-1
    var c = ii()
    edges.add((c,a,b))
var save = edges
edges.sort()
var tmp = 0
for i in 0..<(M):
    var (c,a,b) = edges[i]
    if UF.unite(a,b,i):
        tmp += c

for i in 0..<(M):
    var (c,a,b) = save[i]
    echo tmp+c-edges[UF.when_unite(a,b)][0]