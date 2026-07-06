---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/kruskal.nim
    title: cplib/graph/kruskal.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/kruskal.nim
    title: cplib/graph/kruskal.nim
  - icon: ':question:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':question:'
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
    echo \"Hello World\"\n\nimport cplib/graph/graph\nimport cplib/graph/kruskal\n\
    import cplib/utils/constants\n\nvar g = initWeightedUnDirectedGraph(4)\ng.add_edge(0,\
    \ 1, 1)\ng.add_edge(1, 2, 2)\ng.add_edge(2, 3, 3)\ng.add_edge(0, 3, 10)\ng.add_edge(0,\
    \ 2, 5)\nassert g.get_MST_cost == 6\n\nlet mst = g.to_MST_Graph\nvar edgeCount\
    \ = 0\nvar costSum = 0\nfor i in 0..<mst.len:\n  for (j, c) in mst[i]:\n    if\
    \ i < j:\n      edgeCount += 1\n      costSum += c\nassert edgeCount == 3\nassert\
    \ costSum == 6\n\nvar disconnected = initWeightedUnDirectedGraph(3)\ndisconnected.add_edge(0,\
    \ 1, 1)\nassert disconnected.get_MST_cost == INF64\n"
  dependsOn:
  - cplib/graph/kruskal.nim
  - cplib/graph/graph.nim
  - cplib/collections/unionfind.nim
  - cplib/graph/kruskal.nim
  - cplib/utils/constants.nim
  - cplib/collections/unionfind.nim
  - cplib/utils/constants.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/AI/kruskal_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/kruskal_test.nim
layout: document
redirect_from:
- /verify/verify/AI/kruskal_test.nim
- /verify/verify/AI/kruskal_test.nim.html
title: verify/AI/kruskal_test.nim
---
