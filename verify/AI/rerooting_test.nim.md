---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/tree/rerooting.nim
    title: cplib/tree/rerooting.nim
  - icon: ':question:'
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
  code: '# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

    echo "Hello World"


    import cplib/graph/graph

    import cplib/tree/rerooting


    var g = initUnWeightedUnDirectedGraph(4)

    g.add_edge(0, 1)

    g.add_edge(1, 2)

    g.add_edge(1, 3)


    proc merge(a, b: int): int = max(a, b)

    proc putEdge(x: int, u, v: int): int = x + 1

    proc putVertex(x: int, v: int): int = x


    assert g.solve_Rerooting_raw(merge, 0, putEdge, putVertex) == @[2, 1, 2, 2]

    assert g.solve_Rerooting(merge, 0, putEdge, putVertex) == @[2, 1, 2, 2]

    '
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/tree/rerooting.nim
  - cplib/tree/rerooting.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/AI/rerooting_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/rerooting_test.nim
layout: document
redirect_from:
- /verify/verify/AI/rerooting_test.nim
- /verify/verify/AI/rerooting_test.nim.html
title: verify/AI/rerooting_test.nim
---
