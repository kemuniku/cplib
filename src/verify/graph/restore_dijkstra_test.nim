# verification-helper: PROBLEM https://judge.yosupo.jp/problem/shortest_path
include cplib/tmpl/sheep
import cplib/graph/graph
import cplib/graph/dijkstra
var N,M,s,t = ii()
var G = initWeightedDirectedGraph(N)
for i in 0..<M:
    var a,b,c = ii()
    G.add_edge(a,b,c)
var (path,cost) = G.shortest_path(s,t)
if len(path) == 1:
    echo -1
else:
    echo cost," ",len(path)-1
    for i in 0..<len(path)-1:
        echo path[i]," ",path[i+1]