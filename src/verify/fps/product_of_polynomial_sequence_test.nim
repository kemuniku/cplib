# verification-helper: PROBLEM https://judge.yosupo.jp/problem/product_of_polynomial_sequence

import sequtils, strutils
include cplib/fps/fps
import cplib/modint/modint

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

type
    Mint = modint998244353_barrett

let n = ii()
var polynomials = newSeqOfCap[seq[Mint]](n)
for _ in 0..<n:
    let degree = ii()
    polynomials.add(newSeqWith(degree + 1, Mint(ii())))

let answer = productOfPolynomialSequence(polynomials)
echo answer.join(" ")
