# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/graph/graph
import cplib/graph/dijkstra
import cplib/graph/dijkstra_radix
import cplib/utils/constants

proc checkGraph(G: auto, starts: seq[int], zero, inf: int) =
    let expected = G.dijkstra(starts, zero, inf)
    doAssert G.dijkstra_radix(starts, zero, inf) == expected
    let restored = G.restore_dijkstra_radix(starts, zero, inf)
    doAssert restored.costs == expected
    for v in 0..<G.len:
        if expected[v] == inf: continue
        var current = v
        var steps = 0
        while restored.prev[current] != -1:
            let parent = restored.prev[current]
            var found = false
            for (dest, cost) in G.to_and_cost(parent):
                if dest == current and restored.costs[parent] + cost == restored.costs[current]:
                    found = true
            doAssert found
            current = parent
            inc steps
            doAssert steps < G.len
        doAssert current in starts
        doAssert restored.costs[current] == zero
    if starts.len == 0: return
    let single = G.dijkstra(starts[0], zero, inf)
    doAssert G.dijkstra_radix(starts[0], zero, inf) == single
    for goal in 0..<G.len:
        let answer = G.shortest_path_dijkstra_radix(starts[0], goal, zero, inf)
        doAssert answer.cost == single[goal]
        if single[goal] == inf:
            doAssert answer.path == @[goal]
        else:
            doAssert answer.path[0] == starts[0]
            doAssert answer.path[^1] == goal
            doAssert answer.path.len <= G.len
            var pathCost = zero
            for k in 1..<answer.path.len:
                var best = inf
                for (dest, cost) in G.to_and_cost(answer.path[k - 1]):
                    if dest == answer.path[k]: best = min(best, cost)
                doAssert best != inf
                pathCost += best
            doAssert pathCost == answer.cost

var rng = initRand(987654)
for trial in 0..<100:
    let n = rng.rand(1..25)
    var dynamic = initWeightedDirectedGraph(n)
    var fixed = initWeightedDirectedStaticGraph(n)
    var undirected = initWeightedUnDirectedGraph(n)
    var fixedUndirected = initWeightedUnDirectedStaticGraph(n)
    for edge in 0..<rng.rand(0..n * 5):
        let u = rng.rand(n - 1)
        let v = rng.rand(n - 1)
        let cost = rng.rand(0..100)
        dynamic.add_edge(u, v, cost)
        fixed.add_edge(u, v, cost)
        undirected.add_edge(u, v, cost)
        fixedUndirected.add_edge(u, v, cost)
    fixed.build()
    fixedUndirected.build()
    var starts: seq[int]
    for s in 0..<rng.rand(0..5): starts.add(rng.rand(n - 1))
    let zero = rng.rand(-200..0)
    checkGraph(dynamic, starts, zero, INF64)
    checkGraph(fixed, starts, zero, INF64)
    checkGraph(undirected, starts, zero, INF64)
    checkGraph(fixedUndirected, starts, zero, INF64)

proc checkInteger[T: SomeInteger]() =
    var g = initWeightedDirectedGraph(5, T)
    var sg = initWeightedDirectedStaticGraph(5, T)
    for edge in @[(0, 1, T(4)), (0, 2, T(1)), (2, 1, T(0)), (1, 3, T(2))]:
        g.add_edge(edge[0], edge[1], edge[2])
        sg.add_edge(edge[0], edge[1], edge[2])
    sg.build()
    let expected = @[T(0), T(1), T(1), T(3), high(T)]
    doAssert g.dijkstra_radix(0, T(0), high(T)) == expected
    doAssert sg.dijkstra_radix(0, T(0), high(T)) == expected
    doAssert g.dijkstra_radix(0)[3] == T(3)
    doAssert sg.restore_dijkstra_radix(0).costs[3] == T(3)
    doAssert g.shortest_path_dijkstra_radix(0, 3).path == @[0, 2, 1, 3]
    g.add_edge(0, 1, high(T) - T(1))
    g.add_edge(1, 4, high(T))
    doAssert g.dijkstra_radix(0, T(0), high(T)) == expected
    when T is SomeSignedInt:
        let shifted = g.dijkstra_radix(0, T(-5), high(T))
        doAssert shifted[3] == T(-2)
        doAssert shifted[4] == high(T) - T(4)
        var crossing = initWeightedDirectedGraph(3, T)
        crossing.add_edge(0, 1, high(T))
        crossing.add_edge(1, 2, T(2))
        doAssert crossing.dijkstra_radix(0, low(T), high(T)) == @[low(T), T(-1), T(1)]

checkInteger[int]()
checkInteger[int8]()
checkInteger[int16]()
checkInteger[int32]()
checkInteger[int64]()
checkInteger[uint]()
checkInteger[uint8]()
checkInteger[uint16]()
checkInteger[uint32]()
checkInteger[uint64]()

var ug = initUnWeightedDirectedGraph(4)
var usg = initUnWeightedDirectedStaticGraph(4)
var uug = initUnWeightedUnDirectedGraph(4)
var uusg = initUnWeightedUnDirectedStaticGraph(4)
for edge in @[(0, 1), (1, 2)]:
    ug.add_edge(edge[0], edge[1])
    usg.add_edge(edge[0], edge[1])
    uug.add_edge(edge[0], edge[1])
    uusg.add_edge(edge[0], edge[1])
usg.build()
uusg.build()
checkGraph(ug, @[0, 0], -3, INF64)
checkGraph(usg, @[0, 0], -3, INF64)
checkGraph(uug, @[0, 0], -3, INF64)
checkGraph(uusg, @[0, 0], -3, INF64)
doAssert ug.dijkstra_radix(0) == @[0, 1, 2, INF64]
doAssert usg.restore_dijkstra_radix(0).costs == @[0, 1, 2, INF64]
doAssert usg.shortest_path_dijkstra_radix(0, 0) == (@[0], 0)

var empty = initWeightedDirectedGraph(0)
doAssert empty.dijkstra_radix(newSeq[int]()).len == 0
var capped = initWeightedDirectedGraph(3)
capped.add_edge(0, 1, 5)
capped.add_edge(1, 2, 5)
checkGraph(capped, @[0], 0, 5)
doAssert capped.dijkstra_radix(0, 5, 5) == @[5, 5, 5]

when compileOption("assertions"):
    var rejected = false
    capped.add_edge(0, 2, -1)
    try:
        discard capped.dijkstra_radix(0)
    except AssertionDefect:
        rejected = true
    doAssert rejected

echo "Hello World"
