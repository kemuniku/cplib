---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/rootvalue_unionfind.nim
    title: cplib/collections/rootvalue_unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/rootvalue_unionfind.nim
    title: cplib/collections/rootvalue_unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dynamic_bipartite.nim
    title: cplib/graph/dynamic_bipartite.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dynamic_bipartite.nim
    title: cplib/graph/dynamic_bipartite.nim
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


    import cplib/graph/dynamic_bipartite


    let db = initDynamicBipartite(3)

    assert db.is_bipartite

    assert db.can_unite(0, 1)

    db.unite(0, 1)

    assert db.is_bipartite

    assert db.cnt_sum == 2

    db.unite(1, 2)

    assert db.is_bipartite

    assert db.cnt_sum == 2

    assert not db.can_unite(0, 2)

    db.unite(0, 2)

    assert not db.is_bipartite

    assert db.cnt_sum == -1

    '
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/collections/rootvalue_unionfind.nim
  - cplib/graph/graph.nim
  - cplib/graph/dynamic_bipartite.nim
  - cplib/collections/rootvalue_unionfind.nim
  - cplib/graph/dynamic_bipartite.nim
  isVerificationFile: true
  path: verify/AI/dynamic_bipartite_test.nim
  requiredBy: []
  timestamp: '2026-07-09 02:51:42+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/dynamic_bipartite_test.nim
layout: document
redirect_from:
- /verify/verify/AI/dynamic_bipartite_test.nim
- /verify/verify/AI/dynamic_bipartite_test.nim.html
title: verify/AI/dynamic_bipartite_test.nim
---
