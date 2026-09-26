---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/radix_heap.nim
    title: cplib/collections/radix_heap.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/radix_heap.nim
    title: cplib/collections/radix_heap.nim
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
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/dijkstra_radix_test.nim
    title: verify/AI/dijkstra_radix_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/dijkstra_radix_test.nim
    title: verify/AI/dijkstra_radix_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/restore_dijkstra_radix_test.nim
    title: verify/graph/dynamic/restore_dijkstra_radix_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/restore_dijkstra_radix_test.nim
    title: verify/graph/dynamic/restore_dijkstra_radix_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/restore_dijkstra_radix_static_test.nim
    title: verify/graph/static/restore_dijkstra_radix_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/restore_dijkstra_radix_static_test.nim
    title: verify/graph/static/restore_dijkstra_radix_static_test.nim
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
  code: "when not declared CPLIB_GRAPH_DIJKSTRA_RADIX:\n    const CPLIB_GRAPH_DIJKSTRA_RADIX*\
    \ = 1\n    import algorithm\n    import cplib/collections/radix_heap\n    import\
    \ cplib/graph/graph\n    import cplib/graph/restore_shortest_path_from_prev\n\
    \    import cplib/utils/constants\n\n    template radixDijkstraInf(T: typedesc):\
    \ untyped =\n        ## \u65E2\u5B58\u306E\u30C0\u30A4\u30AF\u30B9\u30C8\u30E9\
    \u3068\u540C\u3058\u65E2\u5B9A\u5024\u3092\u4F7F\u3044\u3001\u4ED6\u306E\u6574\
    \u6570\u578B\u3067\u306F\u6700\u5927\u5024\u3092\u4F7F\u3046\u3002\n        when\
    \ T is int: INF64\n        elif T is int32: INF32\n        else: high(T)\n\n \
    \   proc dijkstraRadixImpl[T: SomeInteger](G: auto,\n            start: int or\
    \ seq[int], ZERO, INF: T, restore, stopAtGoal: static bool,\n            goal:\
    \ int = -1): auto =\n        ## \u975E\u8CA0\u6574\u6570\u91CD\u307F\u306E\u6700\
    \u77ED\u8DDD\u96E2\u3092\u6C42\u3081\u308B\u3002O(V + (E + S)B)\u3001S \u306F\u59CB\
    \u70B9\u6570\u3001B \u306F\u8DDD\u96E2\u306E\u30D3\u30C3\u30C8\u6570\u3002\n \
    \       var queue = initRadixHeap[T, int](ZERO)\n        var costs = newSeq[T](len(G))\n\
    \        costs.fill(INF)\n        when restore:\n            var prev = newSeq[int](len(G))\n\
    \            prev.fill(-1)\n        when start is int:\n            costs[start]\
    \ = ZERO\n            queue.push(ZERO, start)\n        else:\n            for\
    \ s in start:\n                if costs[s] != ZERO:\n                    costs[s]\
    \ = ZERO\n                    queue.push(ZERO, s)\n        while queue.len !=\
    \ 0:\n            let (cost, i) = queue.pop()\n            if cost > costs[i]:\
    \ continue\n            when stopAtGoal:\n                if i == goal: break\n\
    \            for (j, c) in G.to_and_cost(i):\n                assert c >= 0, \"\
    dijkstra_radix\u306E\u8FBA\u91CD\u307F\u306F\u975E\u8CA0\u3067\u3042\u308B\u5FC5\
    \u8981\u304C\u3042\u308A\u307E\u3059\"\n                if cost > high(T) - c:\
    \ continue\n                let nextCost = cost + c\n                if nextCost\
    \ < costs[j]:\n                    costs[j] = nextCost\n                    when\
    \ restore: prev[j] = i\n                    queue.push(nextCost, j)\n        when\
    \ restore: return (costs: costs, prev: prev)\n        else: return costs\n\n \
    \   proc dijkstra_radix*[T: SomeInteger](G: DynamicGraph[T] or StaticGraph[T],\
    \ start: int or seq[int],\n            ZERO: T = T(0), INF: T = radixDijkstraInf(T)):\
    \ seq[T] =\n        ## \u975E\u8CA0\u6574\u6570\u91CD\u307F\u306E\u6700\u77ED\u8DDD\
    \u96E2\u3092\u6C42\u3081\u308B\u3002INF \u4EE5\u4E0A\u306F\u672A\u5230\u9054\u6271\
    \u3044\u3002O(V + (E + S)B)\u3002\n        dijkstraRadixImpl(G, start, ZERO, INF,\
    \ false, false)\n\n    proc dijkstra_radix*(G: UnWeightedGraph, start: int or\
    \ seq[int], ZERO: int = 0, INF: int = INF64): seq[int] =\n        ## \u91CD\u307F\
    \u3092 1 \u3068\u3057\u3066\u6700\u77ED\u8DDD\u96E2\u3092\u6C42\u3081\u308B\u3002\
    O(V + (E + S)B)\u3002\n        dijkstraRadixImpl(G, start, ZERO, INF, false, false)\n\
    \n    proc restore_dijkstra_radix*[T: SomeInteger](G: DynamicGraph[T] or StaticGraph[T],\
    \ start: int or seq[int],\n            ZERO: T = T(0), INF: T = radixDijkstraInf(T)):\
    \ tuple[costs: seq[T], prev: seq[int]] =\n        ## \u975E\u8CA0\u6574\u6570\u91CD\
    \u307F\u306E\u6700\u77ED\u8DDD\u96E2\u3068\u76F4\u524D\u306E\u9802\u70B9\u3092\
    \u8FD4\u3059\u3002\u540C\u8DDD\u96E2\u306E\u7D4C\u8DEF\u306F\u4E0D\u5B9A\u3002\
    O(V + (E + S)B)\u3002\n        dijkstraRadixImpl(G, start, ZERO, INF, true, false)\n\
    \n    proc restore_dijkstra_radix*(G: UnWeightedGraph, start: int or seq[int],\
    \ ZERO: int = 0,\n            INF: int = INF64): tuple[costs: seq[int], prev:\
    \ seq[int]] =\n        ## \u91CD\u307F\u3092 1 \u3068\u3057\u3066\u6700\u77ED\u8DDD\
    \u96E2\u3068\u76F4\u524D\u306E\u9802\u70B9\u3092\u8FD4\u3059\u3002O(V + (E + S)B)\u3002\
    \n        dijkstraRadixImpl(G, start, ZERO, INF, true, false)\n\n    proc shortest_path_dijkstra_radix*[T:\
    \ SomeInteger](G: DynamicGraph[T] or StaticGraph[T], start, goal: int,\n     \
    \       ZERO: T = T(0), INF: T = radixDijkstraInf(T)): tuple[path: seq[int], cost:\
    \ T] =\n        ## \u76EE\u7684\u5730\u304C\u78BA\u5B9A\u3059\u308B\u307E\u3067\
    \u63A2\u7D22\u3059\u308B\u3002\u672A\u5230\u9054\u6642\u306F (@[goal], INF)\u3002\
    O(V + EB)\u3002\n        let (costs, prev) = dijkstraRadixImpl(G, start, ZERO,\
    \ INF, true, true, goal)\n        result.path = prev.restore_shortest_path_from_prev(goal)\n\
    \        result.cost = costs[goal]\n\n    proc shortest_path_dijkstra_radix*(G:\
    \ UnWeightedGraph, start, goal: int, ZERO: int = 0,\n            INF: int = INF64):\
    \ tuple[path: seq[int], cost: int] =\n        ## \u91CD\u307F\u3092 1 \u3068\u3057\
    \u3066\u76EE\u7684\u5730\u307E\u3067\u63A2\u7D22\u3059\u308B\u3002\u672A\u5230\
    \u9054\u6642\u306F (@[goal], INF)\u3002O(V + EB)\u3002\n        let (costs, prev)\
    \ = dijkstraRadixImpl(G, start, ZERO, INF, true, true, goal)\n        result.path\
    \ = prev.restore_shortest_path_from_prev(goal)\n        result.cost = costs[goal]\n"
  dependsOn:
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/graph/graph.nim
  - cplib/utils/constants.nim
  - cplib/graph/graph.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/utils/constants.nim
  - cplib/collections/radix_heap.nim
  - cplib/collections/radix_heap.nim
  isVerificationFile: false
  path: cplib/graph/dijkstra_radix.nim
  requiredBy: []
  timestamp: '2026-09-23 19:26:35+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/static/restore_dijkstra_radix_static_test.nim
  - verify/graph/static/restore_dijkstra_radix_static_test.nim
  - verify/graph/dynamic/restore_dijkstra_radix_test.nim
  - verify/graph/dynamic/restore_dijkstra_radix_test.nim
  - verify/AI/dijkstra_radix_test.nim
  - verify/AI/dijkstra_radix_test.nim
documentation_of: cplib/graph/dijkstra_radix.nim
layout: document
redirect_from:
- /library/cplib/graph/dijkstra_radix.nim
- /library/cplib/graph/dijkstra_radix.nim.html
title: cplib/graph/dijkstra_radix.nim
---
