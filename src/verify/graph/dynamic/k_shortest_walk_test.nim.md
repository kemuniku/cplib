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
    path: cplib/graph/k_shortest_walk.nim
    title: cplib/graph/k_shortest_walk.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/k_shortest_walk.nim
    title: cplib/graph/k_shortest_walk.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
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
    PROBLEM: https://judge.yosupo.jp/problem/k_shortest_walk
    links:
    - https://judge.yosupo.jp/problem/k_shortest_walk
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/k_shortest_walk\n\
    include cplib/tmpl/sheep\nimport cplib/graph/graph\nimport cplib/graph/k_shortest_walk\n\
    \nlet n, m, s, t, k = ii()\nvar g = initWeightedDirectedGraph(n)\nfor _ in 0..<m:\n\
    \    let a, b, c = ii()\n    g.add_edge(a, b, c)\nlet lengths = g.k_shortest_walk(s,\
    \ t, k)\nfor i in 0..<k:\n    echo (if lengths[i] == INF: -1 else: lengths[i])\n"
  dependsOn:
  - cplib/tmpl/sheep.nim
  - cplib/graph/k_shortest_walk.nim
  - cplib/graph/k_shortest_walk.nim
  - cplib/tmpl/fastio.nim
  - cplib/utils/constants.nim
  - cplib/tmpl/fastio.nim
  - cplib/graph/graph.nim
  - cplib/tmpl/sheep.nim
  - cplib/utils/constants.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/graph/dynamic/k_shortest_walk_test.nim
  requiredBy: []
  timestamp: '2026-09-13 17:15:27+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/dynamic/k_shortest_walk_test.nim
layout: document
redirect_from:
- /verify/verify/graph/dynamic/k_shortest_walk_test.nim
- /verify/verify/graph/dynamic/k_shortest_walk_test.nim.html
title: verify/graph/dynamic/k_shortest_walk_test.nim
---
