# verification-helper: PROBLEM https://judge.yosupo.jp/problem/min_plus_convolution_convex_arbitrary

import std/[sequtils, strutils]
import cplib/convolution/min_plus_convolution

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld", addr result)

let n = ii()
let m = ii()
let a = newSeqWith(n, ii())
let b = newSeqWith(m, ii())
echo minPlusConvolutionConvexArbitrary(a, b).join(" ")
