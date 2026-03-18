---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/convolution/convolution/convolution_dynamic_barrett_test.nim
    title: verify/convolution/convolution/convolution_dynamic_barrett_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/convolution/convolution/convolution_dynamic_barrett_test.nim
    title: verify/convolution/convolution/convolution_dynamic_barrett_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/convolution/convolution/convolution_dynamic_montgomery_test.nim
    title: verify/convolution/convolution/convolution_dynamic_montgomery_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/convolution/convolution/convolution_dynamic_montgomery_test.nim
    title: verify/convolution/convolution/convolution_dynamic_montgomery_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/convolution/convolution/convolution_static_barrett_test.nim
    title: verify/convolution/convolution/convolution_static_barrett_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/convolution/convolution/convolution_static_barrett_test.nim
    title: verify/convolution/convolution/convolution_static_barrett_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/convolution/convolution/convolution_static_montgomery_test.nim
    title: verify/convolution/convolution/convolution_static_montgomery_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/convolution/convolution/convolution_static_montgomery_test.nim
    title: verify/convolution/convolution/convolution_static_montgomery_test.nim
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
  code: "when not declared CPLIB_MATH_INVGCD:\n    const CPLIB_MATH_INVGCD* = 1\n\
    \    # @param b `1 <= b`\n    # @return pair(g, x) s.t. g = gcd(a, b), xa = g\
    \ (mod b), 0 <= x < b/g\n    import std/math\n    proc inv_gcd*(a, b: int): (int,\
    \ int) =\n        var a = floorMod(a, b)\n        if a == 0: return (b, 0)\n \
    \       var\n            s = b\n            t = a\n            m0 = 0\n      \
    \      m1 = 1\n\n        while t != 0:\n            var u = s div t\n        \
    \    s -= t * u\n            m0 -= m1 * u\n\n            var tmp = s\n       \
    \     s = t\n            t = tmp\n            tmp = m0\n            m0 = m1\n\
    \            m1 = tmp\n        if m0 < 0: m0 += b div s\n        return (s, m0)\n\
    \n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/math/inv_gcd.nim
  requiredBy:
  - cplib/convolution/convolution.nim
  - cplib/convolution/convolution.nim
  timestamp: '2026-03-18 01:19:58+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/convolution/convolution/convolution_dynamic_barrett_test.nim
  - verify/convolution/convolution/convolution_dynamic_barrett_test.nim
  - verify/convolution/convolution/convolution_dynamic_montgomery_test.nim
  - verify/convolution/convolution/convolution_dynamic_montgomery_test.nim
  - verify/convolution/convolution/convolution_static_montgomery_test.nim
  - verify/convolution/convolution/convolution_static_montgomery_test.nim
  - verify/convolution/convolution/convolution_static_barrett_test.nim
  - verify/convolution/convolution/convolution_static_barrett_test.nim
documentation_of: cplib/math/inv_gcd.nim
layout: document
redirect_from:
- /library/cplib/math/inv_gcd.nim
- /library/cplib/math/inv_gcd.nim.html
title: cplib/math/inv_gcd.nim
---
