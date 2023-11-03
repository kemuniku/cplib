# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ALDS1_4_B
import sequtils, strutils, algorithm
import cplib/utils/binary_search

const INF = int(1_000_000_000_000)
let n = stdin.readLine.parseInt
let s = stdin.readLine.split().map(parseInt).concat(@[-INF, INF]).sorted
let q = stdin.readLine.parseInt
let t = stdin.readLine.split().map(parseInt)
var ans = 0
for i in 0..<q:
    proc ubound(x: int): bool = s[x] <= t[i]
    proc lbound(x: int): bool = s[x] < t[i]
    var upper = meguru_bisect(0, n+1, ubound)
    var lower = meguru_bisect(0, n+1, lbound)
    if upper - lower != 0: ans += 1
echo ans
