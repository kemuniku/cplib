# verification-helper: PROBLEM https://judge.yosupo.jp/problem/number_of_substrings
import cplib/str/static_string

import algorithm
var S = stdin.readLine().toStaticString()
var tmp : seq[StaticString]
for i in 0..<len(S):
    tmp.add(S[i..<len(S)])
tmp.sort()
var sm = 0
for i in 0..<(len(S)-1):
    sm += lcp(tmp[i],tmp[i+1])
echo len(S)*(len(S)+1) div 2 - sm