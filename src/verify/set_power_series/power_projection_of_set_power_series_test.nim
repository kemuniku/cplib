# verification-helper: PROBLEM https://judge.yosupo.jp/problem/power_projection_of_set_power_series

import cplib/set_power_series/set_power_series
import cplib/convolution/subset_convolution
import cplib/modint/modint
import sequtils, strutils
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int = scanf("%lld", addr result)
type mint = modint998244353_barrett
let n = ii()
let m = ii()
let s = newSeqWith(1 shl n, init(mint, ii()))
let w = newSeqWith(1 shl n, init(mint, ii()))
echo setPowerProjection(s, w, m).join(" ")
