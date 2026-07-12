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
    path: cplib/graph/warshall_floyd.nim
    title: cplib/graph/warshall_floyd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/warshall_floyd.nim
    title: cplib/graph/warshall_floyd.nim
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


    import cplib/graph/graph

    import cplib/graph/warshall_floyd


    var g = initWeightedDirectedGraph(3)

    g.add_edge(0, 1, 2)

    g.add_edge(1, 2, 3)

    g.add_edge(0, 2, 10)

    let wf = g.warshall_floyd()

    assert not wf.negative_cycle

    assert wf.d[0][2] == 5


    var ng = initWeightedDirectedGraph(2)

    ng.add_edge(0, 1, -2)

    ng.add_edge(1, 0, -2)

    assert ng.warshall_floyd().negative_cycle

    '
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/graph/warshall_floyd.nim
  - cplib/graph/warshall_floyd.nim
  - cplib/utils/constants.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/AI/warshall_floyd_test.nim
  requiredBy: []
  timestamp: '2026-07-07 07:56:57+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/warshall_floyd_test.nim
layout: document
redirect_from:
- /verify/verify/AI/warshall_floyd_test.nim
- /verify/verify/AI/warshall_floyd_test.nim.html
title: verify/AI/warshall_floyd_test.nim
---
