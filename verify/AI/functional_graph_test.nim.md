---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/functional_graph.nim
    title: cplib/graph/functional_graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/functional_graph.nim
    title: cplib/graph/functional_graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
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


    import algorithm

    import cplib/graph/functional_graph

    import cplib/graph/graph


    var g = initUnWeightedDirectedGraph(4)

    g.add_edge(0, 1)

    g.add_edge(1, 2)

    g.add_edge(2, 1)

    g.add_edge(3, 2)

    let fg = initFunctionalGraph(g)

    assert not fg.incycle(0)

    assert fg.incycle(1)

    assert fg.incycle(2)

    assert fg.movekth(0, 0) == 0

    assert fg.movekth(0, 1) == 1

    assert fg.movekth(0, 2) == 2

    assert fg.movekth(0, 3) == 1

    assert fg.cyclesize(0) == 2

    assert fg.canmove_size(0) == 3

    assert fg.depth(0) == 1

    assert fg.dist(0, 2) == 2

    assert fg.dist(2, 1) == 1

    assert fg.get_cycle(0).sorted == @[1, 2]

    assert fg.root(0) == 1

    '
  dependsOn:
  - cplib/graph/functional_graph.nim
  - cplib/graph/functional_graph.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/AI/functional_graph_test.nim
  requiredBy: []
  timestamp: '2026-07-07 07:56:57+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/functional_graph_test.nim
layout: document
redirect_from:
- /verify/verify/AI/functional_graph_test.nim
- /verify/verify/AI/functional_graph_test.nim.html
title: verify/AI/functional_graph_test.nim
---
