# verification-helper: PROBLEM https://judge.yosupo.jp/problem/factorize
import cplib/math/primefactor
import strscans, strutils

var q: int
discard stdin.readLine.scanf("$i", q)
for _ in 0..<q:
    var a: int
    discard stdin.readLine.scanf("$i", a)
    var ans = primefactor(a)
    if ans.len == 0: echo 0
    else: echo ans.len, " ", ans.join(" ")
