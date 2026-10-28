# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sequtils
import cplib/graph/graph
import cplib/graph/dijkstra
import cplib/utils/constants

type
    Distance = object
        value: int
    Timetable = object
        travel, interval: int

proc `<`(a, b: Distance): bool = a.value < b.value
proc arrive(d: Distance, edge: Timetable): Distance =
    Distance(value: ((d.value + edge.interval - 1) div edge.interval) * edge.interval + edge.travel)

let zero = Distance(value: 0)
let infinity = Distance(value: 1_000_000)

template checkTimetable(g: untyped) =
    doAssert dijkstra[Distance, Timetable](g, 0, arrive, zero, infinity) ==
        @[zero, Distance(value: 2), Distance(value: 6), Distance(value: 9), infinity]
    let restored = g.restore_dijkstra(0, arrive, zero, infinity)
    doAssert restored.prev == @[-1, 0, 1, 2, -1]
    doAssert restored.costs == g.dijkstra(0, arrive, zero, infinity)
    let path = g.shortest_path_dijkstra(0, 3, arrive, zero, infinity)
    doAssert path.path == @[0, 1, 2, 3]
    doAssert path.cost == Distance(value: 9)
    let missing = g.shortest_path_dijkstra(0, 4, arrive, zero, infinity)
    doAssert missing.path == @[4]
    doAssert missing.cost == infinity
    doAssert g.shortest_path_dijkstra(0, 0, arrive, zero, infinity) == (@[0], zero)
    let multi = g.restore_dijkstra(@[0, 2, 0], arrive, zero, infinity)
    doAssert multi.costs == @[zero, zero, zero, Distance(value: 1), infinity]
    doAssert multi.prev == @[-1, 2, -1, 2, -1]
    let empty = g.restore_dijkstra(newSeq[int](), arrive, zero, infinity)
    doAssert empty.costs == newSeqWith(5, infinity)
    doAssert empty.prev == newSeqWith(5, -1)

var dynamicGraph = initWeightedDirectedGraph(5, Timetable)
var staticGraph = initWeightedDirectedStaticGraph(5, Timetable)
for (u, v, travel, interval) in [(0, 1, 2, 1), (0, 2, 20, 1), (1, 2, 1, 5),
        (2, 3, 1, 4), (0, 0, 0, 1), (0, 1, 3, 1), (2, 1, 0, 1)]:
    let edge = Timetable(travel: travel, interval: interval)
    dynamicGraph.add_edge(u, v, edge)
    staticGraph.add_edge(u, v, edge)
staticGraph.build()
checkTimetable(dynamicGraph)
checkTimetable(staticGraph)

block:
    let wait = 2
    let add = proc(d: int64, edge: int): int64 = d + int64(edge + wait)
    var g = initWeightedUnDirectedGraph(3)
    var sg = initWeightedUnDirectedStaticGraph(3)
    g.add_edge(0, 1, 3)
    g.add_edge(1, 2, 4)
    sg.add_edge(0, 1, 3)
    sg.add_edge(1, 2, 4)
    sg.build()
    doAssert g.dijkstra(2, add, 10'i64, 1000'i64) == @[21'i64, 16, 10]
    doAssert sg.dijkstra(2, add, 10'i64, 1000'i64) == @[21'i64, 16, 10]

block:
    let add = proc(d: Distance, edge: int): Distance = Distance(value: d.value + edge)
    var g = initUnWeightedDirectedGraph(3)
    var sg = initUnWeightedDirectedStaticGraph(3)
    g.add_edge(0, 1)
    sg.add_edge(0, 1)
    sg.build()
    doAssert g.dijkstra(0, add, zero, infinity) == @[zero, Distance(value: 1), infinity]
    doAssert sg.dijkstra(0, add, zero, infinity) == @[zero, Distance(value: 1), infinity]
    let emptyGraph = initWeightedDirectedGraph(0, Timetable)
    doAssert emptyGraph.dijkstra(newSeq[int](), arrive, zero, infinity).len == 0

var rng = initRand(20261026)
for trial in 0..<100:
    let n = rng.rand(1..8)
    var g = initWeightedDirectedGraph(n, Timetable)
    var sg = initWeightedDirectedStaticGraph(n, Timetable)
    for u in 0..<n:
        for v in 0..<n:
            if rng.rand(0..3) == 0:
                let edge = Timetable(travel: rng.rand(0..9), interval: rng.rand(1..5))
                g.add_edge(u, v, edge)
                sg.add_edge(u, v, edge)
    sg.build()
    var starts = newSeq[int](rng.rand(0..n + 2))
    var expected = newSeqWith(n, infinity)
    for s in starts.mitems:
        s = rng.rand(0..<n)
        expected[s] = zero
    for iteration in 0..<n:
        for edge in g.edge_info:
            if expected[edge.src] != infinity:
                let next = arrive(expected[edge.src], edge.cost)
                if next < expected[edge.dst]:
                    expected[edge.dst] = next
    doAssert g.dijkstra(starts, arrive, zero, infinity) == expected
    doAssert sg.dijkstra(starts, arrive, zero, infinity) == expected

block:
    var g = initWeightedDirectedGraph(3)
    g.add_edge(0, 1, 5)
    g.add_edge(1, 2, 7)
    g.add_edge(0, 2, 10)
    let minimax = proc(d, edge: int): int = max(d, edge)
    doAssert g.dijkstra(0, minimax, 0, 1000) == @[0, 5, 7]
    doAssert g.dijkstra(0) == @[0, 5, 10]

template checkLegacy(T: typedesc, zero, infinity: untyped) =
    block:
        var g = initWeightedDirectedGraph(3, T)
        var sg = initWeightedDirectedStaticGraph(3, T)
        g.add_edge(0, 1, T(2))
        sg.add_edge(0, 1, T(2))
        sg.build()
        doAssert g.dijkstra(0) == @[T(0), T(2), infinity]
        doAssert sg.dijkstra(0) == @[T(0), T(2), infinity]
        doAssert dijkstra[T](g, 0, zero, infinity) == @[T(0), T(2), infinity]
        doAssert g.restore_dijkstra(@[0, 2]).costs == @[T(0), T(2), T(0)]
        doAssert sg.shortest_path_dijkstra(0, 1) == (@[0, 1], T(2))

checkLegacy(int, 0, INF64)
checkLegacy(int32, 0'i32, INF32)
checkLegacy(float, 0.0, 1e100)
checkLegacy(float32, 0.0'f32, 1e30'f32)

block:
    var g = initUnWeightedUnDirectedGraph(3)
    var sg = initUnWeightedUnDirectedStaticGraph(3)
    g.add_edge(0, 1)
    sg.add_edge(0, 1)
    sg.build()
    doAssert g.dijkstra(0, 0, 1000) == @[0, 1, 1000]
    doAssert sg.dijkstra(0, 0, 1000) == @[0, 1, 1000]
    doAssert g.restore_dijkstra(0).prev == @[-1, 0, -1]
    doAssert sg.shortest_path_dijkstra(0, 1) == (@[0, 1], 1)

echo "Hello World"
