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
    path: cplib/fps/formal_power_series.nim
    title: cplib/fps/formal_power_series.nim
  - icon: ':question:'
    path: cplib/fps/formal_power_series.nim
    title: cplib/fps/formal_power_series.nim
  - icon: ':question:'
    path: cplib/fps/product_tree.nim
    title: cplib/fps/product_tree.nim
  - icon: ':question:'
    path: cplib/fps/product_tree.nim
    title: cplib/fps/product_tree.nim
  - icon: ':question:'
    path: cplib/fps/shift_of_sampling_points.nim
    title: cplib/fps/shift_of_sampling_points.nim
  - icon: ':question:'
    path: cplib/fps/shift_of_sampling_points.nim
    title: cplib/fps/shift_of_sampling_points.nim
  - icon: ':question:'
    path: cplib/fps/taylor_shift.nim
    title: cplib/fps/taylor_shift.nim
  - icon: ':question:'
    path: cplib/fps/taylor_shift.nim
    title: cplib/fps/taylor_shift.nim
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
    path: cplib/math/many_factorials.nim
    title: cplib/math/many_factorials.nim
  - icon: ':question:'
    path: cplib/math/many_factorials.nim
    title: cplib/math/many_factorials.nim
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
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':x:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/many_factorials
    links:
    - https://judge.yosupo.jp/problem/many_factorials
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://judge.yosupo.jp/problem/many_factorials


    import sequtils, strutils

    import cplib/math/many_factorials

    import cplib/modint/modint


    proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}

    proc ii(): int {.inline.} = scanf("%lld\n", addr result)


    type Mint = modint998244353_barrett


    let q = ii()

    let ns = newSeqWith(q, ii())

    echo manyFactorials[Mint](ns).join("\n")

    '
  dependsOn:
  - cplib/math/inv_gcd.nim
  - cplib/math/isprime.nim
  - cplib/fps/shift_of_sampling_points.nim
  - cplib/modint/modint.nim
  - cplib/math/many_factorials.nim
  - cplib/math/isprime.nim
  - cplib/math/inv_gcd.nim
  - cplib/fps/formal_power_series.nim
  - cplib/fps/formal_power_series.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/fps/taylor_shift.nim
  - cplib/convolution/convolution.nim
  - cplib/convolution/convolution.nim
  - cplib/math/isqrt.nim
  - cplib/fps/shift_of_sampling_points.nim
  - cplib/modint/barrett_impl.nim
  - cplib/fps/taylor_shift.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/fps/product_tree.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/math/many_factorials.nim
  - cplib/fps/product_tree.nim
  isVerificationFile: true
  path: verify/math/many_factorials_test.nim
  requiredBy: []
  timestamp: '2026-09-13 12:35:42+09:00'
  verificationStatus: TEST_WRONG_ANSWER
  verifiedWith: []
documentation_of: verify/math/many_factorials_test.nim
layout: document
redirect_from:
- /verify/verify/math/many_factorials_test.nim
- /verify/verify/math/many_factorials_test.nim.html
title: verify/math/many_factorials_test.nim
---
