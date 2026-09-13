---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitwise_and_convolution_test.nim
    title: verify/AI/bitwise_and_convolution_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitwise_and_convolution_test.nim
    title: verify/AI/bitwise_and_convolution_test.nim
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
  code: "when not declared CPLIB_CONVOLUTION_BITWISE_AND_CONVOLUTION:\n    const CPLIB_CONVOLUTION_BITWISE_AND_CONVOLUTION*\
    \ = 1\n\n    proc bitwiseAndConvolution*[T](a, b: seq[T]): seq[T] =\n        ##\
    \ c[k] = \u03A3_{i and j = k} a[i] * b[j] \u3092O(N log N)\u6642\u9593\u30FBO(N)\u8FFD\
    \u52A0\u9818\u57DF\u3067\u6C42\u3081\u308B\u3002\n        ## \u5165\u529B\u306F\
    \u540C\u3058\u9577\u3055\u306E2\u51AA\u306E\u5217\u3068\u3057\u3001\u4E21\u65B9\
    \u304C\u7A7A\u306E\u5834\u5408\u306F\u7A7A\u5217\u3092\u8FD4\u3059\u3002\n   \
    \     assert a.len == b.len, \"\u7573\u307F\u8FBC\u3080\u914D\u5217\u306E\u9577\
    \u3055\u306F\u7B49\u3057\u3044\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n \
    \       let n = a.len\n        if n == 0:\n            return @[]\n        assert\
    \ (n and (n - 1)) == 0, \"\u914D\u5217\u306E\u9577\u3055\u306F2\u306E\u51AA\u3067\
    \u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        result = a\n\
    \        var right = b\n        var bit = 1\n        while bit < n:\n        \
    \    for mask in 0..<n:\n                if (mask and bit) == 0:\n           \
    \         result[mask] += result[mask or bit]\n                    right[mask]\
    \ += right[mask or bit]\n            bit = bit shl 1\n        for mask in 0..<n:\n\
    \            result[mask] *= right[mask]\n        bit = 1\n        while bit <\
    \ n:\n            for mask in 0..<n:\n                if (mask and bit) == 0:\n\
    \                    result[mask] -= result[mask or bit]\n            bit = bit\
    \ shl 1\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/convolution/bitwise_and_convolution.nim
  requiredBy: []
  timestamp: '2026-09-13 17:15:27+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/bitwise_and_convolution_test.nim
  - verify/AI/bitwise_and_convolution_test.nim
documentation_of: cplib/convolution/bitwise_and_convolution.nim
layout: document
redirect_from:
- /library/cplib/convolution/bitwise_and_convolution.nim
- /library/cplib/convolution/bitwise_and_convolution.nim.html
title: cplib/convolution/bitwise_and_convolution.nim
---
