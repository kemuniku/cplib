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
    path: cplib/math/modfast.nim
    title: cplib/math/modfast.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/modfast.nim
    title: cplib/math/modfast.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/primitive_root.nim
    title: cplib/math/primitive_root.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/primitive_root.nim
    title: cplib/math/primitive_root.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/powmod_test.nim
    title: verify/AI/powmod_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/powmod_test.nim
    title: verify/AI/powmod_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/primitive_root_test.nim
    title: verify/AI/primitive_root_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/primitive_root_test.nim
    title: verify/AI/primitive_root_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/euler_phi_yukicoder_test.nim
    title: verify/math/euler_phi_yukicoder_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/euler_phi_yukicoder_test.nim
    title: verify/math/euler_phi_yukicoder_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/modfast_test.nim
    title: verify/math/modfast_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/modfast_test.nim
    title: verify/math/modfast_test.nim
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
    \     ## \u6B63\u306E\u6CD5m\u306B\u3064\u3044\u3066a\u306En\u4E57\u306E\u5270\
    \u4F59\u30920\u4EE5\u4E0Am\u672A\u6E80\u3067\u8FD4\u3059\u3002O(log(n + 1))\u3002\
    \n        assert m > 0, \"\u6CD5m\u306F\u6B63\u3067\u3042\u308B\u5FC5\u8981\u304C\
    \u3042\u308A\u307E\u3059\"\n        if m == 1:\n            return 0\n       \
    \ var\n            rev = 1\n            a = a\n            n = n\n        while\
    \ n > 0:\n            if n mod 2 != 0: rev = mul(rev, a, m)\n            if n\
    \ > 1: a = mul(a, a, m)\n            n = n shr 1\n        if rev < 0: rev += m\n\
    \        return rev\n"
  dependsOn:
  - cplib/math/inner_math.nim
  - cplib/math/inner_math.nim
  isVerificationFile: false
  path: cplib/math/powmod.nim
  requiredBy:
  - cplib/math/modfast.nim
  - cplib/math/modfast.nim
  - cplib/math/primitive_root.nim
  - cplib/math/primitive_root.nim
  timestamp: '2026-09-18 02:04:27+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/math/modfast_test.nim
  - verify/math/modfast_test.nim
  - verify/math/euler_phi_yukicoder_test.nim
  - verify/math/euler_phi_yukicoder_test.nim
  - verify/AI/primitive_root_test.nim
  - verify/AI/primitive_root_test.nim
  - verify/AI/powmod_test.nim
  - verify/AI/powmod_test.nim
documentation_of: cplib/math/powmod.nim
layout: document
redirect_from:
- /library/cplib/math/powmod.nim
- /library/cplib/math/powmod.nim.html
title: cplib/math/powmod.nim
---
