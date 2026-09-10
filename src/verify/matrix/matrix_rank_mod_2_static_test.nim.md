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
    PROBLEM: https://judge.yosupo.jp/problem/matrix_rank_mod_2
    links:
    - https://judge.yosupo.jp/problem/matrix_rank_mod_2
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/matrix_rank_mod_2\n\
    {.checks: off.}\nimport cplib/matrix/static_matrix_mod2\nimport strutils, sequtils\n\
    \nconst\n    MaxCellCount = 1 shl 24\n    MaxStaticCellCount = 2 * MaxCellCount\n\
    \nproc solve[H: static int, W: static int](n: int) =\n    var a: ref StaticMatrixMod2[H,\
    \ W]\n    new a\n    for i in 0..<n:\n        a[].setRowBits(i, stdin.readLine)\n\
    \    echo a[].rank\n\nproc selectWidth[H: static int, W: static int](n, m: int)\
    \ =\n    if m <= W:\n        solve[H, W](n)\n    else:\n        when H * W < MaxStaticCellCount:\n\
    \            selectWidth[H, 2 * W](n, m)\n        else:\n            raise newException(ValueError,\
    \ \"matrix is too large\")\n\nproc selectHeight[H: static int](n, m: int) =\n\
    \    if n <= H:\n        selectWidth[H, 1](n, m)\n    else:\n        when H <\
    \ MaxCellCount:\n            selectHeight[2 * H](n, m)\n        else:\n      \
    \      raise newException(ValueError, \"matrix is too large\")\n\nlet nm = stdin.readLine.split.map(parseInt)\n\
    if nm[0] == 0 or nm[1] == 0:\n    echo 0\n    quit(0)\nselectHeight[1](nm[0],\
    \ nm[1])\n"
  dependsOn:
  - cplib/matrix/field_matrix_ops.nim
  - cplib/matrix/bit_matrix_ops.nim
  - cplib/matrix/static_matrix_mod2.nim
  - cplib/matrix/field_matrix_ops.nim
  - cplib/matrix/bit_matrix_ops.nim
  - cplib/matrix/static_matrix_mod2.nim
  isVerificationFile: true
  path: verify/matrix/matrix_rank_mod_2_static_test.nim
  requiredBy: []
  timestamp: '2026-09-10 08:33:37+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/matrix/matrix_rank_mod_2_static_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/matrix_rank_mod_2_static_test.nim
- /verify/verify/matrix/matrix_rank_mod_2_static_test.nim.html
title: verify/matrix/matrix_rank_mod_2_static_test.nim
---
