# verification-helper: PROBLEM https://judge.yosupo.jp/problem/shortest_path
include cplib/tmpl/sheep
import cplib/graph/graph
import cplib/graph/dijkstra
var N,M,s,t = ii()
var G = initWeightedDirectedGraph(N)
for i in 0..<M:
    var a,b,c = ii()
    G.add_edge(a,b,c)
var (costs,prev) = G.restore_dijkstra(s)
if costs[t] == INF:
    echo -1
else:
    var path = prev.restore_shortestpath_from_prev(t)
    echo costs[t]," ",len(path)-1
    for i in 0..<len(path)-1:
        echo path[i]," ",path[i+1]