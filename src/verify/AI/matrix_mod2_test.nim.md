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
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    echo \"Hello World\"\n\nimport cplib/matrix/[matrix_mod2, static_matrix_mod2]\n\
    import std/options\n\nvar a = initMatrixMod2(@[@[1, 0, 1], @[0, 1, 1]])\nlet b\
    \ = initMatrixMod2(@[@[1, 0], @[0, 1], @[1, 1]])\nassert a.h == 2 and a.w == 3\n\
    assert a * b == initMatrixMod2(@[@[0, 1], @[1, 0]])\nassert a.rank == 2\na[0,\
    \ 1] = true\nassert a[0, 1]\na.setRowBits(0, \"101\")\nassert a.rowBits(0) ==\
    \ \"101\"\nassert a.rowBits(0, 2) == \"10\"\n\nlet d = initMatrixMod2(@[@[1, 1,\
    \ 0], @[1, 0, 1], @[0, 1, 1]])\nassert not d.determinant\nlet e = initMatrixMod2(@[@[1,\
    \ 1, 0], @[0, 1, 1], @[1, 1, 1]])\nassert e.determinant\nassert e.inverse.isSome\n\
    assert e * e.inverse.get == identityMatrixMod2(3)\n\nlet sa = initStaticMatrixMod2([[1,\
    \ 0, 1], [0, 1, 1]])\nlet sb = initStaticMatrixMod2([[1, 0], [0, 1], [1, 1]])\n\
    assert sa.h == 2 and sa.w == 3\nassert sa * sb == initStaticMatrixMod2([[0, 1],\
    \ [1, 0]])\nassert sa.rank == 2\nlet se = initStaticMatrixMod2([[1, 1, 0], [0,\
    \ 1, 1], [1, 1, 1]])\nassert se.determinant\nassert se.inverse.isSome\nassert\
    \ se * se.inverse.get == identityStaticMatrixMod2[3]()\n\n# Cross the 64-bit word\
    \ boundary in storage and elimination.\nvar wide = initMatrixMod2(65, 65)\nfor\
    \ i in 0..<65: wide[i, i] = true\nwide[0, 64] = true\nwide[64, 1] = true\nassert\
    \ wide.rank == 65\nassert wide.inverse.isSome\nassert wide * wide.inverse.get\
    \ == identityMatrixMod2(65)\n\nlet zeroWidthProduct = initMatrixMod2(40, 64) *\
    \ initMatrixMod2(64, 0)\nassert zeroWidthProduct.h == 40 and zeroWidthProduct.w\
    \ == 0\n\nassert initMatrixMod2(0, 0).rank == 0\nassert initMatrixMod2(0, 1 shl\
    \ 24).rank == 0\nassert initMatrixMod2(1000, 0).rank == 0\n\nimport random, strutils\n\
    var rng = initRand(401279)\nfor (h, m, w) in [(3, 65, 7), (39, 64, 65), (40, 64,\
    \ 65), (41, 73, 129)]:\n    var left = initMatrixMod2(h, m)\n    var right = initMatrixMod2(m,\
    \ w)\n    for i in 0..<h:\n        for j in 0..<m: left[i, j] = rng.rand(1) ==\
    \ 1\n    for i in 0..<m:\n        for j in 0..<w: right[i, j] = rng.rand(1) ==\
    \ 1\n    let savedLeft = left\n    let savedRight = right\n    let product = left\
    \ * right\n    for i in 0..<h:\n        for j in 0..<w:\n            var expected\
    \ = false\n            for k in 0..<m: expected = expected xor (left[i, k] and\
    \ right[k, j])\n            assert product[i, j] == expected\n    assert left\
    \ == savedLeft and right == savedRight\n    var copied = left\n    copied.setRowBits(0,\
    \ \"1\")\n    assert copied.rowBits(0) == \"1\" & repeat('0', m - 1)\n    assert\
    \ left == savedLeft\n    assert copied.rowBits(1) == left.rowBits(1)\n\nblock:\n\
    \    const N = 1 shl 24\n    var tall = initMatrixMod2(N, 1)\n    tall[N-1, 0]\
    \ = true\n    assert tall.rank == 1\n    assert tall[N-1, 0] and not tall[0, 0]\n\
    \nfor n in [0, 1, 2, 63, 64, 65, 127, 128, 129]:\n    var a = identityMatrixMod2(n)\n\
    \    for i in 0..<n:\n        for j in 0..<i:\n            if rng.rand(1) == 1:\n\
    \                for k in 0..<n: a[i,k] = a[i,k] xor a[j,k]\n    for i in 0..<n\
    \ div 2:\n        let other = n-1-i\n        for j in 0..<n:\n            let\
    \ value = a[i,j]\n            a[i,j] = a[other,j]\n            a[other,j] = value\n\
    \    let before = a\n    let inverse = a.inverse\n    assert inverse.isSome\n\
    \    assert a * inverse.get == identityMatrixMod2(n)\n    assert inverse.get *\
    \ a == identityMatrixMod2(n)\n    assert inverse.get.inverse.get == a\n    assert\
    \ a == before\n    if n > 0:\n        a.setRowBits(n-1, \"\")\n        assert\
    \ a.inverse.isNone\n"
  dependsOn: []
  isVerificationFile: true
  path: verify/AI/matrix_mod2_test.nim
  requiredBy: []
  timestamp: '2026-09-10 08:33:37+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/matrix_mod2_test.nim
layout: document
redirect_from:
- /verify/verify/AI/matrix_mod2_test.nim
- /verify/verify/AI/matrix_mod2_test.nim.html
title: verify/AI/matrix_mod2_test.nim
---
