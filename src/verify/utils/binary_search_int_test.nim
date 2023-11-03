# verification-helper: PROBLEM https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=ALDS1_4_B
include cplib/tmpl/citrus
import cplib/utils/binary_search

let n = input(int)
let s = input(int, n).concat(@[-INFL, INFL]).sorted
let q = input(int)
let t = input(int, q)
var ans = 0
for i in 0..<q:
    proc ubound(x: int): bool = s[x] <= t[i]
    proc lbound(x: int): bool = s[x] < t[i]
    var upper = meguru_bisect(0, n+1, ubound)
    var lower = meguru_bisect(0, n+1, lbound)
    if upper - lower != 0: ans += 1
print(ans)
