# verification-helper: PROBLEM https://judge.yosupo.jp/problem/shortest_path
include cplib/tmpl/sheep
import cplib/graph/graph
import cplib/graph/shortest_path_graph

let N, M, s, t = ii()
var g = initWeightedDirectedGraph(N)
for _ in 0..<M:
    let a, b, c = ii()
    g.add_edge(a, b, c)
let extracted = g.shortest_path_graph(s, t)
if extracted.distance == high(int):
    echo -1
else:
    var prev = newSeqWith(N, -1)
    var prevEdge = newSeqWith(N, -1)
    var queue = @[s]
    prev[s] = s
    var cursor = 0
    while cursor < queue.len and prev[t] == -1:
        let u = queue[cursor]
        inc cursor
        for (v, id) in extracted.graph.to_and_id(u):
            if prev[v] != -1: continue
            prev[v] = u
            prevEdge[v] = extracted.original_edge_ids[id]
            queue.add(v)
    doAssert prev[t] != -1
    var path: seq[int]
    var v = t
    while v != s:
        path.add(prevEdge[v])
        v = prev[v]
    path.reverse()
    var cost = 0
    for id in path: cost += g.get_edge(id).cost
    doAssert cost == extracted.distance
    echo extracted.distance, " ", path.len
    for id in path:
        let e = g.get_edge(id)
        echo e.src, " ", e.dst
