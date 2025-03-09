# verification-helper: PROBLEM https://judge.yosupo.jp/problem/bitwise_xor_convolution

import cplib/convolution/xor_convolution
import atcoder/modint
import sequtils,math,strutils
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
type mint = modint998244353

var N = ii()
var A = newseqwith(2^N,ii().mint())
var B = newSeqWith(2^N,ii().mint())

var C = xor_convolution(A,B)
echo C.join(" ")