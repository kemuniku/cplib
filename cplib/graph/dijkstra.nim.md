---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/restore_dijkstra_test.nim
    title: verify/graph/dynamic/restore_dijkstra_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/restore_dijkstra_test.nim
    title: verify/graph/dynamic/restore_dijkstra_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/shortest_path_test.nim
    title: verify/graph/dynamic/shortest_path_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/shortest_path_test.nim
    title: verify/graph/dynamic/shortest_path_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/restore_dijkstra_static_test.nim
    title: verify/graph/static/restore_dijkstra_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/restore_dijkstra_static_test.nim
    title: verify/graph/static/restore_dijkstra_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/shortest_path_static_test.nim
    title: verify/graph/static/shortest_path_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/shortest_path_static_test.nim
    title: verify/graph/static/shortest_path_static_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GRAPH_DIJKSTRA:\n    const CPLIB_GRAPH_DIJKSTRA*\
    \ = 1\n    import cplib/graph/graph\n    import std/heapqueue\n    import algorithm\n\
    \    proc restore_dijkstra*[T](G: DynamicGraph[T] or StaticGraph[T], start: int,\
    \ ZERO: T = 0, INF: T = int(3300300300300300491)): tuple[costs: seq[T], prev:\
    \ seq[int]] =\n        var\n            queue = initHeapQueue[(T, int)]()\n  \
    \          costs = newSeq[T](len(G))\n            prev = newseq[int](len(G))\n\
    \        costs.fill(INF)\n        prev.fill(-1)\n        queue.push((ZERO, start))\n\
    \        costs[start] = ZERO\n        while len(queue) != 0:\n            var\
    \ (cost, i) = queue.pop()\n            if cost > costs[i]:\n                continue\n\
    \            for (j, c) in G.to_and_cost(i):\n                var temp = costs[i]\
    \ + c\n                if temp < costs[j]:\n                    prev[j] = i\n\
    \                    costs[j] = temp\n                    queue.push((temp, j))\n\
    \        return (costs, prev)\n    proc dijkstra*[T](G: DynamicGraph[T] or StaticGraph[T],\
    \ start: int, ZERO: T = 0, INF: T = int(3300300300300300491)): seq[T] =\n    \
    \    var (costs, _) = restore_dijkstra(G, start, ZERO, INF)\n        return costs\n\
    \    proc restore_shortestpath_from_prev*(prev: seq[int], goal: int): seq[int]\
    \ =\n        var i = goal\n        while i != -1:\n            result.add(i)\n\
    \            i = prev[i]\n        result = result.reversed()\n    proc shortest_path*[T](G:\
    \ DynamicGraph[T] or StaticGraph[T], start: int, goal: int, ZERO: T = 0, INF:\
    \ T = int(3300300300300300491)): tuple[path: seq[int], cost: T] =\n        var\
    \ (costs, prev) = restore_dijkstra(G, start, ZERO, INF)\n        result.path =\
    \ prev.restore_shortestpath_from_prev(goal)\n        result.cost = costs[goal]\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/dijkstra.nim
  requiredBy: []
  timestamp: '2024-03-22 18:42:41+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/static/shortest_path_static_test.nim
  - verify/graph/static/shortest_path_static_test.nim
  - verify/graph/static/restore_dijkstra_static_test.nim
  - verify/graph/static/restore_dijkstra_static_test.nim
  - verify/graph/dynamic/restore_dijkstra_test.nim
  - verify/graph/dynamic/restore_dijkstra_test.nim
  - verify/graph/dynamic/shortest_path_test.nim
  - verify/graph/dynamic/shortest_path_test.nim
documentation_of: cplib/graph/dijkstra.nim
layout: document
redirect_from:
- /library/cplib/graph/dijkstra.nim
- /library/cplib/graph/dijkstra.nim.html
title: cplib/graph/dijkstra.nim
---
