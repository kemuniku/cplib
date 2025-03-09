---
data:
  _extendedDependsOn:
  - icon: ':warning:'
    path: cplib/math/nearest_equiv.nim
    title: cplib/math/nearest_equiv.nim
  - icon: ':warning:'
    path: cplib/math/nearest_equiv.nim
    title: cplib/math/nearest_equiv.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
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
  isVerificationFile: false
  path: verify/math/nearest_equiv_test_.nim
  requiredBy: []
  timestamp: '2025-03-09 18:22:34+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/math/nearest_equiv_test_.nim
layout: document
redirect_from:
- /library/verify/math/nearest_equiv_test_.nim
- /library/verify/math/nearest_equiv_test_.nim.html
title: verify/math/nearest_equiv_test_.nim
---
