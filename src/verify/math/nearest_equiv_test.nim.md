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
    PROBLEM: https://atcoder.jp/contests/abc334/tasks/abc334_b
    links:
    - https://atcoder.jp/contests/abc334/tasks/abc334_b
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://atcoder.jp/contests/abc334/tasks/abc334_b

    import strutils, sequtils

    import cplib/math/nearest_equiv


    var a, m, l, r: int

    (a, m, l, r) = stdin.readLine.split.map(parseInt)

    var s = nearest_equiv(a, l, m)

    var t = nearest_equiv(a, r+1, m)

    echo max(0, (t - s) div m)

    '
  dependsOn:
  - cplib/math/nearest_equiv.nim
  - cplib/math/nearest_equiv.nim
  isVerificationFile: true
  path: verify/math/nearest_equiv_test.nim
  requiredBy: []
  timestamp: '2024-03-21 23:55:07+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/nearest_equiv_test.nim
layout: document
redirect_from:
- /verify/verify/math/nearest_equiv_test.nim
- /verify/verify/math/nearest_equiv_test.nim.html
title: verify/math/nearest_equiv_test.nim
---
