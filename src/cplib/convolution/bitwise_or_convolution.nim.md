---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/set_transform.nim
    title: cplib/convolution/set_transform.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/set_transform.nim
    title: cplib/convolution/set_transform.nim
  _extendedRequiredBy: []
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
  code: "when not declared CPLIB_CONVOLUTION_BITWISE_OR_CONVOLUTION:\n    const CPLIB_CONVOLUTION_BITWISE_OR_CONVOLUTION*\
    \ = 1\n    import cplib/convolution/set_transform\n\n    proc bitwiseOrConvolution*[T](a,\
    \ b: seq[T]): seq[T] =\n        ## c[S] = \u03A3_{U or V = S} a[U] b[V]\u3002\
    O(n 2^n)\u6642\u9593\u30FBO(2^n)\u8FFD\u52A0\u9818\u57DF\u3002\n        assert\
    \ a.len == b.len, \"\u914D\u5217\u306E\u9577\u3055\u306F\u4E00\u81F4\u3059\u308B\
    \u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        result = a\n        var\
    \ right = b\n        subsetZetaTransform(result)\n        subsetZetaTransform(right)\n\
    \        for i in 0..<a.len: result[i] *= right[i]\n        subsetMobiusTransform(result)\n"
  dependsOn:
  - cplib/convolution/set_transform.nim
  - cplib/convolution/set_transform.nim
  isVerificationFile: false
  path: cplib/convolution/bitwise_or_convolution.nim
  requiredBy: []
  timestamp: '2026-10-02 20:04:36+00:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/set_power_series/set_power_series_regression_test.nim
  - verify/set_power_series/set_power_series_regression_test.nim
  - verify/convolution/bitwise_or_convolution_test.nim
  - verify/convolution/bitwise_or_convolution_test.nim
documentation_of: cplib/convolution/bitwise_or_convolution.nim
layout: document
redirect_from:
- /library/cplib/convolution/bitwise_or_convolution.nim
- /library/cplib/convolution/bitwise_or_convolution.nim.html
title: cplib/convolution/bitwise_or_convolution.nim
---
