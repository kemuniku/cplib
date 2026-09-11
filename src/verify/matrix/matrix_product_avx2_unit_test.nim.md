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
    path: cplib/matrix/field_matrix_ops.nim
    title: cplib/matrix/field_matrix_ops.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/field_matrix_ops.nim
    title: cplib/matrix/field_matrix_ops.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix.nim
    title: cplib/matrix/matrix.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix.nim
    title: cplib/matrix/matrix.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_product_avx2.nim
    title: cplib/matrix/matrix_product_avx2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_product_avx2.nim
    title: cplib/matrix/matrix_product_avx2.nim
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
    import random\nimport cplib/matrix/matrix_product_avx2\nimport cplib/matrix/matrix\n\
    import cplib/modint/modint\n\nconst moduli = [1u32, 3u32, 998244353u32, 1000000007u32,\
    \ 1073741823u32]\nvar rng = initRand(20260908)\n\nproc naiveProduct(a, b: openArray[uint32],\
    \ n, m, k: int,\n        modulus: uint32): seq[uint32] =\n    ## \u5404\u4E57\u7B97\
    \u306E\u76F4\u5F8C\u306B\u5270\u4F59\u3092\u53D6\u308A\u3001\u72EC\u7ACB\u3057\
    \u305F\u5358\u7D14\u5B9F\u88C5\u3067\u6B63\u89E3\u3092\u6C42\u3081\u308B\u3002\
    \n    result = newSeq[uint32](n * k)\n    for i in 0 ..< n:\n        for j in\
    \ 0 ..< k:\n            var value = 0u64\n            for l in 0 ..< m:\n    \
    \            value = (value + a[i * m + l].uint64 * b[l * k + j].uint64) mod\n\
    \                    modulus.uint64\n            result[i * k + j] = value.uint32\n\
    \nproc randomMatrix(rng: var Rand, n, m: int, modulus: uint32): seq[uint32] =\n\
    \    ## \u56FA\u5B9A\u30B7\u30FC\u30C9\u306E\u4E71\u6570\u3067\u3001\u6307\u5B9A\
    \u3057\u305F\u6CD5\u306E\u7BC4\u56F2\u5185\u306E\u884C\u5217\u3092\u751F\u6210\
    \u3059\u308B\u3002\n    result = newSeq[uint32](n * m)\n    for value in result.mitems:\n\
    \        value = rng.rand(0 .. (modulus - 1).int).uint32\n\nproc checkProduct(a,\
    \ b: openArray[uint32], n, m, k: int,\n        modulus: uint32, expected: openArray[uint32])\
    \ =\n    ## \u7A4D\u306E\u5024\u3068\u6B63\u898F\u5316\u3001\u5165\u529B\u914D\
    \u5217\u304C\u5909\u66F4\u3055\u308C\u306A\u3044\u3053\u3068\u3092\u78BA\u8A8D\
    \u3059\u308B\u3002\n    let beforeA = @a\n    let beforeB = @b\n    let actual\
    \ = matrixProduct(a, b, n, m, k, modulus)\n    doAssert actual.len == n * k\n\
    \    doAssert actual == @expected,\n        \"matrix product mismatch: \" & $n\
    \ & \" x \" & $m & \" x \" & $k &\n        \", modulus = \" & $modulus.int\n \
    \   for value in actual:\n        doAssert value < modulus\n    doAssert @a ==\
    \ beforeA\n    doAssert @b == beforeB\n\nproc checkNaive(a, b: openArray[uint32],\
    \ n, m, k: int, modulus: uint32) =\n    ## \u5358\u7D14\u5B9F\u88C5\u3068\u6BD4\
    \u8F03\u3057\u3066\u3001\u4E00\u822C\u306E\u9577\u65B9\u5F62\u884C\u5217\u306E\
    \u7A4D\u3092\u78BA\u8A8D\u3059\u308B\u3002\n    checkProduct(a, b, n, m, k, modulus,\
    \ naiveProduct(a, b, n, m, k, modulus))\n\nproc checkBoundary(size: int, modulus:\
    \ uint32, rng: var Rand) =\n    ## \u5883\u754C\u30B5\u30A4\u30BA\u306E\u5BC6\u884C\
    \u5217\u3092\u3001\u5168\u8981\u7D20\u4E00\u5B9A\u30FB\u7F6E\u63DB\u30FB\u968E\
    \u65701\u306E\u7A4D\u3067\u691C\u8A3C\u3059\u308B\u3002\n    var constant = newSeq[uint32](size\
    \ * size)\n    for value in constant.mitems:\n        value = modulus - 1\n  \
    \  var expected = newSeq[uint32](size * size)\n    for value in expected.mitems:\n\
    \        value = (size.uint64 mod modulus.uint64).uint32\n    checkProduct(constant,\
    \ constant, size, size, size, modulus, expected)\n\n    let dense = randomMatrix(rng,\
    \ size, size, modulus)\n    var permutation = newSeq[uint32](size * size)\n  \
    \  for i in 0 ..< size:\n        permutation[i * size + (i + 1) mod size] = 1u32\
    \ mod modulus\n    for i in 0 ..< size:\n        for j in 0 ..< size:\n      \
    \      expected[i * size + j] = dense[i * size + (j + size - 1) mod size]\n  \
    \  checkProduct(dense, permutation, size, size, size, modulus, expected)\n   \
    \ for i in 0 ..< size:\n        for j in 0 ..< size:\n            expected[i *\
    \ size + j] = dense[((i + 1) mod size) * size + j]\n    checkProduct(permutation,\
    \ dense, size, size, size, modulus, expected)\n\n    let x = randomMatrix(rng,\
    \ size, 1, modulus)\n    let y = randomMatrix(rng, size, 1, modulus)\n    let\
    \ z = randomMatrix(rng, size, 1, modulus)\n    let w = randomMatrix(rng, size,\
    \ 1, modulus)\n    var a = newSeq[uint32](size * size)\n    var b = newSeq[uint32](size\
    \ * size)\n    var dot = 0u64\n    for l in 0 ..< size:\n        dot = (dot +\
    \ y[l].uint64 * z[l].uint64) mod modulus.uint64\n    for i in 0 ..< size:\n  \
    \      for j in 0 ..< size:\n            a[i * size + j] = (x[i].uint64 * y[j].uint64\
    \ mod modulus.uint64).uint32\n            b[i * size + j] = (z[i].uint64 * w[j].uint64\
    \ mod modulus.uint64).uint32\n            expected[i * size + j] =\n         \
    \       (x[i].uint64 * dot mod modulus.uint64 * w[j].uint64 mod modulus.uint64).uint32\n\
    \    checkProduct(a, b, size, size, size, modulus, expected)\n\nproc checkModintValues[T](actual,\
    \ expected: Matrix[T]) =\n    ## Montgomery\u306E\u5197\u9577\u306A\u5185\u90E8\
    \u8868\u73FE\u3092\u8A31\u3057\u3001\u5404\u8981\u7D20\u306E\u516C\u958B\u5024\
    \u3067\u7B49\u4FA1\u6027\u3092\u78BA\u8A8D\u3059\u308B\u3002\n    doAssert actual.h\
    \ == expected.h and actual.w == expected.w\n    for i in 0 ..< actual.h:\n   \
    \     for j in 0 ..< actual.w:\n            doAssert actual[i, j].val == expected[i,\
    \ j].val\n\nproc checkModint[T]() =\n    ## modint\u306E\u5185\u90E8\u8868\u73FE\
    \u3068\u8CA0\u6570\u306E\u6B63\u898F\u5316\u3092\u3001\u65E2\u5B58\u306E\u884C\
    \u5217\u7A4D\u3068\u6BD4\u8F03\u3057\u3066\u691C\u8A3C\u3059\u308B\u3002\n   \
    \ var a = initMatrix(3, 5, T.init(0))\n    var b = initMatrix(5, 2, T.init(0))\n\
    \    for i in 0 ..< a.h:\n        for j in 0 ..< a.w:\n            a[i, j] = T.init((i\
    \ + 1) * (j - 3))\n            a[i, j] += T.init(T.umod.int - 1)\n    for i in\
    \ 0 ..< b.h:\n        for j in 0 ..< b.w:\n            b[i, j] = T.init(i * 29\
    \ - j * 17)\n            b[i, j] -= T.init(T.umod.int - 1)\n    let beforeA =\
    \ $a\n    let beforeB = $b\n    checkModintValues(matrixProduct(a, b), a * b)\n\
    \    doAssert $a == beforeA\n    doAssert $b == beforeB\n    var square = initMatrix(5,\
    \ 5, T.init(0))\n    for i in 0 ..< 5:\n        for j in 0 ..< 5:\n          \
    \  square[i, j] = T.init(i * 7 - j * 13)\n    checkModintValues(matrixProduct(square,\
    \ square), square * square)\n    let empty = initMatrix(0, 0, T.init(0))\n   \
    \ doAssert matrixProduct(empty, empty) == empty\n    let noColumns = initMatrix(3,\
    \ 0, T.init(0))\n    doAssert matrixProduct(noColumns, empty) == noColumns\n\n\
    template expectAssertion(body: untyped) =\n    ## \u4E0D\u6B63\u306A\u5F15\u6570\
    \u304C AssertionDefect \u3067\u62D2\u5426\u3055\u308C\u308B\u3053\u3068\u3092\u78BA\
    \u8A8D\u3059\u308B\u3002\n    block:\n        var caught = false\n        try:\n\
    \            body\n        except AssertionDefect:\n            caught = true\n\
    \        doAssert caught, \"invalid argument was accepted\"\n\nfor modulus in\
    \ moduli:\n    for dimensions in [(0, 0, 0), (0, 3, 5), (4, 0, 5), (3, 4, 0),\n\
    \            (1, 1, 1), (1, 4097, 3), (3, 4097, 1), (3, 1, 4097),\n          \
    \  (4097, 1, 3), (1, 257, 129), (129, 257, 1), (7, 65, 131),\n            (65,\
    \ 7, 131), (65, 131, 7)]:\n        let (n, m, k) = dimensions\n        let a =\
    \ randomMatrix(rng, n, m, modulus)\n        let b = randomMatrix(rng, m, k, modulus)\n\
    \        checkNaive(a, b, n, m, k, modulus)\n\n    for iteration in 0 ..< 60:\n\
    \        let n = rng.rand(0 .. 18)\n        let m = rng.rand(0 .. 18)\n      \
    \  let k = rng.rand(0 .. 18)\n        let a = randomMatrix(rng, n, m, modulus)\n\
    \        let b = randomMatrix(rng, m, k, modulus)\n        checkNaive(a, b, n,\
    \ m, k, modulus)\n\n    for size in [1, 7, 17, 65, 129]:\n        let a = randomMatrix(rng,\
    \ size, size, modulus)\n        checkNaive(a, a, size, size, size, modulus)\n\n\
    \    for size in [63, 64, 65, 127, 128, 129, 255, 256, 257]:\n        checkBoundary(size,\
    \ modulus, rng)\n\n    let a = @[0u32, 1u32 mod modulus, modulus - 1,\n      \
    \  modulus - 1, 0u32, 1u32 mod modulus]\n    let b = @[modulus - 1, 1u32 mod modulus,\
    \ 0u32,\n        modulus - 1, 1u32 mod modulus, 0u32]\n    checkNaive(a, b, 2,\
    \ 3, 2, modulus)\n    let rowsA = @[a[0 .. 2], a[3 .. 5]]\n    let rowsB = @[b[0\
    \ .. 1], b[2 .. 3], b[4 .. 5]]\n    let actual = matrixProduct(rowsA, rowsB, modulus)\n\
    \    let expected = naiveProduct(a, b, 2, 3, 2, modulus)\n    doAssert actual\
    \ == @[expected[0 .. 1], expected[2 .. 3]]\n    doAssert rowsA == @[a[0 .. 2],\
    \ a[3 .. 5]]\n    doAssert rowsB == @[b[0 .. 1], b[2 .. 3], b[4 .. 5]]\n\nlet\
    \ empty = newSeq[uint32]()\nlet emptyRows = newSeq[seq[uint32]]()\ndoAssert matrixProduct(emptyRows,\
    \ emptyRows) == emptyRows\ndoAssert matrixProduct(@[empty, empty], emptyRows)\
    \ == @[empty, empty]\ndoAssert matrixProduct(@[@[1u32, 2u32]], @[empty, empty])\
    \ == @[empty]\ndoAssert matrixProduct(@[2u32], @[3u32], 1, 1, 1) == @[6u32]\n\
    doAssert matrixProduct(@[@[2u32]], @[@[3u32]]) == @[@[6u32]]\n\nfor modulus in\
    \ [0u32, 2u32, 4u32, 1u32 shl 30, (1u32 shl 30) + 1, high(uint32)]:\n    expectAssertion:\n\
    \        discard matrixProduct(empty, empty, 0, 0, 0, modulus)\n    expectAssertion:\n\
    \        discard matrixProduct(emptyRows, emptyRows, modulus)\n\nfor dimensions\
    \ in [(-1, 0, 0), (0, -1, 0), (0, 0, -1), (1, 1, 0), (0, 1, 1)]:\n    let (n,\
    \ m, k) = dimensions\n    expectAssertion:\n        discard matrixProduct(empty,\
    \ empty, n, m, k)\nexpectAssertion:\n    discard matrixProduct(@[1u32], @[1u32],\
    \ 2, 1, 1)\nexpectAssertion:\n    discard matrixProduct(@[1u32], @[1u32, 2u32],\
    \ 1, 1, 1)\nexpectAssertion:\n    discard matrixProduct(empty, empty, high(int),\
    \ 2, 2)\nexpectAssertion:\n    discard matrixProduct(@[@[1u32], @[2u32, 3u32]],\
    \ @[@[1u32]])\nexpectAssertion:\n    discard matrixProduct(@[@[1u32, 2u32]], @[@[1u32],\
    \ @[2u32, 3u32]])\nexpectAssertion:\n    discard matrixProduct(@[@[1u32]], emptyRows)\n\
    expectAssertion:\n    discard matrixProduct(emptyRows, @[@[1u32]])\n\nwhen compileOption(\"\
    assertions\"):\n    expectAssertion:\n        discard matrixProduct(@[3u32], @[0u32],\
    \ 1, 1, 1, 3u32)\n    expectAssertion:\n        discard matrixProduct(@[0u32],\
    \ @[3u32], 1, 1, 1, 3u32)\n\ncheckModint[modint998244353_montgomery]()\ncheckModint[modint1000000007_montgomery]()\n\
    checkModint[modint998244353_barrett]()\ncheckModint[modint1000000007_barrett]()\n\
    for modulus in moduli:\n    modint_montgomery.setMod(modulus.int)\n    modint_barrett.setMod(modulus.int)\n\
    \    checkModint[modint_montgomery]()\n    checkModint[modint_barrett]()\n\necho\
    \ \"Hello World\"\n"
  dependsOn:
  - cplib/matrix/field_matrix_ops.nim
  - cplib/matrix/matrix.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/matrix/field_matrix_ops.nim
  - cplib/math/isqrt.nim
  - cplib/matrix/matrix.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  - cplib/matrix/matrix_product_avx2.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  - cplib/modint/barrett_impl.nim
  - cplib/matrix/matrix_product_avx2.nim
  isVerificationFile: true
  path: verify/matrix/matrix_product_avx2_unit_test.nim
  requiredBy: []
  timestamp: '2026-09-10 08:33:37+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/matrix/matrix_product_avx2_unit_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/matrix_product_avx2_unit_test.nim
- /verify/verify/matrix/matrix_product_avx2_unit_test.nim.html
title: verify/matrix/matrix_product_avx2_unit_test.nim
---
