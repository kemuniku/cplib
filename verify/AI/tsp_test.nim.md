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
    path: cplib/graph/maxk_dijkstra.nim
    title: cplib/graph/maxk_dijkstra.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/maxk_dijkstra.nim
    title: cplib/graph/maxk_dijkstra.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/restore_shortest_path_from_prev.nim
    title: cplib/graph/restore_shortest_path_from_prev.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/restore_shortest_path_from_prev.nim
    title: cplib/graph/restore_shortest_path_from_prev.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/tsp.nim
    title: cplib/graph/tsp.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/tsp.nim
    title: cplib/graph/tsp.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
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
    echo \"Hello World\"\n\nimport cplib/graph/graph\nimport cplib/graph/tsp\nimport\
    \ cplib/utils/constants\n\nlet dist = @[\n  @[0, 1, 4],\n  @[1, 0, 2],\n  @[4,\
    \ 2, 0],\n]\nassert tspPathAnyStart(dist, false) == 3\nassert tspPathCostFrom(dist,\
    \ 0, false) == 3\nassert tspPathCostFromTo(dist, 0, 0, false) == 7\nassert tspPathCostFromTo(dist,\
    \ 0, 0, true) == 6\n\nvar g = initWeightedUnDirectedGraph(3)\ng.add_edge(0, 1,\
    \ 2)\ng.add_edge(1, 2, 3)\ng.add_edge(0, 2, 10)\nlet cg = g.toContractionGraph(@[0,\
    \ 2])\nassert cg.to_adjacency_matrix()[0][1] == 5\n\nvar dg = initWeightedDirectedGraph(3)\n\
    dg.add_edge(0, 1, 10)\ndg.add_edge(0, 1, 4)\ndg.add_edge(1, 2, 8)\nlet mat = dg.to_adjacency_matrix()\n\
    assert mat[0][1] == 4\nassert mat[0][2] == INF64\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/utils/constants.nim
  - cplib/graph/maxk_dijkstra.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/utils/constants.nim
  - cplib/graph/dijkstra.nim
  - cplib/graph/graph.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/graph/tsp.nim
  - cplib/graph/maxk_dijkstra.nim
  - cplib/graph/tsp.nim
  - cplib/graph/dijkstra.nim
  isVerificationFile: true
  path: verify/AI/tsp_test.nim
  requiredBy: []
  timestamp: '2026-07-07 07:56:57+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/tsp_test.nim
layout: document
redirect_from:
- /verify/verify/AI/tsp_test.nim
- /verify/verify/AI/tsp_test.nim.html
title: verify/AI/tsp_test.nim
---
