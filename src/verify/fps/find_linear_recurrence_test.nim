# verification-helper: PROBLEM https://judge.yosupo.jp/problem/find_linear_recurrence

import sequtils, strutils
import cplib/fps/berlekamp_massey
import cplib/modint/modint

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

type Mint = modint998244353_barrett

let n = ii()
let a = newSeqWith(n, Mint(ii()))
let coefficients = berlekampMassey(a)
echo coefficients.len
echo coefficients.mapIt($it).join(" ")
