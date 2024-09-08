# verification-helper: PROBLEM https://judge.yosupo.jp/problem/number_of_substrings
include cplib/str/hash_string

{.checks:off.}
import algorithm,sequtils,strutils
var S = stdin.readLine().initRollingHash()
var tmp : seq[RollingHash]
for i in 0..<len(S):
    tmp.add(S[i..<len(S)])
tmp.sort()
var sm = 0
for i in 0..<(len(S)-1):
    sm += LCP(tmp[i],tmp[i+1])
echo len(S)*(len(S)+1) div 2 - sm