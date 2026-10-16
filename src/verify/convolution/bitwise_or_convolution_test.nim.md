---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/bitwise_or_convolution.nim
    title: cplib/convolution/bitwise_or_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/bitwise_or_convolution.nim
    title: cplib/convolution/bitwise_or_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/set_transform.nim
    title: cplib/convolution/set_transform.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/set_transform.nim
    title: cplib/convolution/set_transform.nim
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
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/bitwise_and_convolution
    links:
    - https://judge.yosupo.jp/problem/bitwise_and_convolution
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://judge.yosupo.jp/problem/bitwise_and_convolution

    import cplib/convolution/bitwise_or_convolution

    import cplib/modint/modint

    import sequtils, strutils, algorithm

    proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}

    proc ii(): int = scanf("%lld", addr result)

    type mint = modint998244353_barrett

    let n = ii()

    var a = newSeqWith(1 shl n, init(mint, ii()))

    var b = newSeqWith(1 shl n, init(mint, ii()))

    a.reverse()

    b.reverse()

    var c = bitwiseOrConvolution(a, b)

    c.reverse()

    echo c.join(" ")

    '
  dependsOn:
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/convolution/set_transform.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/convolution/set_transform.nim
  - cplib/convolution/bitwise_or_convolution.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/convolution/bitwise_or_convolution.nim
  isVerificationFile: true
  path: verify/convolution/bitwise_or_convolution_test.nim
  requiredBy: []
  timestamp: '2026-10-08 06:34:57+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/convolution/bitwise_or_convolution_test.nim
layout: document
redirect_from:
- /verify/verify/convolution/bitwise_or_convolution_test.nim
- /verify/verify/convolution/bitwise_or_convolution_test.nim.html
title: verify/convolution/bitwise_or_convolution_test.nim
---
