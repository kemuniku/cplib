# verification-helper: PROBLEM https://judge.yosupo.jp/problem/convolution_mod

import sequtils, strutils
import cplib/convolution/relaxed_convolution
import cplib/modint/modint

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

type Mint = modint998244353_barrett

let n = ii()
let m = ii()
let a = newSeqWith(n, Mint(ii()))
let b = newSeqWith(m, Mint(ii()))
let coefficientCount = n + m - 1
var convolution = initRelaxedConvolution[Mint](coefficientCount)
var result = newSeq[Mint](coefficientCount)
for i in 0..<coefficientCount:
    let left = if i < n: a[i] else: Mint(0)
    let right = if i < m: b[i] else: Mint(0)
    result[i] = convolution.add(left, right)
echo result.join(" ")
