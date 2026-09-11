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
    path: cplib/matrix/matrix_mod2.nim
    title: cplib/matrix/matrix_mod2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_mod2.nim
    title: cplib/matrix/matrix_mod2.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/inverse_matrix_mod_2
    links:
    - https://judge.yosupo.jp/problem/inverse_matrix_mod_2
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/inverse_matrix_mod_2\n\
    {.checks: off.}\nimport cplib/matrix/matrix_mod2\nimport std/[options, strutils]\n\
    \nlet n = stdin.readLine.parseInt\nvar a = initMatrixMod2(n, n)\nfor i in 0..<n:\n\
    \    let s = stdin.readLine\n    for j in 0..<n: a[i, j] = s[j] == '1'\nlet inv\
    \ = a.inverse\nif inv.isNone:\n    echo -1\nelse:\n    let b = inv.get\n    for\
    \ i in 0..<n:\n        var s = newString(n)\n        for j in 0..<n: s[j] = if\
    \ b[i, j]: '1' else: '0'\n        echo s\n"
  dependsOn:
  - cplib/matrix/bit_matrix_ops.nim
  - cplib/matrix/field_matrix_ops.nim
  - cplib/matrix/matrix_mod2.nim
  - cplib/matrix/bit_matrix_ops.nim
  - cplib/matrix/field_matrix_ops.nim
  - cplib/matrix/matrix_mod2.nim
  isVerificationFile: true
  path: verify/matrix/inverse_matrix_mod_2_test.nim
  requiredBy: []
  timestamp: '2026-09-10 08:33:37+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/matrix/inverse_matrix_mod_2_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/inverse_matrix_mod_2_test.nim
- /verify/verify/matrix/inverse_matrix_mod_2_test.nim.html
title: verify/matrix/inverse_matrix_mod_2_test.nim
---
