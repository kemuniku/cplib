# verification-helper: PROBLEM https://judge.yosupo.jp/problem/convolution_mod

import cplib/convolution/convolution
import cplib/modint/modint
import sequtils, strutils
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
type mint = modint998244353_barrett

var n, m = ii()
var a = newseqwith(n, ii().mint())
var b = newSeqWith(m, ii().mint())
var c = convolution(a, b)
echo c.join(" ")
