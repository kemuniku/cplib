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
    path: cplib/fps/shift_of_sampling_points.nim
    title: cplib/fps/shift_of_sampling_points.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/shift_of_sampling_points.nim
    title: cplib/fps/shift_of_sampling_points.nim
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
    echo \"Hello World\"\n\nimport random, sequtils\nimport cplib/fps/shift_of_sampling_points\n\
    import cplib/modint/modint\n\nproc evaluate[T](f: seq[T], x: T): T =\n  result\
    \ = init(T, 0)\n  for i in countdown(f.high, 0): result = result * x + f[i]\n\n\
    proc checkShift[T: BarrettModint or MontgomeryModint](M: typedesc[T]) =\n  let\
    \ modulus = T.umod.int\n  var rng = initRand(20260910)\n  var lengths = @[0, 1,\
    \ 2, 3, 7, 16, 31, 64, 65, 129, 257]\n  if modulus <= 257: lengths.add(modulus)\n\
    \  for n in lengths:\n    if n > modulus: continue\n    let f = newSeqWith(n,\
    \ init(T, rng.rand(0..<modulus)))\n    var ys = newSeq[T](n)\n    for i in 0..<n:\
    \ ys[i] = evaluate(f, init(T, i))\n    let original = ys.mapIt(it.val)\n    for\
    \ t in [0, 1, n div 2, n, n + 1, -1, -n, modulus - 2]:\n      for m in [0, 1,\
    \ max(0, n - 1), n, n + 3, 2 * n + 7]:\n        let shifted = shiftOfSamplingPoints(ys,\
    \ init(T, t), m)\n        doAssert shifted.len == m\n        for i in 0..<m:\n\
    \          doAssert shifted[i].val == evaluate(f, init(T, t) + i).val,\n     \
    \       $M & \" n=\" & $n & \" m=\" & $m & \" t=\" & $t & \" i=\" & $i\n     \
    \ doAssert shiftOfSamplingPoints(ys, init(T, t)).mapIt(it.val) ==\n        shiftOfSamplingPoints(ys,\
    \ init(T, t), n).mapIt(it.val)\n    doAssert ys.mapIt(it.val) == original\n\n\
    \  doAssert shiftOfSamplingPoints(newSeq[T](min(70, modulus)), init(T, 100), 97).mapIt(it.val)\
    \ ==\n    newSeq[int](97)\n\ncheckShift(modint998244353_barrett)\ncheckShift(modint998244353_montgomery)\n\
    checkShift(modint1000000007_barrett)\ncheckShift(modint1000000007_montgomery)\n\
    for modulus in [998244353, 1000000007]:\n  modint_barrett.setMod(modulus)\n  modint_montgomery.setMod(modulus)\n\
    \  checkShift(modint_barrett)\n  checkShift(modint_montgomery)\ncheckShift(StaticBarrettModint[101u32])\n\
    checkShift(StaticMontgomeryModint[101u32])\ncheckShift(StaticBarrettModint[2u32])\n\
    checkShift(StaticMontgomeryModint[3u32])\n\nblock invalidInput:\n  type Mint =\
    \ StaticBarrettModint[7u32]\n  var rejected = false\n  try:\n    discard shiftOfSamplingPoints(newSeq[Mint](),\
    \ init(Mint, 0), -1)\n  except AssertionDefect:\n    rejected = true\n  doAssert\
    \ rejected\n  rejected = false\n  try:\n    discard shiftOfSamplingPoints(newSeq[Mint](8),\
    \ init(Mint, 0), 1)\n  except AssertionDefect:\n    rejected = true\n  doAssert\
    \ rejected\n"
  dependsOn:
  - cplib/math/powmod.nim
  - cplib/modint/modint.nim
  - cplib/math/powmod.nim
  - cplib/fps/shift_of_sampling_points.nim
  - cplib/convolution/convolution.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/fps/shift_of_sampling_points.nim
  - cplib/math/inv_gcd.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/isprime.nim
  - cplib/math/inner_math.nim
  - cplib/convolution/convolution.nim
  - cplib/math/isprime.nim
  - cplib/math/inner_math.nim
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  isVerificationFile: true
  path: verify/AI/shift_of_sampling_points_test.nim
  requiredBy: []
  timestamp: '2026-09-10 05:48:00+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/shift_of_sampling_points_test.nim
layout: document
redirect_from:
- /verify/verify/AI/shift_of_sampling_points_test.nim
- /verify/verify/AI/shift_of_sampling_points_test.nim.html
title: verify/AI/shift_of_sampling_points_test.nim
---
