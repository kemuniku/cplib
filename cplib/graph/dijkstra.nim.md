---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/graph/restore_dijkstra_test.nim
    title: verify/graph/restore_dijkstra_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/restore_dijkstra_test.nim
    title: verify/graph/restore_dijkstra_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/shortest_path_test.nim
    title: verify/graph/shortest_path_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/shortest_path_test.nim
    title: verify/graph/shortest_path_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GRAPH_DIJKSTRA:\n    import cplib/graph/graph\n \
    \   import std/heapqueue\n    import algorithm\n    const CPLIB_GRAPH_DIJKSTRA*\
    \ = 1\n    proc restore_dijkstra*[T](G: Graph[T], start: int, ZERO: T = 0, INF:\
    \ T = int(3300300300300300491)): tuple[costs: seq[T], prev: seq[int]] =\n    \
    \    var\n            queue = initHeapQueue[(T, int)]()\n            costs = newSeq[T](len(G.edges))\n\
    \            prev = newseq[int](len(G.edges))\n        costs.fill(INF)\n     \
    \   prev.fill(-1)\n        queue.push((ZERO, start))\n        costs[start] = ZERO\n\
    \        while len(queue) != 0:\n            var (cost, i) = queue.pop()\n   \
    \         if cost > costs[i]:\n                continue\n            for (j, c)\
    \ in G.edges[i]:\n                var temp = costs[i] + c\n                if\
    \ temp < costs[j]:\n                    prev[j] = i\n                    costs[j]\
    \ = temp\n                    queue.push((temp, j))\n        return (costs, prev)\n\
    \    proc dijkstra*[T](G: Graph[T], start: int, ZERO: T = 0, INF: T = int(3300300300300300491)):\
    \ seq[T] =\n        var costs, _ = restore_dijkstra(G, start, ZERO, INF)\n   \
    \     return costs\n    proc restore_shortestpath_from_prev*(prev: seq[int], goal:\
    \ int): seq[int] =\n        var i = goal\n        while i != -1:\n           \
    \ result.add(i)\n            i = prev[i]\n        result = result.reversed()\n\
    \    proc shortest_path*[T](G: Graph[T], start: int, goal: int, ZERO: T = 0, INF:\
    \ T = int(3300300300300300491)): tuple[path: seq[int], cost: int] =\n        var\
    \ (costs, prev) = restore_dijkstra(G, start, ZERO, INF)\n        result.path =\
    \ prev.restore_shortestpath_from_prev(goal)\n        result.cost = costs[goal]\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/dijkstra.nim
  requiredBy: []
  timestamp: '2023-11-14 02:43:16+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/shortest_path_test.nim
  - verify/graph/shortest_path_test.nim
  - verify/graph/restore_dijkstra_test.nim
  - verify/graph/restore_dijkstra_test.nim
documentation_of: cplib/graph/dijkstra.nim
layout: document
redirect_from:
- /library/cplib/graph/dijkstra.nim
- /library/cplib/graph/dijkstra.nim.html
title: cplib/graph/dijkstra.nim
---
