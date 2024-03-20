# verification-helper: PROBLEM https://atcoder.jp/contests/abc335/tasks/abc335_e
import strutils, sequtils
import cplib/graph/graph
import cplib/graph/SCC

var n, m: int
(n, m) = stdin.readline.split.map parseInt
var a = stdin.readLine.split.map parseInt
var g = initUnWeightedDirectedStaticGraph(n)
for i in 0..<m:
    var u, v: int
    (u, v) = stdin.readLine.split.map parseInt
    u -= 1; v -= 1
    if a[u] != a[v]:
        if a[u] > a[v]: swap(u, v)
        g.add_edge(u, v)
    else:
        g.add_edge(u, v)
        g.add_edge(v, u)
g.build()
var (newg, itg, _) = g.SCCG()
var dp = newSeqWith(n, 0)
dp[itg[0]] = 1
for i in 0..<newg.N:
    if dp[i] > 0:
        for j in newG[i]:
            dp[j] = max(dp[j], dp[i] + 1)
echo dp[itg[n-1]]
