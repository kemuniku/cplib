---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/misc/binary_search.nim
    title: cplib/misc/binary_search.nim
  - icon: ':heavy_check_mark:'
    path: cplib/misc/binary_search.nim
    title: cplib/misc/binary_search.nim
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
    PROBLEM: https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=ALDS1_4_B
    links:
    - https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=ALDS1_4_B
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=ALDS1_4_B\n\
    include cplib/tmpl/citrus\nimport cplib/misc/binary_search\n\nlet n = input(int)\n\
    let s = input(int, n).concat(@[-INFL, INFL]).sorted\nlet q = input(int)\nlet t\
    \ = input(int, q)\nvar ans = 0\nfor i in 0..<q:\n    proc ubound(x: int): bool\
    \ = s[x] <= t[i]\n    proc lbound(x: int): bool = s[x] < t[i]\n    var upper =\
    \ meguru_bisect(0, n+1, ubound)\n    var lower = meguru_bisect(0, n+1, lbound)\n\
    \    if upper - lower != 0: ans += 1\nprint(ans)\n"
  dependsOn:
  - cplib/tmpl/citrus.nim
  - cplib/misc/binary_search.nim
  - cplib/misc/binary_search.nim
  - cplib/tmpl/citrus.nim
  isVerificationFile: true
  path: verify/misc/binary_search_int_test.nim
  requiredBy: []
  timestamp: '2023-11-03 12:47:02+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/misc/binary_search_int_test.nim
layout: document
redirect_from:
- /verify/verify/misc/binary_search_int_test.nim
- /verify/verify/misc/binary_search_int_test.nim.html
title: verify/misc/binary_search_int_test.nim
---
