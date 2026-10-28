# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sequtils
import cplib/graph/graph
import cplib/graph/dijkstra

type Distance = object
    value: int
    path: string

proc `<`(a, b: Distance): bool {.error: "Distance の比較には cmp を使うこと".}
proc `==`(a, b: Distance): bool {.error: "Distance の同順位判定には cmp を使うこと".}

let zero = Distance(value: 0, path: "start")
let infinity = Distance(value: 1000, path: "unreachable")
let direction = 1
let compare = proc(a, b: Distance): int = direction * system.cmp(a.value, b.value)
var staleExpansions = 0
let add = proc(d: Distance, edge: int): Distance =
    if d.value == 10: inc staleExpansions
    Distance(value: d.value + edge, path: d.path & " " & $edge)

template check(g: untyped) =
    let costs = g.dijkstra(0, add, zero, infinity, cmp = compare)
    for i, value in [0, 2, 1, 3, 2, 1000]:
        doAssert costs[i].value == value
    let restored = g.restore_dijkstra(0, add, zero, infinity, compare)
    doAssert restored.prev == @[-1, 2, 0, 1, 0, -1]
    let shortest = g.shortest_path_dijkstra(0, 3, add, zero, infinity, compare)
    doAssert shortest.path == @[0, 2, 1, 3]
    doAssert shortest.cost.value == 3
    doAssert shortest.cost.path == "start 1 1 1"
    let missing = g.shortest_path_dijkstra(0, 5, add, zero, infinity, compare)
    doAssert missing.cost.value == infinity.value
    doAssert missing.path == @[5]
    let same = g.shortest_path_dijkstra(0, 0, add, zero, infinity, compare)
    doAssert same.cost.value == 0
    doAssert same.path == @[0]
    let multi = g.restore_dijkstra(@[0, 2, 0], add, zero, infinity, compare)
    for i, value in [0, 1, 0, 2, 2, 1000]:
        doAssert multi.costs[i].value == value
    doAssert multi.prev[0] == -1
    doAssert multi.prev[2] == -1
    let empty = g.restore_dijkstra(newSeq[int](), add, zero, infinity, compare)
    doAssert empty.prev == newSeqWith(6, -1)
    for d in empty.costs: doAssert d.value == infinity.value
    doAssert staleExpansions == 0

var g = initWeightedDirectedGraph(6)
var sg = initWeightedDirectedStaticGraph(6)
for (u, v, edge) in [(0, 1, 10), (0, 2, 1), (2, 1, 1), (1, 3, 1),
        (2, 3, 30), (0, 4, 2), (4, 3, 1), (0, 0, 0), (1, 1, 0)]:
    g.add_edge(u, v, edge)
    sg.add_edge(u, v, edge)
sg.build()
check(g)
check(sg)

block:
    var g = initUnWeightedUnDirectedGraph(3)
    var sg = initUnWeightedUnDirectedStaticGraph(3)
    g.add_edge(0, 1)
    sg.add_edge(0, 1)
    sg.build()
    doAssert g.dijkstra(0, add, zero, infinity, compare)[1].value == 1
    doAssert sg.dijkstra(0, add, zero, infinity, compare)[2].value == 1000

var rng = initRand(20261026)
for trial in 0..<100:
    let n = rng.rand(1..8)
    var g = initWeightedDirectedGraph(n)
    var sg = initWeightedDirectedStaticGraph(n)
    for u in 0..<n:
        for v in 0..<n:
            if rng.rand(0..3) == 0:
                let weight = rng.rand(0..9)
                g.add_edge(u, v, weight)
                sg.add_edge(u, v, weight)
    sg.build()
    let start = rng.rand(0..<n)
    var expected = newSeqWith(n, -1)
    expected[start] = 1000
    for iteration in 0..<n:
        for e in g.edge_info:
            if expected[e.src] != -1:
                expected[e.dst] = max(expected[e.dst], min(expected[e.src], e.cost))
    let reverse = trial mod 2 == 0
    let compare = proc(a, b: int): int =
        if reverse: system.cmp(b, a)
        else: system.cmp(-a, -b)
    let bottleneck = proc(d, edge: int): int = min(d, edge)
    doAssert g.dijkstra(start, bottleneck, 1000, -1, compare) == expected
    doAssert sg.dijkstra(start, bottleneck, 1000, -1, compare) == expected
    let sum = proc(d, edge: int): int = d + edge
    doAssert g.dijkstra(start, sum, 0, 1000) == g.dijkstra(start, 0, 1000)

echo "Hello World"
