---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/euler_phi.nim
    title: cplib/math/euler_phi.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/euler_phi.nim
    title: cplib/math/euler_phi.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/NTL_1_D
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/NTL_1_D
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/NTL_1_D

    import strutils

    import cplib/math/euler_phi


    var n = stdin.readLine.parseint

    echo euler_phi(n)

    '
  dependsOn:
  - cplib/math/euler_phi.nim
  - cplib/math/euler_phi.nim
  isVerificationFile: true
  path: verify/math/euler_phi_aoj_test.nim
  requiredBy: []
  timestamp: '2024-01-07 17:44:35+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/euler_phi_aoj_test.nim
layout: document
redirect_from:
- /verify/verify/math/euler_phi_aoj_test.nim
- /verify/verify/math/euler_phi_aoj_test.nim.html
title: verify/math/euler_phi_aoj_test.nim
---