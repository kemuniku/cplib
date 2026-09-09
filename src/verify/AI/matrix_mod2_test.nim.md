---
data:
  _extendedDependsOn: []
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


    import cplib/matrix/[matrix_mod2, static_matrix_mod2]

    import std/options


    var a = initMatrixMod2(@[@[1, 0, 1], @[0, 1, 1]])

    let b = initMatrixMod2(@[@[1, 0], @[0, 1], @[1, 1]])

    assert a.h == 2 and a.w == 3

    assert a * b == initMatrixMod2(@[@[0, 1], @[1, 0]])

    assert a.rank == 2

    a[0, 1] = true

    assert a[0, 1]

    a.setRowBits(0, "101")

    assert a.rowBits(0) == "101"

    assert a.rowBits(0, 2) == "10"


    let d = initMatrixMod2(@[@[1, 1, 0], @[1, 0, 1], @[0, 1, 1]])

    assert not d.determinant

    let e = initMatrixMod2(@[@[1, 1, 0], @[0, 1, 1], @[1, 1, 1]])

    assert e.determinant

    assert e.inverse.isSome

    assert e * e.inverse.get == identityMatrixMod2(3)


    let sa = initStaticMatrixMod2([[1, 0, 1], [0, 1, 1]])

    let sb = initStaticMatrixMod2([[1, 0], [0, 1], [1, 1]])

    assert sa.h == 2 and sa.w == 3

    assert sa * sb == initStaticMatrixMod2([[0, 1], [1, 0]])

    assert sa.rank == 2

    let se = initStaticMatrixMod2([[1, 1, 0], [0, 1, 1], [1, 1, 1]])

    assert se.determinant

    assert se.inverse.isSome

    assert se * se.inverse.get == identityStaticMatrixMod2[3]()


    # Cross the 64-bit word boundary in storage and elimination.

    var wide = initMatrixMod2(65, 65)

    for i in 0..<65: wide[i, i] = true

    wide[0, 64] = true

    wide[64, 1] = true

    assert wide.rank == 65

    assert wide.inverse.isSome

    assert wide * wide.inverse.get == identityMatrixMod2(65)


    let zeroWidthProduct = initMatrixMod2(40, 64) * initMatrixMod2(64, 0)

    assert zeroWidthProduct.h == 40 and zeroWidthProduct.w == 0

    '
  dependsOn: []
  isVerificationFile: true
  path: verify/AI/matrix_mod2_test.nim
  requiredBy: []
  timestamp: '2026-07-14 07:36:02+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/matrix_mod2_test.nim
layout: document
redirect_from:
- /verify/verify/AI/matrix_mod2_test.nim
- /verify/verify/AI/matrix_mod2_test.nim.html
title: verify/AI/matrix_mod2_test.nim
---
