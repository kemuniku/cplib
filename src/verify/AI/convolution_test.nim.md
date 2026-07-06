---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/ntt.nim
    title: cplib/convolution/ntt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/ntt.nim
    title: cplib/convolution/ntt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':question:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':question:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
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
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

    echo "Hello World"


    import sequtils

    import cplib/convolution/convolution

    import cplib/modint/modint


    assert convolution_ll(@[1, 2, 3], @[4, 5]) == @[4, 13, 22, 15]


    type Mint = modint998244353_barrett

    let f = @[Mint(1), Mint(2), Mint(3)]

    let g = @[Mint(4), Mint(5)]

    assert convolution_naive(f, g).mapIt(it.val) == @[4, 13, 22, 15]

    assert convolution(f, g).mapIt(it.val) == @[4, 13, 22, 15]

    '
  dependsOn:
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/inv_gcd.nim
  - cplib/convolution/convolution.nim
  - cplib/convolution/ntt.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/convolution/ntt.nim
  - cplib/convolution/convolution.nim
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  isVerificationFile: true
  path: verify/AI/convolution_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/convolution_test.nim
layout: document
redirect_from:
- /verify/verify/AI/convolution_test.nim
- /verify/verify/AI/convolution_test.nim.html
title: verify/AI/convolution_test.nim
---
