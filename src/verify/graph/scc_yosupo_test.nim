# verification-helper: PROBLEM https://judge.yosupo.jp/problem/scc
import cplib/graph/graph
import cplib/graph/SCC
include cplib/tmpl/fastio
let n = ii()
let m = ii()
var g = initUnWeightedDirectedGraph(n)
for _ in 0..<m:
    let u = ii()
    let v = ii()
    g.add_edge(u, v)
let groups = SCC(g)
print groups.len
for group in groups:
    print(group.len, *group)
