---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/min_plus_convolution.nim
    title: cplib/convolution/min_plus_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/min_plus_convolution.nim
    title: cplib/convolution/min_plus_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/monotone_minima.nim
    title: cplib/utils/monotone_minima.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/monotone_minima.nim
    title: cplib/utils/monotone_minima.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/smawk.nim
    title: cplib/utils/smawk.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/smawk.nim
    title: cplib/utils/smawk.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/min_plus_convolution_convex_arbitrary
    links:
    - https://judge.yosupo.jp/problem/min_plus_convolution_convex_arbitrary
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://judge.yosupo.jp/problem/min_plus_convolution_convex_arbitrary

    import cplib/convolution/min_plus_convolution

    import sequtils, strutils

    proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}

    proc readInt(): int64 = scanf("%lld", addr result)

    let n = int(readInt())

    let m = int(readInt())

    let a = newSeqWith(n, readInt())

    let b = newSeqWith(m, readInt())

    echo minPlusConvolutionConvexArbitraryMonotoneMinima(a, b).join(" ")

    '
  dependsOn:
  - cplib/convolution/min_plus_convolution.nim
  - cplib/convolution/min_plus_convolution.nim
  - cplib/utils/monotone_minima.nim
  - cplib/utils/smawk.nim
  - cplib/utils/monotone_minima.nim
  - cplib/utils/smawk.nim
  isVerificationFile: true
  path: verify/convolution/min_plus_convolution_convex_arbitrary_monotone_minima_test.nim
  requiredBy: []
  timestamp: '2026-09-13 17:15:27+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/convolution/min_plus_convolution_convex_arbitrary_monotone_minima_test.nim
layout: document
redirect_from:
- /verify/verify/convolution/min_plus_convolution_convex_arbitrary_monotone_minima_test.nim
- /verify/verify/convolution/min_plus_convolution_convex_arbitrary_monotone_minima_test.nim.html
title: verify/convolution/min_plus_convolution_convex_arbitrary_monotone_minima_test.nim
---
