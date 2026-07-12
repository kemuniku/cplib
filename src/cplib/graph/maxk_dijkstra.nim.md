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
  - icon: ':warning:'
    path: verify/graph/dynamic/grid_to_graph_abc151d_test_.nim
    title: verify/graph/dynamic/grid_to_graph_abc151d_test_.nim
  - icon: ':warning:'
    path: verify/graph/dynamic/grid_to_graph_abc151d_test_.nim
    title: verify/graph/dynamic/grid_to_graph_abc151d_test_.nim
  - icon: ':warning:'
    path: verify/graph/dynamic/maxk_dijkstra_abc176d_test_.nim
    title: verify/graph/dynamic/maxk_dijkstra_abc176d_test_.nim
  - icon: ':warning:'
    path: verify/graph/dynamic/maxk_dijkstra_abc176d_test_.nim
    title: verify/graph/dynamic/maxk_dijkstra_abc176d_test_.nim
  - icon: ':warning:'
    path: verify/graph/static/grid_to_graph_abc151d_test_.nim
    title: verify/graph/static/grid_to_graph_abc151d_test_.nim
  - icon: ':warning:'
    path: verify/graph/static/grid_to_graph_abc151d_test_.nim
    title: verify/graph/static/grid_to_graph_abc151d_test_.nim
  - icon: ':warning:'
    path: verify/graph/static/maxk_dijkstra_abc176d_test_.nim
    title: verify/graph/static/maxk_dijkstra_abc176d_test_.nim
  - icon: ':warning:'
    path: verify/graph/static/maxk_dijkstra_abc176d_test_.nim
    title: verify/graph/static/maxk_dijkstra_abc176d_test_.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/graph_weight_type_test.nim
    title: verify/AI/graph_weight_type_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/graph_weight_type_test.nim
    title: verify/AI/graph_weight_type_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/maxk_dijkstra_test.nim
    title: verify/AI/maxk_dijkstra_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/maxk_dijkstra_test.nim
    title: verify/AI/maxk_dijkstra_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/tsp_test.nim
    title: verify/AI/tsp_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/tsp_test.nim
    title: verify/AI/tsp_test.nim
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
  code: "when not declared CPLIB_GRAPH_MAXK_DIJKSTRA:\n    const CPLIB_GRAPH_MAXK_DIJKSTRA*\
    \ = 1\n    import cplib/graph/graph\n    import cplib/utils/constants\n    import\
    \ cplib/graph/restore_shortest_path_from_prev\n    import sequtils, algorithm,\
    \ macros\n    proc maxk_dijkstra_impl[T: SomeInteger](G: DynamicGraph[T] or StaticGraph[T],\
    \ start: int or seq[int], k, ZERO, INF: T): seq[T] =\n        var\n          \
    \  width = k + 1\n            bcnt = width.int\n            queue = newSeqWith(bcnt,\
    \ newSeq[int32]())\n            cur = ZERO\n            cnt = 0\n            pos\
    \ = 0\n        result = newSeq[T](len(G))\n        result.fill(INF)\n        when\
    \ start is int:\n            queue[0].add(start.int32)\n            result[start]\
    \ = ZERO\n        else:\n            for s in start:\n                queue[0].add(s.int32)\n\
    \                result[s] = ZERO\n        while cnt < bcnt:\n            if queue[pos].len\
    \ == 0:\n                inc pos\n                if pos == bcnt: pos = 0\n  \
    \              cur += 1\n                inc cnt\n                continue\n \
    \           while queue[pos].len > 0:\n                let i = queue[pos].pop.int\n\
    \                let cost = result[i]\n                if cost != cur: continue\n\
    \                for (j, c) in G.to_and_cost(i):\n                    let temp\
    \ = cost + c\n                    if temp < result[j]:\n                     \
    \   result[j] = temp\n                        var pn = pos + c.int\n         \
    \               if pn >= bcnt: pn -= bcnt\n                        queue[pn].add(j.int32)\n\
    \            cnt = 0\n            inc pos\n            if pos == bcnt: pos = 0\n\
    \            cur += 1\n    proc restore_maxk_dijkstra_impl[T: SomeInteger](G:\
    \ DynamicGraph[T] or StaticGraph[T], start: int or seq[int], k, ZERO, INF: T):\
    \ tuple[costs: seq[T], prev: seq[int]] =\n        var\n            width = k +\
    \ 1\n            bcnt = width.int\n            queue = newSeqWith(bcnt, newSeq[int32]())\n\
    \            costs = newSeq[T](len(G))\n            prev = newSeq[int](len(G))\n\
    \            cur = ZERO\n            cnt = 0\n            pos = 0\n        costs.fill(INF)\n\
    \        prev.fill(-1)\n        when start is int:\n            queue[0].add(start.int32)\n\
    \            costs[start] = ZERO\n        else:\n            for s in start:\n\
    \                queue[0].add(s.int32)\n                costs[s] = ZERO\n    \
    \    while cnt < bcnt:\n            if queue[pos].len == 0:\n                inc\
    \ pos\n                if pos == bcnt: pos = 0\n                cur += 1\n   \
    \             inc cnt\n                continue\n            while queue[pos].len\
    \ > 0:\n                let i = queue[pos].pop.int\n                let cost =\
    \ costs[i]\n                if cost != cur: continue\n                for (j,\
    \ c) in G.to_and_cost(i):\n                    let temp = cost + c\n         \
    \           if temp < costs[j]:\n                        prev[j] = i\n       \
    \                 costs[j] = temp\n                        var pn = pos + c.int\n\
    \                        if pn >= bcnt: pn -= bcnt\n                        queue[pn].add(j.int32)\n\
    \            cnt = 0\n            inc pos\n            if pos == bcnt: pos = 0\n\
    \            cur += 1\n        return (costs, prev)\n    macro declareMaxkDijkstra(name,\
    \ t, zero, inf) =\n        let impl_name = ident($`name` & \"_impl\")\n      \
    \  quote do:\n            proc `name`*(G: DynamicGraph[`t`] or StaticGraph[`t`],\
    \ start: int or seq[int], k: `t`, ZERO: `t` = `zero`, INF: `t` = `inf`): auto\
    \ =\n                `impl_name`(G, start, k, ZERO, INF)\n    declareMaxkDijkstra(restore_maxk_dijkstra,\
    \ int, 0, INF64)\n    declareMaxkDijkstra(restore_maxk_dijkstra, int32, 0i32,\
    \ INF32)\n    proc restore_maxk_dijkstra*[T: SomeInteger](G: DynamicGraph[T] or\
    \ StaticGraph[T], start: int or seq[int], k, ZERO, INF: T): auto =\n        restore_maxk_dijkstra_impl(G,\
    \ start, k, ZERO, INF)\n    declareMaxkDijkstra(maxk_dijkstra, int, 0, INF64)\n\
    \    declareMaxkDijkstra(maxk_dijkstra, int32, 0i32, INF32)\n    proc maxk_dijkstra*[T:\
    \ SomeInteger](G: DynamicGraph[T] or StaticGraph[T], start: int or seq[int], k,\
    \ ZERO, INF: T): auto =\n        maxk_dijkstra_impl(G, start, k, ZERO, INF)\n\
    \    proc shortest_path_maxk_dijkstra_impl[T: SomeInteger](G: DynamicGraph[T]\
    \ or StaticGraph[T], start, goal: int, k, ZERO, INF: T): tuple[path: seq[int],\
    \ cost: T] =\n        var (costs, prev) = restore_maxk_dijkstra(G, start, k, ZERO,\
    \ INF)\n        result.path = prev.restore_shortest_path_from_prev(goal)\n   \
    \     result.cost = costs[goal]\n    proc shortest_path_maxk_dijkstra*(G: DynamicGraph[int]\
    \ or StaticGraph[int], start, goal: int, k: int, ZERO: int = 0, INF: int = INF64):\
    \ tuple[path: seq[int], cost: int] =\n        return shortest_path_maxk_dijkstra_impl(G,\
    \ start, goal, k, ZERO, INF)\n    proc shortest_path_maxk_dijkstra*(G: DynamicGraph[int32]\
    \ or StaticGraph[int32], start, goal: int, k: int32, ZERO: int32 = 0.int32, INF:\
    \ int32 = INF32): tuple[path: seq[int], cost: int32] =\n        return shortest_path_maxk_dijkstra_impl(G,\
    \ start, goal, k, ZERO, INF)\n    proc shortest_path_maxk_dijkstra*[T: SomeInteger](G:\
    \ DynamicGraph[T] or StaticGraph[T], start, goal: int, k, ZERO, INF: T): tuple[path:\
    \ seq[int], cost: T] =\n        return shortest_path_maxk_dijkstra_impl(G, start,\
    \ goal, k, ZERO, INF)\n"
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/utils/constants.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/maxk_dijkstra.nim
  requiredBy:
  - verify/graph/static/maxk_dijkstra_abc176d_test_.nim
  - verify/graph/static/maxk_dijkstra_abc176d_test_.nim
  - verify/graph/static/grid_to_graph_abc151d_test_.nim
  - verify/graph/static/grid_to_graph_abc151d_test_.nim
  - verify/graph/dynamic/maxk_dijkstra_abc176d_test_.nim
  - verify/graph/dynamic/maxk_dijkstra_abc176d_test_.nim
  - verify/graph/dynamic/grid_to_graph_abc151d_test_.nim
  - verify/graph/dynamic/grid_to_graph_abc151d_test_.nim
  - cplib/graph/tsp.nim
  - cplib/graph/tsp.nim
  timestamp: '2026-07-07 07:56:57+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/maxk_dijkstra_test.nim
  - verify/AI/maxk_dijkstra_test.nim
  - verify/AI/tsp_test.nim
  - verify/AI/tsp_test.nim
  - verify/AI/graph_weight_type_test.nim
  - verify/AI/graph_weight_type_test.nim
documentation_of: cplib/graph/maxk_dijkstra.nim
layout: document
redirect_from:
- /library/cplib/graph/maxk_dijkstra.nim
- /library/cplib/graph/maxk_dijkstra.nim.html
title: cplib/graph/maxk_dijkstra.nim
---
