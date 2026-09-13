---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/gcd_lcm_convolution_test.nim
    title: verify/AI/gcd_lcm_convolution_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/gcd_lcm_convolution_test.nim
    title: verify/AI/gcd_lcm_convolution_test.nim
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
  code: "when not declared CPLIB_CONVOLUTION_GCD_CONVOLUTION:\n    const CPLIB_CONVOLUTION_GCD_CONVOLUTION*\
    \ = 1\n\n    proc gcdConvolution*[T](a, b: seq[T]): seq[T] =\n        ## c[k]\
    \ = \u03A3_{gcd(i, j) = k} a[i] * b[j] \u3092O(N log log N)\u6642\u9593\u30FB\
    O(N)\u8FFD\u52A0\u9818\u57DF\u3067\u6C42\u3081\u308B\u3002\n        ## \u5165\u529B\
    \u306F\u540C\u3058\u9577\u3055\u3068\u3057\u3001\u8FD4\u308A\u5024\u3082\u540C\
    \u3058\u9577\u3055\u3002gcd(0, i) = i\u3001gcd(0, 0) = 0\u3068\u3059\u308B\u3002\
    \n        assert a.len == b.len, \"\u7573\u307F\u8FBC\u3080\u914D\u5217\u306E\u9577\
    \u3055\u306F\u7B49\u3057\u3044\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n \
    \       let n = a.len\n        if n == 0:\n            return @[]\n        result\
    \ = a\n        var right = b\n        var composite = newSeq[bool](n)\n      \
    \  var primes: seq[int]\n        for p in 2..<n:\n            if composite[p]:\n\
    \                continue\n            primes.add(p)\n            for i in countdown((n\
    \ - 1) div p, 1):\n                composite[i * p] = true\n                result[i]\
    \ += result[i * p]\n                right[i] += right[i * p]\n        for i in\
    \ 0..<n:\n            result[i] *= right[i]\n        for p in primes:\n      \
    \      for i in 1..(n - 1) div p:\n                result[i] -= result[i * p]\n\
    \        for i in 1..<n:\n            result[i] += a[0] * b[i] + a[i] * b[0]\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/convolution/gcd_convolution.nim
  requiredBy: []
  timestamp: '2026-09-13 17:15:27+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/gcd_lcm_convolution_test.nim
  - verify/AI/gcd_lcm_convolution_test.nim
documentation_of: cplib/convolution/gcd_convolution.nim
layout: document
redirect_from:
- /library/cplib/convolution/gcd_convolution.nim
- /library/cplib/convolution/gcd_convolution.nim.html
title: cplib/convolution/gcd_convolution.nim
---
