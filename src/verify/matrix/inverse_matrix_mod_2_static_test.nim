# verification-helper: PROBLEM https://judge.yosupo.jp/problem/inverse_matrix_mod_2
{.checks: off.}
import cplib/matrix/static_matrix_mod2
import std/[options, strutils]

const MaxN = 4096

let n = stdin.readLine.parseInt
var a = initStaticMatrixMod2[MaxN, MaxN]()
for i in 0..<n:
    a.setRowBits(i, stdin.readLine)
for i in n..<MaxN:
    a[i, i] = true
let inv = a.inverse
if inv.isNone:
    echo -1
else:
    let b = inv.get
    for i in 0..<n:
        echo b.rowBits(i, n)
