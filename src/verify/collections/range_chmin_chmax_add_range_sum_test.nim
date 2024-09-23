# verification-helper: PROBLEM https://judge.yosupo.jp/problem/range_chmin_chmax_add_range_sum
import sequtils
import cplib/collections/segtree_beats_template

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var n, q = ii()
var a = newSeqWith(n, ii())
var seg = initRangeChminChmaxRangeSumMaxMin(a)
for _ in 0..<q:
    var t = ii()
    if t == 0:
        var l, r, b = ii()
        seg.chmin(l..<r, b)
    elif t == 1:
        var l, r, b = ii()
        seg.chmax(l..<r, b)
    elif t == 2:
        var l, r, b = ii()
        seg.add(l..<r, b)
    else:
        var l, r = ii()
        echo seg[l..<r].sum
