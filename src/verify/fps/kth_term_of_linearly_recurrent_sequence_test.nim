# verification-helper: PROBLEM https://judge.yosupo.jp/problem/kth_term_of_linearly_recurrent_sequence

import sequtils
include cplib/fps/fps
import cplib/modint/modint

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

type Mint = modint998244353_barrett

let d = ii()
let k = ii()
let initial = newSeqWith(d, Mint(ii()))
let coefficients = newSeqWith(d, Mint(ii()))
echo linearRecurrenceKth(initial, coefficients, k)
