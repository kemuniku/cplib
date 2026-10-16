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
    path: cplib/tree/rerooting.nim
    title: cplib/tree/rerooting.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/rerooting.nim
    title: cplib/tree/rerooting.nim
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
    import cplib/graph/graph\nimport cplib/tree/rerooting\n\ntype VertexValue = object\n\
    \    count: int\n\nproc merge(a, b: int): int = a + b\nproc putEdge(x: VertexValue,\
    \ u, v: int): int = x.count\nproc putVertex(x: int, v: int): VertexValue = VertexValue(count:\
    \ x + 1)\n\nfor n in 0..8:\n    var g = initUnWeightedUnDirectedGraph(n)\n   \
    \ for v in 1..<n:\n        g.add_edge((v - 1) div 2, v)\n    let raw = solve_Rerooting_raw(g,\
    \ merge, 0, putEdge, putVertex)\n    let values = solve_Rerooting(g, merge, 0,\
    \ putEdge, putVertex)\n    doAssert raw.len == n\n    doAssert values.len == n\n\
    \    for v in 0..<n:\n        doAssert raw[v] == n - 1\n        doAssert values[v].count\
    \ == n\n\nproc sameEdge(x: int, u, v: int): int = x\nproc sameVertex(x: int, v:\
    \ int): int = x + 1\n\nvar g = initUnWeightedUnDirectedGraph(3)\ng.add_edge(0,\
    \ 1)\ng.add_edge(1, 2)\ndoAssert solve_Rerooting(g, merge, 0, sameEdge, sameVertex)\
    \ == @[3, 3, 3]\necho \"Hello World\"\n"
  dependsOn:
  - cplib/tree/rerooting.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/tree/rerooting.nim
  isVerificationFile: true
  path: verify/tree/rerooting_distinct_types_test.nim
  requiredBy: []
  timestamp: '2026-10-01 00:34:14+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/tree/rerooting_distinct_types_test.nim
layout: document
redirect_from:
- /verify/verify/tree/rerooting_distinct_types_test.nim
- /verify/verify/tree/rerooting_distinct_types_test.nim.html
title: verify/tree/rerooting_distinct_types_test.nim
---
