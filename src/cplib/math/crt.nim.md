---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/math/crt_test.nim
    title: verify/math/crt_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/crt_test.nim
    title: verify/math/crt_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links:
    - https://atcoder.github.io/ac-library/production/document_ja/math.html
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_MATH_CRT:\n    const CPLIB_MATH_CRT* = 1\n    import\
    \ cplib/math/inv_gcd\n    import cplib/math/int128\n\n    proc crt*(r, m: openArray[int]):\
    \ tuple[r, m: int] =\n        ## x \u2261 r[i] (mod m[i]) \u3092\u89E3\u304D\u3001\
    \u6700\u5C0F\u975E\u8CA0\u5270\u4F59\u3068\u6CD5\u306E\u6700\u5C0F\u516C\u500D\
    \u6570\u3092\u8FD4\u3059\u3002\n        ## \u6CD5\u306F\u4E92\u3044\u306B\u7D20\
    \u3067\u306A\u304F\u3066\u3082\u3088\u3044\u3002\u89E3\u306A\u3057\u306F (0, 0)\u3001\
    \u7A7A\u5217\u306F (0, 1)\u3002\n        ## \u9577\u3055\u4E0D\u4E00\u81F4\u307E\
    \u305F\u306F\u6B63\u3067\u306A\u3044\u6CD5\u306F ValueError\u3002\u8CA0\u306E\u5270\
    \u4F59\u3082\u53D7\u3051\u4ED8\u3051\u308B\u3002\n        ## \u5165\u529B\u9806\
    \u306B\u4F75\u5408\u3057\u3001\u6574\u5408\u3059\u308B\u9014\u4E2D\u306E\u6700\
    \u5C0F\u516C\u500D\u6570\u304C high(int) \u3092\u8D85\u3048\u305F\u6642\u70B9\u3067\
    \n        ## OverflowDefect \u3092\u9001\u51FA\u3059\u308B\u3002\u305D\u306E\u5F8C\
    \u306E\u5408\u540C\u5F0F\u306E\u6574\u5408\u6027\u306F\u691C\u67FB\u3057\u306A\
    \u3044\u3002\n        ## \u4E0D\u6B63\u5165\u529B\u306E\u691C\u67FB\u30FB\u30AA\
    \u30FC\u30D0\u30FC\u30D5\u30ED\u30FC\u691C\u51FA\u306F release / assertions:off\
    \ \u3067\u3082\u6709\u52B9\u3002\n        ## \u8A08\u7B97\u91CF O(r.len * log(max(m)))\u3001\
    \u88DC\u52A9\u7A7A\u9593 O(1)\u3002C++ \u30D0\u30C3\u30AF\u30A8\u30F3\u30C9\u3092\
    \u4F7F\u7528\u3059\u308B\u3002\n        ## \u53C2\u8003: https://atcoder.github.io/ac-library/production/document_ja/math.html\
    \ (CC0)\n        if r.len != m.len:\n            raise newException(ValueError,\
    \ \"\u5270\u4F59\u5217\u3068\u6CD5\u5217\u306E\u9577\u3055\u304C\u4E00\u81F4\u3057\
    \u307E\u305B\u3093\")\n        for modulus in m:\n            if modulus <= 0:\n\
    \                raise newException(ValueError, \"CRT\u306E\u6CD5\u306F\u6B63\u306E\
    \u6574\u6570\u3067\u6307\u5B9A\u3057\u3066\u304F\u3060\u3055\u3044\")\n      \
    \  result = (0, 1)\n        for i in 0..<r.len:\n            var residue = r[i]\
    \ mod m[i]\n            if residue < 0: residue += m[i]\n            let (g, inverse)\
    \ = inv_gcd(result.m, m[i])\n            let difference = residue - result.r\n\
    \            if difference mod g != 0: return (0, 0)\n            let factor =\
    \ m[i] div g\n            if result.m > high(int) div factor:\n              \
    \  raise newException(OverflowDefect, \"CRT\u306E\u6700\u5C0F\u516C\u500D\u6570\
    \u304Cint\u306E\u7BC4\u56F2\u5916\u3067\u3059\")\n            var step = (to_Int128(difference\
    \ div g) * to_Int128(inverse)) mod to_Int128(factor)\n            if step < 0:\
    \ step += to_Int128(factor)\n            result.r += result.m * step.to_int()\n\
    \            result.m *= factor\n"
  dependsOn:
  - cplib/math/inv_gcd.nim
  - cplib/math/int128.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/int128.nim
  isVerificationFile: false
  path: cplib/math/crt.nim
  requiredBy: []
  timestamp: '2026-10-02 19:57:44+00:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/math/crt_test.nim
  - verify/math/crt_test.nim
documentation_of: cplib/math/crt.nim
layout: document
redirect_from:
- /library/cplib/math/crt.nim
- /library/cplib/math/crt.nim.html
title: cplib/math/crt.nim
---
