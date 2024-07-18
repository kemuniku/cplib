# verification-helper: PROBLEM https://judge.yosupo.jp/problem/number_of_substrings
include cplib/str/hash_string

{.checks:off.}
import algorithm,sequtils,strutils
var S = stdin.readLine()
var T = stdin.readLine()
var X = (S & '$' & T).initRollingHash()
var tmp : seq[RollingHash]
for i in 0..<len(X):
    tmp.add(X[i..<len(X)])
tmp.sort()
var ans = 0
for i in 0..<(len(X)-1):
    if (tmp[i].l in 0..<len(S) and tmp[i+1].l notin 0..<len(S)) or (tmp[i+1].l in 0..<len(S) and tmp[i].l notin 0..<len(S)):
        if ans < LCP(tmp[i],tmp[i+1]):
            ans = LCP(tmp[i],tmp[i+1])
echo ans