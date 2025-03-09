---
data:
  _extendedDependsOn:
  - icon: ':warning:'
    path: cplib/collections/tatyamset.nim
    title: cplib/collections/tatyamset.nim
  - icon: ':warning:'
    path: cplib/collections/tatyamset.nim
    title: cplib/collections/tatyamset.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc236/tasks/abc236_c
    links:
    - https://atcoder.jp/contests/abc236/tasks/abc236_c
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc236/tasks/abc236_c\n\
    import cplib/collections/tatyamset\nimport sequtils, strutils\ndiscard stdin.readLine\n\
    var S = stdin.readLine.split()\nvar T = stdin.readLine.split()\nvar st = initSortedMultiset(T)\n\
    for s in S:\n    if s in st:\n        echo \"Yes\"\n    else:\n        echo \"\
    No\"\n"
  dependsOn:
  - cplib/collections/tatyamset.nim
  - cplib/collections/tatyamset.nim
  isVerificationFile: false
  path: verify/collections/tatyamset/ABC236_test_.nim
  requiredBy: []
  timestamp: '2025-03-09 18:22:34+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/collections/tatyamset/ABC236_test_.nim
layout: document
redirect_from:
- /library/verify/collections/tatyamset/ABC236_test_.nim
- /library/verify/collections/tatyamset/ABC236_test_.nim.html
title: verify/collections/tatyamset/ABC236_test_.nim
---
