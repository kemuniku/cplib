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
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
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
    echo \"Hello World\"\n\nimport sequtils\nimport cplib/convolution/convolution\n\
    import cplib/modint/modint\n\nassert convolution_ll(@[1, 2, 3], @[4, 5]) == @[4,\
    \ 13, 22, 15]\n\ntype Mint = modint998244353_barrett\nlet f = @[Mint(1), Mint(2),\
    \ Mint(3)]\nlet g = @[Mint(4), Mint(5)]\nassert convolution_naive(f, g).mapIt(it.val)\
    \ == @[4, 13, 22, 15]\nassert convolution(f, g).mapIt(it.val) == @[4, 13, 22,\
    \ 15]\n\nproc checkArbitraryMod[T: BarrettModint or MontgomeryModint](M: typedesc[T])\
    \ =\n  var a = newSeq[T](61)\n  var b = newSeq[T](73)\n  for i in 0..<a.len: a[i]\
    \ = T(i * 1_000_003 + 998_241)\n  for i in 0..<b.len: b[i] = T(i * 999_983 + 123_457)\n\
    \  assert convolution(a, b).mapIt(it.val) ==\n    convolution_naive(a, b).mapIt(it.val)\n\
    \ncheckArbitraryMod(modint1000000007_barrett)\ncheckArbitraryMod(modint1000000007_montgomery)\n\
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
  - cplib/modint/montgomery_impl.nim
  - cplib/convolution/convolution.nim
  - cplib/modint/modint.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/isqrt.nim
  - cplib/math/inv_gcd.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/modint/barrett_impl.nim
  - cplib/convolution/convolution.nim
  isVerificationFile: true
  path: verify/AI/convolution_test.nim
  requiredBy: []
  timestamp: '2026-09-02 04:29:41+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/convolution_test.nim
layout: document
redirect_from:
- /verify/verify/AI/convolution_test.nim
- /verify/verify/AI/convolution_test.nim.html
title: verify/AI/convolution_test.nim
---
