# verification-helper: PROBLEM https://judge.yosupo.jp/problem/cycle_detection
import cplib/graph/graph
import cplib/graph/cycle_detection
include cplib/tmpl/fastio

let n = ii()
let m = ii()
var g = initUnWeightedDirectedGraph(n)
for i in 0..<m:
    let u = ii()
    let v = ii()
    g.add_edge(u, v)
let cycle = g.cycle_detection()
if cycle.len == 0:
    echo -1
else:
    echo cycle.len
    for id in cycle: echo id
