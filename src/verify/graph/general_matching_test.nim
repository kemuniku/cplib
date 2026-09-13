# verification-helper: PROBLEM https://judge.yosupo.jp/problem/general_matching
import cplib/graph/graph
import cplib/graph/general_matching
include cplib/tmpl/fastio

let n = ii()
let m = ii()
var g = initUnWeightedUnDirectedGraph(n)
for i in 0..<m:
    let u = ii()
    let v = ii()
    g.add_edge(u, v)
let matching = g.maximum_matching()
echo matching.len
for (u, v) in matching:
    echo u, " ", v
