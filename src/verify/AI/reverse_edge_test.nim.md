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
    path: cplib/graph/reverse_edge.nim
    title: cplib/graph/reverse_edge.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/reverse_edge.nim
    title: cplib/graph/reverse_edge.nim
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


    import sequtils

    import cplib/graph/graph

    import cplib/graph/reverse_edge


    var wg = initWeightedDirectedGraph(3)

    wg.add_edge(0, 1, 5)

    wg.add_edge(2, 1, 7)

    let rwg = wg.reverse_edge

    assert toSeq(rwg[1]) == @[(0, 5), (2, 7)]


    var ug = initUnWeightedDirectedGraph(3)

    ug.add_edge(0, 2)

    ug.add_edge(1, 2)

    let rug = ug.reverse_edge

    assert toSeq(rug[2]) == @[0, 1]


    var swg = initWeightedDirectedStaticGraph(3)

    swg.add_edge(0, 1, 11)

    swg.add_edge(1, 2, 13)

    swg.build()

    let rswg = swg.reverse_edge

    assert toSeq(rswg[1]) == @[(0, 11)]

    assert toSeq(rswg[2]) == @[(1, 13)]


    var sug = initUnWeightedDirectedStaticGraph(3)

    sug.add_edge(0, 1)

    sug.add_edge(2, 1)

    sug.build()

    let rsug = sug.reverse_edge

    assert toSeq(rsug[1]) == @[0, 2]

    '
  dependsOn:
  - cplib/graph/reverse_edge.nim
  - cplib/graph/graph.nim
  - cplib/graph/reverse_edge.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/AI/reverse_edge_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/reverse_edge_test.nim
layout: document
redirect_from:
- /verify/verify/AI/reverse_edge_test.nim
- /verify/verify/AI/reverse_edge_test.nim.html
title: verify/AI/reverse_edge_test.nim
---
