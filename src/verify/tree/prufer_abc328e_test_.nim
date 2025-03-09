# verification-helper: PROBLEM https://atcoder.jp/contests/abc328/tasks/abc328_e
import sequtils, strutils
import cplib/tree/prufer

var n, m, k: int
(n, m, k) = stdin.readline.split.map parseInt
var inf = int(300000000000000000)
var g = newSeqWith(n, newSeqWith(n, inf))
for i in 0..<m:
    var u, v, w: int
    (u, v, w) = stdin.readLine.split.map parseInt
    g[u-1][v-1] = w
    g[v-1][u-1] = w

var a = newSeqWith(n-2, 0)
var ans = inf
proc dfs(d: int) =
    if d == n-2:
        var t = a.prufer_decode
        var cur = 0
        for i in 0..<n:
            for (j, c) in t.edges[i]:
                if i < j: continue
                if g[i][j] == inf: return
                cur += g[i][j]
        ans = min(ans, cur mod k)
        return
    for i in 0..<n:
        a[d] = i
        dfs(d+1)
dfs(0)
echo ans
