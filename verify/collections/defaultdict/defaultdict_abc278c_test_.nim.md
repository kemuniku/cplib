---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/defaultdict.nim
    title: cplib/collections/defaultdict.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/defaultdict.nim
    title: cplib/collections/defaultdict.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc278/tasks/abc278_c
    links:
    - https://atcoder.jp/contests/abc278/tasks/abc278_c
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc278/tasks/abc278_c\n\
    import cplib/collections/defaultdict\nimport strutils, sequtils, sets\nvar n,\
    \ q, t, a, b: int\n(n, q) = stdin.readLine.split.map parseInt\nvar d = initDefaultDict[int,\
    \ Hashset[int]](initHashSet[int](0))\nfor _ in 0..<q:\n    (t, a, b) = stdin.readLine.split.map\
    \ parseInt\n    a -= 1; b -= 1\n    if t == 1: d[a].incl(b)\n    elif t == 2:\
    \ d[a].excl(b)\n    else: echo(if b in d[a] and a in d[b]: \"Yes\" else: \"No\"\
    )\n"
  dependsOn:
  - cplib/collections/defaultdict.nim
  - cplib/collections/defaultdict.nim
  isVerificationFile: false
  path: verify/collections/defaultdict/defaultdict_abc278c_test_.nim
  requiredBy: []
  timestamp: '2025-03-09 18:22:34+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/collections/defaultdict/defaultdict_abc278c_test_.nim
layout: document
redirect_from:
- /library/verify/collections/defaultdict/defaultdict_abc278c_test_.nim
- /library/verify/collections/defaultdict/defaultdict_abc278c_test_.nim.html
title: verify/collections/defaultdict/defaultdict_abc278c_test_.nim
---
