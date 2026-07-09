---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc330/tasks/abc330_c
    links:
    - https://atcoder.jp/contests/abc330/tasks/abc330_c
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc330/tasks/abc330_c\n\
    import math\nimport cplib/math/isqrt\nproc scanf(formatstr: cstring){.header:\
    \ \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr\
    \ result)\n\nvar D = ii()\nvar ans = D\nfor x in 0..(1 + isqrt(D - 1)):\n    if\
    \ (x^2-D) >= 0:\n        ans = min(ans, x^2-D)\n    else:\n        var y1 = isqrt(D-x^2)\n\
    \        var y2 = 1 + y1\n        ans = min(ans, abs(x^2+y1^2-D))\n        ans\
    \ = min(ans, abs(x^2+y2^2-D))\necho ans\n"
  dependsOn:
  - cplib/math/isqrt.nim
  - cplib/math/isqrt.nim
  isVerificationFile: false
  path: verify/math/isqrt_test_.nim
  requiredBy: []
  timestamp: '2025-03-09 18:22:34+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/math/isqrt_test_.nim
layout: document
redirect_from:
- /library/verify/math/isqrt_test_.nim
- /library/verify/math/isqrt_test_.nim.html
title: verify/math/isqrt_test_.nim
---
