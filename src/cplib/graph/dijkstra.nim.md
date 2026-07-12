---
data:
  _extendedDependsOn:
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
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/tsp.nim
    title: cplib/graph/tsp.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/tsp.nim
    title: cplib/graph/tsp.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/dijkstra_test.nim
    title: verify/AI/dijkstra_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/dijkstra_test.nim
    title: verify/AI/dijkstra_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/graph_weight_type_test.nim
    title: verify/AI/graph_weight_type_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/graph_weight_type_test.nim
    title: verify/AI/graph_weight_type_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/tsp_test.nim
    title: verify/AI/tsp_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/tsp_test.nim
    title: verify/AI/tsp_test.nim
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
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GRAPH_DIJKSTRA:\n    const CPLIB_GRAPH_DIJKSTRA*\
    \ = 1\n    import cplib/graph/graph\n    import cplib/utils/constants\n    import\
    \ cplib/graph/restore_shortest_path_from_prev\n    import std/heapqueue, macros,\
    \ algorithm\n    proc restore_dijkstra_impl[T](G: DynamicGraph[T] or StaticGraph[T],\
    \ start: int or seq[int], ZERO, INF: T): tuple[costs: seq[T], prev: seq[int]]\
    \ =\n        var\n            queue = initHeapQueue[(T, int)]()\n            costs\
    \ = newSeq[T](len(G))\n            prev = newseq[int](len(G))\n        costs.fill(INF)\n\
    \        prev.fill(-1)\n        when start is int:\n            queue.push((ZERO,\
    \ start))\n            costs[start] = ZERO\n        else:\n            for s in\
    \ start:\n                queue.push((ZERO, s))\n                costs[s] = ZERO\n\
    \        while len(queue) != 0:\n            var (cost, i) = queue.pop()\n   \
    \         if cost > costs[i]:\n                continue\n            for (j, c)\
    \ in G.to_and_cost(i):\n                var temp = costs[i] + c\n            \
    \    if temp < costs[j]:\n                    prev[j] = i\n                  \
    \  costs[j] = temp\n                    queue.push((temp, j))\n        return\
    \ (costs, prev)\n    macro declareDijkstra(name, t, zero, inf) =\n        let\
    \ impl_name = ident($`name` & \"_impl\")\n        quote do:\n            proc\
    \ `name`*(G: DynamicGraph[`t`] or StaticGraph[`t`], start: int or seq[int], ZERO:\
    \ `t` = `zero`, INF: `t` = `inf`): auto =\n                `impl_name`(G, start,\
    \ ZERO, INF)\n    declareDijkstra(restore_dijkstra, int, 0, INF64)\n    declareDijkstra(restore_dijkstra,\
    \ int32, 0i32, INF32)\n    declareDijkstra(restore_dijkstra, float, 0.0, 1e100)\n\
    \    declareDijkstra(restore_dijkstra, float32, 0.0'f32, 1e30'f32)\n    proc restore_dijkstra*[T](G:\
    \ DynamicGraph[T] or StaticGraph[T], start: int or seq[int], ZERO, INF: T): auto\
    \ =\n        restore_dijkstra_impl(G, start, ZERO, INF)\n    proc dijkstra_impl[T](G:\
    \ DynamicGraph[T] or StaticGraph[T], start: int or seq[int], ZERO, INF: T): seq[T]\
    \ =\n        var (costs, _) = restore_dijkstra(G, start, ZERO, INF)\n        return\
    \ costs\n    declareDijkstra(dijkstra, int, 0, INF64)\n    declareDijkstra(dijkstra,\
    \ int32, 0i32, INF32)\n    declareDijkstra(dijkstra, float, 0.0, 1e100)\n    declareDijkstra(dijkstra,\
    \ float32, 0.0'f32, 1e30'f32)\n    proc dijkstra*[T](G: DynamicGraph[T] or StaticGraph[T],\
    \ start: int or seq[int], ZERO, INF: T): auto =\n        dijkstra_impl(G, start,\
    \ ZERO, INF)\n    proc shortest_path_dijkstra_impl[T](G: DynamicGraph[T] or StaticGraph[T],\
    \ start: int, goal: int, ZERO: T, INF: T): tuple[path: seq[int], cost: T] =\n\
    \        var (costs, prev) = restore_dijkstra(G, start, ZERO, INF)\n        result.path\
    \ = prev.restore_shortest_path_from_prev(goal)\n        result.cost = costs[goal]\n\
    \    proc shortest_path_dijkstra*(G: DynamicGraph[int] or StaticGraph[int], start:\
    \ int, goal: int, ZERO: int = 0, INF: int = INF64): tuple[path: seq[int], cost:\
    \ int] =\n        shortest_path_dijkstra_impl(G, start, goal, ZERO, INF)\n   \
    \ proc shortest_path_dijkstra*(G: DynamicGraph[int32] or StaticGraph[int32], start:\
    \ int, goal: int, ZERO: int32 = 0.int32, INF: int32 = INF32): tuple[path: seq[int],\
    \ cost: int32] =\n        shortest_path_dijkstra_impl(G, start, goal, ZERO, INF)\n\
    \    proc shortest_path_dijkstra*(G: DynamicGraph[float] or StaticGraph[float],\
    \ start: int, goal: int, ZERO: float = 0.0, INF: float = 1e100): tuple[path: seq[int],\
    \ cost: float] =\n        shortest_path_dijkstra_impl(G, start, goal, ZERO, INF)\n\
    \    proc shortest_path_dijkstra*(G: DynamicGraph[float32] or StaticGraph[float32],\
    \ start: int, goal: int, ZERO: float32 = 0.0'f32, INF: float32 = 1e30'f32): tuple[path:\
    \ seq[int], cost: float32] =\n        shortest_path_dijkstra_impl(G, start, goal,\
    \ ZERO, INF)\n    proc shortest_path_dijkstra*[T](G: DynamicGraph[T] or StaticGraph[T],\
    \ start: int, goal: int, ZERO: T, INF: T): tuple[path: seq[int], cost: T] =\n\
    \        shortest_path_dijkstra_impl(G, start, goal, ZERO, INF)\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/utils/constants.nim
  - cplib/graph/graph.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/utils/constants.nim
  isVerificationFile: false
  path: cplib/graph/dijkstra.nim
  requiredBy:
  - cplib/graph/tsp.nim
  - cplib/graph/tsp.nim
  timestamp: '2026-07-07 07:56:57+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/tsp_test.nim
  - verify/AI/tsp_test.nim
  - verify/AI/dijkstra_test.nim
  - verify/AI/dijkstra_test.nim
  - verify/AI/graph_weight_type_test.nim
  - verify/AI/graph_weight_type_test.nim
  - verify/graph/static/restore_dijkstra_static_test.nim
  - verify/graph/static/restore_dijkstra_static_test.nim
  - verify/graph/static/shortest_path_static_test.nim
  - verify/graph/static/shortest_path_static_test.nim
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
