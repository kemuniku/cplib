# verification-helper: PROBLEM https://judge.yosupo.jp/problem/point_add_range_sum
import sequtils, strutils
import cplib/collections/segtree_var

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var N, Q = ii()
var A = newSeqWith(N, ii())
var st = newSegWith(A, l+r, 0)
assert $st == A.join(" ")
for i in 0..<Q:
    var T = ii()
    if T == 0:
        var p, x = ii()
        st[p] += x
    else:
        var l, r = ii()
        echo st[l..<r]
