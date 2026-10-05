# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import hashes, tables
import cplib/utils/implicit_dijkstra
import cplib/utils/constants

type Vertex = object
    x, y: int

proc `==`(a, b: Vertex): bool = a.x == b.x and a.y == b.y
proc hash(v: Vertex): Hash = hash((v.x, v.y))

proc makeAdjacent(width, height: int, blocked: Vertex): proc(v: Vertex): seq[(Vertex, int)] {.closure.} =
    result = proc(v: Vertex): seq[(Vertex, int)] =
        for (dx, dy, cost) in @[(1, 0, 2), (-1, 0, 2), (0, 1, 1), (0, -1, 1)]:
            let next = Vertex(x: v.x + dx, y: v.y + dy)
            if next.x in 0..<width and next.y in 0..<height and next != blocked:
                result.add((next, cost))

let start = Vertex(x: 0, y: 0)
let goal = Vertex(x: 2, y: 0)
let adjacent = makeAdjacent(3, 2, Vertex(x: 1, y: 0))
let distances = implicit_dijkstra(start, adjacent)
doAssert distances[goal] == 6
doAssert not distances.hasKey(Vertex(x: 9, y: 9))

let targetX = 2
let untilX = implicit_dijkstra_until(
    start,
    adjacent,
    proc(v: Vertex): bool = v.x == targetX,
)
doAssert untilX == 5
doAssert implicit_dijkstra_until(start, adjacent, proc(v: Vertex): bool = v == start) == 0
doAssert implicit_dijkstra_until(start, adjacent, proc(v: Vertex): bool = v.x == 9) == INF64

let restored = restore_implicit_dijkstra(start, adjacent)
doAssert restored.costs[goal] == 6
doAssert restored.prev[goal] == Vertex(x: 2, y: 1)

let shortest = shortest_path_implicit_dijkstra(start, goal, adjacent)
doAssert shortest.cost == 6
doAssert shortest.path == @[
    Vertex(x: 0, y: 0),
    Vertex(x: 0, y: 1),
    Vertex(x: 1, y: 1),
    Vertex(x: 2, y: 1),
    Vertex(x: 2, y: 0),
]

let unreachable = shortest_path_implicit_dijkstra(
    start,
    Vertex(x: 9, y: 9),
    adjacent,
)
doAssert unreachable.cost == INF64
doAssert unreachable.path.len == 0

import random, sequtils
import cplib/graph/graph
import cplib/graph/dijkstra

proc checkGraph[T](states: seq[T], edges: seq[seq[(int, int)]], sources: seq[int]) =
    var graph = initWeightedDirectedGraph(states.len)
    for i, row in edges:
        for (j, cost) in row:
            graph.add_edge(i, j, cost)
    let expected = graph.dijkstra(sources)
    let starts = sources.mapIt(states[it])
    let adjacent: ImplicitDijkstraAdjacent[T] = proc(v: T): seq[(T, int)] =
        let i = states.find(v)
        doAssert i >= 0
        for (j, cost) in edges[i]:
            result.add((states[j], cost))
    let costs = implicit_dijkstra(starts, adjacent)
    let restored = restore_implicit_dijkstra(starts, adjacent)
    doAssert costs == restored.costs
    for i, v in states:
        doAssert costs.hasKey(v) == (expected[i] != INF64)
        if costs.hasKey(v):
            doAssert costs[v] == expected[i]
            var current = v
            var steps = 0
            while restored.prev.hasKey(current):
                let parent = restored.prev[current]
                var validEdge = false
                for (j, cost) in edges[states.find(parent)]:
                    if states[j] == current and costs[parent] + cost == costs[current]:
                        validEdge = true
                doAssert validEdge
                current = parent
                inc steps
                doAssert steps < states.len
            doAssert current in starts and costs[current] == 0
        if v in starts:
            doAssert not restored.prev.hasKey(v)
        let finish: ImplicitDijkstraFinish[T] = proc(u: T): bool = u == v
        doAssert implicit_dijkstra_until(starts, adjacent, finish) == expected[i]
        let path = shortest_path_implicit_dijkstra(starts, v, adjacent)
        doAssert path.cost == expected[i]
        if expected[i] == INF64:
            doAssert path.path.len == 0
        else:
            doAssert path.path[0] in starts and path.path[^1] == v
            var total = 0
            for k in 1..<path.path.len:
                let parent = path.path[k-1]
                let child = path.path[k]
                var edgeCost = INF64
                for (j, cost) in edges[states.find(parent)]:
                    if states[j] == child:
                        edgeCost = min(edgeCost, cost)
                doAssert edgeCost != INF64
                total += edgeCost
            doAssert total == path.cost
    for goals in @[newSeq[T](), @[states[0], states[^1], states[0]], states]:
        var best = INF64
        for g in goals:
            best = min(best, expected[states.find(g)])
        doAssert implicit_dijkstra_until(starts, adjacent, goals) == best
        doAssert implicit_dijkstra_until[T](starts, adjacent, goals) == best
        let path = shortest_path_implicit_dijkstra(starts, goals, adjacent)
        doAssert shortest_path_implicit_dijkstra[T](starts, goals, adjacent) == path
        doAssert path.cost == best
        if best == INF64:
            doAssert path.path.len == 0
        else:
            doAssert path.path[0] in starts and path.path[^1] in goals
            var total = 0
            for k in 1..<path.path.len:
                var cost = INF64
                for (j, w) in edges[states.find(path.path[k-1])]:
                    if states[j] == path.path[k]:
                        cost = min(cost, w)
                doAssert cost != INF64
                total += cost
            doAssert total == best
    if sources.len > 0:
        let s = starts[0]
        let single = implicit_dijkstra(s, adjacent)
        doAssert single == implicit_dijkstra([s], adjacent)
        doAssert implicit_dijkstra[T](s, adjacent) == single
        doAssert implicit_dijkstra[T]([s], adjacent) == single
        let goals = @[states[0], states[^1], states[0]]
        doAssert implicit_dijkstra_until(s, adjacent, goals) == implicit_dijkstra_until([s], adjacent, goals)
        doAssert implicit_dijkstra_until[T](s, adjacent, goals) == implicit_dijkstra_until[T]([s], adjacent, goals)
        doAssert shortest_path_implicit_dijkstra(s, goals, adjacent) == shortest_path_implicit_dijkstra([s], goals, adjacent)
        doAssert shortest_path_implicit_dijkstra[T](s, goals, adjacent) == shortest_path_implicit_dijkstra[T]([s], goals, adjacent)
        let singleRestore = restore_implicit_dijkstra(s, adjacent)
        doAssert singleRestore.costs == single
        doAssert restore_implicit_dijkstra[T]([s], adjacent).prev == singleRestore.prev
        let finish: ImplicitDijkstraFinish[T] = proc(u: T): bool = u == states[^1]
        doAssert implicit_dijkstra_until(s, adjacent, finish) == implicit_dijkstra_until([s], adjacent, finish)
        doAssert implicit_dijkstra_until[T](s, adjacent, finish) == implicit_dijkstra_until[T]([s], adjacent, finish)
        doAssert shortest_path_implicit_dijkstra(s, states[^1], adjacent) == shortest_path_implicit_dijkstra([s], states[^1], adjacent)
        doAssert shortest_path_implicit_dijkstra[T](s, states[^1], adjacent) == shortest_path_implicit_dijkstra[T]([s], states[^1], adjacent)
        doAssert shortest_path_implicit_dijkstra(s, s, adjacent).path == @[s]
    let never: ImplicitDijkstraFinish[T] = proc(v: T): bool = false
    doAssert implicit_dijkstra_until(starts, adjacent, never, INF = -123) == -123
    doAssert implicit_dijkstra_until(start = starts, adjacent = adjacent, finish = never, INF = -321) == -321

var rng = initRand(20261005)
for trial in 0..<250:
    let n = rng.rand(1..12)
    var edges = newSeq[seq[(int, int)]](n)
    for i in 0..<n:
        for j in 0..<n:
            if rng.rand(0..3) == 0:
                edges[i].add((j, rng.rand(0..8)))
                if rng.rand(0..4) == 0:
                    edges[i].add((j, rng.rand(0..8)))
    var sources: seq[int]
    for k in 0..<rng.rand(0..n+2):
        sources.add(rng.rand(0..<n))
    checkGraph(toSeq(0..<n), edges, sources)
    checkGraph(toSeq(0..<n).mapIt((x: it, tag: "tuple")), edges, sources)
    checkGraph(toSeq(0..<n).mapIt(@[it, 42]), edges, sources)

block:
    var expansions, predicates: int
    let adjacent: ImplicitDijkstraAdjacent[int] = proc(v: int): seq[(int, int)] =
        inc expansions
        doAssert false
    let finish: ImplicitDijkstraFinish[int] = proc(v: int): bool =
        inc predicates
        true
    let empty = newSeq[int]()
    let restored = restore_implicit_dijkstra(empty, adjacent)
    doAssert restored.costs.len == 0 and restored.prev.len == 0
    doAssert implicit_dijkstra(empty, adjacent).len == 0
    doAssert implicit_dijkstra(newSeq[int](), adjacent).len == 0
    doAssert implicit_dijkstra_until(empty, adjacent, finish, -17) == -17
    let missing = shortest_path_implicit_dijkstra(empty, 1, adjacent, -17)
    doAssert missing.path.len == 0 and missing.cost == -17
    doAssert expansions == 0 and predicates == 0
    doAssert implicit_dijkstra_until(@[1, 1, 2], adjacent, finish) == 0
    doAssert shortest_path_implicit_dijkstra(@[1, 1, 2], 1, adjacent).path == @[1]
    doAssert expansions == 0 and predicates == 1

block:
    var expansions: int
    let adjacent: ImplicitDijkstraAdjacent[int] = proc(v: int): seq[(int, int)] =
        inc expansions
        result = @[(v, 0), (v, 1)]
    let restored = restore_implicit_dijkstra(@[7, 7, 7], adjacent)
    doAssert restored.costs.len == 1 and restored.costs[7] == 0
    doAssert restored.prev.len == 0 and expansions == 1
    doAssert shortest_path_implicit_dijkstra(@[7, 7], 8, adjacent, 99).cost == 99

block:
    let infinite: ImplicitDijkstraAdjacent[int] = proc(v: int): seq[(int, int)] = @[(v + 1, 1)]
    doAssert implicit_dijkstra_until(0, infinite, proc(v: int): bool = v == 4) == 4
    doAssert shortest_path_implicit_dijkstra(@[0, 1], 4, infinite).cost == 3

block:
    let adjacent: ImplicitDijkstraAdjacent[int] = proc(v: int): seq[(int, int)] =
        if v == 0: @[(1, high(int)), (2, INF64 + 10)]
        elif v == 1: @[(3, 0)]
        else: @[]
    doAssert implicit_dijkstra(0, adjacent)[3] == high(int)
    doAssert implicit_dijkstra_until(0, adjacent, proc(v: int): bool = v == 3) == high(int)
    doAssert shortest_path_implicit_dijkstra(0, 3, adjacent).cost == high(int)
    doAssert shortest_path_implicit_dijkstra(0, 3, adjacent).path == @[0, 1, 3]


type CollisionState = object
    id: int
proc hash(v: CollisionState): Hash = Hash(0)
proc `==`(a, b: CollisionState): bool = a.id == b.id

block:
    let states = @[CollisionState(id: 0), CollisionState(id: 1), CollisionState(id: 2), CollisionState(id: 3)]
    let edges = @[@[(0, 0), (1, 0), (1, 0)], @[(0, 0), (2, 0)], @[(2, 0)], newSeq[(int, int)]()]
    checkGraph(states, edges, @[0, 1, 1])
    checkGraph(states, edges, @[])
    checkGraph(states, edges, @[0])

block:
    var expansions: int
    let adjacent: ImplicitDijkstraAdjacent[int] = proc(v: int): seq[(int, int)] =
        inc expansions
        doAssert false
    doAssert implicit_dijkstra_until(@[0], adjacent, newSeq[int](), -22) == -22
    doAssert implicit_dijkstra_until(0, adjacent, newSeq[int](), -22) == -22
    doAssert shortest_path_implicit_dijkstra(@[0], newSeq[int](), adjacent, -22) == (@[], -22)
    doAssert shortest_path_implicit_dijkstra(0, newSeq[int](), adjacent, -22) == (@[], -22)
    doAssert implicit_dijkstra_until(@[1, 0, 1], adjacent, @[1, 1]) == 0
    doAssert shortest_path_implicit_dijkstra(@[1, 0, 1], @[1, 1], adjacent) == (@[1], 0)
    doAssert implicit_dijkstra_until(0, adjacent, [0, 0]) == 0
    doAssert shortest_path_implicit_dijkstra([0], [0, 0], adjacent) == (@[0], 0)
    doAssert expansions == 0

block:
    var expanded: seq[int]
    let adjacent: ImplicitDijkstraAdjacent[int] = proc(v: int): seq[(int, int)] =
        expanded.add(v)
        case v
        of 0: @[(1, 10), (2, 1), (3, 5)]
        of 2: @[(1, 1)]
        else: @[]
    doAssert implicit_dijkstra_until(0, adjacent, @[1, 3, 1]) == 2
    doAssert expanded == @[0, 2]
    expanded.setLen(0)
    doAssert shortest_path_implicit_dijkstra(0, @[1, 3, 1], adjacent) == (@[0, 2, 1], 2)
    doAssert expanded == @[0, 2]

block:
    let emptyState = newSeq[int]()
    let adjacent: ImplicitDijkstraAdjacent[seq[int]] = proc(v: seq[int]): seq[(seq[int], int)] =
        if v.len == 0: @[( @[1], 1)]
        else: @[]
    let costs = implicit_dijkstra(emptyState, adjacent)
    doAssert costs.len == 2 and costs[emptyState] == 0 and costs[@[1]] == 1
    doAssert restore_implicit_dijkstra(emptyState, adjacent).prev[@[1]] == emptyState
    doAssert implicit_dijkstra(newSeq[seq[int]](), adjacent).len == 0
    doAssert shortest_path_implicit_dijkstra(emptyState, emptyState, adjacent) == (@[emptyState], 0)
    doAssert shortest_path_implicit_dijkstra(emptyState, @[1], adjacent) == (@[emptyState, @[1]], 1)
    doAssert shortest_path_implicit_dijkstra([emptyState], [@[1]], adjacent) == (@[emptyState, @[1]], 1)
    doAssert implicit_dijkstra_until(emptyState, adjacent, [@[1]]) == 1
