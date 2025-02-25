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
    PROBLEM: https://atcoder.jp/contests/abc337/tasks/abc337_b
    links:
    - https://atcoder.jp/contests/abc337/tasks/abc337_b
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc337/tasks/abc337_b\n\
    import cplib/collections/avlset\nimport sequtils, strutils\nvar S = stdin.readLine()\n\
    var st = initAvlSortedMultiset(S.toseq())\nif st.toseq().join() == S:\n    echo\
    \ \"Yes\"\nelse:\n    echo \"No\"\n"
  dependsOn:
  - cplib/collections/avltreenode.nim
  - cplib/collections/avltreenode.nim
  - cplib/collections/avlset.nim
  - cplib/collections/avlset.nim
  isVerificationFile: true
  path: verify/collections/avlset/multiset/ABC337_test.nim
  requiredBy: []
  timestamp: '2024-09-28 12:27:57+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/avlset/multiset/ABC337_test.nim
layout: document
redirect_from:
- /verify/verify/collections/avlset/multiset/ABC337_test.nim
- /verify/verify/collections/avlset/multiset/ABC337_test.nim.html
title: verify/collections/avlset/multiset/ABC337_test.nim
---
