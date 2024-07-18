# verification-helper: PROBLEM https://judge.yosupo.jp/problem/suffixarray
import cplib/str/static_string

import algorithm,sequtils,strutils
var S = stdin.readLine().toStaticString()
var tmp : seq[StaticString]
for i in 0..<len(S):
    tmp.add(S[i..<len(S)])
tmp.sort()

echo tmp.mapit(it.l).join(" ")