---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/tatyamset.nim
    title: cplib/collections/tatyamset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/tatyamset.nim
    title: cplib/collections/tatyamset.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc236/tasks/abc236_c
    links:
    - https://atcoder.jp/contests/abc236/tasks/abc236_c
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc236/tasks/abc236_c\n\
    import cplib/collections/tatyamset\nimport sequtils, strutils\ndiscard stdin.readLine\n\
    var S = stdin.readLine.split()\nvar T = stdin.readLine.split()\nvar st = initSortedMultiset(T)\n\
    for s in S:\n    if s in st:\n        echo \"Yes\"\n    else:\n        echo \"\
    No\"\n"
  dependsOn:
  - cplib/collections/tatyamset.nim
  - cplib/collections/tatyamset.nim
  isVerificationFile: true
  path: verify/collections/tatyamset/ABC236_test.nim
  requiredBy: []
  timestamp: '2024-01-28 10:52:19+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/tatyamset/ABC236_test.nim
layout: document
redirect_from:
- /verify/verify/collections/tatyamset/ABC236_test.nim
- /verify/verify/collections/tatyamset/ABC236_test.nim.html
title: verify/collections/tatyamset/ABC236_test.nim
---
