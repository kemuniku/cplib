# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/graph
import cplib/tree/rerooting

type VertexValue = object
    count: int

proc merge(a, b: int): int = a + b
proc putEdge(x: VertexValue, u, v: int): int = x.count
proc putVertex(x: int, v: int): VertexValue = VertexValue(count: x + 1)

for n in 0..8:
    var g = initUnWeightedUnDirectedGraph(n)
    for v in 1..<n:
        g.add_edge((v - 1) div 2, v)
    let raw = solve_Rerooting_raw(g, merge, 0, putEdge, putVertex)
    let values = solve_Rerooting(g, merge, 0, putEdge, putVertex)
    doAssert raw.len == n
    doAssert values.len == n
    for v in 0..<n:
        doAssert raw[v] == n - 1
        doAssert values[v].count == n

proc sameEdge(x: int, u, v: int): int = x
proc sameVertex(x: int, v: int): int = x + 1

var g = initUnWeightedUnDirectedGraph(3)
g.add_edge(0, 1)
g.add_edge(1, 2)
doAssert solve_Rerooting(g, merge, 0, sameEdge, sameVertex) == @[3, 3, 3]
echo "Hello World"
