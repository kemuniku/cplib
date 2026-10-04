# verification-helper: PROBLEM https://judge.yosupo.jp/problem/multipoint_evaluation_on_geometric_sequence

import sequtils, strutils
import cplib/fps/chirp_z
import cplib/modint/modint

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld", addr result)

type Mint = modint998244353_barrett
let n = ii()
let m = ii()
let a = Mint(ii())
let r = Mint(ii())
let f = newSeqWith(n, Mint(ii()))
echo multipointEvaluationGeometric(f, a, r, m).join(" ")
