# verification-helper: PROBLEM https://yukicoder.me/problems/no/878 import cplib/collections/segtree
import cplib/collections/segtree
import sequtils, strutils, algorithm

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var n, q = ii()
var a = newSeqWith(n, ii())
a.reverse
var seg = newSegWith(a, max(l, r), 0)
var mn = newSeq[int](n)
for i in 0..<n:
    var l = n-1-i
    var mx = seg.max_right(l+1, proc(x: int): bool = x <= a[l])
    mn[i] = n-mx
var ad = newseqwith(n, newseq[int]())
for i in 0..<n:
    ad[mn[i]].add(i)
a.reverse
var query = newSeq[(int, int, int)](q)
for i in 0..<q:
    var _, l, r = ii()
    query[i] = (l-1, r, i)
query.sort

var ans = newseq[int](q)
var seg_add = newsegwith(newseqwith(n, 0), l+r, 0)
var li = 0
for (l, r, id) in query:
    while li <= l:
        for x in ad[li]:
            seg_add[x] = seg_add[x] + 1
        li += 1
    ans[id] = seg_add[l..<r]
echo ans.join("\n")
