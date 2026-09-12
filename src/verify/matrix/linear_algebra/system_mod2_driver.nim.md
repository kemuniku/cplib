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
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/static_matrix_mod2.nim
    title: cplib/matrix/static_matrix_mod2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/static_matrix_mod2.nim
    title: cplib/matrix/static_matrix_mod2.nim
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
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "include cplib/tmpl/fastio\nimport options\nwhen defined(testStaticMatrixMod2):\n\
    \    import cplib/matrix/static_matrix_mod2\nelse:\n    import cplib/matrix/matrix_mod2\n\
    \nproc bits(values: seq[bool]): string =\n    result = newString(values.len)\n\
    \    for i, value in values: result[i] = char(ord('0') + int(value))\n\nlet n\
    \ = input(int)\nlet m = input(int)\nwhen defined(testStaticMatrixMod2):\n    var\
    \ storage: ref StaticMatrixMod2[4096, 4096]\n    new storage\n    template a:\
    \ untyped = storage[]\nelse:\n    var a = initMatrixMod2(n, m)\nfor i in 0..<n:\n\
    \    a.setRowBits(i, input(string))\nlet rhs = input(string)\nvar b = newSeq[bool](n)\n\
    for i in 0..<n: b[i] = rhs[i] == '1'\nwhen defined(testStaticMatrixMod2):\n  \
    \  let answer = a.solveLinearSystem(b, n, m)\nelse:\n    let answer = a.solveLinearSystem(b)\n\
    if answer.isNone:\n    print -1\nelse:\n    let solution = answer.get\n    print\
    \ solution.basis.len\n    print bits(solution.particular)\n    for vector in solution.basis:\
    \ print bits(vector)\n"
  dependsOn:
  - cplib/matrix/static_matrix_mod2.nim
  - cplib/matrix/bit_matrix_ops.nim
  - cplib/matrix/field_matrix_ops.nim
  - cplib/matrix/matrix_mod2.nim
  - cplib/tmpl/fastio.nim
  - cplib/matrix/bit_matrix_ops.nim
  - cplib/matrix/static_matrix_mod2.nim
  - cplib/matrix/matrix_mod2.nim
  - cplib/tmpl/fastio.nim
  - cplib/matrix/field_matrix_ops.nim
  isVerificationFile: false
  path: verify/matrix/linear_algebra/system_mod2_driver.nim
  requiredBy: []
  timestamp: '2026-09-10 08:33:37+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/matrix/linear_algebra/system_mod2_driver.nim
layout: document
redirect_from:
- /library/verify/matrix/linear_algebra/system_mod2_driver.nim
- /library/verify/matrix/linear_algebra/system_mod2_driver.nim.html
title: verify/matrix/linear_algebra/system_mod2_driver.nim
---
