---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':question:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':question:'
    path: cplib/convolution/ntt.nim
    title: cplib/convolution/ntt.nim
  - icon: ':question:'
    path: cplib/convolution/ntt.nim
    title: cplib/convolution/ntt.nim
  - icon: ':question:'
    path: cplib/convolution/relaxed_convolution.nim
    title: cplib/convolution/relaxed_convolution.nim
  - icon: ':question:'
    path: cplib/convolution/relaxed_convolution.nim
    title: cplib/convolution/relaxed_convolution.nim
  - icon: ':question:'
    path: cplib/convolution/semi_relaxed_convolution.nim
    title: cplib/convolution/semi_relaxed_convolution.nim
  - icon: ':question:'
    path: cplib/convolution/semi_relaxed_convolution.nim
    title: cplib/convolution/semi_relaxed_convolution.nim
  - icon: ':question:'
    path: cplib/fps/bostan_mori.nim
    title: cplib/fps/bostan_mori.nim
  - icon: ':question:'
    path: cplib/fps/bostan_mori.nim
    title: cplib/fps/bostan_mori.nim
  - icon: ':question:'
    path: cplib/fps/composition.nim
    title: cplib/fps/composition.nim
  - icon: ':question:'
    path: cplib/fps/composition.nim
    title: cplib/fps/composition.nim
  - icon: ':question:'
    path: cplib/fps/formal_power_series.nim
    title: cplib/fps/formal_power_series.nim
  - icon: ':question:'
    path: cplib/fps/formal_power_series.nim
    title: cplib/fps/formal_power_series.nim
  - icon: ':question:'
    path: cplib/fps/fps.nim
    title: cplib/fps/fps.nim
  - icon: ':question:'
    path: cplib/fps/fps.nim
    title: cplib/fps/fps.nim
  - icon: ':question:'
    path: cplib/fps/polynomial_interpolation.nim
    title: cplib/fps/polynomial_interpolation.nim
  - icon: ':question:'
    path: cplib/fps/polynomial_interpolation.nim
    title: cplib/fps/polynomial_interpolation.nim
  - icon: ':question:'
    path: cplib/fps/product_of_polynomial_sequence.nim
    title: cplib/fps/product_of_polynomial_sequence.nim
  - icon: ':question:'
    path: cplib/fps/product_of_polynomial_sequence.nim
    title: cplib/fps/product_of_polynomial_sequence.nim
  - icon: ':question:'
    path: cplib/fps/product_tree.nim
    title: cplib/fps/product_tree.nim
  - icon: ':question:'
    path: cplib/fps/product_tree.nim
    title: cplib/fps/product_tree.nim
  - icon: ':question:'
    path: cplib/fps/sparse_formal_power_series.nim
    title: cplib/fps/sparse_formal_power_series.nim
  - icon: ':question:'
    path: cplib/fps/sparse_formal_power_series.nim
    title: cplib/fps/sparse_formal_power_series.nim
  - icon: ':question:'
    path: cplib/fps/taylor_shift.nim
    title: cplib/fps/taylor_shift.nim
  - icon: ':question:'
    path: cplib/fps/taylor_shift.nim
    title: cplib/fps/taylor_shift.nim
  - icon: ':question:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':question:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':question:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':question:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':question:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':question:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':question:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':question:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':question:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':question:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':question:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':question:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':question:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':question:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':question:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  - icon: ':question:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/pow_of_formal_power_series
    links:
    - https://judge.yosupo.jp/problem/pow_of_formal_power_series
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://judge.yosupo.jp/problem/pow_of_formal_power_series


    import sequtils, strutils

    include cplib/fps/fps

    import cplib/modint/modint


    proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}

    proc ii(): int {.inline.} = scanf("%lld\n", addr result)


    type Mint = modint998244353_barrett


    let n = ii()

    let k = ii()

    let f = newSeqWith(n, Mint(ii()))

    echo f.pow(k, n).join(" ")

    '
  dependsOn:
  - cplib/modint/modint.nim
  - cplib/fps/bostan_mori.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/math/isqrt.nim
  - cplib/fps/product_tree.nim
  - cplib/fps/product_of_polynomial_sequence.nim
  - cplib/convolution/semi_relaxed_convolution.nim
  - cplib/fps/formal_power_series.nim
  - cplib/fps/taylor_shift.nim
  - cplib/math/inner_math.nim
  - cplib/fps/product_of_polynomial_sequence.nim
  - cplib/convolution/semi_relaxed_convolution.nim
  - cplib/fps/product_tree.nim
  - cplib/math/inner_math.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/powmod.nim
  - cplib/convolution/convolution.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/powmod.nim
  - cplib/fps/taylor_shift.nim
  - cplib/convolution/relaxed_convolution.nim
  - cplib/convolution/ntt.nim
  - cplib/fps/composition.nim
  - cplib/fps/sparse_formal_power_series.nim
  - cplib/convolution/relaxed_convolution.nim
  - cplib/fps/formal_power_series.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isprime.nim
  - cplib/fps/polynomial_interpolation.nim
  - cplib/fps/fps.nim
  - cplib/convolution/ntt.nim
  - cplib/fps/fps.nim
  - cplib/math/isprime.nim
  - cplib/fps/bostan_mori.nim
  - cplib/fps/sparse_formal_power_series.nim
  - cplib/convolution/convolution.nim
  - cplib/math/inv_gcd.nim
  - cplib/modint/barrett_impl.nim
  - cplib/fps/polynomial_interpolation.nim
  - cplib/fps/composition.nim
  isVerificationFile: true
  path: verify/fps/pow_of_formal_power_series_test.nim
  requiredBy: []
  timestamp: '2026-09-04 10:21:15+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/fps/pow_of_formal_power_series_test.nim
layout: document
redirect_from:
- /verify/verify/fps/pow_of_formal_power_series_test.nim
- /verify/verify/fps/pow_of_formal_power_series_test.nim.html
title: verify/fps/pow_of_formal_power_series_test.nim
---
