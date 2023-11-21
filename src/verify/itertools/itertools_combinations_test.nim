# verification-helper: PROBLEM https://atcoder.jp/contests/abc328/tasks/abc328_e
import math,sequtils
import cplib/itertools/combinations
import cplib/collections/unionfind

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
var N,M,K = ii()
var edges :seq[(int,int,int)]
for i in 0..<M:
    var u,v,w = ii()-1
    w += 1
    edges.add((u,v,w))
var ans = 10^18
for x in combinations((0..<M).toseq,N-1):
    var uf = initUnionFind(N)
    var tmp = 0
    for j in x:
        var (u,v,w) = edges[j]
        uf.unite(u,v)
        tmp += w
        tmp = tmp mod K
    if uf.count == 1:
        ans = min(ans,tmp)
echo ans

