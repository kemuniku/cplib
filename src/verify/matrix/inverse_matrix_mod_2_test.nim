# verification-helper: PROBLEM https://judge.yosupo.jp/problem/inverse_matrix_mod_2
{.checks: off.}
import cplib/matrix/matrix_mod2
import std/[options, strutils]

let n = stdin.readLine.parseInt
var a = initMatrixMod2(n, n)
for i in 0..<n:
    let s = stdin.readLine
    for j in 0..<n: a[i, j] = s[j] == '1'
let inv = a.inverse
if inv.isNone:
    echo -1
else:
    let b = inv.get
    for i in 0..<n:
        var s = newString(n)
        for j in 0..<n: s[j] = if b[i, j]: '1' else: '0'
        echo s
