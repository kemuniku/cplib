---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
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
    path: cplib/math/primefactor.nim
    title: cplib/math/primefactor.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/primefactor.nim
    title: cplib/math/primefactor.nim
  - icon: ':warning:'
    path: cplib/math/primitive_root.nim
    title: cplib/math/primitive_root.nim
  - icon: ':warning:'
    path: cplib/math/primitive_root.nim
    title: cplib/math/primitive_root.nim
  - icon: ':warning:'
    path: cplib/utils/random_helper.nim
    title: cplib/utils/random_helper.nim
  - icon: ':warning:'
    path: cplib/utils/random_helper.nim
    title: cplib/utils/random_helper.nim
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
    path: verify/math/euler_phi_yukicoder_test.nim
    title: verify/math/euler_phi_yukicoder_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/euler_phi_yukicoder_test.nim
    title: verify/math/euler_phi_yukicoder_test.nim
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
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_MATH_POWMOD:\n    const CPLIB_MATH_POWMOD* = 1\n\
    \    import cplib/math/inner_math\n    proc powmod*(a, n, m: int): int =\n   \
    \     assert m != 0\n        if m == 1:\n            return 0\n        var\n \
    \           rev = 1\n            a = a\n            n = n\n        while n > 0:\n\
    \            if n mod 2 != 0: rev = mul(rev, a, m)\n            if n > 1: a =\
    \ mul(a, a, m)\n            n = n shr 1\n        return rev\n"
  dependsOn:
  - cplib/math/inner_math.nim
  - cplib/math/inner_math.nim
  isVerificationFile: false
  path: cplib/math/powmod.nim
  requiredBy:
  - verify/math/factorize_table_abc284d_test_.nim
  - verify/math/factorize_table_abc284d_test_.nim
  - verify/math/divisor_many_atcoder_test_.nim
  - verify/math/divisor_many_atcoder_test_.nim
  - verify/math/factorize_tuple_abc324b_test_.nim
  - verify/math/factorize_tuple_abc324b_test_.nim
  - verify/math/divisor_atcoder_test_.nim
  - verify/math/divisor_atcoder_test_.nim
  - cplib/utils/random_helper.nim
  - cplib/utils/random_helper.nim
  - cplib/math/isprime.nim
  - cplib/math/isprime.nim
  - cplib/math/primefactor.nim
  - cplib/math/primefactor.nim
  - cplib/math/divisor.nim
  - cplib/math/divisor.nim
  - cplib/math/primitive_root.nim
  - cplib/math/primitive_root.nim
  timestamp: '2024-11-07 17:54:13+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/math/isprime_yosupo_test.nim
  - verify/math/isprime_yosupo_test.nim
  - verify/math/isprime_yukicoder_test.nim
  - verify/math/isprime_yukicoder_test.nim
  - verify/math/euler_phi_yukicoder_test.nim
  - verify/math/euler_phi_yukicoder_test.nim
  - verify/math/factorize_yosupo_test.nim
  - verify/math/factorize_yosupo_test.nim
documentation_of: cplib/math/powmod.nim
layout: document
redirect_from:
- /library/cplib/math/powmod.nim
- /library/cplib/math/powmod.nim.html
title: cplib/math/powmod.nim
---
