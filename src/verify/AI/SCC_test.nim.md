---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/SCC.nim
    title: cplib/graph/SCC.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/SCC.nim
    title: cplib/graph/SCC.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
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


    import algorithm, sequtils

    import cplib/graph/SCC

    import cplib/graph/graph


    var g = initUnWeightedDirectedGraph(4)

    g.add_edge(0, 1)

    g.add_edge(1, 0)

    g.add_edge(1, 2)

    g.add_edge(2, 3)

    g.add_edge(3, 2)

    let comps = g.SCC.mapIt(it.sorted)

    assert comps == @[@[0, 1], @[2, 3]]

    let (cg, toGroup, groups) = g.SCCG

    assert groups.mapIt(it.sorted) == @[@[0, 1], @[2, 3]]

    assert toGroup[0] == toGroup[1]

    assert toGroup[2] == toGroup[3]

    assert cg.len == 2

    assert toSeq(cg[toGroup[1]]) == @[toGroup[2]]

    '
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/graph/SCC.nim
  - cplib/graph/SCC.nim
  isVerificationFile: true
  path: verify/AI/SCC_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/SCC_test.nim
layout: document
redirect_from:
- /verify/verify/AI/SCC_test.nim
- /verify/verify/AI/SCC_test.nim.html
title: verify/AI/SCC_test.nim
---
