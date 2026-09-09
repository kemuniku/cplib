# verification-helper: PROBLEM https://judge.yosupo.jp/problem/convolution_mod

import sequtils, strutils
include cplib/fps/fps
import cplib/modint/modint

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

type Mint = modint998244353_barrett

let n = ii()
let m = ii()
let f = newSeqWith(n, Mint(ii()))
let g = newSeqWith(m, Mint(ii()))
echo (f * g).join(" ")
