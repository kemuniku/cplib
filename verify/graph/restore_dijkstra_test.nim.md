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
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
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
    var N, M, s, t = ii()\nvar G = initWeightedDirectedGraph(N)\nfor i in 0..<M:\n\
    \    var a, b, c = ii()\n    G.add_edge(a, b, c)\nvar (path, cost) = G.shortest_path(s,\
    \ t)\nif len(path) == 1:\n    echo -1\nelse:\n    echo cost, \" \", len(path)-1\n\
    \    for i in 0..<len(path)-1:\n        echo path[i], \" \", path[i+1]\n"
  dependsOn:
  - cplib/tmpl/sheep.nim
  - cplib/graph/graph.nim
  - cplib/tmpl/sheep.nim
  - cplib/graph/dijkstra.nim
  - cplib/graph/graph.nim
  - cplib/graph/dijkstra.nim
  isVerificationFile: true
  path: verify/graph/restore_dijkstra_test.nim
  requiredBy: []
  timestamp: '2024-01-18 19:23:28+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/restore_dijkstra_test.nim
layout: document
redirect_from:
- /verify/verify/graph/restore_dijkstra_test.nim
- /verify/verify/graph/restore_dijkstra_test.nim.html
title: verify/graph/restore_dijkstra_test.nim
---