---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/fps/berlekamp_massey.nim
    title: cplib/fps/berlekamp_massey.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/berlekamp_massey.nim
    title: cplib/fps/berlekamp_massey.nim
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
    PROBLEM: https://judge.yosupo.jp/problem/find_linear_recurrence
    links:
    - https://judge.yosupo.jp/problem/find_linear_recurrence
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://judge.yosupo.jp/problem/find_linear_recurrence


    import sequtils, strutils

    import cplib/fps/berlekamp_massey

    import cplib/modint/modint


    proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}

    proc ii(): int {.inline.} = scanf("%lld\n", addr result)


    type Mint = modint998244353_barrett


    let n = ii()

    let a = newSeqWith(n, Mint(ii()))

    let coefficients = berlekampMassey(a)

    echo coefficients.len

    echo coefficients.mapIt($it).join(" ")

    '
  dependsOn:
  - cplib/math/isqrt.nim
  - cplib/fps/berlekamp_massey.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/modint/barrett_impl.nim
  - cplib/fps/berlekamp_massey.nim
  isVerificationFile: true
  path: verify/fps/find_linear_recurrence_test.nim
  requiredBy: []
  timestamp: '2026-09-09 14:27:08+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/fps/find_linear_recurrence_test.nim
layout: document
redirect_from:
- /verify/verify/fps/find_linear_recurrence_test.nim
- /verify/verify/fps/find_linear_recurrence_test.nim.html
title: verify/fps/find_linear_recurrence_test.nim
---
