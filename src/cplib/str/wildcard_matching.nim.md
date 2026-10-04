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
  - icon: ':heavy_check_mark:'
    path: verify/str/wildcard_matching_test.nim
    title: verify/str/wildcard_matching_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/wildcard_matching_test.nim
    title: verify/str/wildcard_matching_test.nim
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
    \        return\n        {.push assertions: on.}\n        assert S.len <= (1 shl\
    \ 24) - T.len + 1, \"\u7573\u307F\u8FBC\u307F\u306B\u5FC5\u8981\u306A\u9577\u3055\
    S.len + T.len - 1\u306F2^24\u4EE5\u4E0B\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\
    \u308A\u307E\u3059\"\n        {.pop.}\n        for i in 0..<result.len:\n    \
    \        result[i] = true\n        if T.len <= 60:\n            for i in 0..<result.len:\n\
    \                for j in 0..<T.len:\n                    if S[i + j] != wild\
    \ and T[j] != wild and S[i + j] != T[j]:\n                        result[i] =\
    \ false\n                        break\n            return\n\n        var lo =\
    \ 255\n        var hi = 0\n        var fixedS, fixedT = 0\n        for c in S:\n\
    \            if c != wild:\n                lo = min(lo, ord(c))\n           \
    \     hi = max(hi, ord(c))\n                inc fixedS\n        for c in T:\n\
    \            if c != wild:\n                lo = min(lo, ord(c))\n           \
    \     hi = max(hi, ord(c))\n                inc fixedT\n        if fixedS == 0\
    \ or fixedT == 0 or lo == hi:\n            return\n\n        # \u03A3 maskS maskT\
    \ (x-y)^2 \u306F\u975E\u8CA0\u3067\u3001\u4E00\u81F4\u3059\u308B\u3068\u304D\u3060\
    \u30510\u306B\u306A\u308B\u3002\n        # \u5404\u30B9\u30B3\u30A2\u306F fixedT*(hi-lo)^2\
    \ \u4EE5\u4E0B\u30021\u7D20\u6570\u3067\u8DB3\u308A\u306A\u3051\u308C\u30702\u7D20\
    \u6570\u3067\u96F6\u5224\u5B9A\u3059\u308B\u3002\n        # \u4E0A\u9650\u306F\
    2^23*255^2 < 469762049*167772161\u306A\u306E\u3067\u3001\u5270\u4F59\u306E\u885D\
    \u7A81\u306F\u306A\u3044\u3002\n        # \u5DE1\u56DE\u9577L >= |S|\u3067\u306F\
    \u6298\u308A\u8FD4\u3059\u9AD8\u6B21\u9805\u306F|T|-2\u4EE5\u4E0B\u306B\u3057\u304B\
    \u5C4A\u304B\u306A\u3044\u3002\n        let bound = fixedT.uint64 * (hi - lo).uint64\
    \ * (hi - lo).uint64\n        let output = cast[ptr uint8](addr result[0])\n \
    \       let s = cast[ptr uint8](unsafeAddr S[0])\n        let t = cast[ptr uint8](unsafeAddr\
    \ T[0])\n        wildcardMatchingNttKernel(output, s, S.len.csize_t, t, T.len.csize_t,\n\
    \            ord(wild).uint8, lo.uint32, 469762049u32)\n        if bound >= 469762049u64:\n\
    \            wildcardMatchingNttKernel(output, s, S.len.csize_t, t, T.len.csize_t,\n\
    \                ord(wild).uint8, lo.uint32, 167772161u32)\n"
  dependsOn:
  - cplib/modint/montgomery_impl.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/math/inv_gcd.nim
  - cplib/modint/modint.nim
  - cplib/convolution/convolution.nim
  - cplib/convolution/convolution.nim
  - cplib/math/isprime.nim
  - cplib/math/isprime.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/montgomery_impl.nim
  isVerificationFile: false
  path: cplib/str/wildcard_matching.nim
  requiredBy: []
  timestamp: '2026-10-02 14:56:06+00:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/wildcard_matching_test.nim
  - verify/AI/wildcard_matching_test.nim
  - verify/str/wildcard_matching_test.nim
  - verify/str/wildcard_matching_test.nim
documentation_of: cplib/str/wildcard_matching.nim
layout: document
redirect_from:
- /library/cplib/str/wildcard_matching.nim
- /library/cplib/str/wildcard_matching.nim.html
title: cplib/str/wildcard_matching.nim
---
