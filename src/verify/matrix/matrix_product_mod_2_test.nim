# verification-helper: PROBLEM https://judge.yosupo.jp/problem/matrix_product_mod_2
{.checks: off.}
import cplib/matrix/matrix_mod2
import strutils,sequtils

let nmk = stdin.readLine.split.map(parseInt)
let (n, m, k) = (nmk[0], nmk[1], nmk[2])
var a = initMatrixMod2(n, m)
var b = initMatrixMod2(m, k)
for i in 0..<n:
    a.setRowBits(i, stdin.readLine)
for i in 0..<m:
    b.setRowBits(i, stdin.readLine)
let c = a * b
for i in 0..<n:
    echo c.rowBits(i)
