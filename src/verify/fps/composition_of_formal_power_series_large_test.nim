# verification-helper: PROBLEM https://judge.yosupo.jp/problem/composition_of_formal_power_series_large

import sequtils, strutils
include cplib/fps/fps
import cplib/modint/modint

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

type Mint = modint998244353_barrett

let n = ii()
let outer = newSeqWith(n, Mint(ii()))
let inner = newSeqWith(n, Mint(ii()))
echo outer.compose(inner, n).join(" ")
