---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitvector.nim
    title: cplib/collections/bitvector.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitvector.nim
    title: cplib/collections/bitvector.nim
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


    import cplib/collections/bitvector


    var bv = newBitVector(130)

    bv.set(0)

    bv.set(64)

    bv.set(129)

    bv.build()

    assert bv.access(0)

    assert bv[64]

    assert not bv[65]

    assert bv.rank(0) == 0

    assert bv.rank(65) == 2

    assert bv.rank(130) == 3

    '
  dependsOn:
  - cplib/collections/bitvector.nim
  - cplib/collections/bitvector.nim
  isVerificationFile: true
  path: verify/AI/bitvector_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/bitvector_test.nim
layout: document
redirect_from:
- /verify/verify/AI/bitvector_test.nim
- /verify/verify/AI/bitvector_test.nim.html
title: verify/AI/bitvector_test.nim
---
