# verification-helper: PROBLEM https://judge.yosupo.jp/problem/shortest_path
include cplib/tmpl/sheep
import cplib/utils/implicit_dijkstra

var N, M, s, t = ii()
var edges = newSeq[seq[(int, int)]](N)
var starts = @[s]
var goals = @[t]
for i in 0..<M:
    var a, b, c = ii()
    edges[a].add((b, c))
    if a == s and c == 0:
        starts.add(b)
    if b == t and c == 0:
        goals.add(a)

let adjacent: ImplicitDijkstraAdjacent[int] = proc(v: int): seq[(int, int)] = edges[v]
# s から／t への重み 0 の辺で始終点を拡張し、返る経路にその辺を補う。
var (path, cost) = shortest_path_implicit_dijkstra(starts, goals, adjacent)
if path.len == 0:
    echo -1
else:
    if path[0] != s:
        path.insert(s, 0)
    if path[^1] != t:
        path.add(t)
    echo cost, " ", path.len - 1
    for i in 1..<path.len:
        echo path[i - 1], " ", path[i]
