# verification-helper: PROBLEM https://judge.yosupo.jp/problem/polynomial_interpolation

import sequtils, strutils
include cplib/fps/fps
import cplib/modint/modint

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

type Mint = modint998244353_barrett

let n = ii()
let xs = newSeqWith(n, Mint(ii()))
let ys = newSeqWith(n, Mint(ii()))
echo polynomialInterpolation(xs, ys).join(" ")
