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
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/bellmanford_grl1b_test.nim
    title: verify/graph/dynamic/bellmanford_grl1b_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/bellmanford_grl1b_test.nim
    title: verify/graph/dynamic/bellmanford_grl1b_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/bellmanford_grl1b_test.nim
    title: verify/graph/static/bellmanford_grl1b_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/bellmanford_grl1b_test.nim
    title: verify/graph/static/bellmanford_grl1b_test.nim
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
  code: "when not declared CPLIB_GRAPH_BELLMANFORD:\n    const CPLIB_GRAPH_BELLMANFORD*\
    \ = 1\n    import deques, sequtils, macros\n    import cplib/graph/graph\n   \
    \ import cplib/graph/restore_shortest_path_from_prev\n    import cplib/utils/constants\n\
    \    proc restore_bellmanford_impl[T](G: DynamicGraph[T] or StaticGraph[T], start:\
    \ int or seq[int], ZERO, INF: T): tuple[costs: seq[T], prev: seq[int]] =\n   \
    \     let N = len(G)\n        var\n            costs = newSeqWith(N, INF)\n  \
    \          prev = newSeqWith(N, -1)\n            changed: bool\n        when start\
    \ is int:\n            costs[start] = ZERO\n        else:\n            for s in\
    \ start:\n                costs[s] = ZERO\n        for _ in 0..<N:\n         \
    \   changed = false\n            for i in 0..<N:\n                if costs[i]\
    \ == INF: continue\n                for (j, c) in G[i]:\n                    var\
    \ temp = costs[i] + c\n                    if temp < costs[j]:\n             \
    \           prev[j] = i\n                        costs[j] = temp\n           \
    \             changed = true\n            if not changed: break\n        if changed:\n\
    \            for _ in 0..<N:\n                for i in 0..<N:\n              \
    \      if costs[i] == INF: continue\n                    for (j, c) in G[i]:\n\
    \                        var temp = costs[i] + c\n                        if temp\
    \ < costs[j]:\n                            costs[j] = -INF\n                 \
    \           prev[j] = -1\n        return (costs, prev)\n    macro declareBellmanFord(name,\
    \ t, zero, inf) =\n        let impl_name = ident($`name` & \"_impl\")\n      \
    \  quote do:\n            proc `name`*(G: DynamicGraph[`t`] or StaticGraph[`t`],\
    \ start: int or seq[int], ZERO: `t` = `zero`, INF: `t` = `inf`): auto =\n    \
    \            `impl_name`(G, start, ZERO, INF)\n    declareBellmanFord(restore_bellmanford,\
    \ int, 0, INF64)\n    declareBellmanFord(restore_bellmanford, int32, 0, INF32)\n\
    \    declareBellmanFord(restore_bellmanford, float, 0.0, 1e100)\n    proc restore_bellmanford*[T](G:\
    \ DynamicGraph[T] or StaticGraph[T], start: int or seq[int], ZERO, INF: T): auto\
    \ =\n        restore_bellmanford_impl(G, start, ZERO, INF)\n    proc bellmanford_impl[T](G:\
    \ DynamicGraph[T] or StaticGraph[T], start: int or seq[int], ZERO, INF: T): auto\
    \ =\n        var (costs, _) = restore_bellmanford(G, start, ZERO, INF)\n     \
    \   return costs\n    declareBellmanFord(bellmanford, int, 0, INF64)\n    declareBellmanFord(bellmanford,\
    \ int32, 0, INF32)\n    declareBellmanFord(bellmanford, float, 0.0, 1e100)\n \
    \   proc bellmanford*[T](G: DynamicGraph[T] or StaticGraph[T], start: int or seq[int],\
    \ ZERO, INF: T): auto =\n        bellmanford_impl(G, start, ZERO, INF)\n    proc\
    \ shortest_path_bellmanford_impl[T](G: DynamicGraph[T] or StaticGraph[T], start,\
    \ goal: int, ZERO, INF: T): tuple[path: seq[int], cost: T] =\n        var (costs,\
    \ prev) = restore_bellmanford(G, start, ZERO, INF)\n        result.path = prev.restore_shortest_path_from_prev(goal)\n\
    \        result.cost = costs[goal]\n    proc shortest_path_bellmanford*(G: DynamicGraph[int]\
    \ or StaticGraph[int], start, goal: int, ZERO: int = 0, INF: int = INF64): tuple[path:\
    \ seq[int], cost: int] =\n        shortest_path_bellmanford_impl(G, start, goal,\
    \ ZERO, INF)\n    proc shortest_path_bellmanford*(G: DynamicGraph[int32] or StaticGraph[int32],\
    \ start, goal: int, ZERO: int32 = 0, INF: int32 = INF32): tuple[path: seq[int],\
    \ cost: int32] =\n        shortest_path_bellmanford_impl(G, start, goal, ZERO,\
    \ INF)\n    proc shortest_path_bellmanford*[T](G: DynamicGraph[T] or StaticGraph[T],\
    \ start, goal: int, ZERO, INF: T): tuple[path: seq[int], cost: T] =\n        shortest_path_bellmanford_impl(G,\
    \ start, goal, ZERO, INF)\n"
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/graph/graph.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/utils/constants.nim
  - cplib/graph/graph.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  isVerificationFile: false
  path: cplib/graph/bellmanford.nim
  requiredBy: []
  timestamp: '2025-03-09 17:42:58+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/static/bellmanford_grl1b_test.nim
  - verify/graph/static/bellmanford_grl1b_test.nim
  - verify/graph/dynamic/bellmanford_grl1b_test.nim
  - verify/graph/dynamic/bellmanford_grl1b_test.nim
documentation_of: cplib/graph/bellmanford.nim
layout: document
redirect_from:
- /library/cplib/graph/bellmanford.nim
- /library/cplib/graph/bellmanford.nim.html
title: cplib/graph/bellmanford.nim
---
