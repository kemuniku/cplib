# verification-helper: PROBLEM https://judge.yosupo.jp/problem/point_add_range_sum
import sequtils, strutils
import cplib/collections/root_rangesum

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var N, Q = ii()
var A = newSeqWith(N, ii())
var st = initrangesum(A)
for i in 0..<Q:
    var T = ii()
    if T == 0:
        var p, x = ii()
        st[p] = st[p] + x
    else:
        var l, r = ii()
        echo st[l..<r]
