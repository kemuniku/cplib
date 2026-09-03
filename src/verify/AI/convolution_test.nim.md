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
    path: cplib/convolution/ntt.nim
    title: cplib/convolution/ntt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/ntt.nim
    title: cplib/convolution/ntt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/relaxed_convolution.nim
    title: cplib/convolution/relaxed_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/relaxed_convolution.nim
    title: cplib/convolution/relaxed_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/semi_relaxed_convolution.nim
    title: cplib/convolution/semi_relaxed_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/semi_relaxed_convolution.nim
    title: cplib/convolution/semi_relaxed_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
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
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
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
    echo \"Hello World\"\n\nimport sequtils\nimport cplib/convolution/convolution\n\
    import cplib/convolution/relaxed_convolution\nimport cplib/convolution/semi_relaxed_convolution\n\
    import cplib/modint/modint\n\nassert convolution_ll(@[1, 2, 3], @[4, 5]) == @[4,\
    \ 13, 22, 15]\n\ntype Mint = modint998244353_barrett\nlet f = @[Mint(1), Mint(2),\
    \ Mint(3)]\nlet g = @[Mint(4), Mint(5)]\nassert convolution_naive(f, g).mapIt(it.val)\
    \ == @[4, 13, 22, 15]\nassert convolution(f, g).mapIt(it.val) == @[4, 13, 22,\
    \ 15]\n\nproc checkCyclicConvolution[T: BarrettModint or MontgomeryModint](M:\
    \ typedesc[T]) =\n  const n = 128\n  var a = newSeq[T](n)\n  var b = newSeq[T](73)\n\
    \  for i in 0..<a.len: a[i] = init(T, i * 1_000_003 + 17)\n  for i in 0..<b.len:\
    \ b[i] = init(T, i * 999_983 + 31)\n  let product = convolution_naive(a, b)\n\
    \  var expected = newSeq[T](n)\n  for i in 0..<product.len: expected[i mod n]\
    \ += product[i]\n  let actual = convolutionCyclicPowerOfTwo(a, b, n)\n  for i\
    \ in 0..<n:\n    doAssert actual[i].val == expected[i].val,\n      $M & \" \"\
    \ & $i & \" \" & $actual[i].val & \" \" & $expected[i].val\n\ncheckCyclicConvolution(modint998244353_barrett)\n\
    checkCyclicConvolution(modint998244353_montgomery)\ncheckCyclicConvolution(modint1000000007_barrett)\n\
    checkCyclicConvolution(modint1000000007_montgomery)\n\ntype CompositeBarrett =\
    \ StaticBarrettModint[129u32]\ntype CompositeMontgomery = StaticMontgomeryModint[129u32]\n\
    checkCyclicConvolution(CompositeBarrett)\ncheckCyclicConvolution(CompositeMontgomery)\n\
    \nproc checkRelaxedConvolution[T: BarrettModint or MontgomeryModint](\n    M:\
    \ typedesc[T], n: int) =\n  var a = newSeq[T](n)\n  var b = newSeq[T](n)\n  for\
    \ i in 0..<n:\n    a[i] = T(i * i * 17 + i * 31 + 9)\n    b[i] = T(i * i * 13\
    \ + i * 29 + 7)\n  let expected = convolution_naive(a, b)\n  var relaxed = initRelaxedConvolution[T](n)\n\
    \  for i in 0..<n:\n    var pending = init(T, 0)\n    for j in 1..<i: pending\
    \ += a[j] * b[i - j]\n    doAssert relaxed.pendingCoefficient.val == pending.val,\n\
    \      $M & \" \" & $n & \" \" & $i\n    doAssert relaxed.add(a[i], b[i]).val\
    \ == expected[i].val,\n      $M & \" \" & $n & \" \" & $i\n  let actual = relaxed.coefficients\n\
    \  for i in 0..<n:\n    doAssert actual[i].val == expected[i].val, $M & \" \"\
    \ & $n & \" \" & $i\n\nproc checkSemiRelaxedConvolution[T: BarrettModint or MontgomeryModint](\n\
    \    M: typedesc[T], fixedCount, onlineCount: int) =\n  var fixed = newSeq[T](fixedCount)\n\
    \  var online = newSeq[T](onlineCount)\n  for i in 0..<fixed.len:\n    fixed[i]\
    \ = T(i * i * 19 + i * 37 + 11)\n  for i in 0..<online.len:\n    online[i] = T(i\
    \ * i * 23 + i * 41 + 13)\n  let expected = convolution_naive(fixed, online)\n\
    \  var relaxed = initSemiRelaxedConvolution[T](fixed)\n  for i in 0..<online.len:\n\
    \    let expectedValue = if i < expected.len: expected[i].val else: 0\n    doAssert\
    \ relaxed.add(online[i]).val == expectedValue,\n      $M & \" \" & $fixedCount\
    \ & \" \" & $onlineCount & \" \" & $i\n  let actual = relaxed.coefficients\n \
    \ for i in 0..<online.len:\n    let expectedValue = if i < expected.len: expected[i].val\
    \ else: 0\n    doAssert actual[i].val == expectedValue,\n      $M & \" \" & $fixedCount\
    \ & \" \" & $onlineCount & \" \" & $i\n\nfor n in [1, 2, 3, 7, 16, 17, 31, 32,\
    \ 33, 63, 64, 65, 127, 128, 129, 257]:\n  checkRelaxedConvolution(modint998244353_barrett,\
    \ n)\n  checkSemiRelaxedConvolution(modint998244353_barrett, n, n)\ncheckRelaxedConvolution(modint998244353_montgomery,\
    \ 130)\ncheckSemiRelaxedConvolution(modint998244353_montgomery, 130, 130)\ncheckRelaxedConvolution(modint1000000007_barrett,\
    \ 130)\ncheckSemiRelaxedConvolution(modint1000000007_barrett, 130, 130)\ncheckRelaxedConvolution(modint1000000007_montgomery,\
    \ 130)\ncheckSemiRelaxedConvolution(modint1000000007_montgomery, 130, 130)\ncheckSemiRelaxedConvolution(modint998244353_barrett,\
    \ 17, 70)\ncheckSemiRelaxedConvolution(modint998244353_barrett, 70, 17)\ncheckSemiRelaxedConvolution(modint998244353_barrett,\
    \ 0, 20)\n\nproc checkArbitraryMod[T: BarrettModint or MontgomeryModint](M: typedesc[T])\
    \ =\n  var a = newSeq[T](61)\n  var b = newSeq[T](73)\n  for i in 0..<a.len: a[i]\
    \ = T(i * 1_000_003 + 998_241)\n  for i in 0..<b.len: b[i] = T(i * 999_983 + 123_457)\n\
    \  assert convolution(a, b).mapIt(it.val) ==\n    convolution_naive(a, b).mapIt(it.val)\n\
    \ncheckArbitraryMod(modint1000000007_barrett)\ncheckArbitraryMod(modint1000000007_montgomery)\n\
    \nproc checkCompositeMod[T: BarrettModint or MontgomeryModint](M: typedesc[T])\
    \ =\n  var a = newSeq[T](61)\n  var b = newSeq[T](61)\n  for i in 0..<a.len:\n\
    \    a[i] = init(T, i * i + 17 * i + 3)\n    b[i] = init(T, i * i + 31 * i + 7)\n\
    \  doAssert convolution(a, b).mapIt(it.val) ==\n    convolution_naive(a, b).mapIt(it.val),\
    \ $M\n\ncheckCompositeMod(CompositeBarrett)\ncheckCompositeMod(CompositeMontgomery)\n\
    \ntype DynamicBarrett = modint_barrett\nDynamicBarrett.setMod(1_000_000_007)\n\
    checkArbitraryMod(DynamicBarrett)\n\ntype DynamicMontgomery = modint_montgomery\n\
    DynamicMontgomery.setMod(1_000_000_007)\ncheckArbitraryMod(DynamicMontgomery)\n\
    \nproc convolutionNaiveMod[m: static[int]](a, b: seq[int]): seq[int] =\n  if a.len\
    \ == 0 or b.len == 0: return @[]\n  result = newSeq[int](a.len + b.len - 1)\n\
    \  for i in 0..<a.len:\n    let ai = ((a[i] mod m) + m) mod m\n    for j in 0..<b.len:\n\
    \      let bj = ((b[j] mod m) + m) mod m\n      result[i + j] = ((result[i + j].int64\
    \ + ai.int64 * bj.int64) mod\n        m.int64).int\n\nassert convolution[1_000_000_007](@[1,\
    \ -2, 3], @[4, 5]) ==\n  @[4, 1_000_000_004, 2, 15]\nassert convolution[1](@[1,\
    \ -2, 3], @[4, 5]) == @[0, 0, 0, 0]\nassert convolution[1_000_000_007](newSeq[int](),\
    \ @[1, 2]) == @[]\nvar intA = newSeq[int](67)\nvar intB = newSeq[int](79)\nfor\
    \ i in 0..<intA.len: intA[i] = i * 1_000_003 - 50_000_007\nfor i in 0..<intB.len:\
    \ intB[i] = i * 999_983 - 30_000_011\nassert convolution[1_000_000_007](intA,\
    \ intB) ==\n  convolutionNaiveMod[1_000_000_007](intA, intB)\nassert convolution[998_244_353](intA,\
    \ intB) ==\n  convolutionNaiveMod[998_244_353](intA, intB)\n"
  dependsOn:
  - cplib/convolution/semi_relaxed_convolution.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/convolution/relaxed_convolution.nim
  - cplib/convolution/ntt.nim
  - cplib/math/isqrt.nim
  - cplib/math/isprime.nim
  - cplib/math/inner_math.nim
  - cplib/math/powmod.nim
  - cplib/convolution/ntt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/inner_math.nim
  - cplib/math/inv_gcd.nim
  - cplib/convolution/relaxed_convolution.nim
  - cplib/convolution/semi_relaxed_convolution.nim
  - cplib/convolution/convolution.nim
  - cplib/modint/modint.nim
  - cplib/modint/modint.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/powmod.nim
  - cplib/math/isprime.nim
  - cplib/math/isqrt.nim
  - cplib/convolution/convolution.nim
  - cplib/math/inv_gcd.nim
  isVerificationFile: true
  path: verify/AI/convolution_test.nim
  requiredBy: []
  timestamp: '2026-09-03 22:19:58+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/convolution_test.nim
layout: document
redirect_from:
- /verify/verify/AI/convolution_test.nim
- /verify/verify/AI/convolution_test.nim.html
title: verify/AI/convolution_test.nim
---
