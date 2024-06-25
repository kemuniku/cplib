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
    PROBLEM: https://atcoder.jp/contests/abc294/tasks/abc294_d
    links:
    - https://atcoder.jp/contests/abc294/tasks/abc294_d
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc294/tasks/abc294_d\n\
    proc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int\
    \ {.inline.} = scanf(\"%lld\\n\", addr result)\nimport sequtils\nimport cplib/collections/avlset\n\
    let N, Q = ii()\nvar st1 = initAvlSortedMultiset((1..N).toseq())\nvar st2 = initAvlSortedMultiset[int]()\n\
    \nfor _ in 0..<Q:\n    let T = ii()\n    if T == 1:\n        st2.incl(st1.pop(0))\n\
    \    elif T == 2:\n        st2.excl(ii())\n    else:\n        echo st2[0]\n"
  dependsOn:
  - cplib/collections/avltreenode.nim
  - cplib/collections/avlset.nim
  - cplib/collections/avlset.nim
  - cplib/collections/avltreenode.nim
  isVerificationFile: true
  path: verify/collections/avlset/ABC294_test.nim
  requiredBy: []
  timestamp: '2024-06-25 05:12:55+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/avlset/ABC294_test.nim
layout: document
redirect_from:
- /verify/verify/collections/avlset/ABC294_test.nim
- /verify/verify/collections/avlset/ABC294_test.nim.html
title: verify/collections/avlset/ABC294_test.nim
---
