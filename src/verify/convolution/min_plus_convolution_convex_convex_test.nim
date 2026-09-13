# verification-helper: PROBLEM https://judge.yosupo.jp/problem/min_plus_convolution_convex_convex
import cplib/convolution/min_plus_convolution
import sequtils, strutils
proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc readInt(): int64 = scanf("%lld", addr result)
let n = int(readInt())
let m = int(readInt())
let a = newSeqWith(n, readInt())
let b = newSeqWith(m, readInt())
echo minPlusConvolutionConvexConvex(a, b).join(" ")
