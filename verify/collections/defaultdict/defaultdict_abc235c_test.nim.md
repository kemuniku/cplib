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
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc235/tasks/abc235_c
    links:
    - https://atcoder.jp/contests/abc235/tasks/abc235_c
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
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
  isVerificationFile: true
  path: verify/collections/defaultdict/defaultdict_abc235c_test.nim
  requiredBy: []
  timestamp: '2024-02-07 11:13:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/defaultdict/defaultdict_abc235c_test.nim
layout: document
redirect_from:
- /verify/verify/collections/defaultdict/defaultdict_abc235c_test.nim
- /verify/verify/collections/defaultdict/defaultdict_abc235c_test.nim.html
title: verify/collections/defaultdict/defaultdict_abc235c_test.nim
---
