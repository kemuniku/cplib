---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dag_minimum_path_cover.nim
    title: cplib/graph/dag_minimum_path_cover.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dag_minimum_path_cover.nim
    title: cplib/graph/dag_minimum_path_cover.nim
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


    import cplib/graph/dag_minimum_path_cover

    import cplib/graph/graph


    var g = initUnWeightedDirectedGraph(4)

    g.add_edge(0, 1)

    g.add_edge(1, 2)

    g.add_edge(0, 3)

    assert dag_minimum_path_cover(g) == 2


    var chain = initUnWeightedDirectedGraph(3)

    chain.add_edge(0, 1)

    chain.add_edge(1, 2)

    assert dag_minimum_path_cover(chain) == 1

    '
  dependsOn:
  - cplib/graph/dag_minimum_path_cover.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/graph/topologicalsort.nim
  - cplib/graph/topologicalsort.nim
  - cplib/graph/dag_minimum_path_cover.nim
  isVerificationFile: true
  path: verify/AI/dag_minimum_path_cover_test.nim
  requiredBy: []
  timestamp: '2026-07-07 07:56:57+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/dag_minimum_path_cover_test.nim
layout: document
redirect_from:
- /verify/verify/AI/dag_minimum_path_cover_test.nim
- /verify/verify/AI/dag_minimum_path_cover_test.nim.html
title: verify/AI/dag_minimum_path_cover_test.nim
---
