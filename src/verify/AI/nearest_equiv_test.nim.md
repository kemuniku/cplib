---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/nearest_equiv.nim
    title: cplib/math/nearest_equiv.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/nearest_equiv.nim
    title: cplib/math/nearest_equiv.nim
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


    import cplib/math/nearest_equiv


    assert nearest_equiv(2, 10, 3) == 11

    assert nearest_equiv(20, 10, 3) == 11

    assert nearest_equiv(-1, 5, 4) == 7

    assert nearest_equiv(10, 10, -6) == 10

    '
  dependsOn:
  - cplib/math/nearest_equiv.nim
  - cplib/math/nearest_equiv.nim
  isVerificationFile: true
  path: verify/AI/nearest_equiv_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/nearest_equiv_test.nim
layout: document
redirect_from:
- /verify/verify/AI/nearest_equiv_test.nim
- /verify/verify/AI/nearest_equiv_test.nim.html
title: verify/AI/nearest_equiv_test.nim
---
