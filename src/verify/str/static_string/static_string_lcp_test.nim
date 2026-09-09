# verification-helper: PROBLEM https://judge.yosupo.jp/problem/number_of_substrings
import cplib/str/suffix_array

let S = stdin.readLine()
let SA = suffix_array(S)
let LCP = lcp_array(S, SA)
var sm = 0
for value in LCP:
    sm += value
echo len(S) * (len(S) + 1) div 2 - sm
