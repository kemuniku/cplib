---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/knapsack.nim
    title: cplib/utils/knapsack.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/knapsack.nim
    title: cplib/utils/knapsack.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/courses/library/7/DPL/all/DPL_1_F
    links:
    - https://onlinejudge.u-aizu.ac.jp/courses/library/7/DPL/all/DPL_1_F
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/7/DPL/all/DPL_1_F\n\
    \nimport sequtils\nimport cplib/utils/knapsack\nproc scanf(formatstr: cstring){.header:\
    \ \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr\
    \ result)\n\nvar N,W = ii()\n\nvar tmp : seq[(int,int)]\nfor _ in 0..<N:\n   \
    \ var v,w = ii()\n    tmp.add((v,w))\n\necho solve_01knapsack_NV(tmp,W)"
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  - cplib/utils/knapsack.nim
  - cplib/utils/knapsack.nim
  isVerificationFile: true
  path: verify/utils/knapsack/solve_01knapsack_NV_test.nim
  requiredBy: []
  timestamp: '2026-05-26 06:35:21+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/knapsack/solve_01knapsack_NV_test.nim
layout: document
redirect_from:
- /verify/verify/utils/knapsack/solve_01knapsack_NV_test.nim
- /verify/verify/utils/knapsack/solve_01knapsack_NV_test.nim.html
title: verify/utils/knapsack/solve_01knapsack_NV_test.nim
---
