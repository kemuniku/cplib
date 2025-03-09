# verification-helper: PROBLEM https://atcoder.jp/contests/abc284/tasks/abc284_d
import cplib/math/primefactor
import strutils, tables

proc solve() =
    var n = stdin.readLine.parseInt
    var p, q: int
    for k, v in primefactor_table(n):
        if v == 2: p = k
        else: q = k
    echo p, " ", q

var t = stdin.readLine.parseInt
for _ in 0..<t: solve()
