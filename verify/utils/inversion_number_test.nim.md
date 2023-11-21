---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/inversion_number.nim
    title: "\u8EE2\u5012\u6570"
  - icon: ':heavy_check_mark:'
    path: cplib/utils/inversion_number.nim
    title: "\u8EE2\u5012\u6570"
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
  code: '# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ALDS1_5_D

    import sequtils, strutils

    import cplib/utils/inversion_number


    discard stdin.readLine.parseInt

    var a = stdin.readLine.split.map(parseInt)

    echo inversion_number(a)

    '
  dependsOn:
  - cplib/utils/inversion_number.nim
  - cplib/utils/inversion_number.nim
  isVerificationFile: true
  path: verify/utils/inversion_number_test.nim
  requiredBy: []
  timestamp: '2023-11-16 05:13:09+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/inversion_number_test.nim
layout: document
redirect_from:
- /verify/verify/utils/inversion_number_test.nim
- /verify/verify/utils/inversion_number_test.nim.html
title: verify/utils/inversion_number_test.nim
---