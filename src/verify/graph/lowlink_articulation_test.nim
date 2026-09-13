# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/GRL_3_A
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
for v in ll.articulation: echo v
