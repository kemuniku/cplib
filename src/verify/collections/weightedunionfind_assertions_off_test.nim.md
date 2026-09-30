---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/weightedunionfind.nim
    title: cplib/collections/weightedunionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/weightedunionfind.nim
    title: cplib/collections/weightedunionfind.nim
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
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    import cplib/collections/weightedunionfind\n\nproc makeUnionFind(): WeightedUnionFind[int]\
    \ =\n    result = initWeightedUnionFind(6)\n    doAssert result.unite(0, 1, 10)\n\
    \    doAssert result.unite(2, 3, 20)\n    doAssert result.unite(0, 2, 30)\n  \
    \  doAssert result.unite(4, 5, -7)\n\nblock:\n    var uf = makeUnionFind()\n \
    \   doAssert uf.diff(0, 3) == 50\n    doAssert uf.diff(3, 0) == -50\n    doAssert\
    \ uf.diff(1, 3) == 40\n    doAssert uf.diff(3, 2) == -20\n    doAssert uf.diff(3,\
    \ 3) == 0\n    doAssert uf.diff(4, 5) == -7\n    doAssert uf.diff(5, 4) == 7\n\
    \    doAssert uf.count == 2\n    doAssert uf.siz(3) == 4\n    doAssert uf.unite(1,\
    \ 3, 40)\n    doAssert not uf.unite(1, 3, 41)\n\nblock:\n    var uf = makeUnionFind()\n\
    \    doAssert uf.diff(3, 0) == -50\n\nblock:\n    var uf = initWeightedUnionFind(4,\
    \ int64)\n    doAssert uf.unite(0, 1, 10'i64)\n    doAssert uf.unite(2, 3, -20'i64)\n\
    \    doAssert uf.unite(0, 2, 30'i64)\n    doAssert uf.diff(0, 3) == 10'i64\n \
    \   doAssert uf.diff(3, 1) == 0'i64\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/weightedunionfind.nim
  - cplib/collections/weightedunionfind.nim
  isVerificationFile: true
  path: verify/collections/weightedunionfind_assertions_off_test.nim
  requiredBy: []
  timestamp: '2026-09-30 20:33:13+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/weightedunionfind_assertions_off_test.nim
layout: document
redirect_from:
- /verify/verify/collections/weightedunionfind_assertions_off_test.nim
- /verify/verify/collections/weightedunionfind_assertions_off_test.nim.html
title: verify/collections/weightedunionfind_assertions_off_test.nim
---
