# verification-helper: PROBLEM https://judge.yosupo.jp/problem/many_factorials

import cplib/math/many_factorials
import cplib/modint/modint

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

type Mint = modint998244353_barrett

let q = ii()
let table = initLargeFactorial[Mint]()
for i in 0..<q:
    echo table.fact(ii())
