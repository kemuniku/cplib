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
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    import cplib/math/multiplicative_prefix_sum\nimport cplib/modint/modint\n\ntype\
    \ Mint = modint1000000007_barrett\nfor root in [65, 100, 257, 1000]:\n    for\
    \ n in [root * root - 1, root * root, root * root + 1,\n              root * (root\
    \ + 1) - 1, root * (root + 1), root * (root + 1) + 1]:\n        let x = init(Mint,\
    \ n)\n        let constant = multiplicativePrefixSum(n, @[init(Mint, 1)],\n  \
    \          proc(p, e: int): Mint = init(Mint, 1))\n        doAssert constant ==\
    \ x\n        let square = multiplicativePrefixSum(n, @[init(Mint, 0), init(Mint,\
    \ 0), init(Mint, 1)],\n            proc(p, e: int): Mint = init(Mint, p).pow(2\
    \ * e))\n        doAssert square == x * (x + 1) * (2 * x + 1) / 6\n\necho \"Hello\
    \ World\"\n"
  dependsOn:
  - cplib/math/multiplicative_prefix_sum.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isprime.nim
  - cplib/math/multiplicative_prefix_sum.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isprime.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  isVerificationFile: true
  path: verify/AI/multiplicative_prefix_sum_limit_test.nim
  requiredBy: []
  timestamp: '2026-09-30 20:31:36+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/multiplicative_prefix_sum_limit_test.nim
layout: document
redirect_from:
- /verify/verify/AI/multiplicative_prefix_sum_limit_test.nim
- /verify/verify/AI/multiplicative_prefix_sum_limit_test.nim.html
title: verify/AI/multiplicative_prefix_sum_limit_test.nim
---
