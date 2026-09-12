---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/wildcard_matching_test.nim
    title: verify/AI/wildcard_matching_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/wildcard_matching_test.nim
    title: verify/AI/wildcard_matching_test.nim
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
  code: "when not declared CPLIB_STR_WILDCARD_MATCHING:\n    const CPLIB_STR_WILDCARD_MATCHING*\
    \ = 1\n\n    import cplib/convolution/convolution\n\n    proc wildcard_match*(S,\
    \ T: string, wild: char = '?'): seq[bool] =\n        ## S \u306E\u5404\u958B\u59CB\
    \u4F4D\u7F6E\u3067 T \u304C\u4E00\u81F4\u3059\u308B\u304B\u3092\u3001\u6642\u9593\
    \ O((|S|+|T|) log(|S|+|T|))\u3001\u7A7A\u9593 O(|S|+|T|) \u3067\u8FD4\u3057\u307E\
    \u3059\u3002\n        ## \u4E21\u6587\u5B57\u5217\u306E wild \u306F\u4EFB\u610F\
    \u306E 1 \u30D0\u30A4\u30C8\u306B\u4E00\u81F4\u3057\u3001string \u306F\u30D0\u30A4\
    \u30C8\u5358\u4F4D\u3067\u6271\u3044\u307E\u3059\u3002\n        ## T \u304C\u7A7A\
    \u306A\u3089 |S|+1 \u500B\u306E true\u3001|T| > |S| \u306A\u3089\u7A7A\u5217\u3092\
    \u8FD4\u3057\u307E\u3059\u3002\n        ## 64 bit \u74B0\u5883\u304C\u5FC5\u8981\
    \u3067\u3059\u30020 < |T| <= |S| \u306E\u5834\u5408\u3001|S|+|T|-1 <= 2^24 \u304C\
    \u5FC5\u8981\u3067\u3059\u3002\n        if T.len > S.len:\n            return\
    \ @[]\n        result = newSeq[bool](S.len - T.len + 1)\n        if T.len == 0:\n\
    \            for i in 0..<result.len:\n                result[i] = true\n    \
    \        return\n        doAssert S.len <= (1 shl 24) - T.len + 1\n\n        var\
    \ s, t: array[3, seq[int]]\n        for k in 0..<3:\n            s[k] = newSeq[int](S.len)\n\
    \            t[k] = newSeq[int](T.len)\n        for i, c in S:\n            if\
    \ c != wild:\n                let x = ord(c) + 1\n                s[0][i] = x\n\
    \                s[1][i] = x * x\n                s[2][i] = x * x * x\n      \
    \  for i, c in T:\n            if c != wild:\n                let x = ord(c) +\
    \ 1\n                let j = T.len - 1 - i\n                t[0][j] = x\n    \
    \            t[1][j] = x * x\n                t[2][j] = x * x * x\n\n        #\
    \ \u03A3 xy(x-y)^2 \u306F\u3001\u4E00\u81F4\u3059\u308B\u3068\u304D\u3060\u3051\
    \ 0 \u306B\u306A\u308A\u307E\u3059\u3002\n        # \u6574\u6570\u7573\u307F\u8FBC\
    \u307F\u3067\u5270\u4F59\u306E\u885D\u7A81\u3092\u907F\u3051\u307E\u3059\u3002\
    \u4E0A\u306E\u9577\u3055\u5236\u9650\u3067\u306F\u4E2D\u9593\u5024\u3082 int64\
    \ \u306B\u53CE\u307E\u308A\u307E\u3059\u3002\n        let a = convolution_ll(s[0],\
    \ t[2])\n        let b = convolution_ll(s[1], t[1])\n        let c = convolution_ll(s[2],\
    \ t[0])\n        for i in 0..<result.len:\n            let j = i + T.len - 1\n\
    \            result[i] = a[j] + c[j] - 2 * b[j] == 0\n"
  dependsOn:
  - cplib/modint/barrett_impl.nim
  - cplib/convolution/convolution.nim
  - cplib/math/isqrt.nim
  - cplib/math/isprime.nim
  - cplib/math/isqrt.nim
  - cplib/math/isprime.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/powmod.nim
  - cplib/modint/modint.nim
  - cplib/convolution/convolution.nim
  - cplib/math/inner_math.nim
  - cplib/math/powmod.nim
  - cplib/modint/modint.nim
  - cplib/math/inner_math.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/inv_gcd.nim
  - cplib/modint/montgomery_impl.nim
  isVerificationFile: false
  path: cplib/str/wildcard_matching.nim
  requiredBy: []
  timestamp: '2026-09-10 06:14:46+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/wildcard_matching_test.nim
  - verify/AI/wildcard_matching_test.nim
documentation_of: cplib/str/wildcard_matching.nim
layout: document
redirect_from:
- /library/cplib/str/wildcard_matching.nim
- /library/cplib/str/wildcard_matching.nim.html
title: cplib/str/wildcard_matching.nim
---
