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
    PROBLEM: https://atcoder.jp/contests/abc235/tasks/abc235_c
    links:
    - https://atcoder.jp/contests/abc235/tasks/abc235_c
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc235/tasks/abc235_c\n\
    import sequtils, strutils\ninclude cplib/collections/defaultdict\n\nvar n, q,\
    \ x, k: int\n(n, q) = stdin.readLine.split.map parseInt\nvar d = initDefaultDict[int,\
    \ seq[int]](newSeq[int](0))\nvar a = stdin.readLine.split.map parseInt\nfor i\
    \ in 0..<n:\n    d[a[i]].add(i+1)\nvar ans = newSeq[int](q)\nfor i in 0..<q:\n\
    \    (x, k) = stdin.readLine.split.map parseInt\n    if d[x].len < k: ans[i] =\
    \ -1\n    else: ans[i] = d[x][k-1]\necho ans.join(\"\\n\")\n"
  dependsOn:
  - cplib/collections/defaultdict.nim
  - cplib/collections/defaultdict.nim
  isVerificationFile: false
  path: verify/collections/defaultdict/defaultdict_abc235c_test_.nim
  requiredBy: []
  timestamp: '2025-03-09 18:22:34+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/collections/defaultdict/defaultdict_abc235c_test_.nim
layout: document
redirect_from:
- /library/verify/collections/defaultdict/defaultdict_abc235c_test_.nim
- /library/verify/collections/defaultdict/defaultdict_abc235c_test_.nim.html
title: verify/collections/defaultdict/defaultdict_abc235c_test_.nim
---
