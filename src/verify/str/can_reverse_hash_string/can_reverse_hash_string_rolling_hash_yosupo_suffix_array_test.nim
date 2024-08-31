# verification-helper: PROBLEM https://judge.yosupo.jp/problem/suffixarray
import cplib/str/can_reverse_hash_string

{.checks:off.}
import algorithm,sequtils,strutils
var S = stdin.readLine().initRollingHash()
var tmp : seq[RollingHash]
for i in 0..<len(S):
    tmp.add(S[i..<len(S)])
tmp.sort()

echo tmp.mapit(it.l).join(" ")