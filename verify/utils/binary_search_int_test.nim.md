---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/binary_search.nim
    title: cplib/utils/binary_search.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/binary_search.nim
    title: cplib/utils/binary_search.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ALDS1_4_B
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ALDS1_4_B
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ALDS1_4_B\n\
    import sequtils, strutils, algorithm\nimport cplib/utils/binary_search\n\nconst\
    \ INF = int(1_000_000_000_000)\nlet n = stdin.readLine.parseInt\nlet s = stdin.readLine.split().map(parseInt).concat(@[-INF,\
    \ INF]).sorted\nlet q = stdin.readLine.parseInt\nlet t = stdin.readLine.split().map(parseInt)\n\
    var ans = 0\nfor i in 0..<q:\n    proc ubound(x: int): bool = s[x] <= t[i]\n \
    \   proc lbound(x: int): bool = s[x] < t[i]\n    var upper = meguru_bisect(0,\
    \ n+1, ubound)\n    var lower = meguru_bisect(0, n+1, lbound)\n    if upper -\
    \ lower != 0: ans += 1\necho ans\n"
  dependsOn:
  - cplib/utils/binary_search.nim
  - cplib/utils/binary_search.nim
  isVerificationFile: true
  path: verify/utils/binary_search_int_test.nim
  requiredBy: []
  timestamp: '2023-11-28 01:21:59+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/binary_search_int_test.nim
layout: document
redirect_from:
- /verify/verify/utils/binary_search_int_test.nim
- /verify/verify/utils/binary_search_int_test.nim.html
title: verify/utils/binary_search_int_test.nim
---
