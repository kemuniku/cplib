# verification-helper: PROBLEM https://judge.yosupo.jp/problem/inv_of_formal_power_series_2d
import strutils
import cplib/fps/bivariate_formal_power_series
import cplib/modint/modint

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld", addr result)

type Mint = modint998244353_barrett

let n = ii()
let m = ii()
var f: BivariateFPS[Mint] = initBivariateFPS[Mint](n, m)
for i in 0..<n:
    for j in 0..<m:
        f[i][j] = Mint(ii())
let answer = f.inv(n, m)
for row in answer:
    echo row.join(" ")
