---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':question:'
    path: cplib/math/divisor.nim
    title: cplib/math/divisor.nim
  - icon: ':question:'
    path: cplib/math/divisor.nim
    title: cplib/math/divisor.nim
  - icon: ':question:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':question:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':question:'
    path: cplib/math/primefactor.nim
    title: cplib/math/primefactor.nim
  - icon: ':question:'
    path: cplib/math/primefactor.nim
    title: cplib/math/primefactor.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/primitive_root.nim
    title: cplib/math/primitive_root.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/primitive_root.nim
    title: cplib/math/primitive_root.nim
  - icon: ':warning:'
    path: verify/math/divisor_atcoder_test_.nim
    title: verify/math/divisor_atcoder_test_.nim
  - icon: ':warning:'
    path: verify/math/divisor_atcoder_test_.nim
    title: verify/math/divisor_atcoder_test_.nim
  - icon: ':warning:'
    path: verify/math/divisor_many_atcoder_test_.nim
    title: verify/math/divisor_many_atcoder_test_.nim
  - icon: ':warning:'
    path: verify/math/divisor_many_atcoder_test_.nim
    title: verify/math/divisor_many_atcoder_test_.nim
  - icon: ':warning:'
    path: verify/math/factorize_table_abc284d_test_.nim
    title: verify/math/factorize_table_abc284d_test_.nim
  - icon: ':warning:'
    path: verify/math/factorize_table_abc284d_test_.nim
    title: verify/math/factorize_table_abc284d_test_.nim
  - icon: ':warning:'
    path: verify/math/factorize_tuple_abc324b_test_.nim
    title: verify/math/factorize_tuple_abc324b_test_.nim
  - icon: ':warning:'
    path: verify/math/factorize_tuple_abc324b_test_.nim
    title: verify/math/factorize_tuple_abc324b_test_.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/divisor_test.nim
    title: verify/AI/divisor_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/divisor_test.nim
    title: verify/AI/divisor_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/inner_math_test.nim
    title: verify/AI/inner_math_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/inner_math_test.nim
    title: verify/AI/inner_math_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/powmod_test.nim
    title: verify/AI/powmod_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/powmod_test.nim
    title: verify/AI/powmod_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/primefactor_test.nim
    title: verify/AI/primefactor_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/primefactor_test.nim
    title: verify/AI/primefactor_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/primitive_root_test.nim
    title: verify/AI/primitive_root_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/primitive_root_test.nim
    title: verify/AI/primitive_root_test.nim
  - icon: ':x:'
    path: verify/math/euler_phi_yukicoder_test.nim
    title: verify/math/euler_phi_yukicoder_test.nim
  - icon: ':x:'
    path: verify/math/euler_phi_yukicoder_test.nim
    title: verify/math/euler_phi_yukicoder_test.nim
  - icon: ':x:'
    path: verify/math/factorize_yosupo_test.nim
    title: verify/math/factorize_yosupo_test.nim
  - icon: ':x:'
    path: verify/math/factorize_yosupo_test.nim
    title: verify/math/factorize_yosupo_test.nim
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':question:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_MATH_INNER_MATH:\n    const CPLIB_MATH_INNER_MATH*\
    \ = 1\n    proc add*(a, b, m: int): int {.importcpp: \"((__int128)(#) + (__int128)(#))\
    \ % (__int128)(#)\", nodecl.}\n    proc mul*(a, b, m: int): int {.importcpp: \"\
    (__int128)(#) * (__int128)(#) % (__int128)(#)\", nodecl.}\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/math/inner_math.nim
  requiredBy:
  - verify/math/factorize_table_abc284d_test_.nim
  - verify/math/factorize_table_abc284d_test_.nim
  - verify/math/divisor_atcoder_test_.nim
  - verify/math/divisor_atcoder_test_.nim
  - verify/math/factorize_tuple_abc324b_test_.nim
  - verify/math/factorize_tuple_abc324b_test_.nim
  - verify/math/divisor_many_atcoder_test_.nim
  - verify/math/divisor_many_atcoder_test_.nim
  - cplib/math/divisor.nim
  - cplib/math/divisor.nim
  - cplib/math/primefactor.nim
  - cplib/math/primefactor.nim
  - cplib/math/powmod.nim
  - cplib/math/powmod.nim
  - cplib/math/primitive_root.nim
  - cplib/math/primitive_root.nim
  timestamp: '2024-03-16 01:58:47+09:00'
  verificationStatus: LIBRARY_SOME_WA
  verifiedWith:
  - verify/math/factorize_yosupo_test.nim
  - verify/math/factorize_yosupo_test.nim
  - verify/math/euler_phi_yukicoder_test.nim
  - verify/math/euler_phi_yukicoder_test.nim
  - verify/AI/primefactor_test.nim
  - verify/AI/primefactor_test.nim
  - verify/AI/divisor_test.nim
  - verify/AI/divisor_test.nim
  - verify/AI/inner_math_test.nim
  - verify/AI/inner_math_test.nim
  - verify/AI/primitive_root_test.nim
  - verify/AI/primitive_root_test.nim
  - verify/AI/powmod_test.nim
  - verify/AI/powmod_test.nim
documentation_of: cplib/math/inner_math.nim
layout: document
redirect_from:
- /library/cplib/math/inner_math.nim
- /library/cplib/math/inner_math.nim.html
title: cplib/math/inner_math.nim
---
