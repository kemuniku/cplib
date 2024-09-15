# verification-helper: PROBLEM https://judge.yosupo.jp/problem/static_range_sum
import sequtils, sugar
import cplib/collections/segtree_var

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var N, Q = ii()
var A = newSeqWith(N, ii())
var st = initSegmentTree(A, (a, b: int)=>a + b, 0)
for i in 0..<Q:
    var L, R = ii()
    echo st.get(L..<R)
