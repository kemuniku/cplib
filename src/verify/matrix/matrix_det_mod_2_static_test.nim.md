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
    PROBLEM: https://judge.yosupo.jp/problem/matrix_det_mod_2
    links:
    - https://judge.yosupo.jp/problem/matrix_det_mod_2
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/matrix_det_mod_2\n\
    {.checks: off.}\nimport cplib/matrix/static_matrix_mod2\nimport std/strutils\n\
    \nconst MaxN = 4096\n\nlet n = stdin.readLine.parseInt\nvar a = initStaticMatrixMod2[MaxN,\
    \ MaxN]()\nfor i in 0..<n:\n    a.setRowBits(i, stdin.readLine)\nfor i in n..<MaxN:\n\
    \    a[i, i] = true\necho int(a.determinant)\n"
  dependsOn:
  - cplib/matrix/field_matrix_ops.nim
  - cplib/matrix/static_matrix_mod2.nim
  - cplib/matrix/field_matrix_ops.nim
  - cplib/matrix/bit_matrix_ops.nim
  - cplib/matrix/bit_matrix_ops.nim
  - cplib/matrix/static_matrix_mod2.nim
  isVerificationFile: true
  path: verify/matrix/matrix_det_mod_2_static_test.nim
  requiredBy: []
  timestamp: '2026-09-10 08:33:37+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/matrix/matrix_det_mod_2_static_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/matrix_det_mod_2_static_test.nim
- /verify/verify/matrix/matrix_det_mod_2_static_test.nim.html
title: verify/matrix/matrix_det_mod_2_static_test.nim
---
