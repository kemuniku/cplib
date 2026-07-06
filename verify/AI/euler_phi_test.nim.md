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


    import cplib/math/euler_phi


    assert euler_phi(1) == 1

    assert euler_phi(9) == 6

    assert euler_phi(36) == 12

    assert euler_phi_list(10) == @[0, 1, 1, 2, 2, 4, 2, 6, 4, 6, 4]

    '
  dependsOn:
  - cplib/math/euler_phi.nim
  - cplib/math/euler_phi.nim
  isVerificationFile: true
  path: verify/AI/euler_phi_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/euler_phi_test.nim
layout: document
redirect_from:
- /verify/verify/AI/euler_phi_test.nim
- /verify/verify/AI/euler_phi_test.nim.html
title: verify/AI/euler_phi_test.nim
---
