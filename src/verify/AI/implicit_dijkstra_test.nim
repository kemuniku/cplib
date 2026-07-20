# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import std/[hashes, tables]
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
