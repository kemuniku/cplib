# verification-helper: PROBLEM https://judge.yosupo.jp/problem/matrix_rank_mod_2
{.checks: off.}
import cplib/matrix/matrix_mod2
import strutils, sequtils

let nm = stdin.readLine.split.map(parseInt)
let (n, m) = (nm[0], nm[1])
if n == 0 or m == 0:
    echo 0
    quit(0)
var a = initMatrixMod2(n, m)
for i in 0..<n:
    let s = stdin.readLine
    for j in 0..<m: a[i, j] = s[j] == '1'
echo a.rank
