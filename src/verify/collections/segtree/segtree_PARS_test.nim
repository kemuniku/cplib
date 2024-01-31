# verification-helper: PROBLEM https://judge.yosupo.jp/problem/point_add_range_sum
import sequtils, sugar
import cplib/collections/segtree

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var N, Q = ii()
var A = newSeqWith(N, ii())
var st = initSegmentTree(A, (a, b: int)=>a + b, 0)
for i in 0..<Q:
    var T = ii()
    if T == 0:
        var p, x = ii()
        st.update(p, st.get(p, p+1) + x)
    else:
        var l, r = ii()
        echo st.get(l, r)
