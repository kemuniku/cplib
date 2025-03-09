# verification-helper: PROBLEM https://atcoder.jp/contests/abc309/tasks/abc309_e
import strutils, sequtils
import cplib/tree/tree

var n, m, x, y: int
(n, m) = stdin.readLine.split.map(parseInt)
var p = stdin.readLine.split.map(parseInt).mapIt(it-1)
var g = initUnWeightedTree(p)
var ins = newSeqWith(n, 0)
for i in 0..<m:
    (x, y) = stdin.readLine.split.map(parseInt)
    ins[x-1] = max(ins[x-1], y+1)

proc dfs(u, par, insi: int): int =
    var insi = max(insi, ins[u])
    if insi > 0: result = 1
    for (v, c) in g.edges[u]:
        if v == par: continue
        result += dfs(v, u, insi-1)
echo dfs(0, -1, 0)
