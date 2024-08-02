---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avlset.nim
    title: cplib/collections/avlset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avlset.nim
    title: cplib/collections/avlset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avltreenode.nim
    title: cplib/collections/avltreenode.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avltreenode.nim
    title: cplib/collections/avltreenode.nim
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
    import cplib/collections/avlset\nimport strutils\ndiscard stdin.readLine\nvar\
    \ S = stdin.readLine.split()\nvar T = stdin.readLine.split()\nvar st = initAvlSortedMultiset(T)\n\
    for s in S:\n    if s in st:\n        echo \"Yes\"\n    else:\n        echo \"\
    No\"\n"
  dependsOn:
  - cplib/collections/avltreenode.nim
  - cplib/collections/avlset.nim
  - cplib/collections/avlset.nim
  - cplib/collections/avltreenode.nim
  isVerificationFile: true
  path: verify/collections/avlset/ABC236_test.nim
  requiredBy: []
  timestamp: '2024-07-21 20:30:56+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/avlset/ABC236_test.nim
layout: document
redirect_from:
- /verify/verify/collections/avlset/ABC236_test.nim
- /verify/verify/collections/avlset/ABC236_test.nim.html
title: verify/collections/avlset/ABC236_test.nim
---
