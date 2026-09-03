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
    path: cplib/tree/diameter.nim
    title: cplib/tree/diameter.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/diameter.nim
    title: cplib/tree/diameter.nim
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

    import cplib/tree/diameter


    var g = initWeightedUnDirectedGraph(4, int)

    g.add_edge(0, 1, 2)

    g.add_edge(1, 2, 3)

    g.add_edge(1, 3, 4)


    let (dist, u, v) = g.diameter_and_edge()

    assert dist == 7

    assert {u, v} == {2, 3}

    assert g.diameter() == 7


    let (pathDist, path) = g.diameter_path()

    assert pathDist == 7

    assert path.len == 3

    assert {path[0], path[^1]} == {2, 3}

    assert path[1] == 1


    var ug = initUnWeightedUnDirectedGraph(5)

    ug.add_edge(0, 1)

    ug.add_edge(1, 2)

    ug.add_edge(2, 3)

    ug.add_edge(1, 4)

    assert ug.diameter() == 3

    '
  dependsOn:
  - cplib/tree/diameter.nim
  - cplib/graph/graph.nim
  - cplib/tree/diameter.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/AI/diameter_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/diameter_test.nim
layout: document
redirect_from:
- /verify/verify/AI/diameter_test.nim
- /verify/verify/AI/diameter_test.nim.html
title: verify/AI/diameter_test.nim
---
