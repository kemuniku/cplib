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
    import math\nimport cplib/fps/formal_power_series\nimport cplib/fps/sparse_formal_power_series\n\
    import cplib/modint/modint\n\nproc check[T: BarrettModint or MontgomeryModint]()\
    \ =\n  let p = T.umod.int\n  let f = @[init(T, 0), init(T, 0), init(T, 0), init(T,\
    \ 1)]\n  let integrated = f.integral\n  doAssert integrated[4].val == init(T,\
    \ 4).inv.val\n  var coefficients = newSeq[T](p - 1)\n  for i in 1..<p:\n    if\
    \ gcd(i, p) == 1: coefficients[i - 1] = init(T, 1)\n  let actual = coefficients.integral\n\
    \  for i in 1..<p:\n    let expected = coefficients[i - 1] / i\n    doAssert actual[i].val\
    \ == expected.val, $T & \" mod=\" & $p & \" i=\" & $i\n\n  let exponent = sfps[T](x^4)\n\
    \  let unit = sfps[T](1 + x^4)\n  let denseExponent = exponent.toDense(5)\n  let\
    \ denseUnit = unit.toDense(5)\n  for result in [exponent.exp(5), denseExponent.exp(5)]:\n\
    \    for i in 0..<5:\n      doAssert result[i].val == (if i == 0 or i == 4: 1\
    \ else: 0)\n  for result in [unit.log(5), denseUnit.log(5)]:\n    for i in 0..<5:\n\
    \      doAssert result[i].val == (if i == 4: 1 else: 0)\n  for result in [unit.pow(2,\
    \ 5), denseUnit.pow(2, 5)]:\n    for i in 0..<5:\n      doAssert result[i].val\
    \ == (if i == 0: 1 elif i == 4: 2 else: 0)\n\ndeclarStaticBarrettModint(CompositeBarrett,\
    \ 15u32)\ndeclarStaticMontgomeryModint(CompositeMontgomery, 15u32)\ncheck[CompositeBarrett]()\n\
    check[CompositeMontgomery]()\nfor modulus in [15, 17, 21, 35, 17, 15]:\n  modint_barrett.setMod(modulus)\n\
    \  modint_montgomery.setMod(modulus)\n  check[modint_barrett]()\n  check[modint_montgomery]()\n\
    \necho \"Hello World\"\n"
  dependsOn:
  - cplib/convolution/convolution.nim
  - cplib/modint/modint.nim
  - cplib/fps/bostan_mori.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/isprime.nim
  - cplib/modint/barrett_impl.nim
  - cplib/fps/sparse_formal_power_series.nim
  - cplib/fps/product_tree.nim
  - cplib/math/isprime.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/convolution/convolution.nim
  - cplib/fps/sparse_formal_power_series.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/isqrt.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/fps/formal_power_series.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/fps/product_tree.nim
  - cplib/fps/formal_power_series.nim
  - cplib/modint/modint.nim
  - cplib/fps/bostan_mori.nim
  isVerificationFile: true
  path: verify/AI/fps_composite_modulus_test.nim
  requiredBy: []
  timestamp: '2026-09-16 23:15:29+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/fps_composite_modulus_test.nim
layout: document
redirect_from:
- /verify/verify/AI/fps_composite_modulus_test.nim
- /verify/verify/AI/fps_composite_modulus_test.nim.html
title: verify/AI/fps_composite_modulus_test.nim
---
