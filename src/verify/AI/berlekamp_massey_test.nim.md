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
    echo \"Hello World\"\n\nimport random, sequtils\nimport cplib/fps/berlekamp_massey\n\
    import cplib/fps/bostan_mori\nimport cplib/modint/modint\n\nproc checkRecurrence[T](a,\
    \ c: seq[T]) =\n  for n in c.len..<a.len:\n    var expected = init(T, 0)\n   \
    \ for i in 0..<c.len:\n      expected += c[i] * a[n - i - 1]\n    doAssert a[n].val\
    \ == expected.val\n\nproc checkExamples[T: BarrettModint or MontgomeryModint](M:\
    \ typedesc[T]) =\n  doAssert berlekampMassey(newSeq[T]()).len == 0\n  doAssert\
    \ berlekampMassey(newSeq[T](10)).len == 0\n  doAssert berlekampMassey(@[init(T,\
    \ 1), init(T, 0), init(T, 0)]).mapIt(it.val) == @[0]\n  doAssert berlekampMassey(@[init(T,\
    \ 0), init(T, 0), init(T, 1)]).len == 3\n  let constant = newSeqWith(10, init(T,\
    \ 7))\n  doAssert berlekampMassey(constant).mapIt(it.val) == @[1]\n  var geometric:\
    \ seq[T]\n  for value in [1, 3, 9, 27, 81, 243]:\n    geometric.add(init(T, value))\n\
    \  doAssert berlekampMassey(geometric).mapIt(it.val) == @[3]\n  var fib: seq[T]\n\
    \  for value in [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]:\n    fib.add(init(T, value))\n\
    \  let c = berlekampMassey(fib)\n  doAssert c.mapIt(it.val) == @[1, 1]\n  doAssert\
    \ linearRecurrenceKth(fib[0..<c.len], c, 20).val == 6765\n\n  var rng = initRand(20260909)\n\
    \  for d in 1..16:\n    for trial in 0..<16:\n      let original = newSeqWith(d,\
    \ init(T, rng.rand(0..100)))\n      var a = newSeq[T](4 * d + 10)\n      for i\
    \ in 0..<d:\n        a[i] = init(T, rng.rand(0..100))\n      for n in d..<a.len:\n\
    \        for i in 0..<d:\n          a[n] += original[i] * a[n - i - 1]\n     \
    \ let inferred = berlekampMassey(a[0..<2 * d])\n      doAssert inferred.len <=\
    \ d\n      # \u63A8\u5B9A\u306B\u4F7F\u7528\u3057\u3066\u3044\u306A\u3044\u5F8C\
    \u7D9A\u9805\u3067\u3082\u6F38\u5316\u5F0F\u304C\u6210\u308A\u7ACB\u3064\u3053\
    \u3068\u3092\u78BA\u8A8D\u3059\u308B\u3002\n      checkRecurrence(a, inferred)\n\
    \      if inferred.len > 0 and trial == 0:\n        doAssert linearRecurrenceKth(a[0..<inferred.len],\
    \ inferred, a.high).val == a[^1].val\n\n# \u5C0F\u3055\u3044\u6709\u9650\u4F53\
    \u4E0A\u3067\u4FC2\u6570\u3092\u5168\u63A2\u7D22\u3057\u3001\u6700\u5C0F\u6B21\
    \u6570\u3092\u72EC\u7ACB\u306B\u691C\u8A3C\u3059\u308B\u3002\nproc minimumOrder(a:\
    \ seq[int], modulus: int): int =\n  var count = 1\n  for d in 0..a.len:\n    for\
    \ encoding in 0..<count:\n      var code = encoding\n      var c = newSeq[int](d)\n\
    \      for i in 0..<d:\n        c[i] = code mod modulus\n        code = code div\
    \ modulus\n      var valid = true\n      for n in d..<a.len:\n        var expected\
    \ = 0\n        for i in 0..<d:\n          expected += c[i] * a[n - i - 1]\n  \
    \      if expected mod modulus != a[n]:\n          valid = false\n          break\n\
    \      if valid: return d\n    count *= modulus\n\nproc checkExhaustive[T: BarrettModint\
    \ or MontgomeryModint](M: typedesc[T], maxLen: int) =\n  let modulus = M.mod.int\n\
    \  var count = 1\n  for n in 0..maxLen:\n    for encoding in 0..<count:\n    \
    \  var code = encoding\n      var a = newSeq[T](n)\n      for i in 0..<n:\n  \
    \      a[i] = init(T, code mod modulus)\n        code = code div modulus\n   \
    \   let c = berlekampMassey(a)\n      checkRecurrence(a, c)\n      doAssert c.len\
    \ == minimumOrder(a.mapIt(it.val), modulus)\n    count *= modulus\n\ncheckExamples(modint998244353_barrett)\n\
    checkExamples(modint998244353_montgomery)\ncheckExamples(modint1000000007_barrett)\n\
    checkExamples(modint1000000007_montgomery)\nmodint_barrett.setMod(998244353)\n\
    modint_montgomery.setMod(998244353)\ncheckExamples(modint_barrett)\ncheckExamples(modint_montgomery)\n\
    checkExhaustive(StaticBarrettModint[2u32], 8)\ncheckExhaustive(StaticMontgomeryModint[3u32],\
    \ 6)\n"
  dependsOn:
  - cplib/math/isqrt.nim
  - cplib/math/inv_gcd.nim
  - cplib/convolution/convolution.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/fps/bostan_mori.nim
  - cplib/math/isqrt.nim
  - cplib/fps/formal_power_series.nim
  - cplib/math/powmod.nim
  - cplib/math/inner_math.nim
  - cplib/modint/barrett_impl.nim
  - cplib/convolution/convolution.nim
  - cplib/fps/berlekamp_massey.nim
  - cplib/math/powmod.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/inner_math.nim
  - cplib/math/isprime.nim
  - cplib/fps/berlekamp_massey.nim
  - cplib/modint/modint.nim
  - cplib/math/isprime.nim
  - cplib/fps/bostan_mori.nim
  - cplib/fps/formal_power_series.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/math/inv_gcd.nim
  isVerificationFile: true
  path: verify/AI/berlekamp_massey_test.nim
  requiredBy: []
  timestamp: '2026-09-09 17:06:01+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/berlekamp_massey_test.nim
layout: document
redirect_from:
- /verify/verify/AI/berlekamp_massey_test.nim
- /verify/verify/AI/berlekamp_massey_test.nim.html
title: verify/AI/berlekamp_massey_test.nim
---
