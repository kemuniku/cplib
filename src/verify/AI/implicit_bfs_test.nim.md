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
    path: cplib/utils/implicit_bfs.nim
    title: cplib/utils/implicit_bfs.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/implicit_bfs.nim
    title: cplib/utils/implicit_bfs.nim
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
    echo \"Hello World\"\n\nimport cplib/utils/implicit_bfs\nimport cplib/utils/constants\n\
    import tables, hashes\n\nimport random, sequtils\nimport cplib/graph/graph\nimport\
    \ cplib/graph/dijkstra\n\nproc checkGraph[T](states: seq[T], edges: seq[seq[(int,\
    \ int)]], sources: seq[int]) =\n    var graph = initWeightedDirectedGraph(states.len)\n\
    \    for i, row in edges:\n        for (j, cost) in row:\n            graph.add_edge(i,\
    \ j, cost)\n    let expected = graph.dijkstra(sources)\n    let starts = sources.mapIt(states[it])\n\
    \    let adjacent: ImplicitBfsAdjacent[T] = proc(v: T): seq[T] =\n        let\
    \ i = states.find(v)\n        doAssert i >= 0\n        for (j, cost) in edges[i]:\n\
    \            result.add(states[j])\n    let costs = implicit_bfs(starts, adjacent)\n\
    \    let restored = restore_implicit_bfs(starts, adjacent)\n    doAssert costs\
    \ == restored.costs\n    for i, v in states:\n        doAssert costs.hasKey(v)\
    \ == (expected[i] != INF64)\n        if costs.hasKey(v):\n            doAssert\
    \ costs[v] == expected[i]\n            var current = v\n            var steps\
    \ = 0\n            while restored.prev.hasKey(current):\n                let parent\
    \ = restored.prev[current]\n                var validEdge = false\n          \
    \      for (j, cost) in edges[states.find(parent)]:\n                    if states[j]\
    \ == current and costs[parent] + cost == costs[current]:\n                   \
    \     validEdge = true\n                doAssert validEdge\n                current\
    \ = parent\n                inc steps\n                doAssert steps < states.len\n\
    \            doAssert current in starts and costs[current] == 0\n        if v\
    \ in starts:\n            doAssert not restored.prev.hasKey(v)\n        let finish:\
    \ ImplicitBfsFinish[T] = proc(u: T): bool = u == v\n        doAssert implicit_bfs_until(starts,\
    \ adjacent, finish) == expected[i]\n        let path = shortest_path_implicit_bfs(starts,\
    \ v, adjacent)\n        doAssert path.cost == expected[i]\n        if expected[i]\
    \ == INF64:\n            doAssert path.path.len == 0\n        else:\n        \
    \    doAssert path.path[0] in starts and path.path[^1] == v\n            var total\
    \ = 0\n            for k in 1..<path.path.len:\n                let parent = path.path[k-1]\n\
    \                let child = path.path[k]\n                var edgeCost = INF64\n\
    \                for (j, cost) in edges[states.find(parent)]:\n              \
    \      if states[j] == child:\n                        edgeCost = min(edgeCost,\
    \ cost)\n                doAssert edgeCost != INF64\n                total +=\
    \ edgeCost\n            doAssert total == path.cost\n    for goals in @[newSeq[T](),\
    \ @[states[0], states[^1], states[0]], states]:\n        var best = INF64\n  \
    \      for g in goals:\n            best = min(best, expected[states.find(g)])\n\
    \        doAssert implicit_bfs_until(starts, adjacent, goals) == best\n      \
    \  doAssert implicit_bfs_until[T](starts, adjacent, goals) == best\n        let\
    \ path = shortest_path_implicit_bfs(starts, goals, adjacent)\n        doAssert\
    \ shortest_path_implicit_bfs[T](starts, goals, adjacent) == path\n        doAssert\
    \ path.cost == best\n        if best == INF64:\n            doAssert path.path.len\
    \ == 0\n        else:\n            doAssert path.path[0] in starts and path.path[^1]\
    \ in goals\n            var total = 0\n            for k in 1..<path.path.len:\n\
    \                var cost = INF64\n                for (j, w) in edges[states.find(path.path[k-1])]:\n\
    \                    if states[j] == path.path[k]:\n                        cost\
    \ = min(cost, w)\n                doAssert cost != INF64\n                total\
    \ += cost\n            doAssert total == best\n    if sources.len > 0:\n     \
    \   let s = starts[0]\n        let single = implicit_bfs(s, adjacent)\n      \
    \  doAssert single == implicit_bfs([s], adjacent)\n        doAssert implicit_bfs[T](s,\
    \ adjacent) == single\n        doAssert implicit_bfs[T]([s], adjacent) == single\n\
    \        let goals = @[states[0], states[^1], states[0]]\n        doAssert implicit_bfs_until(s,\
    \ adjacent, goals) == implicit_bfs_until([s], adjacent, goals)\n        doAssert\
    \ implicit_bfs_until[T](s, adjacent, goals) == implicit_bfs_until[T]([s], adjacent,\
    \ goals)\n        doAssert shortest_path_implicit_bfs(s, goals, adjacent) == shortest_path_implicit_bfs([s],\
    \ goals, adjacent)\n        doAssert shortest_path_implicit_bfs[T](s, goals, adjacent)\
    \ == shortest_path_implicit_bfs[T]([s], goals, adjacent)\n        let singleRestore\
    \ = restore_implicit_bfs(s, adjacent)\n        doAssert singleRestore.costs ==\
    \ single\n        doAssert restore_implicit_bfs[T]([s], adjacent).prev == singleRestore.prev\n\
    \        let finish: ImplicitBfsFinish[T] = proc(u: T): bool = u == states[^1]\n\
    \        doAssert implicit_bfs_until(s, adjacent, finish) == implicit_bfs_until([s],\
    \ adjacent, finish)\n        doAssert implicit_bfs_until[T](s, adjacent, finish)\
    \ == implicit_bfs_until[T]([s], adjacent, finish)\n        doAssert shortest_path_implicit_bfs(s,\
    \ states[^1], adjacent) == shortest_path_implicit_bfs([s], states[^1], adjacent)\n\
    \        doAssert shortest_path_implicit_bfs[T](s, states[^1], adjacent) == shortest_path_implicit_bfs[T]([s],\
    \ states[^1], adjacent)\n        doAssert shortest_path_implicit_bfs(s, s, adjacent).path\
    \ == @[s]\n    let never: ImplicitBfsFinish[T] = proc(v: T): bool = false\n  \
    \  doAssert implicit_bfs_until(starts, adjacent, never, INF = -123) == -123\n\
    \    doAssert implicit_bfs_until(start = starts, adjacent = adjacent, finish =\
    \ never, INF = -321) == -321\n\nvar rng = initRand(20261005)\nfor trial in 0..<250:\n\
    \    let n = rng.rand(1..12)\n    var edges = newSeq[seq[(int, int)]](n)\n   \
    \ for i in 0..<n:\n        for j in 0..<n:\n            if rng.rand(0..3) == 0:\n\
    \                edges[i].add((j, 1))\n                if rng.rand(0..4) == 0:\n\
    \                    edges[i].add((j, 1))\n    var sources: seq[int]\n    for\
    \ k in 0..<rng.rand(0..n+2):\n        sources.add(rng.rand(0..<n))\n    checkGraph(toSeq(0..<n),\
    \ edges, sources)\n    checkGraph(toSeq(0..<n).mapIt((x: it, tag: \"tuple\")),\
    \ edges, sources)\n    checkGraph(toSeq(0..<n).mapIt(@[it, 42]), edges, sources)\n\
    \nblock:\n    var expansions, predicates: int\n    let adjacent: ImplicitBfsAdjacent[int]\
    \ = proc(v: int): seq[int] =\n        inc expansions\n        doAssert false\n\
    \    let finish: ImplicitBfsFinish[int] = proc(v: int): bool =\n        inc predicates\n\
    \        true\n    let empty = newSeq[int]()\n    let restored = restore_implicit_bfs(empty,\
    \ adjacent)\n    doAssert restored.costs.len == 0 and restored.prev.len == 0\n\
    \    doAssert implicit_bfs(empty, adjacent).len == 0\n    doAssert implicit_bfs(newSeq[int](),\
    \ adjacent).len == 0\n    doAssert implicit_bfs_until(empty, adjacent, finish,\
    \ -17) == -17\n    let missing = shortest_path_implicit_bfs(empty, 1, adjacent,\
    \ -17)\n    doAssert missing.path.len == 0 and missing.cost == -17\n    doAssert\
    \ expansions == 0 and predicates == 0\n    doAssert implicit_bfs_until(@[1, 1,\
    \ 2], adjacent, finish) == 0\n    doAssert shortest_path_implicit_bfs(@[1, 1,\
    \ 2], 1, adjacent).path == @[1]\n    doAssert expansions == 0 and predicates ==\
    \ 1\n\nblock:\n    var expansions: int\n    let adjacent: ImplicitBfsAdjacent[int]\
    \ = proc(v: int): seq[int] =\n        inc expansions\n        result = @[v, v]\n\
    \    let restored = restore_implicit_bfs(@[7, 7, 7], adjacent)\n    doAssert restored.costs.len\
    \ == 1 and restored.costs[7] == 0\n    doAssert restored.prev.len == 0 and expansions\
    \ == 1\n    doAssert shortest_path_implicit_bfs(@[7, 7], 8, adjacent, 99).cost\
    \ == 99\n\nblock:\n    let infinite: ImplicitBfsAdjacent[int] = proc(v: int):\
    \ seq[int] = @[v + 1]\n    doAssert implicit_bfs_until(0, infinite, proc(v: int):\
    \ bool = v == 4) == 4\n    doAssert shortest_path_implicit_bfs(@[0, 1], 4, infinite).cost\
    \ == 3\n\n\ntype CollisionState = object\n    id: int\nproc hash(v: CollisionState):\
    \ Hash = Hash(0)\nproc `==`(a, b: CollisionState): bool = a.id == b.id\n\nblock:\n\
    \    let states = @[CollisionState(id: 0), CollisionState(id: 1), CollisionState(id:\
    \ 2), CollisionState(id: 3)]\n    let edges = @[@[(0, 1), (1, 1), (1, 1)], @[(0,\
    \ 1), (2, 1)], @[(2, 1)], newSeq[(int, int)]()]\n    checkGraph(states, edges,\
    \ @[0, 1, 1])\n    checkGraph(states, edges, @[])\n    checkGraph(states, edges,\
    \ @[0])\n\nblock:\n    var expansions: int\n    let adjacent: ImplicitBfsAdjacent[int]\
    \ = proc(v: int): seq[int] =\n        inc expansions\n        doAssert false\n\
    \    doAssert implicit_bfs_until(@[0], adjacent, newSeq[int](), -22) == -22\n\
    \    doAssert implicit_bfs_until(0, adjacent, newSeq[int](), -22) == -22\n   \
    \ doAssert shortest_path_implicit_bfs(@[0], newSeq[int](), adjacent, -22) == (@[],\
    \ -22)\n    doAssert shortest_path_implicit_bfs(0, newSeq[int](), adjacent, -22)\
    \ == (@[], -22)\n    doAssert implicit_bfs_until(@[1, 0, 1], adjacent, @[1, 1])\
    \ == 0\n    doAssert shortest_path_implicit_bfs(@[1, 0, 1], @[1, 1], adjacent)\
    \ == (@[1], 0)\n    doAssert implicit_bfs_until(0, adjacent, [0, 0]) == 0\n  \
    \  doAssert shortest_path_implicit_bfs([0], [0, 0], adjacent) == (@[0], 0)\n \
    \   doAssert expansions == 0\n\nblock:\n    let emptyState = newSeq[int]()\n \
    \   let adjacent: ImplicitBfsAdjacent[seq[int]] = proc(v: seq[int]): seq[seq[int]]\
    \ =\n        if v.len == 0: @[@[1]]\n        else: @[]\n    let costs = implicit_bfs(emptyState,\
    \ adjacent)\n    doAssert costs.len == 2 and costs[emptyState] == 0 and costs[@[1]]\
    \ == 1\n    doAssert restore_implicit_bfs(emptyState, adjacent).prev[@[1]] ==\
    \ emptyState\n    doAssert implicit_bfs(newSeq[seq[int]](), adjacent).len == 0\n\
    \    doAssert shortest_path_implicit_bfs(emptyState, emptyState, adjacent) ==\
    \ (@[emptyState], 0)\n    doAssert shortest_path_implicit_bfs(emptyState, @[1],\
    \ adjacent) == (@[emptyState, @[1]], 1)\n    doAssert shortest_path_implicit_bfs([emptyState],\
    \ [@[1]], adjacent) == (@[emptyState, @[1]], 1)\n    doAssert implicit_bfs_until(emptyState,\
    \ adjacent, [@[1]]) == 1\n"
  dependsOn:
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/graph/graph.nim
  - cplib/utils/constants.nim
  - cplib/utils/implicit_bfs.nim
  - cplib/graph/graph.nim
  - cplib/utils/implicit_bfs.nim
  - cplib/utils/constants.nim
  - cplib/graph/dijkstra.nim
  - cplib/graph/dijkstra.nim
  isVerificationFile: true
  path: verify/AI/implicit_bfs_test.nim
  requiredBy: []
  timestamp: '2026-10-05 12:14:47+00:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/implicit_bfs_test.nim
layout: document
redirect_from:
- /verify/verify/AI/implicit_bfs_test.nim
- /verify/verify/AI/implicit_bfs_test.nim.html
title: verify/AI/implicit_bfs_test.nim
---
