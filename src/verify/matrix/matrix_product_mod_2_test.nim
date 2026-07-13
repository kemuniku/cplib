# verification-helper: PROBLEM https://judge.yosupo.jp/problem/matrix_product_mod_2
{.checks: off.}
import cplib/matrix/matrix_mod2
import std/[strutils, sequtils]

let nmk = stdin.readLine.split.map(parseInt)
let (n, m, k) = (nmk[0], nmk[1], nmk[2])
var a = initMatrixMod2(n, m)
var b = initMatrixMod2(m, k)
for i in 0..<n:
    let s = stdin.readLine
    for j in 0..<m: a[i, j] = s[j] == '1'
for i in 0..<m:
    let s = stdin.readLine
    for j in 0..<k: b[i, j] = s[j] == '1'
let c = a * b
for i in 0..<n:
    var s = newString(k)
    for j in 0..<k: s[j] = if c[i, j]: '1' else: '0'
    echo s
