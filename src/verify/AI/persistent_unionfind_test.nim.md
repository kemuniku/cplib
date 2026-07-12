---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_array.nim
    title: cplib/collections/persistent_array.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_array.nim
    title: cplib/collections/persistent_array.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_unionfind.nim
    title: cplib/collections/persistent_unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_unionfind.nim
    title: cplib/collections/persistent_unionfind.nim
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


    import cplib/collections/persistent_unionfind


    let uf0 = initPersistentUnionFind(4)

    let uf1 = uf0.unite(0, 1)

    let uf2 = uf1.unite(2, 3)

    let uf3 = uf2.unite(1, 2)


    assert uf0.count == 4

    assert not uf0.issame(0, 1)

    assert uf1.issame(0, 1)

    assert not uf1.issame(0, 2)

    assert uf2.siz(2) == 2

    assert uf3.issame(0, 3)

    assert uf3.siz(0) == 4

    assert uf2.count == 2

    assert uf3.count == 1

    '
  dependsOn:
  - cplib/collections/persistent_array.nim
  - cplib/collections/persistent_unionfind.nim
  - cplib/collections/persistent_unionfind.nim
  - cplib/collections/persistent_array.nim
  isVerificationFile: true
  path: verify/AI/persistent_unionfind_test.nim
  requiredBy: []
  timestamp: '2026-07-09 02:51:42+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/persistent_unionfind_test.nim
layout: document
redirect_from:
- /verify/verify/AI/persistent_unionfind_test.nim
- /verify/verify/AI/persistent_unionfind_test.nim.html
title: verify/AI/persistent_unionfind_test.nim
---
