---
data:
  _extendedDependsOn:
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
    path: cplib/math/multiplicative_prefix_sum.nim
    title: cplib/math/multiplicative_prefix_sum.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/multiplicative_prefix_sum.nim
    title: cplib/math/multiplicative_prefix_sum.nim
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
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/sum_of_multiplicative_function
    links:
    - https://judge.yosupo.jp/problem/sum_of_multiplicative_function
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/sum_of_multiplicative_function\n\
    include cplib/tmpl/sheep\nimport cplib/modint/modint\nimport cplib/math/multiplicative_prefix_sum\n\
    \ntype Mint = StaticMontgomeryModint[469762049'u32]\nlet t = ii()\nfor _ in 0..<t:\n\
    \    let n = ii()\n    let a = init(Mint, ii())\n    let b = init(Mint, ii())\n\
    \    let answer = multiplicativePrefixSum(n, @[a, b],\n        proc(p, e: int):\
    \ Mint = a * e + b * p)\n    print answer\n"
  dependsOn:
  - cplib/math/multiplicative_prefix_sum.nim
  - cplib/math/isprime.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/utils/constants.nim
  - cplib/math/isprime.nim
  - cplib/tmpl/fastio.nim
  - cplib/tmpl/sheep.nim
  - cplib/math/multiplicative_prefix_sum.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/tmpl/sheep.nim
  - cplib/utils/constants.nim
  - cplib/tmpl/fastio.nim
  isVerificationFile: true
  path: verify/math/sum_of_multiplicative_function_test.nim
  requiredBy: []
  timestamp: '2026-10-01 06:31:44+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/sum_of_multiplicative_function_test.nim
layout: document
redirect_from:
- /verify/verify/math/sum_of_multiplicative_function_test.nim
- /verify/verify/math/sum_of_multiplicative_function_test.nim.html
title: verify/math/sum_of_multiplicative_function_test.nim
---
