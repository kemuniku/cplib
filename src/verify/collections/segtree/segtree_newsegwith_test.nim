# verification-helper: PROBLEM https://judge.yosupo.jp/problem/staticrmq
import sequtils, sugar
import cplib/collections/segtree

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var N, Q = ii()
var A = newSeqWith(N, ii())
var st = newSegWith(A,min(l,r), int(1e18))
for i in 0..<Q:
    var L, R = ii()
    echo st.get(L, R)
