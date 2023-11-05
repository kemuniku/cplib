---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/math/isprime_yosupo_test.nim
    title: verify/math/isprime_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/isprime_yosupo_test.nim
    title: verify/math/isprime_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/isprime_yukicoder_test.nim
    title: verify/math/isprime_yukicoder_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/isprime_yukicoder_test.nim
    title: verify/math/isprime_yukicoder_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_MATH_POWMOD:\n    const COMPETITIVE_MATH_POWMOD*\
    \ = 1\n    proc mul(a, b, m:int):int {.importcpp: \"(__int128)(#) * (#) % (#)\"\
    , nodecl.}\n    proc powmod*(a, n, m: int): int =\n        var\n            rev\
    \ = 1\n            a = a\n            n = n\n        while n > 0:\n          \
    \  if n mod 2 != 0: rev = mul(rev,a,m)\n            if n > 1: a = mul(a,a,m)\n\
    \            n = n shr 1\n        return rev"
  dependsOn: []
  isVerificationFile: false
  path: cplib/math/powmod.nim
  requiredBy:
  - cplib/math/isprime.nim
  - cplib/math/isprime.nim
  timestamp: '2023-11-06 03:23:25+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/math/isprime_yosupo_test.nim
  - verify/math/isprime_yosupo_test.nim
  - verify/math/isprime_yukicoder_test.nim
  - verify/math/isprime_yukicoder_test.nim
documentation_of: cplib/math/powmod.nim
layout: document
redirect_from:
- /library/cplib/math/powmod.nim
- /library/cplib/math/powmod.nim.html
title: cplib/math/powmod.nim
---
