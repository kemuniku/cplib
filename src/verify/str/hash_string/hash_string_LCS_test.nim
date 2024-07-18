# verification-helper: PROBLEM https://judge.yosupo.jp/problem/longest_common_substring
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
var a = 0
var b = 0
var c = 0
var d = 0
for i in 0..<(len(X)-1):
    if (tmp[i].l in 0..<len(S) and tmp[i+1].l notin 0..<len(S)) or (tmp[i+1].l in 0..<len(S) and tmp[i].l notin 0..<len(S)):
        var lcp = LCP(tmp[i],tmp[i+1])
        if ans < lcp:
            ans = lcp
            if tmp[i].l in 0..<len(S):
                a = tmp[i].l
                b = tmp[i].l+lcp
                c = tmp[i+1].l-len(S)-1
                d = tmp[i+1].l+lcp-len(S)-1
            else:
                a = tmp[i+1].l
                b = tmp[i+1].l+lcp
                c = tmp[i].l-len(S)-1
                d = tmp[i].l+lcp-len(S)-1
echo a," ",b," ",c," ",d