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
    path: cplib/utils/infl.nim
    title: cplib/utils/infl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/infl.nim
    title: cplib/utils/infl.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/grid_to_graph_abc151d_test.nim
    title: verify/graph/dynamic/grid_to_graph_abc151d_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/grid_to_graph_abc151d_test.nim
    title: verify/graph/dynamic/grid_to_graph_abc151d_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/maxk_dijkstra_abc176d_test.nim
    title: verify/graph/dynamic/maxk_dijkstra_abc176d_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/maxk_dijkstra_abc176d_test.nim
    title: verify/graph/dynamic/maxk_dijkstra_abc176d_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/grid_to_graph_abc151d_test.nim
    title: verify/graph/static/grid_to_graph_abc151d_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/grid_to_graph_abc151d_test.nim
    title: verify/graph/static/grid_to_graph_abc151d_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/maxk_dijkstra_abc176d_test.nim
    title: verify/graph/static/maxk_dijkstra_abc176d_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/maxk_dijkstra_abc176d_test.nim
    title: verify/graph/static/maxk_dijkstra_abc176d_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GRAPH_MAXK_DIJKSTRA:\n    const CPLIB_GRAPH_MAXK_DIJKSTRA*\
    \ = 1\n    import cplib/graph/graph\n    import cplib/utils/infl\n    import sequtils,\
    \ algorithm, macros\n    proc restore_maxk_dijkstra_impl[T: SomeInteger](G: DynamicGraph[T]\
    \ or StaticGraph[T], start: int or seq[int], k, ZERO, INF: T): tuple[costs: seq[T],\
    \ prev: seq[int]] =\n        var\n            k = k+1\n            queue = newSeqWith(k,\
    \ newSeq[int32]())\n            costs = newSeq[T](len(G))\n            prev =\
    \ newSeq[int](len(G))\n            cnt, pos = 0\n        costs.fill(INF)\n   \
    \     prev.fill(-1)\n        when start is int:\n            queue[0].add(start.int32)\n\
    \            costs[start] = ZERO\n        else:\n            for s in start:\n\
    \                queue[0].add(s.int32)\n                costs[s] = ZERO\n    \
    \    while cnt < k:\n            if queue[pos].len == 0:\n                pos\
    \ += 1\n                if pos >= k: pos -= k\n                cnt += 1\n    \
    \            continue\n            while queue[pos].len > 0:\n               \
    \ var i = queue[pos].pop\n                var cost = costs[i]\n              \
    \  if cost mod k != pos: continue\n                for (j, c) in G.to_and_cost(i):\n\
    \                    var temp = cost + c\n                    if temp < costs[j]:\n\
    \                        prev[j] = i\n                        costs[j] = temp\n\
    \                        var pn = pos + c\n                        if pn >= k:\
    \ pn -= k\n                        queue[pn].add(j.int32)\n            cnt = 0\n\
    \            pos += 1\n            if pos >= k: pos -= k\n        return (costs,\
    \ prev)\n    macro declareMaxkDijkstra(name, t, zero, inf) =\n        let impl_name\
    \ = ident($`name` & \"_impl\")\n        quote do:\n            proc `name`*(G:\
    \ DynamicGraph[`t`] or StaticGraph[`t`], start: int or seq[int], k: `t`, ZERO:\
    \ `t` = `zero`, INF: `t` = `inf`): auto =\n                `impl_name`(G, start,\
    \ k, ZERO, INF)\n    declareMaxkDijkstra(restore_maxk_dijkstra, int, 0, INFL)\n\
    \    declareMaxkDijkstra(restore_maxk_dijkstra, int32, 0i32, INFi32)\n    proc\
    \ restore_maxk_dijkstra*[T: SomeInteger](G: DynamicGraph[T] or StaticGraph[T],\
    \ start: int or seq[int], k, ZERO, INF: T): auto =\n        restore_maxk_dijkstra_impl(G,\
    \ start, k, ZERO, INF)\n    proc maxk_dijkstra_impl[T: SomeInteger](G: DynamicGraph[T]\
    \ or StaticGraph[T], start: int or seq[int], k: T, ZERO, INF: T): seq[T] =\n \
    \       var (costs, _) = restore_maxk_dijkstra(G, start, k, ZERO, INF)\n     \
    \   return costs\n    declareMaxkDijkstra(maxk_dijkstra, int, 0, INFL)\n    declareMaxkDijkstra(maxk_dijkstra,\
    \ int32, 0i32, INFi32)\n    proc maxk_dijkstra*[T: SomeInteger](G: DynamicGraph[T]\
    \ or StaticGraph[T], start: int or seq[int], k, ZERO, INF: T): auto =\n      \
    \  maxk_dijkstra_impl(G, start, k, ZERO, INF)\n    proc restore_shortestpath_from_prev*(prev:\
    \ seq[int], goal: int): seq[int] =\n        var i = goal\n        while i != -1:\n\
    \            result.add(i)\n            i = prev[i]\n        result = result.reversed()\n\
    \    proc shortest_path*(G: DynamicGraph[int] or StaticGraph[int], start, goal,\
    \ k: int, ZERO: int = 0, INF: int = INFL): tuple[path: seq[int], cost: int] =\n\
    \        var (costs, prev) = restore_maxk_dijkstra(G, start, k, ZERO, INF)\n \
    \       result.path = prev.restore_shortestpath_from_prev(goal)\n        result.cost\
    \ = costs[goal]\n"
  dependsOn:
  - cplib/utils/infl.nim
  - cplib/graph/graph.nim
  - cplib/utils/infl.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/maxk_dijkstra.nim
  requiredBy: []
  timestamp: '2024-04-11 03:42:22+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/dynamic/maxk_dijkstra_abc176d_test.nim
  - verify/graph/dynamic/maxk_dijkstra_abc176d_test.nim
  - verify/graph/dynamic/grid_to_graph_abc151d_test.nim
  - verify/graph/dynamic/grid_to_graph_abc151d_test.nim
  - verify/graph/static/maxk_dijkstra_abc176d_test.nim
  - verify/graph/static/maxk_dijkstra_abc176d_test.nim
  - verify/graph/static/grid_to_graph_abc151d_test.nim
  - verify/graph/static/grid_to_graph_abc151d_test.nim
documentation_of: cplib/graph/maxk_dijkstra.nim
layout: document
redirect_from:
- /library/cplib/graph/maxk_dijkstra.nim
- /library/cplib/graph/maxk_dijkstra.nim.html
title: cplib/graph/maxk_dijkstra.nim
---
