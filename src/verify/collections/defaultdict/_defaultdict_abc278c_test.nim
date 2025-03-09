# verification-helper: PROBLEM https://atcoder.jp/contests/abc278/tasks/abc278_c
import cplib/collections/defaultdict
import strutils, sequtils, sets
var n, q, t, a, b: int
(n, q) = stdin.readLine.split.map parseInt
var d = initDefaultDict[int, Hashset[int]](initHashSet[int](0))
for _ in 0..<q:
    (t, a, b) = stdin.readLine.split.map parseInt
    a -= 1; b -= 1
    if t == 1: d[a].incl(b)
    elif t == 2: d[a].excl(b)
    else: echo(if b in d[a] and a in d[b]: "Yes" else: "No")
