# verification-helper: PROBLEM https://judge.yosupo.jp/problem/convolution_mod

import cplib/convolution/convolution
import cplib/modint/modint
import sequtils, strutils
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
type mint = modint_montgomery
mint.setMod(998244353)

let n = ii()
let m = ii()
let a = newSeqWith(n, ii().mint())
let b = newSeqWith(m, ii().mint())
var u = newSeq[mint](max(n, m))
var v = newSeq[mint](max(n, m))
for i in 0..<n:
    u[i] += a[i]
    v[i] += a[i]
for i in 0..<m:
    u[i] += b[i]
    v[i] -= b[i]
let uSquared = convolution(u, u)
let vSquared = convolution(v, v)
let inverseFour = init(mint, 4).inv()
var answer = newSeq[mint](n + m - 1)
for i in 0..<answer.len:
    answer[i] = (uSquared[i] - vSquared[i]) * inverseFour
echo answer.join(" ")
