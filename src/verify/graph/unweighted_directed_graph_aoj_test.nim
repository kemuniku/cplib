# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ALDS1_11_B
import cplib/graph/graph
import strutils, sequtils

var n = stdin.readLine.parseint
var g = initUnWeightedDirectedGraph(n)
for i in 0..<n:
    var line = stdin.readLine.split().map(parseInt)
    for j in 0..<line[1]:
        g.add_edge(line[0]-1, line[2+j]-1)

var ans = newSeqWith(n, (-1, -1))
proc dfs(x, cnt: int): int =
    if ans[x][0] != -1:
        return cnt - 1
    var cnt = cnt
    ans[x][0] = cnt
    for (y, c) in g.edges[x]:
        cnt = dfs(y, cnt+1)
    ans[x][1] = cnt + 1
    return cnt + 1

var pos = 1
for i in 0..<n:
    if ans[i][0] == -1:
        pos = dfs(i, pos) + 1

for i in 0..<n:
    var (s, t) = ans[i]
    echo i+1, " ", s, " ", t
