# verification-helper: PROBLEM https://judge.yosupo.jp/problem/matrix_det_mod_2
{.checks: off.}
import cplib/matrix/static_matrix_mod2
import std/strutils

const MaxN = 4096

let n = stdin.readLine.parseInt
var a = initStaticMatrixMod2[MaxN, MaxN]()
for i in 0..<n:
    a.setRowBits(i, stdin.readLine)
for i in n..<MaxN:
    a[i, i] = true
echo int(a.determinant)
