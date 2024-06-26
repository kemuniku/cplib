# verification-helper: PROBLEM https://atcoder.jp/contests/abc185/tasks/abc185_f
import sequtils, sugar

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
proc `^=`(x: var int, y: int) = x = x xor y
include cplib/collections/segtree_var

var N, Q = ii()
var A = newSeqWith(N, ii())
var st = initSegmentTree(A, (a, b: int)=>a xor b, 0)
for i in 0..<Q:
    var T, X, Y = ii()
    if T == 1:
        st[X-1] ^= Y
    else:
        echo st.get(X-1, Y)
