# verification-helper: PROBLEM https://judge.yosupo.jp/problem/matrix_det_mod_2
{.checks: off.}
import cplib/matrix/matrix_mod2
import std/strutils

let n = stdin.readLine.parseInt
var a = initMatrixMod2(n, n)
for i in 0..<n:
    let s = stdin.readLine
    for j in 0..<n: a[i, j] = s[j] == '1'
echo int(a.determinant)
