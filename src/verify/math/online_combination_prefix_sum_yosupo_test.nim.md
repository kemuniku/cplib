---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/combination.nim
    title: cplib/math/combination.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/combination.nim
    title: cplib/math/combination.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/online_combination_prefix_sum.nim
    title: cplib/math/online_combination_prefix_sum.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/online_combination_prefix_sum.nim
    title: cplib/math/online_combination_prefix_sum.nim
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
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/prefix_sum_of_binomial_coefficient
    links:
    - https://judge.yosupo.jp/problem/prefix_sum_of_binomial_coefficient
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/prefix_sum_of_binomial_coefficient\n\
    \ninclude cplib/tmpl/fastio\nimport cplib/math/online_combination_prefix_sum\n\
    import cplib/modint/modint\n\ntype Mint = modint998244353_barrett\n\nlet t = ii()\n\
    let sums = initOnlineCombinationPrefixSum[Mint](200000)\nfor _ in 0..<t:\n   \
    \ let n = ii()\n    let k = ii()\n    print(sums.prefixSum(n, k))\n"
  dependsOn:
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/math/online_combination_prefix_sum.nim
  - cplib/tmpl/fastio.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  - cplib/math/online_combination_prefix_sum.nim
  - cplib/modint/barrett_impl.nim
  - cplib/tmpl/fastio.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/math/combination.nim
  - cplib/math/combination.nim
  isVerificationFile: true
  path: verify/math/online_combination_prefix_sum_yosupo_test.nim
  requiredBy: []
  timestamp: '2026-10-26 00:28:06+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/online_combination_prefix_sum_yosupo_test.nim
layout: document
redirect_from:
- /verify/verify/math/online_combination_prefix_sum_yosupo_test.nim
- /verify/verify/math/online_combination_prefix_sum_yosupo_test.nim.html
title: verify/math/online_combination_prefix_sum_yosupo_test.nim
---
