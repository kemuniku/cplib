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
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':x:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/sqrt_of_formal_power_series
    links:
    - https://judge.yosupo.jp/problem/sqrt_of_formal_power_series
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/sqrt_of_formal_power_series\n\
    \nimport options, sequtils, strutils\ninclude cplib/fps/fps\nimport cplib/modint/modint\n\
    \nproc scanf(formatstr: cstring) {.header: \"<stdio.h>\", varargs.}\nproc ii():\
    \ int {.inline.} = scanf(\"%lld\\n\", addr result)\n\ntype Mint = modint998244353_barrett\n\
    \nlet n = ii()\nlet f = newSeqWith(n, Mint(ii()))\nlet root = f.sqrt(n)\nif root.isNone:\n\
    \    echo -1\nelse:\n    echo root.get.join(\" \")\n"
  dependsOn:
  - cplib/modint/modint.nim
  - cplib/fps/taylor_shift.nim
  - cplib/math/isqrt.nim
  - cplib/fps/formal_power_series.nim
  - cplib/math/inner_math.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/convolution/convolution.nim
  - cplib/fps/product_tree.nim
  - cplib/math/inner_math.nim
  - cplib/convolution/convolution.nim
  - cplib/math/powmod.nim
  - cplib/fps/polynomial_interpolation.nim
  - cplib/convolution/ntt.nim
  - cplib/fps/product_tree.nim
  - cplib/convolution/relaxed_convolution.nim
  - cplib/math/inv_gcd.nim
  - cplib/convolution/relaxed_convolution.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/fps/sparse_formal_power_series.nim
  - cplib/convolution/ntt.nim
  - cplib/math/isqrt.nim
  - cplib/fps/product_of_polynomial_sequence.nim
  - cplib/fps/formal_power_series.nim
  - cplib/modint/barrett_impl.nim
  - cplib/fps/composition.nim
  - cplib/fps/sparse_formal_power_series.nim
  - cplib/fps/product_of_polynomial_sequence.nim
  - cplib/fps/bostan_mori.nim
  - cplib/math/isprime.nim
  - cplib/fps/bostan_mori.nim
  - cplib/fps/polynomial_interpolation.nim
  - cplib/math/powmod.nim
  - cplib/modint/modint.nim
  - cplib/convolution/semi_relaxed_convolution.nim
  - cplib/fps/composition.nim
  - cplib/convolution/semi_relaxed_convolution.nim
  - cplib/math/isprime.nim
  - cplib/fps/taylor_shift.nim
  - cplib/math/inv_gcd.nim
  - cplib/fps/fps.nim
  - cplib/fps/fps.nim
  isVerificationFile: true
  path: verify/fps/sqrt_of_formal_power_series_test.nim
  requiredBy: []
  timestamp: '2026-09-08 11:13:22+09:00'
  verificationStatus: TEST_WRONG_ANSWER
  verifiedWith: []
documentation_of: verify/fps/sqrt_of_formal_power_series_test.nim
layout: document
redirect_from:
- /verify/verify/fps/sqrt_of_formal_power_series_test.nim
- /verify/verify/fps/sqrt_of_formal_power_series_test.nim.html
title: verify/fps/sqrt_of_formal_power_series_test.nim
---
