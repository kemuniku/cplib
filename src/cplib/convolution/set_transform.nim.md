---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/bitwise_or_convolution.nim
    title: cplib/convolution/bitwise_or_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/bitwise_or_convolution.nim
    title: cplib/convolution/bitwise_or_convolution.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/convolution/bitwise_or_convolution_test.nim
    title: verify/convolution/bitwise_or_convolution_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/convolution/bitwise_or_convolution_test.nim
    title: verify/convolution/bitwise_or_convolution_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/set_power_series_regression_test.nim
    title: verify/set_power_series/set_power_series_regression_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/set_power_series/set_power_series_regression_test.nim
    title: verify/set_power_series/set_power_series_regression_test.nim
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
  code: "when not declared CPLIB_CONVOLUTION_SET_TRANSFORM:\n    const CPLIB_CONVOLUTION_SET_TRANSFORM*\
    \ = 1\n\n    proc subsetZetaTransform*[T](a: var seq[T]) =\n        ## a[S] =\
    \ \u03A3_{U\u2286S} a[U] \u306B\u5909\u63DB\u3059\u308B\u3002O(n 2^n)\u6642\u9593\
    \u30FBO(1)\u8FFD\u52A0\u9818\u57DF\u3002\n        assert a.len == 0 or (a.len\
    \ and (a.len - 1)) == 0, \"\u9577\u3055\u306F\u7A7A\u307E\u305F\u306F2\u51AA\u3067\
    \u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        var bit = 1\n\
    \        while bit < a.len:\n            var base = 0\n            while base\
    \ < a.len:\n                for j in 0..<bit: a[base + bit + j] += a[base + j]\n\
    \                base += bit * 2\n            bit = bit shl 1\n\n    proc subsetMobiusTransform*[T](a:\
    \ var seq[T]) =\n        ## subsetZetaTransform\u306E\u9006\u5909\u63DB\u3002\
    O(n 2^n)\u6642\u9593\u30FBO(1)\u8FFD\u52A0\u9818\u57DF\u3002\n        assert a.len\
    \ == 0 or (a.len and (a.len - 1)) == 0, \"\u9577\u3055\u306F\u7A7A\u307E\u305F\
    \u306F2\u51AA\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n\
    \        var bit = 1\n        while bit < a.len:\n            var base = 0\n \
    \           while base < a.len:\n                for j in 0..<bit: a[base + bit\
    \ + j] -= a[base + j]\n                base += bit * 2\n            bit = bit\
    \ shl 1\n\n    proc supersetZetaTransform*[T](a: var seq[T]) =\n        ## a[S]\
    \ = \u03A3_{U\u2287S} a[U] \u306B\u5909\u63DB\u3059\u308B\u3002O(n 2^n)\u6642\u9593\
    \u30FBO(1)\u8FFD\u52A0\u9818\u57DF\u3002\n        assert a.len == 0 or (a.len\
    \ and (a.len - 1)) == 0, \"\u9577\u3055\u306F\u7A7A\u307E\u305F\u306F2\u51AA\u3067\
    \u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        var bit = 1\n\
    \        while bit < a.len:\n            var base = 0\n            while base\
    \ < a.len:\n                for j in 0..<bit: a[base + j] += a[base + bit + j]\n\
    \                base += bit * 2\n            bit = bit shl 1\n\n    proc supersetMobiusTransform*[T](a:\
    \ var seq[T]) =\n        ## supersetZetaTransform\u306E\u9006\u5909\u63DB\u3002\
    O(n 2^n)\u6642\u9593\u30FBO(1)\u8FFD\u52A0\u9818\u57DF\u3002\n        assert a.len\
    \ == 0 or (a.len and (a.len - 1)) == 0, \"\u9577\u3055\u306F\u7A7A\u307E\u305F\
    \u306F2\u51AA\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n\
    \        var bit = 1\n        while bit < a.len:\n            var base = 0\n \
    \           while base < a.len:\n                for j in 0..<bit: a[base + j]\
    \ -= a[base + bit + j]\n                base += bit * 2\n            bit = bit\
    \ shl 1\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/convolution/set_transform.nim
  requiredBy:
  - cplib/convolution/bitwise_or_convolution.nim
  - cplib/convolution/bitwise_or_convolution.nim
  timestamp: '2026-10-02 20:04:36+00:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/set_power_series/set_power_series_regression_test.nim
  - verify/set_power_series/set_power_series_regression_test.nim
  - verify/convolution/bitwise_or_convolution_test.nim
  - verify/convolution/bitwise_or_convolution_test.nim
documentation_of: cplib/convolution/set_transform.nim
layout: document
redirect_from:
- /library/cplib/convolution/set_transform.nim
- /library/cplib/convolution/set_transform.nim.html
title: cplib/convolution/set_transform.nim
---
