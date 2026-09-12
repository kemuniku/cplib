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
    path: cplib/fps/shift_of_sampling_points.nim
    title: cplib/fps/shift_of_sampling_points.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/shift_of_sampling_points.nim
    title: cplib/fps/shift_of_sampling_points.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/taylor_shift.nim
    title: cplib/fps/taylor_shift.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/taylor_shift.nim
    title: cplib/fps/taylor_shift.nim
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
    path: cplib/math/many_factorials.nim
    title: cplib/math/many_factorials.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/many_factorials.nim
    title: cplib/math/many_factorials.nim
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
    echo \"Hello World\"\n\nimport algorithm, random, sequtils\nimport cplib/math/many_factorials\n\
    import cplib/modint/modint\n\nproc checkFactorials[T: BarrettModint or MontgomeryModint](M:\
    \ typedesc[T]) =\n  let modulus = T.umod.int\n  doAssert many_factorials.manyFactorials[T](newSeq[int]()).len\
    \ == 0\n  doAssert many_factorials.manyFactorials[T]([modulus, modulus + 1, int.high]).mapIt(it.val)\
    \ == @[0, 0, 0]\n  doAssert many_factorials.manyFactorials[T]([0, 1, 0]).mapIt(it.val)\
    \ == @[1, 1, 1]\n\n  let limit = min(modulus - 1, 100000)\n  var fact = newSeq[T](limit\
    \ + 1)\n  fact[0] = init(T, 1)\n  for i in 1..limit: fact[i] = fact[i - 1] * i\n\
    \  var ns: seq[int]\n  for n in 0..min(limit, 1100): ns.add(n)\n  for n in [2047,\
    \ 2048, 2049, 4095, 4096, 4097, 32767, 32768, 32769, limit]:\n    if n <= limit:\
    \ ns.add(n)\n  var rng = initRand(20260910)\n  for i in 0..<1000: ns.add(rng.rand(0..limit))\n\
    \  ns = ns & ns\n  rng.shuffle(ns)\n  let actual = many_factorials.manyFactorials[T](ns)\n\
    \  for i, n in ns: doAssert actual[i].val == fact[n].val, $M & \" n=\" & $n\n\
    \  for blockSize in [1, 64, 1024]:\n    let table = initLargeFactorial[T](maxN\
    \ = limit, blockSize = blockSize)\n    for n in ns:\n      doAssert table.fact(n).val\
    \ == fact[n].val,\n        $M & \" n=\" & $n & \" blockSize=\" & $blockSize\n\
    \    doAssert table.fact(modulus).val == 0\n    doAssert table.fact(int.high).val\
    \ == 0\n  for n in [1023, 1024, 1025, 4095, 4096, 4097, limit]:\n    if n <= limit:\
    \ doAssert many_factorials.manyFactorials[T]([n])[0].val == fact[n].val\n\n  if\
    \ modulus <= 100001:\n    ns = toSeq(0..modulus + 3)\n    ns.reverse\n    let\
    \ exhaustive = many_factorials.manyFactorials[T](ns)\n    let table = initLargeFactorial[T]()\n\
    \    for i, n in ns:\n      let expected = if n < modulus: fact[n].val else: 0\n\
    \      doAssert exhaustive[i].val == expected, $M & \" n=\" & $n\n      doAssert\
    \ table.fact(n).val == expected, $M & \" online n=\" & $n\n  else:\n    let offsets\
    \ = @[0, 1, 2, 31, 32, 63, 64, 1023, 1024, 32767, 32768, 32769]\n    ns = offsets.mapIt(modulus\
    \ - 1 - it)\n    ns.add([modulus, modulus + 1, int.high, 0])\n    let nearModulus\
    \ = many_factorials.manyFactorials[T](ns)\n    let table = initLargeFactorial[T](blockSize\
    \ = 32768)\n    for i, k in offsets:\n      var expected = fact[k].inv\n     \
    \ if (k and 1) == 0: expected = -expected\n      doAssert nearModulus[i].val ==\
    \ expected.val, $M & \" k=\" & $k\n      doAssert table.fact(ns[i]).val == expected.val,\
    \ $M & \" online k=\" & $k\n    doAssert nearModulus[^4..^1].mapIt(it.val) ==\
    \ @[0, 0, 0, 1]\n\ncheckFactorials(modint998244353_barrett)\ncheckFactorials(modint998244353_montgomery)\n\
    checkFactorials(modint1000000007_barrett)\ncheckFactorials(modint1000000007_montgomery)\n\
    for modulus in [998244353, 1000000007]:\n  modint_barrett.setMod(modulus)\n  modint_montgomery.setMod(modulus)\n\
    \  checkFactorials(modint_barrett)\n  checkFactorials(modint_montgomery)\ncheckFactorials(StaticBarrettModint[2u32])\n\
    checkFactorials(StaticMontgomeryModint[3u32])\ncheckFactorials(StaticBarrettModint[65537u32])\n\
    checkFactorials(StaticMontgomeryModint[65537u32])\n\nblock invalidInput:\n  var\
    \ rejected = false\n  try:\n    discard many_factorials.manyFactorials[modint998244353_barrett]([0,\
    \ -1])\n  except AssertionDefect:\n    rejected = true\n  doAssert rejected\n\n\
    template expectAssertion(body: untyped) =\n  block:\n    var rejected = false\n\
    \    try:\n      body\n    except AssertionDefect:\n      rejected = true\n  \
    \  doAssert rejected\n\nblock onlineBounds:\n  type Mint = StaticBarrettModint[101u32]\n\
    \  let zero = initLargeFactorial[Mint](maxN = 0)\n  let limited = initLargeFactorial[Mint](maxN\
    \ = 10, blockSize = 4)\n  let full = initLargeFactorial[Mint](maxN = int.high)\n\
    \  doAssert zero.fact(0).val == 1\n  doAssert zero.fact(101).val == 0\n  doAssert\
    \ limited.fact(10).val == 72\n  doAssert full.fact(100).val == 100\n  doAssert\
    \ limited.fact(10).val == 72\n  expectAssertion: discard zero.fact(1)\n  expectAssertion:\
    \ discard limited.fact(11)\n  expectAssertion: discard limited.fact(-1)\n  expectAssertion:\
    \ discard initLargeFactorial[Mint](maxN = -2)\n  for blockSize in [-1, 0, 3]:\n\
    \    expectAssertion: discard initLargeFactorial[Mint](blockSize = blockSize)\n\
    \  var uninitialized: LargeFactorial[Mint]\n  expectAssertion: discard uninitialized.fact(0)\n\
    \nproc checkModulusChange[T: BarrettModint or MontgomeryModint](M: typedesc[T])\
    \ =\n  T.setMod(101)\n  let first = initLargeFactorial[T]()\n  T.setMod(103)\n\
    \  let second = initLargeFactorial[T]()\n  doAssert second.fact(102).val == 102\n\
    \  expectAssertion: discard first.fact(0)\n  T.setMod(101)\n  doAssert first.fact(100).val\
    \ == 100\n  expectAssertion: discard second.fact(0)\n\ncheckModulusChange(modint_barrett)\n\
    checkModulusChange(modint_montgomery)\n"
  dependsOn:
  - cplib/convolution/convolution.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isprime.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/modint/barrett_impl.nim
  - cplib/fps/taylor_shift.nim
  - cplib/math/many_factorials.nim
  - cplib/fps/product_tree.nim
  - cplib/modint/modint.nim
  - cplib/fps/formal_power_series.nim
  - cplib/convolution/convolution.nim
  - cplib/math/inv_gcd.nim
  - cplib/fps/shift_of_sampling_points.nim
  - cplib/fps/product_tree.nim
  - cplib/math/powmod.nim
  - cplib/math/isprime.nim
  - cplib/math/isqrt.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/powmod.nim
  - cplib/math/many_factorials.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/inner_math.nim
  - cplib/fps/formal_power_series.nim
  - cplib/fps/shift_of_sampling_points.nim
  - cplib/math/isqrt.nim
  - cplib/fps/taylor_shift.nim
  - cplib/math/inner_math.nim
  isVerificationFile: true
  path: verify/AI/many_factorials_test.nim
  requiredBy: []
  timestamp: '2026-09-10 05:48:00+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/many_factorials_test.nim
layout: document
redirect_from:
- /verify/verify/AI/many_factorials_test.nim
- /verify/verify/AI/many_factorials_test.nim.html
title: verify/AI/many_factorials_test.nim
---
