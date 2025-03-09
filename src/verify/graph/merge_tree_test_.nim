# verification-helper: PROBLEM https://atcoder.jp/contests/abc183/tasks/abc183_f
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
import cplib/graph/merge_tree
import cplib/collections/staticrangecount
import sequtils


var N,Q = ii()
var C = newseqwith(N,ii())
var querys: seq[(int,int,int)]
var v : seq[(int,int)]
for i in 0..<(Q):
    var t,x,y = ii()
    querys.add((t,x,y))
    if t == 1:
        v.add((x-1,y-1))

var MT = initMergeTree(N,v)
var SRC = initStaticRangeCount(MT.make_seq(C))
for i in 0..<(Q):
    var (t,x,y) = querys[i]
    if t == 1:
        MT.unite(x-1,y-1)
    else:
        echo SRC.count(MT.get_range(x-1),y)