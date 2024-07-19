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
    PROBLEM: https://atcoder.jp/contests/abc234/tasks/abc234_d
    links:
    - https://atcoder.jp/contests/abc234/tasks/abc234_d
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc234/tasks/abc234_d\n\
    proc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int\
    \ {.inline.} = scanf(\"%lld\\n\", addr result)\nimport sequtils, strutils\nimport\
    \ cplib/collections/avlset\nvar N, K = ii()\nvar P = newseqwith(N, ii())\nK -=\
    \ 1\nvar s = initAvlSortedMultiSet(P[0..<K])\nvar ans: seq[int]\nfor i in K..<N:\n\
    \    s.incl(P[i])\n    ans.add(s[^(K+1)])\necho ans.join(\"\\n\")\n"
  dependsOn:
  - cplib/collections/avlset.nim
  - cplib/collections/avlset.nim
  - cplib/collections/avltreenode.nim
  - cplib/collections/avltreenode.nim
  isVerificationFile: true
  path: verify/collections/avlset/ABC234D_access_test.nim
  requiredBy: []
  timestamp: '2024-06-25 05:12:55+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/avlset/ABC234D_access_test.nim
layout: document
redirect_from:
- /verify/verify/collections/avlset/ABC234D_access_test.nim
- /verify/verify/collections/avlset/ABC234D_access_test.nim.html
title: verify/collections/avlset/ABC234D_access_test.nim
---
