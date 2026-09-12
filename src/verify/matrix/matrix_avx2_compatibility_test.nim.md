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
    import cplib/modint/modint\nimport cplib/matrix/matrix as legacy\nimport cplib/matrix/matrix_avx2\
    \ as fast\n\nproc checkCompatibility[T]() =\n    ## \u95A2\u6570API\u3068\u65B0\
    \u65E7Matrix\u3092\u540C\u6642\u306Bimport\u3057\u3066\u3082\u540D\u524D\u89E3\
    \u6C7A\u3067\u304D\u308B\u3053\u3068\u3092\u78BA\u8A8D\u3059\u308B\u3002\n   \
    \ let rows = @[@[T.init(1), T.init(2)], @[T.init(3), T.init(4)]]\n    let oldMatrix\
    \ = legacy.initMatrix(rows)\n    let newMatrix = fast.initMatrix(rows)\n    let\
    \ oldProduct = fast.matrixProduct(oldMatrix, oldMatrix)\n    let oldProductExplicit\
    \ = fast.matrixProduct[T](oldMatrix, oldMatrix)\n    let newProduct = fast.matrixProduct(newMatrix,\
    \ newMatrix)\n    let newProductExplicit = fast.matrixProduct[T](newMatrix, newMatrix)\n\
    \    for i in 0 ..< 2:\n        for j in 0 ..< 2:\n            doAssert oldProduct[i,\
    \ j].val == newProduct[i, j].val\n            doAssert oldProductExplicit[i, j].val\
    \ == oldProduct[i, j].val\n    doAssert newProductExplicit == newProduct\n   \
    \ doAssert fast.toMatrix(rows) == newMatrix\n    doAssert fast.initMatrix[T](2,\
    \ 2, 1)[0, 0].val == 1\n    doAssert fast.initMatrix(@[T.init(1), T.init(2)],\
    \ true).h == 2\n    doAssert fast.identity_matrix[T](2) * newMatrix == newMatrix\n\
    \    doAssert newMatrix.pow(2) == newProduct\n    doAssert (5 - newMatrix)[0,\
    \ 0].val == 4\n\nproc checkLegacyShapes[T]() =\n    ## \u5F93\u6765\u306EMatrix\u3078\
    \u306E\u7D50\u679C\u5FA9\u5143\u304C\u77E9\u5F62\u3068\u7A7A\u884C\u5217\u306B\
    \u5BFE\u5FDC\u3057\u3001\u5165\u529B\u3092\u5909\u66F4\u3057\u306A\u3044\u3053\
    \u3068\u3092\u78BA\u8A8D\u3059\u308B\u3002\n    let a = legacy.initMatrix(@[\n\
    \        @[T.init(1), T.init(2), T.init(3)],\n        @[T.init(4), T.init(5),\
    \ T.init(6)]])\n    let b = legacy.initMatrix(@[\n        @[T.init(7), T.init(8),\
    \ T.init(9), T.init(10)],\n        @[T.init(11), T.init(12), T.init(13), T.init(14)],\n\
    \        @[T.init(15), T.init(16), T.init(17), T.init(18)]])\n    let savedA =\
    \ a\n    let savedB = b\n    var c = fast.matrixProduct(a, b)\n    let expected\
    \ = [[74, 80, 86, 92], [173, 188, 203, 218]]\n    doAssert c.h == 2 and c.w ==\
    \ 4\n    for i in 0 ..< c.h:\n        for j in 0 ..< c.w:\n            doAssert\
    \ c[i, j].val == expected[i][j]\n    doAssert a == savedA and b == savedB\n  \
    \  c[0, 0] = T.init(99)\n    doAssert a == savedA and b == savedB\n    for i in\
    \ 0 ..< a.h:\n        for j in 0 ..< a.w:\n            doAssert a[i, j].val ==\
    \ 1 + i * 3 + j\n    for i in 0 ..< b.h:\n        for j in 0 ..< b.w:\n      \
    \      doAssert b[i, j].val == 7 + i * 4 + j\n    for shape in [(0, 0, 0), (4,\
    \ 0, 0), (3, 2, 0), (0, 3, 4), (2, 0, 5)]:\n        let (h, w, k) = shape\n  \
    \      let emptyA = legacy.initMatrix[T](h, w, T.init(0))\n        let emptyB\
    \ = legacy.initMatrix[T](w, k, T.init(0))\n        let emptyC = fast.matrixProduct(emptyA,\
    \ emptyB)\n        doAssert emptyC.h == h and emptyC.w == k\n\ncheckCompatibility[modint998244353_montgomery]()\n\
    checkCompatibility[modint1000000007_barrett]()\ncheckLegacyShapes[modint998244353_montgomery]()\n\
    checkLegacyShapes[modint1000000007_barrett]()\ndoAssert fast.matrixProduct(@[2u32],\
    \ @[2u32], 1, 1, 1) == @[4u32]\ndoAssert fast.matrixProduct(@[@[2u32]], @[@[2u32]])\
    \ == @[@[4u32]]\necho \"Hello World\"\n"
  dependsOn:
  - cplib/math/isqrt.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/barrett_impl.nim
  isVerificationFile: true
  path: verify/matrix/matrix_avx2_compatibility_test.nim
  requiredBy: []
  timestamp: '2026-09-10 06:38:45+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/matrix/matrix_avx2_compatibility_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/matrix_avx2_compatibility_test.nim
- /verify/verify/matrix/matrix_avx2_compatibility_test.nim.html
title: verify/matrix/matrix_avx2_compatibility_test.nim
---
