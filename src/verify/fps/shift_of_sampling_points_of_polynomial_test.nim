# verification-helper: PROBLEM https://judge.yosupo.jp/problem/shift_of_sampling_points_of_polynomial

import sequtils, strutils
include cplib/fps/fps
import cplib/modint/modint

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

type Mint = modint998244353_barrett

let n = ii()
let m = ii()
let t = Mint(ii())
let ys = newSeqWith(n, Mint(ii()))
echo shiftOfSamplingPoints(ys, t, m).join(" ")
