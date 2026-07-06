---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
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

    import cplib/collections/unionfind


    var uf = initUnionFind(5)

    assert uf.count == 5

    assert uf.root(0) == 0

    uf.unite(0, 1)

    uf.unite(3, 4)

    assert uf.issame(0, 1)

    assert not uf.issame(0, 2)

    assert uf.siz(0) == 2

    assert uf.count == 3


    var roots = uf.roots()

    roots.sort()

    assert roots == @[0, 2, 3]


    var cp = uf.copy()

    cp.unite(1, 2)

    assert cp.issame(0, 2)

    assert not uf.issame(0, 2)

    '
  dependsOn:
  - cplib/collections/unionfind.nim
  - cplib/collections/unionfind.nim
  isVerificationFile: true
  path: verify/AI/unionfind_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/unionfind_test.nim
layout: document
redirect_from:
- /verify/verify/AI/unionfind_test.nim
- /verify/verify/AI/unionfind_test.nim.html
title: verify/AI/unionfind_test.nim
---
