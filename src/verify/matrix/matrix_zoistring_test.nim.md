---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/field_matrix_ops.nim
    title: cplib/matrix/field_matrix_ops.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/field_matrix_ops.nim
    title: cplib/matrix/field_matrix_ops.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix.nim
    title: cplib/matrix/matrix.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix.nim
    title: cplib/matrix/matrix.nim
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
    PROBLEM: https://yukicoder.me/problems/no/2156
    links:
    - https://yukicoder.me/problems/no/2156
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://yukicoder.me/problems/no/2156

    include cplib/matrix/matrix

    proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}

    proc ii(): int {.inline.} = scanf("%lld\n", addr result)

    import cplib/modint/modint

    type mint = modint998244353_barrett


    var n = ii()

    var a = @[@[mint(1), mint(1)], @[mint(1), mint(0)]].toMatrix

    var ans = initMatrix(@[mint(1), mint(0)], true)

    ans = a.pow(n) * ans

    echo ans[0, 0] - 1

    '
  dependsOn:
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/matrix/matrix.nim
  - cplib/matrix/field_matrix_ops.nim
  - cplib/modint/barrett_impl.nim
  - cplib/matrix/field_matrix_ops.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/matrix/matrix.nim
  - cplib/math/isqrt.nim
  isVerificationFile: true
  path: verify/matrix/matrix_zoistring_test.nim
  requiredBy: []
  timestamp: '2026-10-15 15:23:06+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/matrix/matrix_zoistring_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/matrix_zoistring_test.nim
- /verify/verify/matrix/matrix_zoistring_test.nim.html
title: verify/matrix/matrix_zoistring_test.nim
---
