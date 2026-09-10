---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/bit_matrix_ops.nim
    title: cplib/matrix/bit_matrix_ops.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/bit_matrix_ops.nim
    title: cplib/matrix/bit_matrix_ops.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/field_matrix_ops.nim
    title: cplib/matrix/field_matrix_ops.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/field_matrix_ops.nim
    title: cplib/matrix/field_matrix_ops.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/static_matrix_mod2.nim
    title: cplib/matrix/static_matrix_mod2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/static_matrix_mod2.nim
    title: cplib/matrix/static_matrix_mod2.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/matrix_product_mod_2
    links:
    - https://judge.yosupo.jp/problem/matrix_product_mod_2
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/matrix_product_mod_2\n\
    {.checks: off.}\nimport cplib/matrix/static_matrix_mod2\nimport strutils,sequtils\n\
    \nlet nmk = stdin.readLine.split.map(parseInt)\nlet (N,M,K) = (nmk[0], nmk[1],\
    \ nmk[2])\n\nvar A = initStaticMatrixMod2[4096,4096]()\nvar B = initStaticMatrixMod2[4096,4096]()\n\
    \nfor i in 0..<N:\n    A.setRowBits(i, stdin.readLine())\n\nfor i in 0..<M:\n\
    \    B.setRowBits(i, stdin.readLine())\n\nvar C = A * B\n\nfor i in 0..<N:\n \
    \   stdout.writeLine C.rowBits(i, K)\n"
  dependsOn:
  - cplib/matrix/field_matrix_ops.nim
  - cplib/matrix/static_matrix_mod2.nim
  - cplib/matrix/field_matrix_ops.nim
  - cplib/matrix/bit_matrix_ops.nim
  - cplib/matrix/bit_matrix_ops.nim
  - cplib/matrix/static_matrix_mod2.nim
  isVerificationFile: true
  path: verify/matrix/matrix_product_mod_2_static_test.nim
  requiredBy: []
  timestamp: '2026-09-10 08:33:37+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/matrix/matrix_product_mod_2_static_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/matrix_product_mod_2_static_test.nim
- /verify/verify/matrix/matrix_product_mod_2_static_test.nim.html
title: verify/matrix/matrix_product_mod_2_static_test.nim
---
