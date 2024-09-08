---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/bellmanford.nim
    title: cplib/graph/bellmanford.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/bellmanford.nim
    title: cplib/graph/bellmanford.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dijkstra.nim
    title: cplib/graph/dijkstra.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dijkstra.nim
    title: cplib/graph/dijkstra.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/maxk_dijkstra.nim
    title: cplib/graph/maxk_dijkstra.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/maxk_dijkstra.nim
    title: cplib/graph/maxk_dijkstra.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/bellmanford_grl1b_test.nim
    title: verify/graph/dynamic/bellmanford_grl1b_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/bellmanford_grl1b_test.nim
    title: verify/graph/dynamic/bellmanford_grl1b_test.nim
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
    path: verify/graph/static/bellmanford_grl1b_test.nim
    title: verify/graph/static/bellmanford_grl1b_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/bellmanford_grl1b_test.nim
    title: verify/graph/static/bellmanford_grl1b_test.nim
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
  code: "when not declared CPLIB_GRAPH_RESTORE_SHORTESTPATH_FROM_PREV:\n    const\
    \ CPLIB_GRAPH_RESTORE_SHORTESTPATH_FROM_PREV* = 1\n    import algorithm\n    proc\
    \ restore_shortest_path_from_prev*(prev: seq[int], goal: int): seq[int] =\n  \
    \      var i = goal\n        while i != -1:\n            result.add(i)\n     \
    \       i = prev[i]\n        result.reverse\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/graph/restore_shortest_path_from_prev.nim
  requiredBy:
  - cplib/graph/dijkstra.nim
  - cplib/graph/dijkstra.nim
  - cplib/graph/maxk_dijkstra.nim
  - cplib/graph/maxk_dijkstra.nim
  - cplib/graph/bellmanford.nim
  - cplib/graph/bellmanford.nim
  timestamp: '2024-06-25 04:43:29+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/static/shortest_path_static_test.nim
  - verify/graph/static/shortest_path_static_test.nim
  - verify/graph/static/grid_to_graph_abc151d_test.nim
  - verify/graph/static/grid_to_graph_abc151d_test.nim
  - verify/graph/static/maxk_dijkstra_abc176d_test.nim
  - verify/graph/static/maxk_dijkstra_abc176d_test.nim
  - verify/graph/static/restore_dijkstra_static_test.nim
  - verify/graph/static/restore_dijkstra_static_test.nim
  - verify/graph/static/bellmanford_grl1b_test.nim
  - verify/graph/static/bellmanford_grl1b_test.nim
  - verify/graph/dynamic/grid_to_graph_abc151d_test.nim
  - verify/graph/dynamic/grid_to_graph_abc151d_test.nim
  - verify/graph/dynamic/restore_dijkstra_test.nim
  - verify/graph/dynamic/restore_dijkstra_test.nim
  - verify/graph/dynamic/maxk_dijkstra_abc176d_test.nim
  - verify/graph/dynamic/maxk_dijkstra_abc176d_test.nim
  - verify/graph/dynamic/bellmanford_grl1b_test.nim
  - verify/graph/dynamic/bellmanford_grl1b_test.nim
  - verify/graph/dynamic/shortest_path_test.nim
  - verify/graph/dynamic/shortest_path_test.nim
documentation_of: cplib/graph/restore_shortest_path_from_prev.nim
layout: document
redirect_from:
- /library/cplib/graph/restore_shortest_path_from_prev.nim
- /library/cplib/graph/restore_shortest_path_from_prev.nim.html
title: cplib/graph/restore_shortest_path_from_prev.nim
---
