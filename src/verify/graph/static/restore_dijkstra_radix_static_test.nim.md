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
    path: cplib/graph/dijkstra_radix.nim
    title: cplib/graph/dijkstra_radix.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dijkstra_radix.nim
    title: cplib/graph/dijkstra_radix.nim
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
    PROBLEM: https://judge.yosupo.jp/problem/shortest_path
    links:
    - https://judge.yosupo.jp/problem/shortest_path
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/shortest_path\n\
    include cplib/tmpl/sheep\ninclude cplib/graph/graph\ninclude cplib/graph/dijkstra_radix\n\
    \nlet N, M, s, t = ii()\nvar G = initWeightedDirectedStaticGraph(N)\nfor i in\
    \ 0..<M:\n    let a, b, c = ii()\n    G.add_edge(a, b, c)\nG.build()\nlet (path,\
    \ cost) = G.shortest_path_dijkstra_radix(s, t)\nif cost == INF64:\n    echo -1\n\
    else:\n    echo cost, \" \", path.len - 1\n    for i in 0..<path.len - 1:\n  \
    \      echo path[i], \" \", path[i + 1]\n"
  dependsOn:
  - cplib/tmpl/fastio.nim
  - cplib/utils/constants.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/collections/radix_heap.nim
  - cplib/graph/dijkstra_radix.nim
  - cplib/tmpl/fastio.nim
  - cplib/tmpl/sheep.nim
  - cplib/graph/dijkstra_radix.nim
  - cplib/graph/graph.nim
  - cplib/collections/radix_heap.nim
  - cplib/graph/graph.nim
  - cplib/tmpl/sheep.nim
  - cplib/utils/constants.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  isVerificationFile: true
  path: verify/graph/static/restore_dijkstra_radix_static_test.nim
  requiredBy: []
  timestamp: '2026-09-23 19:26:35+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/static/restore_dijkstra_radix_static_test.nim
layout: document
redirect_from:
- /verify/verify/graph/static/restore_dijkstra_radix_static_test.nim
- /verify/verify/graph/static/restore_dijkstra_radix_static_test.nim.html
title: verify/graph/static/restore_dijkstra_radix_static_test.nim
---
