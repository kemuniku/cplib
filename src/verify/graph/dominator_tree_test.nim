# verification-helper: PROBLEM https://judge.yosupo.jp/problem/dominatortree
import cplib/graph/graph
import cplib/graph/dominator_tree
include cplib/tmpl/fastio

let n = ii()
let m = ii()
let root = ii()
var g = initUnWeightedDirectedStaticGraph(n, capacity = m)
for i in 0..<m:
    let u = ii()
    let v = ii()
    g.add_edge(u, v)
g.build()
echo g.dominator_tree(root).join(" ")
