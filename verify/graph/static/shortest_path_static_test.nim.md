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
    path: cplib/graph/restore_shortest_path_from_prev.nim
    title: cplib/graph/restore_shortest_path_from_prev.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/restore_shortest_path_from_prev.nim
    title: cplib/graph/restore_shortest_path_from_prev.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
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
    PROBLEM: https://judge.yosupo.jp/problem/shortest_path
    links:
    - https://judge.yosupo.jp/problem/shortest_path
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/shortest_path\n\
    include cplib/tmpl/sheep\nimport cplib/graph/graph\nimport cplib/graph/dijkstra\n\
    import cplib/graph/restore_shortest_path_from_prev\nvar N, M, s, t = ii()\nvar\
    \ G = initWeightedDirectedGraph(N)\nfor i in 0..<M:\n    var a, b, c = ii()\n\
    \    G.add_edge(a, b, c)\nvar (costs, prev) = G.restore_dijkstra(s)\nif costs[t]\
    \ == INF:\n    echo -1\nelse:\n    var path = prev.restore_shortestpath_from_prev(t)\n\
    \    echo costs[t], \" \", len(path)-1\n    for i in 0..<len(path)-1:\n      \
    \  echo path[i], \" \", path[i+1]\n"
  dependsOn:
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/graph/dijkstra.nim
  - cplib/tmpl/sheep.nim
  - cplib/utils/constants.nim
  - cplib/graph/dijkstra.nim
  - cplib/graph/graph.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/graph/graph.nim
  - cplib/tmpl/sheep.nim
  - cplib/utils/constants.nim
  isVerificationFile: true
  path: verify/graph/static/shortest_path_static_test.nim
  requiredBy: []
  timestamp: '2024-09-21 03:52:16+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/static/shortest_path_static_test.nim
layout: document
redirect_from:
- /verify/verify/graph/static/shortest_path_static_test.nim
- /verify/verify/graph/static/shortest_path_static_test.nim.html
title: verify/graph/static/shortest_path_static_test.nim
---
