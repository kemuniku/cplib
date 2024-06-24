# verification-helper: PROBLEM https://judge.yosupo.jp/problem/shortest_path
include cplib/tmpl/sheep
include cplib/graph/graph
include cplib/graph/dijkstra
var N, M, s, t = ii()
var G = initWeightedDirectedStaticGraph(N)
for i in 0..<M:
    var a, b, c = ii()
    G.add_edge(a, b, c)
G.build()
var (path, cost) = G.shortest_path_dijkstra(s, t)
if len(path) == 1:
    echo -1
else:
    echo cost, " ", len(path)-1
    for i in 0..<len(path)-1:
        echo path[i], " ", path[i+1]
