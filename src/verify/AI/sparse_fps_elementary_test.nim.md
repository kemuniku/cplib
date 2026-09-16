---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/bostan_mori.nim
    title: cplib/fps/bostan_mori.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/bostan_mori.nim
    title: cplib/fps/bostan_mori.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/formal_power_series.nim
    title: cplib/fps/formal_power_series.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/formal_power_series.nim
    title: cplib/fps/formal_power_series.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/product_tree.nim
    title: cplib/fps/product_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/product_tree.nim
    title: cplib/fps/product_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/sparse_formal_power_series.nim
    title: cplib/fps/sparse_formal_power_series.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/sparse_formal_power_series.nim
    title: cplib/fps/sparse_formal_power_series.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
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
    import options, random\nimport cplib/fps/sparse_formal_power_series\nimport cplib/fps/formal_power_series\n\
    import cplib/modint/modint\n\nvar rng = initRand(20260916)\n\nproc same[T](a,\
    \ b: seq[T]): bool =\n  if a.len != b.len: return false\n  for i in 0..<a.len:\n\
    \    if a[i].val != b[i].val: return false\n  true\n\nproc naiveProduct[T](a,\
    \ b: seq[T], n: int): seq[T] =\n  result = newSeq[T](n)\n  for i in 0..<min(a.len,\
    \ n):\n    for j in 0..<min(b.len, n - i): result[i + j] += a[i] * b[j]\n\nproc\
    \ naiveInverse[T](f: seq[T], n: int): seq[T] =\n  result = newSeq[T](n)\n  if\
    \ n == 0: return\n  result[0] = f[0].inv\n  for i in 1..<n:\n    for j in 1..min(i,\
    \ f.len - 1): result[i] -= f[j] * result[i - j]\n    result[i] *= result[0]\n\n\
    proc naiveExp[T](f: seq[T], n: int): seq[T] =\n  result = newSeq[T](n)\n  if n\
    \ == 0: return\n  result[0] = init(T, 1)\n  for i in 1..<n:\n    for j in 1..min(i,\
    \ f.len - 1): result[i] += f[j] * j * result[i - j]\n    result[i] /= i\n\nproc\
    \ check[T: BarrettModint or MontgomeryModint](n: int) =\n  for count in [0, 1,\
    \ 8]:\n    var terms: seq[SparseTerm[T]]\n    for j in 0..<count:\n      terms.add((1\
    \ + rng.rand(n + 10), init(T, rng.rand(T.umod.int - 1))))\n    let f = initSparseFPS[T](terms)\n\
    \    let original = f\n    let dense = f.toDense(n)\n    doAssert same(f.exp(n),\
    \ naiveExp(dense, n))\n    let unit = f + 1\n    let denseUnit = unit.toDense(n)\n\
    \    doAssert same(unit.log(n), denseUnit.log(n))\n    var numerator = newSeq[T](max(n\
    \ - 5, 0))\n    for i in 0..<numerator.len: numerator[i] = init(T, rng.rand(T.umod.int\
    \ - 1))\n    for constant in [1, 3]:\n      let denominator = f + constant\n \
    \     let expectedInverse = naiveInverse(denominator.toDense(max(n, 1)), n)\n\
    \      doAssert same(denominator.inv(n), expectedInverse)\n      doAssert same(numerator.divPrefix(denominator,\
    \ n),\n        naiveProduct(numerator, expectedInverse, n))\n    for shift in\
    \ [0, 1, 2, n + 1]:\n      var shiftedTerms: seq[SparseTerm[T]]\n      for term\
    \ in f + 4:\n        shiftedTerms.add((term.degree + shift, term.coefficient))\n\
    \      let shifted = initSparseFPS[T](shiftedTerms)\n      let shiftedDense =\
    \ shifted.toDense(n)\n      var expected = newSeq[T](n)\n      if n > 0: expected[0]\
    \ = init(T, 1)\n      for k in 0..4:\n        doAssert same(shifted.pow(k, n),\
    \ expected)\n        expected = naiveProduct(expected, shiftedDense, n)\n    \
    \  let root = shifted.sqrt(n)\n      if shift < n and shift mod 2 == 1:\n    \
    \    doAssert root.isNone\n      else:\n        doAssert root.isSome\n       \
    \ doAssert same(naiveProduct(root.get, root.get, n), shiftedDense)\n    doAssert\
    \ same(unit.pow(T.umod.int, n), denseUnit.pow(T.umod.int, n))\n    doAssert f\
    \ == original\n  doAssert initSparseFPS[T]([(0, init(T, 1)), (1, init(T, 2))]).inv(300).len\
    \ == 300\n\nproc checkSizes[T: BarrettModint or MontgomeryModint]() =\n  for n\
    \ in [0, 1, 2, 3, 17, 31, 32, 63, 64, 65, 129, 257]: check[T](n)\n\ncheckSizes[modint998244353_barrett]()\n\
    checkSizes[modint998244353_montgomery]()\ncheckSizes[modint1000000007_barrett]()\n\
    checkSizes[modint1000000007_montgomery]()\nfor modulus in [998244353, 1000000007,\
    \ 17, 257, 998244353]:\n  modint_barrett.setMod(modulus)\n  modint_montgomery.setMod(modulus)\n\
    \  for n in [1, min(modulus, 65), min(modulus, 129)]:\n    check[modint_barrett](n)\n\
    \    check[modint_montgomery](n)\n  if modulus <= 257:\n    check[modint_barrett](modulus)\n\
    \    check[modint_montgomery](modulus)\n\nblock longSeries:\n  type M = modint998244353_barrett\n\
    \  let unit = sfps[M](1 + 3*x + 7*x^17 + 11*x^1000 + 13*x^8192)\n  let exponent\
    \ = sfps[M](3*x + 7*x^17 + 11*x^1000 + 13*x^8192)\n  for n in [1024, 4097]:\n\
    \    let dense = unit.toDense(n)\n    doAssert same(unit.inv(n), dense.inv(n))\n\
    \    doAssert same(unit.log(n), dense.log(n))\n    doAssert same(exponent.exp(n),\
    \ exponent.toDense(n).exp(n))\n    doAssert same(unit.pow(1234567, n), dense.pow(1234567,\
    \ n))\n    let root = unit.sqrt(n)\n    doAssert root.isSome\n    doAssert same(prefix(root.get\
    \ * root.get, n), dense)\n  doAssert sfps[M](3 + x^5).sqrt(20).isNone\n\nblock\
    \ compositeInverse:\n  type M = StaticBarrettModint[35u32]\n  let f = sfps[M](2\
    \ + 3*x + 5*x^11)\n  doAssert same(f.inv(80), naiveInverse(f.toDense(80), 80))\n\
    \necho \"Hello World\"\n"
  dependsOn:
  - cplib/modint/barrett_impl.nim
  - cplib/math/isprime.nim
  - cplib/fps/formal_power_series.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/convolution/convolution.nim
  - cplib/math/isqrt.nim
  - cplib/convolution/convolution.nim
  - cplib/math/inv_gcd.nim
  - cplib/fps/formal_power_series.nim
  - cplib/modint/modint.nim
  - cplib/fps/bostan_mori.nim
  - cplib/fps/product_tree.nim
  - cplib/math/isprime.nim
  - cplib/fps/sparse_formal_power_series.nim
  - cplib/fps/sparse_formal_power_series.nim
  - cplib/math/isqrt.nim
  - cplib/fps/product_tree.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/inv_gcd.nim
  - cplib/fps/bostan_mori.nim
  isVerificationFile: true
  path: verify/AI/sparse_fps_elementary_test.nim
  requiredBy: []
  timestamp: '2026-09-16 23:15:29+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/sparse_fps_elementary_test.nim
layout: document
redirect_from:
- /verify/verify/AI/sparse_fps_elementary_test.nim
- /verify/verify/AI/sparse_fps_elementary_test.nim.html
title: verify/AI/sparse_fps_elementary_test.nim
---
