# verification-helper: PROBLEM https://judge.yosupo.jp/problem/sqrt_of_formal_power_series

import options, sequtils, strutils
import cplib/convolution/relaxed_convolution
import cplib/modint/modint

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

type Mint = modint998244353_barrett

let n = ii()
let f = newSeqWith(n, Mint(ii()))
let root = f.sqrtRelaxed(n)
if root.isNone:
    echo -1
else:
    echo root.get.join(" ")
