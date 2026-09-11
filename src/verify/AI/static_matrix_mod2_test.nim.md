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
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

    echo "Hello World"


    import cplib/matrix/static_matrix_mod2

    import options


    var a = initStaticMatrixMod2([[1, 0, 1], [0, 1, 1]])

    let b = toStaticMatrixMod2([[1, 0], [0, 1], [1, 1]])

    assert a.h == 2 and a.w == 3

    assert a[0, 2]

    a[0, 1] = true

    assert a == initStaticMatrixMod2([[1, 1, 1], [0, 1, 1]])

    a[0, 1] = 0

    assert $a == "1 0 1\n0 1 1"

    assert a.rowBits(0) == "101"

    a.setRowBits(0, "011")

    assert a.rowBits(0) == "011"

    a.setRowBits(0, "101")

    assert a.transposed == initStaticMatrixMod2([[1, 0], [0, 1], [1, 1]])

    assert a * b == initStaticMatrixMod2([[0, 1], [1, 0]])


    let boolMatrix = initStaticMatrixMod2([[true, false], [true, true]])

    assert boolMatrix == initStaticMatrixMod2([[1, 0], [1, 1]])

    assert boolMatrix.pow(0) == identityStaticMatrixMod2[2]()

    assert boolMatrix ** 2 == initStaticMatrixMod2([[1, 0], [0, 1]])


    let singular = initStaticMatrixMod2([[1, 1], [1, 1]])

    assert singular.rank == 1

    assert not singular.determinant

    assert singular.inverse.isNone


    let invertible = initStaticMatrixMod2([[1, 1, 0], [0, 1, 1], [1, 1, 1]])

    assert invertible.rank == 3

    assert invertible.determinant

    assert invertible.inverse.isSome

    assert invertible * invertible.inverse.get == identityStaticMatrixMod2[3]()


    # Cross the uint64 word boundary in storage, multiplication, and elimination.

    var wide = initStaticMatrixMod2[65, 65]()

    for i in 0..<65: wide[i, i] = true

    wide[0, 64] = true

    wide[64, 1] = true

    assert wide.rank == 65

    assert wide.inverse.isSome

    assert wide * wide.inverse.get == identityStaticMatrixMod2[65]()


    assert initStaticMatrixMod2[0, 0]().rank == 0

    assert initStaticMatrixMod2[0, 1 shl 24]().rank == 0

    assert initStaticMatrixMod2[1000, 0]().rank == 0

    '
  dependsOn:
  - cplib/matrix/static_matrix_mod2.nim
  - cplib/matrix/bit_matrix_ops.nim
  - cplib/matrix/field_matrix_ops.nim
  - cplib/matrix/bit_matrix_ops.nim
  - cplib/matrix/field_matrix_ops.nim
  - cplib/matrix/static_matrix_mod2.nim
  isVerificationFile: true
  path: verify/AI/static_matrix_mod2_test.nim
  requiredBy: []
  timestamp: '2026-09-10 08:33:37+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/static_matrix_mod2_test.nim
layout: document
redirect_from:
- /verify/verify/AI/static_matrix_mod2_test.nim
- /verify/verify/AI/static_matrix_mod2_test.nim.html
title: verify/AI/static_matrix_mod2_test.nim
---
