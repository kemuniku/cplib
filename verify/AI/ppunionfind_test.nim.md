---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/ppunionfind.nim
    title: cplib/collections/ppunionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/ppunionfind.nim
    title: cplib/collections/ppunionfind.nim
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


    import cplib/collections/ppunionfind


    var uf = initPartialPersistentUnionFind(4)

    assert uf.root(0) == 0

    assert uf.unite(0, 1, 2)

    assert uf.unite(2, 3, 5)

    assert uf.unite(1, 2, 8)

    assert uf.issame(0, 1, 2)

    assert not uf.issame(0, 2, 7)

    assert uf.issame(0, 3, 8)

    assert uf.size(0, 1) == 1

    assert uf.size(0, 2) == 2

    assert uf.size(3, 5) == 2

    assert uf.size(3, 8) == 4

    assert uf.when_unite(0, 3) == 8

    assert uf.when_unite(0, 1) == 2

    '
  dependsOn:
  - cplib/collections/ppunionfind.nim
  - cplib/collections/ppunionfind.nim
  isVerificationFile: true
  path: verify/AI/ppunionfind_test.nim
  requiredBy: []
  timestamp: '2026-07-09 02:51:42+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/ppunionfind_test.nim
layout: document
redirect_from:
- /verify/verify/AI/ppunionfind_test.nim
- /verify/verify/AI/ppunionfind_test.nim.html
title: verify/AI/ppunionfind_test.nim
---
