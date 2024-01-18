# verification-helper: PROBLEM https://atcoder.jp/contests/abc225/tasks/abc225_e
import strutils, sequtils, algorithm
import cplib/math/rational

var n = stdin.readLine.parseint
var p = newSeq[(Rational[int], Rational[int])](n)
for i in 0..<n:
    var x, y: int
    (x, y) = stdin.readLine.split.map parseInt
    var lower = initRational(y-1, x)
    var upper = if x != 1: initRational(y, x-1) else: initRational(int(2000000000), 1)
    p[i] = (lower, upper)
p.sort(proc(x, y: (Rational[int], Rational[int])): int =
    if x[1] != y[1]: return cmp(x[1], y[1])
    return cmp(x[0], y[0])
)
var cur = initRational(-2, 1)
var ans = 0
for i in 0..<n:
    var (l, u) = p[i]
    if cur > l: continue
    ans += 1
    cur = u
echo ans
