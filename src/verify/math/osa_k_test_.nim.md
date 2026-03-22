---
data:
  _extendedDependsOn:
  - icon: ':warning:'
    path: cplib/math/osa_k.nim
    title: cplib/math/osa_k.nim
  - icon: ':warning:'
    path: cplib/math/osa_k.nim
    title: cplib/math/osa_k.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/run_length_encode.nim
    title: cplib/str/run_length_encode.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/run_length_encode.nim
    title: cplib/str/run_length_encode.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc383/tasks/abc383_d
    links:
    - https://atcoder.jp/contests/abc383/tasks/abc383_d
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc383/tasks/abc383_d\n\
    import cplib/math/osa_k\nimport algorithm\nproc scanf(formatstr: cstring){.header:\
    \ \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr\
    \ result)\n\nvar t = initPrimeFactorTable(2*(1000000))\nvar ans : seq[int]\nfor\
    \ i in countup(2,2*(1000000)):\n    var tmp = t.primefactor_tuple(i) \n    if\
    \ (len(tmp) == 1 and tmp[0][1] == 4) or (len(tmp) == 2 and tmp[0][1] == 1 and\
    \ tmp[1][1] == 1):\n        ans.add(i*i)\nvar N = ii()\necho ans.upperbound(N)"
  dependsOn:
  - cplib/str/run_length_encode.nim
  - cplib/str/run_length_encode.nim
  - cplib/math/osa_k.nim
  - cplib/math/osa_k.nim
  isVerificationFile: false
  path: verify/math/osa_k_test_.nim
  requiredBy: []
  timestamp: '2025-03-09 18:51:31+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/math/osa_k_test_.nim
layout: document
redirect_from:
- /library/verify/math/osa_k_test_.nim
- /library/verify/math/osa_k_test_.nim.html
title: verify/math/osa_k_test_.nim
---
