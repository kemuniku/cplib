# verification-helper: PROBLEM https://judge.yosupo.jp/problem/multipoint_evaluation

import sequtils, strutils
include cplib/fps/fps
import cplib/modint/modint

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

type Mint = modint998244353_barrett

let n = ii()
let m = ii()
let f = newSeqWith(n, Mint(ii()))
let xs = newSeqWith(m, Mint(ii()))
echo multipointEvaluation(f, xs).join(" ")
