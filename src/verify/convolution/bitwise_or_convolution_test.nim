# verification-helper: PROBLEM https://judge.yosupo.jp/problem/bitwise_and_convolution
import cplib/convolution/bitwise_or_convolution
import cplib/modint/modint
import sequtils, strutils, algorithm
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int = scanf("%lld", addr result)
type mint = modint998244353_barrett
let n = ii()
var a = newSeqWith(1 shl n, init(mint, ii()))
var b = newSeqWith(1 shl n, init(mint, ii()))
a.reverse()
b.reverse()
var c = bitwiseOrConvolution(a, b)
c.reverse()
echo c.join(" ")
