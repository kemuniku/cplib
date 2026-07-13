# verification-helper: PROBLEM https://judge.yosupo.jp/problem/matrix_rank_mod_2
{.checks: off.}
import cplib/matrix/static_matrix_mod2
import std/[strutils, sequtils]

const MaxN = 4096

let nm = stdin.readLine.split.map(parseInt)
let n = nm[0]
var a = initStaticMatrixMod2[MaxN, MaxN]()
for i in 0..<n:
    a.setRowBits(i, stdin.readLine)
echo a.rank
