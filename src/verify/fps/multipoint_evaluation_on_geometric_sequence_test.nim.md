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
    path: cplib/fps/chirp_z.nim
    title: cplib/fps/chirp_z.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/chirp_z.nim
    title: cplib/fps/chirp_z.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
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
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/multipoint_evaluation_on_geometric_sequence
    links:
    - https://judge.yosupo.jp/problem/multipoint_evaluation_on_geometric_sequence
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://judge.yosupo.jp/problem/multipoint_evaluation_on_geometric_sequence


    import sequtils, strutils

    import cplib/fps/chirp_z

    import cplib/modint/modint


    proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}

    proc ii(): int {.inline.} = scanf("%lld", addr result)


    type Mint = modint998244353_barrett

    let n = ii()

    let m = ii()

    let a = Mint(ii())

    let r = Mint(ii())

    let f = newSeqWith(n, Mint(ii()))

    echo multipointEvaluationGeometric(f, a, r, m).join(" ")

    '
  dependsOn:
  - cplib/modint/barrett_impl.nim
  - cplib/math/isprime.nim
  - cplib/fps/chirp_z.nim
  - cplib/convolution/convolution.nim
  - cplib/math/inv_gcd.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/fps/chirp_z.nim
  - cplib/math/isqrt.nim
  - cplib/math/isprime.nim
  - cplib/convolution/convolution.nim
  - cplib/modint/modint.nim
  - cplib/math/inv_gcd.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  isVerificationFile: true
  path: verify/fps/multipoint_evaluation_on_geometric_sequence_test.nim
  requiredBy: []
  timestamp: '2026-10-05 00:27:38+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/fps/multipoint_evaluation_on_geometric_sequence_test.nim
layout: document
redirect_from:
- /verify/verify/fps/multipoint_evaluation_on_geometric_sequence_test.nim
- /verify/verify/fps/multipoint_evaluation_on_geometric_sequence_test.nim.html
title: verify/fps/multipoint_evaluation_on_geometric_sequence_test.nim
---
