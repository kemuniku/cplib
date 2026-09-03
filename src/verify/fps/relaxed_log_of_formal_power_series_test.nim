# verification-helper: PROBLEM https://judge.yosupo.jp/problem/log_of_formal_power_series

import strutils
import cplib/convolution/relaxed_convolution
import cplib/modint/modint

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

type Mint = modint998244353_barrett

let n = ii()
var logarithm = initRelaxedLog[Mint](n)
var result = newSeq[Mint](n)
for i in 0..<n:
    result[i] = logarithm.add(Mint(ii()))
echo result.join(" ")
