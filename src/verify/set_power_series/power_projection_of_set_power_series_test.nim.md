---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/private/subset_convolution_barrett.nim
    title: cplib/convolution/private/subset_convolution_barrett.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/private/subset_convolution_barrett.nim
    title: cplib/convolution/private/subset_convolution_barrett.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/subset_convolution.nim
    title: cplib/convolution/subset_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/subset_convolution.nim
    title: cplib/convolution/subset_convolution.nim
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
  - icon: ':heavy_check_mark:'
    path: cplib/set_power_series/set_power_series.nim
    title: cplib/set_power_series/set_power_series.nim
  - icon: ':heavy_check_mark:'
    path: cplib/set_power_series/set_power_series.nim
    title: cplib/set_power_series/set_power_series.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/power_projection_of_set_power_series
    links:
    - https://judge.yosupo.jp/problem/power_projection_of_set_power_series
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://judge.yosupo.jp/problem/power_projection_of_set_power_series


    import cplib/set_power_series/set_power_series

    import cplib/convolution/subset_convolution

    import cplib/modint/modint

    import sequtils, strutils

    proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}

    proc ii(): int = scanf("%lld", addr result)

    type mint = modint998244353_barrett

    let n = ii()

    let m = ii()

    let s = newSeqWith(1 shl n, init(mint, ii()))

    let w = newSeqWith(1 shl n, init(mint, ii()))

    echo setPowerProjection(s, w, m).join(" ")

    '
  dependsOn:
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isprime.nim
  - cplib/convolution/subset_convolution.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/convolution/subset_convolution.nim
  - cplib/convolution/private/subset_convolution_barrett.nim
  - cplib/set_power_series/set_power_series.nim
  - cplib/math/isprime.nim
  - cplib/set_power_series/set_power_series.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/convolution/private/subset_convolution_barrett.nim
  isVerificationFile: true
  path: verify/set_power_series/power_projection_of_set_power_series_test.nim
  requiredBy: []
  timestamp: '2026-10-08 06:34:57+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/set_power_series/power_projection_of_set_power_series_test.nim
layout: document
redirect_from:
- /verify/verify/set_power_series/power_projection_of_set_power_series_test.nim
- /verify/verify/set_power_series/power_projection_of_set_power_series_test.nim.html
title: verify/set_power_series/power_projection_of_set_power_series_test.nim
---
