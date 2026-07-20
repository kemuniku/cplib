---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/implicit_dijkstra_test.nim
    title: verify/AI/implicit_dijkstra_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/implicit_dijkstra_test.nim
    title: verify/AI/implicit_dijkstra_test.nim
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
  code: "when not declared CPLIB_UTILS_IMPLICIT_DIJKSTRA:\n    const CPLIB_UTILS_IMPLICIT_DIJKSTRA*\
    \ = 1\n\n    import std/[algorithm, heapqueue, tables]\n    import cplib/utils/constants\n\
    \n    type\n        ImplicitDijkstraAdjacent*[T] = proc(v: T): seq[(T, int)] {.closure.}\n\
    \        ImplicitDijkstraFinish*[T] = proc(v: T): bool {.closure.}\n\n    proc\
    \ restore_implicit_dijkstra*[T](start: T, adjacent: ImplicitDijkstraAdjacent[T]):\
    \ tuple[costs: Table[T, int], prev: Table[T, T]] =\n        ## `adjacent(v)` \u3067\
    \u8FBA\u3092\u5217\u6319\u3059\u308B\u3001\u9802\u70B9\u96C6\u5408\u3092\u660E\
    \u793A\u3057\u306A\u3044\u30B0\u30E9\u30D5\u4E0A\u306E\n        ## Dijkstra \u6CD5\
    \u3002\u975E\u8CA0\u8FBA\u3092\u4EEE\u5B9A\u3057\u3001\u5230\u9054\u53EF\u80FD\
    \u306A\u9802\u70B9\u3092\u3059\u3079\u3066\u63A2\u7D22\u3059\u308B\u3002\n   \
    \     var\n            queue = initHeapQueue[(int, int)]()\n            vertices\
    \ = @[start]\n            vertexIds = initTable[T, int]()\n        result.costs\
    \ = initTable[T, int]()\n        result.prev = initTable[T, T]()\n        vertexIds[start]\
    \ = 0\n        result.costs[start] = 0\n        queue.push((0, 0))\n\n       \
    \ while queue.len > 0:\n            let (cost, vertexId) = queue.pop()\n     \
    \       let vertex = vertices[vertexId]\n            if cost != result.costs[vertex]:\n\
    \                continue\n            for (next, edgeCost) in adjacent(vertex):\n\
    \                let nextCost = cost + edgeCost\n                if not result.costs.hasKey(next)\
    \ or nextCost < result.costs[next]:\n                    if not vertexIds.hasKey(next):\n\
    \                        vertexIds[next] = vertices.len\n                    \
    \    vertices.add(next)\n                    result.costs[next] = nextCost\n \
    \                   result.prev[next] = vertex\n                    queue.push((nextCost,\
    \ vertexIds[next]))\n\n    proc implicit_dijkstra*[T](start: T, adjacent: ImplicitDijkstraAdjacent[T]):\
    \ Table[T, int] =\n        ## \u59CB\u70B9\u304B\u3089\u5230\u9054\u53EF\u80FD\
    \u306A\u5404\u9802\u70B9\u307E\u3067\u306E\u6700\u77ED\u8DDD\u96E2\u3092\u8FD4\
    \u3059\u3002\n        ## \u5230\u9054\u4E0D\u80FD\u306A\u9802\u70B9\u306F\u8FD4\
    \u308A\u5024\u306E Table \u306B\u542B\u307E\u308C\u306A\u3044\u3002\n        restore_implicit_dijkstra(start,\
    \ adjacent).costs\n\n    proc implicit_dijkstra_until*[T](start: T, adjacent:\
    \ ImplicitDijkstraAdjacent[T], finish: ImplicitDijkstraFinish[T], INF: int = INF64):\
    \ int =\n        ## \u975E\u8CA0\u8FBA\u3092\u4EEE\u5B9A\u3057\u3001\u6700\u77ED\
    \u8DDD\u96E2\u304C\u78BA\u5B9A\u3057\u305F\u9802\u70B9\u304C\u521D\u3081\u3066\
    \ `finish` \u3092\n        ## \u6E80\u305F\u3057\u305F\u3068\u304D\u3001\u305D\
    \u306E\u9802\u70B9\u307E\u3067\u306E\u30B3\u30B9\u30C8\u3092\u8FD4\u3059\u3002\
    \n        var\n            queue = initHeapQueue[(int, int)]()\n            vertices\
    \ = @[start]\n            vertexIds = initTable[T, int]()\n            costs =\
    \ initTable[T, int]()\n        vertexIds[start] = 0\n        costs[start] = 0\n\
    \        queue.push((0, 0))\n\n        while queue.len > 0:\n            let (cost,\
    \ vertexId) = queue.pop()\n            let vertex = vertices[vertexId]\n     \
    \       if cost != costs[vertex]:\n                continue\n            if finish(vertex):\n\
    \                return cost\n            for (next, edgeCost) in adjacent(vertex):\n\
    \                let nextCost = cost + edgeCost\n                if not costs.hasKey(next)\
    \ or nextCost < costs[next]:\n                    if not vertexIds.hasKey(next):\n\
    \                        vertexIds[next] = vertices.len\n                    \
    \    vertices.add(next)\n                    costs[next] = nextCost\n        \
    \            queue.push((nextCost, vertexIds[next]))\n\n        return INF\n\n\
    \    proc shortest_path_implicit_dijkstra*[T](start, goal: T, adjacent: ImplicitDijkstraAdjacent[T],\
    \ INF: int = INF64): tuple[path: seq[T], cost: int] =\n        ## \u975E\u8CA0\
    \u8FBA\u3092\u4EEE\u5B9A\u3057\u3001`goal` \u306E\u6700\u77ED\u8DDD\u96E2\u304C\
    \u78BA\u5B9A\u3057\u305F\u6642\u70B9\u3067\u63A2\u7D22\u3092\u7D42\u4E86\u3059\
    \u308B\u3002\n        var\n            queue = initHeapQueue[(int, int)]()\n \
    \           vertices = @[start]\n            vertexIds = initTable[T, int]()\n\
    \            costs = initTable[T, int]()\n            prev = initTable[T, T]()\n\
    \        vertexIds[start] = 0\n        costs[start] = 0\n        queue.push((0,\
    \ 0))\n\n        while queue.len > 0:\n            let (cost, vertexId) = queue.pop()\n\
    \            let vertex = vertices[vertexId]\n            if cost != costs[vertex]:\n\
    \                continue\n            if vertex == goal:\n                result.cost\
    \ = cost\n                var current = goal\n                result.path.add(current)\n\
    \                while current != start:\n                    current = prev[current]\n\
    \                    result.path.add(current)\n                result.path.reverse()\n\
    \                return\n            for (next, edgeCost) in adjacent(vertex):\n\
    \                let nextCost = cost + edgeCost\n                if not costs.hasKey(next)\
    \ or nextCost < costs[next]:\n                    if not vertexIds.hasKey(next):\n\
    \                        vertexIds[next] = vertices.len\n                    \
    \    vertices.add(next)\n                    costs[next] = nextCost\n        \
    \            prev[next] = vertex\n                    queue.push((nextCost, vertexIds[next]))\n\
    \n        result.cost = INF\n        result.path = @[]\n"
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  isVerificationFile: false
  path: cplib/utils/implicit_dijkstra.nim
  requiredBy: []
  timestamp: '2026-07-20 01:43:13+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/implicit_dijkstra_test.nim
  - verify/AI/implicit_dijkstra_test.nim
documentation_of: cplib/utils/implicit_dijkstra.nim
layout: document
redirect_from:
- /library/cplib/utils/implicit_dijkstra.nim
- /library/cplib/utils/implicit_dijkstra.nim.html
title: cplib/utils/implicit_dijkstra.nim
---
