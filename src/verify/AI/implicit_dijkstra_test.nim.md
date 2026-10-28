---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dijkstra.nim
    title: cplib/graph/dijkstra.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dijkstra.nim
    title: cplib/graph/dijkstra.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/restore_shortest_path_from_prev.nim
    title: cplib/graph/restore_shortest_path_from_prev.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/restore_shortest_path_from_prev.nim
    title: cplib/graph/restore_shortest_path_from_prev.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/implicit_dijkstra.nim
    title: cplib/utils/implicit_dijkstra.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/implicit_dijkstra.nim
    title: cplib/utils/implicit_dijkstra.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    echo \"Hello World\"\n\nimport hashes, tables\nimport cplib/utils/implicit_dijkstra\n\
    import cplib/utils/constants\n\ntype Vertex = object\n    x, y: int\n\nproc `==`(a,\
    \ b: Vertex): bool = a.x == b.x and a.y == b.y\nproc hash(v: Vertex): Hash = hash((v.x,\
    \ v.y))\n\nproc makeAdjacent(width, height: int, blocked: Vertex): proc(v: Vertex):\
    \ seq[(Vertex, int)] {.closure.} =\n    result = proc(v: Vertex): seq[(Vertex,\
    \ int)] =\n        for (dx, dy, cost) in @[(1, 0, 2), (-1, 0, 2), (0, 1, 1), (0,\
    \ -1, 1)]:\n            let next = Vertex(x: v.x + dx, y: v.y + dy)\n        \
    \    if next.x in 0..<width and next.y in 0..<height and next != blocked:\n  \
    \              result.add((next, cost))\n\nlet start = Vertex(x: 0, y: 0)\nlet\
    \ goal = Vertex(x: 2, y: 0)\nlet adjacent = makeAdjacent(3, 2, Vertex(x: 1, y:\
    \ 0))\nlet distances = implicit_dijkstra(start, adjacent)\ndoAssert distances[goal]\
    \ == 6\ndoAssert not distances.hasKey(Vertex(x: 9, y: 9))\n\nlet targetX = 2\n\
    let untilX = implicit_dijkstra_until(\n    start,\n    adjacent,\n    proc(v:\
    \ Vertex): bool = v.x == targetX,\n)\ndoAssert untilX == 5\ndoAssert implicit_dijkstra_until(start,\
    \ adjacent, proc(v: Vertex): bool = v == start) == 0\ndoAssert implicit_dijkstra_until(start,\
    \ adjacent, proc(v: Vertex): bool = v.x == 9) == INF64\n\nlet restored = restore_implicit_dijkstra(start,\
    \ adjacent)\ndoAssert restored.costs[goal] == 6\ndoAssert restored.prev[goal]\
    \ == Vertex(x: 2, y: 1)\n\nlet shortest = shortest_path_implicit_dijkstra(start,\
    \ goal, adjacent)\ndoAssert shortest.cost == 6\ndoAssert shortest.path == @[\n\
    \    Vertex(x: 0, y: 0),\n    Vertex(x: 0, y: 1),\n    Vertex(x: 1, y: 1),\n \
    \   Vertex(x: 2, y: 1),\n    Vertex(x: 2, y: 0),\n]\n\nlet unreachable = shortest_path_implicit_dijkstra(\n\
    \    start,\n    Vertex(x: 9, y: 9),\n    adjacent,\n)\ndoAssert unreachable.cost\
    \ == INF64\ndoAssert unreachable.path.len == 0\n\nimport random, sequtils\nimport\
    \ cplib/graph/graph\nimport cplib/graph/dijkstra\n\nproc checkGraph[T](states:\
    \ seq[T], edges: seq[seq[(int, int)]], sources: seq[int]) =\n    var graph = initWeightedDirectedGraph(states.len)\n\
    \    for i, row in edges:\n        for (j, cost) in row:\n            graph.add_edge(i,\
    \ j, cost)\n    let expected = graph.dijkstra(sources)\n    let starts = sources.mapIt(states[it])\n\
    \    let adjacent: ImplicitDijkstraAdjacent[T] = proc(v: T): seq[(T, int)] =\n\
    \        let i = states.find(v)\n        doAssert i >= 0\n        for (j, cost)\
    \ in edges[i]:\n            result.add((states[j], cost))\n    let costs = implicit_dijkstra(starts,\
    \ adjacent)\n    let restored = restore_implicit_dijkstra(starts, adjacent)\n\
    \    doAssert costs == restored.costs\n    for i, v in states:\n        doAssert\
    \ costs.hasKey(v) == (expected[i] != INF64)\n        if costs.hasKey(v):\n   \
    \         doAssert costs[v] == expected[i]\n            var current = v\n    \
    \        var steps = 0\n            while restored.prev.hasKey(current):\n   \
    \             let parent = restored.prev[current]\n                var validEdge\
    \ = false\n                for (j, cost) in edges[states.find(parent)]:\n    \
    \                if states[j] == current and costs[parent] + cost == costs[current]:\n\
    \                        validEdge = true\n                doAssert validEdge\n\
    \                current = parent\n                inc steps\n               \
    \ doAssert steps < states.len\n            doAssert current in starts and costs[current]\
    \ == 0\n        if v in starts:\n            doAssert not restored.prev.hasKey(v)\n\
    \        let finish: ImplicitDijkstraFinish[T] = proc(u: T): bool = u == v\n \
    \       doAssert implicit_dijkstra_until(starts, adjacent, finish) == expected[i]\n\
    \        let path = shortest_path_implicit_dijkstra(starts, v, adjacent)\n   \
    \     doAssert path.cost == expected[i]\n        if expected[i] == INF64:\n  \
    \          doAssert path.path.len == 0\n        else:\n            doAssert path.path[0]\
    \ in starts and path.path[^1] == v\n            var total = 0\n            for\
    \ k in 1..<path.path.len:\n                let parent = path.path[k-1]\n     \
    \           let child = path.path[k]\n                var edgeCost = INF64\n \
    \               for (j, cost) in edges[states.find(parent)]:\n               \
    \     if states[j] == child:\n                        edgeCost = min(edgeCost,\
    \ cost)\n                doAssert edgeCost != INF64\n                total +=\
    \ edgeCost\n            doAssert total == path.cost\n    for goals in @[newSeq[T](),\
    \ @[states[0], states[^1], states[0]], states]:\n        var best = INF64\n  \
    \      for g in goals:\n            best = min(best, expected[states.find(g)])\n\
    \        doAssert implicit_dijkstra_until(starts, adjacent, goals) == best\n \
    \       doAssert implicit_dijkstra_until[T](starts, adjacent, goals) == best\n\
    \        let path = shortest_path_implicit_dijkstra(starts, goals, adjacent)\n\
    \        doAssert shortest_path_implicit_dijkstra[T](starts, goals, adjacent)\
    \ == path\n        doAssert path.cost == best\n        if best == INF64:\n   \
    \         doAssert path.path.len == 0\n        else:\n            doAssert path.path[0]\
    \ in starts and path.path[^1] in goals\n            var total = 0\n          \
    \  for k in 1..<path.path.len:\n                var cost = INF64\n           \
    \     for (j, w) in edges[states.find(path.path[k-1])]:\n                    if\
    \ states[j] == path.path[k]:\n                        cost = min(cost, w)\n  \
    \              doAssert cost != INF64\n                total += cost\n       \
    \     doAssert total == best\n    if sources.len > 0:\n        let s = starts[0]\n\
    \        let single = implicit_dijkstra(s, adjacent)\n        doAssert single\
    \ == implicit_dijkstra([s], adjacent)\n        doAssert implicit_dijkstra[T](s,\
    \ adjacent) == single\n        doAssert implicit_dijkstra[T]([s], adjacent) ==\
    \ single\n        let goals = @[states[0], states[^1], states[0]]\n        doAssert\
    \ implicit_dijkstra_until(s, adjacent, goals) == implicit_dijkstra_until([s],\
    \ adjacent, goals)\n        doAssert implicit_dijkstra_until[T](s, adjacent, goals)\
    \ == implicit_dijkstra_until[T]([s], adjacent, goals)\n        doAssert shortest_path_implicit_dijkstra(s,\
    \ goals, adjacent) == shortest_path_implicit_dijkstra([s], goals, adjacent)\n\
    \        doAssert shortest_path_implicit_dijkstra[T](s, goals, adjacent) == shortest_path_implicit_dijkstra[T]([s],\
    \ goals, adjacent)\n        let singleRestore = restore_implicit_dijkstra(s, adjacent)\n\
    \        doAssert singleRestore.costs == single\n        doAssert restore_implicit_dijkstra[T]([s],\
    \ adjacent).prev == singleRestore.prev\n        let finish: ImplicitDijkstraFinish[T]\
    \ = proc(u: T): bool = u == states[^1]\n        doAssert implicit_dijkstra_until(s,\
    \ adjacent, finish) == implicit_dijkstra_until([s], adjacent, finish)\n      \
    \  doAssert implicit_dijkstra_until[T](s, adjacent, finish) == implicit_dijkstra_until[T]([s],\
    \ adjacent, finish)\n        doAssert shortest_path_implicit_dijkstra(s, states[^1],\
    \ adjacent) == shortest_path_implicit_dijkstra([s], states[^1], adjacent)\n  \
    \      doAssert shortest_path_implicit_dijkstra[T](s, states[^1], adjacent) ==\
    \ shortest_path_implicit_dijkstra[T]([s], states[^1], adjacent)\n        doAssert\
    \ shortest_path_implicit_dijkstra(s, s, adjacent).path == @[s]\n    let never:\
    \ ImplicitDijkstraFinish[T] = proc(v: T): bool = false\n    doAssert implicit_dijkstra_until(starts,\
    \ adjacent, never, INF = -123) == -123\n    doAssert implicit_dijkstra_until(start\
    \ = starts, adjacent = adjacent, finish = never, INF = -321) == -321\n\nvar rng\
    \ = initRand(20261005)\nfor trial in 0..<250:\n    let n = rng.rand(1..12)\n \
    \   var edges = newSeq[seq[(int, int)]](n)\n    for i in 0..<n:\n        for j\
    \ in 0..<n:\n            if rng.rand(0..3) == 0:\n                edges[i].add((j,\
    \ rng.rand(0..8)))\n                if rng.rand(0..4) == 0:\n                \
    \    edges[i].add((j, rng.rand(0..8)))\n    var sources: seq[int]\n    for k in\
    \ 0..<rng.rand(0..n+2):\n        sources.add(rng.rand(0..<n))\n    checkGraph(toSeq(0..<n),\
    \ edges, sources)\n    checkGraph(toSeq(0..<n).mapIt((x: it, tag: \"tuple\")),\
    \ edges, sources)\n    checkGraph(toSeq(0..<n).mapIt(@[it, 42]), edges, sources)\n\
    \nblock:\n    var expansions, predicates: int\n    let adjacent: ImplicitDijkstraAdjacent[int]\
    \ = proc(v: int): seq[(int, int)] =\n        inc expansions\n        doAssert\
    \ false\n    let finish: ImplicitDijkstraFinish[int] = proc(v: int): bool =\n\
    \        inc predicates\n        true\n    let empty = newSeq[int]()\n    let\
    \ restored = restore_implicit_dijkstra(empty, adjacent)\n    doAssert restored.costs.len\
    \ == 0 and restored.prev.len == 0\n    doAssert implicit_dijkstra(empty, adjacent).len\
    \ == 0\n    doAssert implicit_dijkstra(newSeq[int](), adjacent).len == 0\n   \
    \ doAssert implicit_dijkstra_until(empty, adjacent, finish, -17) == -17\n    let\
    \ missing = shortest_path_implicit_dijkstra(empty, 1, adjacent, -17)\n    doAssert\
    \ missing.path.len == 0 and missing.cost == -17\n    doAssert expansions == 0\
    \ and predicates == 0\n    doAssert implicit_dijkstra_until(@[1, 1, 2], adjacent,\
    \ finish) == 0\n    doAssert shortest_path_implicit_dijkstra(@[1, 1, 2], 1, adjacent).path\
    \ == @[1]\n    doAssert expansions == 0 and predicates == 1\n\nblock:\n    var\
    \ expansions: int\n    let adjacent: ImplicitDijkstraAdjacent[int] = proc(v: int):\
    \ seq[(int, int)] =\n        inc expansions\n        result = @[(v, 0), (v, 1)]\n\
    \    let restored = restore_implicit_dijkstra(@[7, 7, 7], adjacent)\n    doAssert\
    \ restored.costs.len == 1 and restored.costs[7] == 0\n    doAssert restored.prev.len\
    \ == 0 and expansions == 1\n    doAssert shortest_path_implicit_dijkstra(@[7,\
    \ 7], 8, adjacent, 99).cost == 99\n\nblock:\n    let infinite: ImplicitDijkstraAdjacent[int]\
    \ = proc(v: int): seq[(int, int)] = @[(v + 1, 1)]\n    doAssert implicit_dijkstra_until(0,\
    \ infinite, proc(v: int): bool = v == 4) == 4\n    doAssert shortest_path_implicit_dijkstra(@[0,\
    \ 1], 4, infinite).cost == 3\n\nblock:\n    let adjacent: ImplicitDijkstraAdjacent[int]\
    \ = proc(v: int): seq[(int, int)] =\n        if v == 0: @[(1, high(int)), (2,\
    \ INF64 + 10)]\n        elif v == 1: @[(3, 0)]\n        else: @[]\n    doAssert\
    \ implicit_dijkstra(0, adjacent)[3] == high(int)\n    doAssert implicit_dijkstra_until(0,\
    \ adjacent, proc(v: int): bool = v == 3) == high(int)\n    doAssert shortest_path_implicit_dijkstra(0,\
    \ 3, adjacent).cost == high(int)\n    doAssert shortest_path_implicit_dijkstra(0,\
    \ 3, adjacent).path == @[0, 1, 3]\n\n\ntype CollisionState = object\n    id: int\n\
    proc hash(v: CollisionState): Hash = Hash(0)\nproc `==`(a, b: CollisionState):\
    \ bool = a.id == b.id\n\nblock:\n    let states = @[CollisionState(id: 0), CollisionState(id:\
    \ 1), CollisionState(id: 2), CollisionState(id: 3)]\n    let edges = @[@[(0, 0),\
    \ (1, 0), (1, 0)], @[(0, 0), (2, 0)], @[(2, 0)], newSeq[(int, int)]()]\n    checkGraph(states,\
    \ edges, @[0, 1, 1])\n    checkGraph(states, edges, @[])\n    checkGraph(states,\
    \ edges, @[0])\n\nblock:\n    var expansions: int\n    let adjacent: ImplicitDijkstraAdjacent[int]\
    \ = proc(v: int): seq[(int, int)] =\n        inc expansions\n        doAssert\
    \ false\n    doAssert implicit_dijkstra_until(@[0], adjacent, newSeq[int](), -22)\
    \ == -22\n    doAssert implicit_dijkstra_until(0, adjacent, newSeq[int](), -22)\
    \ == -22\n    doAssert shortest_path_implicit_dijkstra(@[0], newSeq[int](), adjacent,\
    \ -22) == (@[], -22)\n    doAssert shortest_path_implicit_dijkstra(0, newSeq[int](),\
    \ adjacent, -22) == (@[], -22)\n    doAssert implicit_dijkstra_until(@[1, 0, 1],\
    \ adjacent, @[1, 1]) == 0\n    doAssert shortest_path_implicit_dijkstra(@[1, 0,\
    \ 1], @[1, 1], adjacent) == (@[1], 0)\n    doAssert implicit_dijkstra_until(0,\
    \ adjacent, [0, 0]) == 0\n    doAssert shortest_path_implicit_dijkstra([0], [0,\
    \ 0], adjacent) == (@[0], 0)\n    doAssert expansions == 0\n\nblock:\n    var\
    \ expanded: seq[int]\n    let adjacent: ImplicitDijkstraAdjacent[int] = proc(v:\
    \ int): seq[(int, int)] =\n        expanded.add(v)\n        case v\n        of\
    \ 0: @[(1, 10), (2, 1), (3, 5)]\n        of 2: @[(1, 1)]\n        else: @[]\n\
    \    doAssert implicit_dijkstra_until(0, adjacent, @[1, 3, 1]) == 2\n    doAssert\
    \ expanded == @[0, 2]\n    expanded.setLen(0)\n    doAssert shortest_path_implicit_dijkstra(0,\
    \ @[1, 3, 1], adjacent) == (@[0, 2, 1], 2)\n    doAssert expanded == @[0, 2]\n\
    \nblock:\n    let emptyState = newSeq[int]()\n    let adjacent: ImplicitDijkstraAdjacent[seq[int]]\
    \ = proc(v: seq[int]): seq[(seq[int], int)] =\n        if v.len == 0: @[( @[1],\
    \ 1)]\n        else: @[]\n    let costs = implicit_dijkstra(emptyState, adjacent)\n\
    \    doAssert costs.len == 2 and costs[emptyState] == 0 and costs[@[1]] == 1\n\
    \    doAssert restore_implicit_dijkstra(emptyState, adjacent).prev[@[1]] == emptyState\n\
    \    doAssert implicit_dijkstra(newSeq[seq[int]](), adjacent).len == 0\n    doAssert\
    \ shortest_path_implicit_dijkstra(emptyState, emptyState, adjacent) == (@[emptyState],\
    \ 0)\n    doAssert shortest_path_implicit_dijkstra(emptyState, @[1], adjacent)\
    \ == (@[emptyState, @[1]], 1)\n    doAssert shortest_path_implicit_dijkstra([emptyState],\
    \ [@[1]], adjacent) == (@[emptyState, @[1]], 1)\n    doAssert implicit_dijkstra_until(emptyState,\
    \ adjacent, [@[1]]) == 1\n"
  dependsOn:
  - cplib/utils/implicit_dijkstra.nim
  - cplib/graph/graph.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/graph/dijkstra.nim
  - cplib/graph/graph.nim
  - cplib/graph/dijkstra.nim
  - cplib/utils/constants.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/utils/implicit_dijkstra.nim
  - cplib/utils/constants.nim
  isVerificationFile: true
  path: verify/AI/implicit_dijkstra_test.nim
  requiredBy: []
  timestamp: '2026-10-29 04:15:51+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/implicit_dijkstra_test.nim
layout: document
redirect_from:
- /verify/verify/AI/implicit_dijkstra_test.nim
- /verify/verify/AI/implicit_dijkstra_test.nim.html
title: verify/AI/implicit_dijkstra_test.nim
---
