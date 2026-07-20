# verification-helper: PROBLEM https://judge.yosupo.jp/problem/inv_of_formal_power_series
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
import sequtils, strutils
import cplib/fps/fps
import cplib/modint/modint
type mint = modint998244353_barrett

var n = ii()
var f = initFormalPowerSeries[mint](newSeqWith(n, mint(ii())))
var ans = initFormalPowerSeries(@[mint(1)]) / f
echo ans
