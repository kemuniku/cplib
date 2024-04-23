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
    \ cplib/collections/tatyamset\nvar N, K = ii()\nvar P = newseqwith(N, ii())\n\
    K -= 1\nvar s = initSortedMultiSet(P[0..<K])\nvar ans: seq[int]\nfor i in K..<N:\n\
    \    s.incl(P[i])\n    ans.add(s[-K-1])\necho ans.join(\"\\n\")\n"
  dependsOn:
  - cplib/collections/tatyamset.nim
  - cplib/collections/tatyamset.nim
  isVerificationFile: true
  path: verify/collections/tatyamset/ABC234D_access_test.nim
  requiredBy: []
  timestamp: '2024-04-23 21:11:58+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/tatyamset/ABC234D_access_test.nim
layout: document
redirect_from:
- /verify/verify/collections/tatyamset/ABC234D_access_test.nim
- /verify/verify/collections/tatyamset/ABC234D_access_test.nim.html
title: verify/collections/tatyamset/ABC234D_access_test.nim
---
