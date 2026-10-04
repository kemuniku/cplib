# verification-helper: PROBLEM https://judge.yosupo.jp/problem/min_cost_b_flow
import cplib/graph/min_cost_b_flow
import cplib/math/int128
import strutils, sequtils

let nm = stdin.readLine.split.map(parseInt)
var g = initMinCostBFlow(nm[0])
for v in 0..<nm[0]:
    g.add_supply(v, parseBiggestInt(stdin.readLine))
for i in 0..<nm[1]:
    let e = stdin.readLine.split.map(parseBiggestInt)
    g.add_edge(int(e[0]), int(e[1]), e[2], e[3], e[4])
let answer = g.solve()
if not answer.feasible:
    echo "infeasible"
else:
    echo answer.cost
    for p in g.get_potential():
        echo p
    for e in g.get_edges():
        echo e.flow
