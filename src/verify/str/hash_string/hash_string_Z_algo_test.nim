# verification-helper: PROBLEM https://judge.yosupo.jp/problem/zalgorithm
include cplib/str/hash_string

{.checks:off.}
import algorithm,sequtils,strutils
var S = stdin.readLine().initRollingHash()
var ans : seq[int]
for i in 0..<len(S):
    ans.add(LCP(S,S[i..<len(S)]))

echo ans.join(" ")