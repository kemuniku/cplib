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
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/primefactor.nim
    title: cplib/math/primefactor.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/primefactor.nim
    title: cplib/math/primefactor.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/math/factorize_yosupo_test.nim
    title: verify/math/factorize_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/factorize_yosupo_test.nim
    title: verify/math/factorize_yosupo_test.nim
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
  code: "when not declared COMPETITIVE_MATH_INNER_MATH:\n    const COMPETITIVE_MATH_INNER_MATH*\
    \ = 1\n    proc mul*(a, b, m: int): int {.importcpp: \"(__int128)(#) * (#) % (#)\"\
    , nodecl.}\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/math/inner_math.nim
  requiredBy:
  - cplib/math/powmod.nim
  - cplib/math/powmod.nim
  - cplib/math/isprime.nim
  - cplib/math/isprime.nim
  - cplib/math/primefactor.nim
  - cplib/math/primefactor.nim
  timestamp: '2023-11-10 01:03:01+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/math/factorize_yosupo_test.nim
  - verify/math/factorize_yosupo_test.nim
  - verify/math/isprime_yosupo_test.nim
  - verify/math/isprime_yosupo_test.nim
  - verify/math/isprime_yukicoder_test.nim
  - verify/math/isprime_yukicoder_test.nim
documentation_of: cplib/math/inner_math.nim
layout: document
redirect_from:
- /library/cplib/math/inner_math.nim
- /library/cplib/math/inner_math.nim.html
title: cplib/math/inner_math.nim
---
