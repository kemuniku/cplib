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
    PROBLEM: https://judge.yosupo.jp/problem/pow_of_matrix
    links:
    - https://judge.yosupo.jp/problem/pow_of_matrix
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/pow_of_matrix\n\
    import cplib/modint/modint\nimport cplib/matrix/matrix\nimport sequtils,strutils\n\
    \nproc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc ii():\
    \ int {.inline.} = scanf(\"%lld\\n\", addr result)\n\ntype mint = modint998244353_montgomery\n\
    var N,K = ii()\nvar A = newSeqWith(N,newSeqWith(N,mint(ii()))).toMatrix()\nvar\
    \ B = A.pow(K)\nfor i in 0..<N:\n    echo B[i].join(\" \")"
  dependsOn:
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  - cplib/matrix/matrix.nim
  - cplib/math/isqrt.nim
  - cplib/matrix/matrix.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  - cplib/modint/barrett_impl.nim
  isVerificationFile: true
  path: verify/matrix/matrix_pow_test.nim
  requiredBy: []
  timestamp: '2024-05-30 18:29:26+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/matrix/matrix_pow_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/matrix_pow_test.nim
- /verify/verify/matrix/matrix_pow_test.nim.html
title: verify/matrix/matrix_pow_test.nim
---
