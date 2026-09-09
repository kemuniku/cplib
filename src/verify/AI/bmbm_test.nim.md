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
    path: cplib/fps/berlekamp_massey.nim
    title: cplib/fps/berlekamp_massey.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/berlekamp_massey.nim
    title: cplib/fps/berlekamp_massey.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/bmbm.nim
    title: cplib/fps/bmbm.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/bmbm.nim
    title: cplib/fps/bmbm.nim
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
    echo \"Hello World\"\n\nimport random, sequtils\nimport cplib/fps/bmbm\nimport\
    \ cplib/modint/modint\n\nproc checkBmbm[T: BarrettModint or MontgomeryModint](M:\
    \ typedesc[T]) =\n  let empty = newSeq[T]()\n  let zeros = newSeq[T](8)\n  let\
    \ impulse = @[init(T, 1), init(T, 0), init(T, 0)]\n  let delayed = @[init(T, 0),\
    \ init(T, 0), init(T, 1),\n      init(T, 0), init(T, 0), init(T, 0)]\n  let constant\
    \ = newSeqWith(6, init(T, 7))\n  let geometric = @[init(T, 1), init(T, 3), init(T,\
    \ 9), init(T, 27)]\n  let fib = @[init(T, 0), init(T, 1), init(T, 1), init(T,\
    \ 2)]\n  for k in [0, 1, 2, 3, 8, 100, int.high]:\n    doAssert bmbm(empty, k).val\
    \ == 0\n    doAssert bmbm(zeros, k).val == 0\n    doAssert bmbm(impulse, k).val\
    \ == (if k == 0: 1 else: 0)\n    doAssert bmbm(delayed, k).val == (if k == 2:\
    \ 1 else: 0)\n    doAssert bmbm(constant, k).val == 7\n    doAssert bmbm(geometric,\
    \ k).val == init(T, 3).pow(k).val\n  doAssert bmbm(fib, 20).val == 6765\n  for\
    \ a in [empty, fib]:\n    var rejected = false\n    try:\n      discard bmbm(a,\
    \ -1)\n    except AssertionDefect:\n      rejected = true\n    doAssert rejected\n\
    \n  var rng = initRand(20260909)\n  for d in [1, 2, 3, 8, 32, 65]:\n    for trial\
    \ in 0..<8:\n      var c = newSeq[T](d)\n      var a = newSeq[T](4 * d + 10)\n\
    \      for i in 0..<d:\n        c[i] = init(T, rng.rand(0..100))\n        a[i]\
    \ = init(T, rng.rand(0..100))\n      for n in d..<a.len:\n        for i in 0..<d:\n\
    \          a[n] += c[i] * a[n - i - 1]\n      let samples = a[0..<2 * d]\n   \
    \   for k in [0, d, samples.high, samples.len, a.high]:\n        doAssert bmbm(samples,\
    \ k).val == a[k].val\n\ncheckBmbm(modint998244353_barrett)\ncheckBmbm(modint998244353_montgomery)\n\
    checkBmbm(modint1000000007_barrett)\ncheckBmbm(modint1000000007_montgomery)\n\
    modint_barrett.setMod(998244353)\nmodint_montgomery.setMod(998244353)\ncheckBmbm(modint_barrett)\n\
    checkBmbm(modint_montgomery)\n"
  dependsOn:
  - cplib/modint/modint.nim
  - cplib/math/powmod.nim
  - cplib/fps/bostan_mori.nim
  - cplib/fps/formal_power_series.nim
  - cplib/math/isprime.nim
  - cplib/math/inv_gcd.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/inner_math.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/powmod.nim
  - cplib/modint/modint.nim
  - cplib/convolution/convolution.nim
  - cplib/math/isprime.nim
  - cplib/math/inner_math.nim
  - cplib/math/isqrt.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/math/inv_gcd.nim
  - cplib/fps/bostan_mori.nim
  - cplib/fps/bmbm.nim
  - cplib/fps/bmbm.nim
  - cplib/fps/berlekamp_massey.nim
  - cplib/convolution/convolution.nim
  - cplib/fps/formal_power_series.nim
  - cplib/fps/berlekamp_massey.nim
  isVerificationFile: true
  path: verify/AI/bmbm_test.nim
  requiredBy: []
  timestamp: '2026-09-09 17:06:01+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/bmbm_test.nim
layout: document
redirect_from:
- /verify/verify/AI/bmbm_test.nim
- /verify/verify/AI/bmbm_test.nim.html
title: verify/AI/bmbm_test.nim
---
