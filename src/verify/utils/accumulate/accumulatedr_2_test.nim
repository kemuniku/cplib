# verification-helper: PROBLEM https://judge.yosupo.jp/problem/static_range_sum

import cplib/utils/accumulate
import sequtils

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var N,Q = ii()
var a = (newseqwith(N,ii()) & @[0]).accumulatedr(a+b)

for i in 0..<Q:
    var l = ii()
    var r = ii()
    echo a[l]-a[r]