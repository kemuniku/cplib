# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/GRL_3_B
import algorithm
import cplib/graph/graph
import cplib/graph/lowlink
include cplib/tmpl/fastio

let n = ii()
let m = ii()
var g = initUnWeightedUnDirectedGraph(n)
for i in 0..<m:
    let u = ii()
    let v = ii()
    g.add_edge(u, v)
let ll = initLowLink(g)
var bridges: seq[(int, int)]
for (u, v) in ll.bridges: bridges.add((min(u, v), max(u, v)))
bridges.sort()
for (u, v) in bridges: echo u, " ", v
