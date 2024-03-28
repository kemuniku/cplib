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
    PROBLEM: https://atcoder.jp/contests/abc278/tasks/abc278_d
    links:
    - https://atcoder.jp/contests/abc278/tasks/abc278_d
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc278/tasks/abc278_d\n\
    import cplib/collections/defaultdict\nimport strutils, sequtils, tables, hashes\n\
    var n = stdin.readLine.parseInt\nvar a = stdin.readLine.split.map parseInt\nvar\
    \ add = (0..<n).toSeq.mapIt((it, a[it])).toDefaultDict(0)\nvar base = 0\nvar q\
    \ = stdin.readLine.parseInt\nvar ans = newSeqOfCap[int](q)\nfor i in 0..<q:\n\
    \    var t = stdin.readLine.split.map parseInt\n    if t[0] == 1:\n        base\
    \ = t[1]\n        add.clear\n    elif t[0] == 2:\n        add[t[1] - 1] += t[2]\n\
    \    else:\n        ans.add(base + add[t[1] - 1])\necho ans.join(\"\\n\")\n"
  dependsOn:
  - cplib/collections/defaultdict.nim
  - cplib/collections/defaultdict.nim
  isVerificationFile: true
  path: verify/collections/defaultdict/defaultdict_abc278d_test.nim
  requiredBy: []
  timestamp: '2024-02-08 03:05:04+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/defaultdict/defaultdict_abc278d_test.nim
layout: document
redirect_from:
- /verify/verify/collections/defaultdict/defaultdict_abc278d_test.nim
- /verify/verify/collections/defaultdict/defaultdict_abc278d_test.nim.html
title: verify/collections/defaultdict/defaultdict_abc278d_test.nim
---