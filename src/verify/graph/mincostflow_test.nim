# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/GRL_6_B
import cplib/graph/mincostflow
import strutils, sequtils
let nmf = stdin.readLine.split.map(parseInt)
var g = initMinCostFlow[int, int64](nmf[0])
for i in 0..<nmf[1]:
    let e = stdin.readLine.split.map(parseInt)
    g.add_edge(e[0], e[1], e[2], int64(e[3]))
let answer = g.flow(0, nmf[0] - 1, nmf[2])
if answer.flow == nmf[2]:
    echo answer.cost
else:
    echo -1
