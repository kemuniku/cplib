# verification-helper: PROBLEM https://judge.yosupo.jp/problem/shortest_path
include cplib/tmpl/sheep
import cplib/graph/graph
import cplib/graph/dijkstra_radix

let N, M, s, t = ii()
var G = initWeightedDirectedGraph(N)
for i in 0..<M:
    let a, b, c = ii()
    G.add_edge(a, b, c)
let (path, cost) = G.shortest_path_dijkstra_radix(s, t)
if cost == INF64:
    echo -1
else:
    echo cost, " ", path.len - 1
    for i in 0..<path.len - 1:
        echo path[i], " ", path[i + 1]
