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
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc234/tasks/abc234_d
    links:
    - https://atcoder.jp/contests/abc234/tasks/abc234_d
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc234/tasks/abc234_d\n\
    proc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int\
    \ {.inline.} = scanf(\"%lld\\n\", addr result)\nimport sequtils, strutils\nimport\
    \ cplib/collections/avlset\nvar N, K = ii()\nvar P = newseqwith(N, ii())\nK -=\
    \ 1\nvar s = initAvlSortedMultiSet(P[0..<K])\nvar ans: seq[int]\nfor i in K..<N:\n\
    \    s.incl(P[i])\n    ans.add(s[^(K+1)])\necho ans.join(\"\\n\")\n"
  dependsOn:
  - cplib/collections/avlset.nim
  - cplib/collections/avltreenode.nim
  - cplib/collections/avltreenode.nim
  - cplib/collections/avlset.nim
  isVerificationFile: false
  path: verify/collections/avlset/multiset/ABC234D_access_test_.nim
  requiredBy: []
  timestamp: '2025-04-27 19:08:43+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/collections/avlset/multiset/ABC234D_access_test_.nim
layout: document
redirect_from:
- /library/verify/collections/avlset/multiset/ABC234D_access_test_.nim
- /library/verify/collections/avlset/multiset/ABC234D_access_test_.nim.html
title: verify/collections/avlset/multiset/ABC234D_access_test_.nim
---
