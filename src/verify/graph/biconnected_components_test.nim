# verification-helper: PROBLEM https://judge.yosupo.jp/problem/biconnected_components
import cplib/graph/graph
import cplib/graph/biconnected_components
include cplib/tmpl/fastio

let n = ii()
let m = ii()
var g = initUnWeightedUnDirectedGraph(n)
for i in 0..<m:
    let u = ii()
    let v = ii()
    g.add_edge(u, v)
let decomposition = initBiconnectedComponents(g)
echo decomposition.groups.len
for group in decomposition.groups:
    stdout.write group.len
    for v in group: stdout.write " ", v
    stdout.write "\n"
