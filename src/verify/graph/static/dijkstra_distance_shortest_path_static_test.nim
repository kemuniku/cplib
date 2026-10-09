# verification-helper: PROBLEM https://judge.yosupo.jp/problem/shortest_path
include cplib/tmpl/sheep
import cplib/graph/graph
import cplib/graph/dijkstra

var N, M, s, t = ii()
var G = initWeightedDirectedStaticGraph(N)
for i in 0..<M:
    var a, b, c = ii()
    G.add_edge(a, b, c)
G.build()
let costs = G.dijkstra(s)
if costs[t] == INF:
    echo -1
else:
    var prev = newSeqWith(N, -1)
    var que = initDeque[int]()
    prev[s] = s
    que.addLast(s)
    while que.len > 0 and prev[t] == -1:
        let u = que.popFirst()
        for (v, w) in G.to_and_cost(u):
            if prev[v] == -1 and costs[u] + w == costs[v]:
                prev[v] = u
                que.addLast(v)
    doAssert prev[t] != -1
    var path = @[t]
    while path[^1] != s:
        path.add(prev[path[^1]])
    path.reverse()
    echo costs[t], " ", path.len - 1
    for i in 0..<path.len - 1:
        echo path[i], " ", path[i+1]
