---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/math/divisor.nim
    title: cplib/math/divisor.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/divisor.nim
    title: cplib/math/divisor.nim
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
    path: verify/math/divisor_atcoder_test.nim
    title: verify/math/divisor_atcoder_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/divisor_atcoder_test.nim
    title: verify/math/divisor_atcoder_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/divisor_many_atcoder_test.nim
    title: verify/math/divisor_many_atcoder_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/divisor_many_atcoder_test.nim
    title: verify/math/divisor_many_atcoder_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/euler_phi_yukicoder_test.nim
    title: verify/math/euler_phi_yukicoder_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/euler_phi_yukicoder_test.nim
    title: verify/math/euler_phi_yukicoder_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/factorize_table_abc284d_test.nim
    title: verify/math/factorize_table_abc284d_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/factorize_table_abc284d_test.nim
    title: verify/math/factorize_table_abc284d_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/factorize_tuple_abc324b_test.nim
    title: verify/math/factorize_tuple_abc324b_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/factorize_tuple_abc324b_test.nim
    title: verify/math/factorize_tuple_abc324b_test.nim
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
  code: "when not declared CPLIB_MATH_INNER_MATH:\n    const CPLIB_MATH_INNER_MATH*\
    \ = 1\n    proc add*(a, b, m: int): int {.importcpp: \"((__int128)(#) + (__int128)(#))\
    \ % (__int128)(#)\", nodecl.}\n    proc mul*(a, b, m: int): int {.importcpp: \"\
    (__int128)(#) * (__int128)(#) % (__int128)(#)\", nodecl.}\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/math/inner_math.nim
  requiredBy:
  - cplib/math/primefactor.nim
  - cplib/math/primefactor.nim
  - cplib/math/powmod.nim
  - cplib/math/powmod.nim
  - cplib/math/divisor.nim
  - cplib/math/divisor.nim
  - cplib/math/isprime.nim
  - cplib/math/isprime.nim
  timestamp: '2024-03-16 01:58:47+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/math/factorize_table_abc284d_test.nim
  - verify/math/factorize_table_abc284d_test.nim
  - verify/math/isprime_yukicoder_test.nim
  - verify/math/isprime_yukicoder_test.nim
  - verify/math/divisor_atcoder_test.nim
  - verify/math/divisor_atcoder_test.nim
  - verify/math/euler_phi_yukicoder_test.nim
  - verify/math/euler_phi_yukicoder_test.nim
  - verify/math/isprime_yosupo_test.nim
  - verify/math/isprime_yosupo_test.nim
  - verify/math/divisor_many_atcoder_test.nim
  - verify/math/divisor_many_atcoder_test.nim
  - verify/math/factorize_yosupo_test.nim
  - verify/math/factorize_yosupo_test.nim
  - verify/math/factorize_tuple_abc324b_test.nim
  - verify/math/factorize_tuple_abc324b_test.nim
documentation_of: cplib/math/inner_math.nim
layout: document
redirect_from:
- /library/cplib/math/inner_math.nim
- /library/cplib/math/inner_math.nim.html
title: cplib/math/inner_math.nim
---
