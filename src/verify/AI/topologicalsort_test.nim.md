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
    path: cplib/graph/topologicalsort.nim
    title: cplib/graph/topologicalsort.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/topologicalsort.nim
    title: cplib/graph/topologicalsort.nim
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

    import cplib/graph/topologicalsort


    var dag = initUnWeightedDirectedGraph(4)

    dag.add_edge(0, 1)

    dag.add_edge(0, 2)

    dag.add_edge(1, 3)

    dag.add_edge(2, 3)

    let ord = dag.topologicalsort

    assert ord.len == 4

    assert ord.find(0) < ord.find(1)

    assert ord.find(0) < ord.find(2)

    assert ord.find(1) < ord.find(3)

    assert dag.isDAG


    var cyc = initUnWeightedDirectedGraph(2)

    cyc.add_edge(0, 1)

    cyc.add_edge(1, 0)

    assert not cyc.isDAG

    '
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/topologicalsort.nim
  - cplib/graph/graph.nim
  - cplib/graph/topologicalsort.nim
  isVerificationFile: true
  path: verify/AI/topologicalsort_test.nim
  requiredBy: []
  timestamp: '2026-07-07 07:56:57+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/topologicalsort_test.nim
layout: document
redirect_from:
- /verify/verify/AI/topologicalsort_test.nim
- /verify/verify/AI/topologicalsort_test.nim.html
title: verify/AI/topologicalsort_test.nim
---
