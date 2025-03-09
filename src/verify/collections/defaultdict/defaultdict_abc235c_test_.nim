# verification-helper: PROBLEM https://atcoder.jp/contests/abc235/tasks/abc235_c
import sequtils, strutils
include cplib/collections/defaultdict

var n, q, x, k: int
(n, q) = stdin.readLine.split.map parseInt
var d = initDefaultDict[int, seq[int]](newSeq[int](0))
var a = stdin.readLine.split.map parseInt
for i in 0..<n:
    d[a[i]].add(i+1)
var ans = newSeq[int](q)
for i in 0..<q:
    (x, k) = stdin.readLine.split.map parseInt
    if d[x].len < k: ans[i] = -1
    else: ans[i] = d[x][k-1]
echo ans.join("\n")
