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
    PROBLEM: https://atcoder.jp/contests/abc294/tasks/abc294_d
    links:
    - https://atcoder.jp/contests/abc294/tasks/abc294_d
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc294/tasks/abc294_d\n\
    proc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int\
    \ {.inline.} = scanf(\"%lld\\n\", addr result)\nimport sequtils\nimport cplib/collections/tatyamset\n\
    let N, Q = ii()\nvar st1 = initSortedMultiset((1..N).toseq())\nvar st2 = initSortedMultiset[int]()\n\
    \nfor _ in 0..<Q:\n    let T = ii()\n    if T == 1:\n        st2.incl(st1.pop(0))\n\
    \    elif T == 2:\n        st2.excl(ii())\n    else:\n        echo st2[0]\n"
  dependsOn:
  - cplib/collections/tatyamset.nim
  - cplib/collections/tatyamset.nim
  isVerificationFile: true
  path: verify/collections/tatyamset/ABC294_test.nim
  requiredBy: []
  timestamp: '2024-04-23 21:11:58+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/tatyamset/ABC294_test.nim
layout: document
redirect_from:
- /verify/verify/collections/tatyamset/ABC294_test.nim
- /verify/verify/collections/tatyamset/ABC294_test.nim.html
title: verify/collections/tatyamset/ABC294_test.nim
---
