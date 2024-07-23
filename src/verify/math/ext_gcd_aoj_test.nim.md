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
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/NTL_1_E
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/NTL_1_E
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/NTL_1_E

    import strutils, sequtils

    import cplib/math/ext_gcd


    var a = stdin.readLine.split.map(parseInt)

    var (x, y) = ext_gcd(a[0], a[1])

    echo x, " ", y

    '
  dependsOn:
  - cplib/math/ext_gcd.nim
  - cplib/math/ext_gcd.nim
  isVerificationFile: true
  path: verify/math/ext_gcd_aoj_test.nim
  requiredBy: []
  timestamp: '2024-07-21 21:50:59+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/ext_gcd_aoj_test.nim
layout: document
redirect_from:
- /verify/verify/math/ext_gcd_aoj_test.nim
- /verify/verify/math/ext_gcd_aoj_test.nim.html
title: verify/math/ext_gcd_aoj_test.nim
---
