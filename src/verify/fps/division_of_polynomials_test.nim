# verification-helper: PROBLEM https://judge.yosupo.jp/problem/division_of_polynomials

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
let (quotient, remainder) = f.divmod(g)
echo quotient.len, " ", remainder.len
echo quotient.join(" ")
echo remainder.join(" ")
