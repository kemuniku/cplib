---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/namori_graph.nim
    title: cplib/graph/namori_graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/namori_graph.nim
    title: cplib/graph/namori_graph.nim
  - icon: ':question:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':question:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
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
  code: '# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

    echo "Hello World"


    import cplib/graph/graph

    import cplib/graph/namori_graph

    import cplib/utils/constants


    var g = initUnWeightedUnDirectedGraph(4)

    g.add_edge(0, 1)

    g.add_edge(1, 2)

    g.add_edge(2, 0)

    g.add_edge(1, 3)

    let ng = initNamoriGraph(g)

    assert ng.incycle(0)

    assert ng.incycle(1)

    assert ng.incycle(2)

    assert not ng.incycle(3)

    assert ng.root(3) == 1

    assert ng.same_tree(1, 3)

    assert not ng.same_tree(0, 3)

    assert ng.dist(0, 2) == (1, 2)

    assert ng.dist(1, 3) == (1, INF64)

    '
  dependsOn:
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/graph.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/namori_graph.nim
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  - cplib/graph/namori_graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/AI/namori_graph_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/namori_graph_test.nim
layout: document
redirect_from:
- /verify/verify/AI/namori_graph_test.nim
- /verify/verify/AI/namori_graph_test.nim.html
title: verify/AI/namori_graph_test.nim
---
