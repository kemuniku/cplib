# verification-helper: PROBLEM https://judge.yosupo.jp/problem/inv_of_formal_power_series

import strutils
import cplib/convolution/relaxed_convolution
import cplib/modint/modint

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

type Mint = modint998244353_barrett

let n = ii()
var inverse = initRelaxedInv[Mint](n)
var result = newSeq[Mint](n)
for i in 0..<n:
    result[i] = inverse.add(Mint(ii()))
echo result.join(" ")
