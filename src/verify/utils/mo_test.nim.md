---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/mo.nim
    title: cplib/utils/mo.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/mo.nim
    title: cplib/utils/mo.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc174/tasks/abc174_f
    links:
    - https://atcoder.jp/contests/abc174/tasks/abc174_f
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc174/tasks/abc174_f\n\
    import std/sequtils\nimport std/algorithm\nimport std/strutils\nimport cplib/utils/mo\n\
    proc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int\
    \ = scanf(\"%lld\\n\", addr result)\n\nvar\n    N, Q = ii()\n    c = newSeqWith(N,\
    \ ii()-1)\n    m = initMo(N, Q)\n\nfor i in 0..<Q:\n    var l, r = ii()-1\n  \
    \  m.insert(l, r+1)\n\nvar\n    ans = newSeqWith(Q, 0)\n    now = 0\n    count\
    \ = newSeqWith(N, 0)\n\nproc addq(id: int) =\n    if count[c[id]] == 0:\n    \
    \    now += 1\n    count[c[id]] += 1\n\nproc delq(id: int) =\n    if count[c[id]]\
    \ == 1:\n        now -= 1\n    count[c[id]] -= 1\n\nproc rem(id: int) =\n    ans[id]\
    \ = now\n\nm.run(addq, addq, delq, delq, rem)\n\necho ans.join(\"\\n\")\n"
  dependsOn:
  - cplib/utils/mo.nim
  - cplib/utils/mo.nim
  isVerificationFile: true
  path: verify/utils/mo_test.nim
  requiredBy: []
  timestamp: '2024-03-16 18:25:22+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/mo_test.nim
layout: document
redirect_from:
- /verify/verify/utils/mo_test.nim
- /verify/verify/utils/mo_test.nim.html
title: verify/utils/mo_test.nim
---
