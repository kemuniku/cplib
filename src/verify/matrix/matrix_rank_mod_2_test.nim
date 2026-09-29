# verification-helper: PROBLEM https://judge.yosupo.jp/problem/matrix_rank_mod_2
{.checks: off.}
import cplib/matrix/matrix_mod2
import strutils, sequtils

let nm = stdin.readLine.split.map(parseInt)
let (n, m) = (nm[0], nm[1])
if n == 0 or m == 0:
    echo 0
    quit(0)
let data = stdin.readAll
var a = initMatrixMod2(min(n, m), max(n, m))
var position = 0
for i in 0..<n:
    while data[position] <= ' ': inc position
    if n <= m:
        a.setRowBits(i, data[position..<position+m])
    else:
        for j in 0..<m: a[j, i] = data[position+j] == '1'
    position += m
echo a.rank
