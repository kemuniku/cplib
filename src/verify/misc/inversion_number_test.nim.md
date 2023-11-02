---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/misc/inversion_number.nim
    title: cplib/misc/inversion_number.nim
  - icon: ':heavy_check_mark:'
    path: cplib/misc/inversion_number.nim
    title: cplib/misc/inversion_number.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/citrus.nim
    title: cplib/tmpl/citrus.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/citrus.nim
    title: cplib/tmpl/citrus.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ALDS1_5_D
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ALDS1_5_D
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verify-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ALDS1_5_D

    include cplib/tmpl/citrus

    import cplib/misc/inversion_number


    var n = input(int)

    var a = input(int, n)

    print(inversion_number(a))

    '
  dependsOn:
  - cplib/tmpl/citrus.nim
  - cplib/tmpl/citrus.nim
  - cplib/misc/inversion_number.nim
  - cplib/misc/inversion_number.nim
  isVerificationFile: true
  path: verify/misc/inversion_number_test.nim
  requiredBy: []
  timestamp: '2023-11-02 23:17:10+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/misc/inversion_number_test.nim
layout: document
redirect_from:
- /verify/verify/misc/inversion_number_test.nim
- /verify/verify/misc/inversion_number_test.nim.html
title: verify/misc/inversion_number_test.nim
---
