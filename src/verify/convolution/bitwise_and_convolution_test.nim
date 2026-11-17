# verification-helper: PROBLEM https://judge.yosupo.jp/problem/bitwise_and_convolution

import cplib/convolution/bitwise_and_convolution
import cplib/modint/modint
import sequtils, strutils

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int = scanf("%lld", addr result)
type mint = modint998244353_barrett

let n = ii()
let a = newSeqWith(1 shl n, init(mint, ii()))
let b = newSeqWith(1 shl n, init(mint, ii()))
let c = bitwiseAndConvolution(a, b)
echo c.join(" ")
