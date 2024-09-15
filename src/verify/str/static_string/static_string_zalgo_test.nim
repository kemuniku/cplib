# verification-helper: PROBLEM https://judge.yosupo.jp/problem/zalgorithm
import cplib/str/static_string

import algorithm,sequtils,strutils
var S = stdin.readLine().toStaticString()
var ans : seq[int]
for i in 0..<len(S):
    ans.add(lcp(S,S[i..<len(S)]))

echo ans.join(" ")