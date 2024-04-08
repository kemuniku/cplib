---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':question:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc330/tasks/abc330_c
    links:
    - https://atcoder.jp/contests/abc330/tasks/abc330_c
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
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
  isVerificationFile: true
  path: verify/math/isqrt_test.nim
  requiredBy: []
  timestamp: '2024-02-07 16:25:18+00:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/isqrt_test.nim
layout: document
redirect_from:
- /verify/verify/math/isqrt_test.nim
- /verify/verify/math/isqrt_test.nim.html
title: verify/math/isqrt_test.nim
---
