# verification-helper: PROBLEM https://judge.yosupo.jp/problem/k_shortest_walk
include cplib/tmpl/sheep
import cplib/graph/graph
import cplib/graph/k_shortest_walk

let n, m, s, t, k = ii()
var g = initWeightedDirectedGraph(n)
for _ in 0..<m:
    let a, b, c = ii()
    g.add_edge(a, b, c)
let lengths = g.k_shortest_walk(s, t, k)
for i in 0..<k:
    echo (if lengths[i] == INF: -1 else: lengths[i])
