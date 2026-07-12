---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/bellmanford.nim
    title: cplib/graph/bellmanford.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/bellmanford.nim
    title: cplib/graph/bellmanford.nim
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


    import cplib/graph/bellmanford

    import cplib/graph/graph


    var g = initWeightedDirectedGraph(4)

    g.add_edge(0, 1, 2)

    g.add_edge(1, 2, -5)

    g.add_edge(0, 2, 10)

    g.add_edge(2, 3, 1)

    assert g.bellmanford(0)[3] == -2

    let restored = g.restore_bellmanford(0)

    assert restored.costs[2] == -3

    assert restored.prev[3] == 2

    let sp = g.shortest_path_bellmanford(0, 3)

    assert sp.path == @[0, 1, 2, 3]

    assert sp.cost == -2


    var ng = initWeightedDirectedGraph(3)

    ng.add_edge(0, 1, 1)

    ng.add_edge(1, 2, -3)

    ng.add_edge(2, 1, 1)

    assert ng.bellmanford(0)[1] < -1_000_000_000

    '
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/bellmanford.nim
  - cplib/utils/constants.nim
  - cplib/graph/graph.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/utils/constants.nim
  - cplib/graph/bellmanford.nim
  isVerificationFile: true
  path: verify/AI/bellmanford_test.nim
  requiredBy: []
  timestamp: '2026-07-07 07:56:57+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/bellmanford_test.nim
layout: document
redirect_from:
- /verify/verify/AI/bellmanford_test.nim
- /verify/verify/AI/bellmanford_test.nim.html
title: verify/AI/bellmanford_test.nim
---
