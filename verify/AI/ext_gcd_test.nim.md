---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/ext_gcd.nim
    title: cplib/math/ext_gcd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/ext_gcd.nim
    title: cplib/math/ext_gcd.nim
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


    import std/math

    import cplib/math/ext_gcd


    let (x1, y1) = ext_gcd(30, 18)

    assert 30 * x1 + 18 * y1 == gcd(30, 18)

    let (x2, y2) = ext_gcd(-30, 18)

    assert -30 * x2 + 18 * y2 == gcd(30, 18)

    let (x3, y3) = ext_gcd(17, 5)

    assert 17 * x3 + 5 * y3 == 1

    '
  dependsOn:
  - cplib/math/ext_gcd.nim
  - cplib/math/ext_gcd.nim
  isVerificationFile: true
  path: verify/AI/ext_gcd_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/ext_gcd_test.nim
layout: document
redirect_from:
- /verify/verify/AI/ext_gcd_test.nim
- /verify/verify/AI/ext_gcd_test.nim.html
title: verify/AI/ext_gcd_test.nim
---
