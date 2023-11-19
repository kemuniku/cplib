# verification-helper: PROBLEM https://atcoder.jp/contests/abc138/tasks/abc138_d
import sequtils, strutils
import cplib/tree/tree

var n, q, a, b, p, x: int
(n, q) = stdin.readLine.split.map(parseInt)
var g = initUnWeightedTree(n)
for i in 0..<n-1:
    (a, b) = stdin.readLine.split.map(parseInt)
    g.add_edge(a-1, b-1)
var cnt = newSeqWith(n, 0)
for i in 0..<q:
    (p, x) = stdin.readLine.split.map(parseInt)
    cnt[p-1] += x
proc dfs(u, par, val: int): void =
    cnt[u] += val
    for (v, c) in g.edges[u]:
        if v == par: continue
        dfs(v, u, cnt[u])
dfs(0, -1, 0)
echo cnt.join(" ")
