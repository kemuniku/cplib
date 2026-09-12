# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/GRL_6_A
import cplib/graph/maxflow
import strutils, sequtils
let nm = stdin.readLine.split.map(parseInt)
var g = initMaxFlow[int](nm[0])
for i in 0..<nm[1]:
    let e = stdin.readLine.split.map(parseInt)
    g.add_edge(e[0], e[1], e[2])
echo g.flow(0, nm[0] - 1)
