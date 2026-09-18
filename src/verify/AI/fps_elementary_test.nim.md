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
    import options, random\nimport cplib/fps/formal_power_series\nimport cplib/modint/modint\n\
    \nvar rng = initRand(20260916)\n\nproc same[T](a, b: seq[T]): bool =\n  if a.len\
    \ != b.len: return false\n  for i in 0..<a.len:\n    if a[i].val != b[i].val:\
    \ return false\n  return true\n\nproc naiveProduct[T](a, b: seq[T], n: int): seq[T]\
    \ =\n  result = newSeq[T](n)\n  for i in 0..<min(a.len, n):\n    for j in 0..<min(b.len,\
    \ n - i): result[i + j] += a[i] * b[j]\n\nproc naiveInverse[T](f: seq[T], n: int):\
    \ seq[T] =\n  result = newSeq[T](n)\n  if n == 0: return\n  result[0] = f[0].inv\n\
    \  for i in 1..<n:\n    for j in 1..min(i, f.len - 1): result[i] -= f[j] * result[i\
    \ - j]\n    result[i] *= result[0]\n\nproc naiveExp[T](f: seq[T], n: int): seq[T]\
    \ =\n  result = newSeq[T](n)\n  if n == 0: return\n  result[0] = init(T, 1)\n\
    \  for i in 1..<n:\n    for j in 1..min(i, f.len - 1): result[i] += f[j] * j *\
    \ result[i - j]\n    result[i] /= i\n\nproc check[T: BarrettModint or MontgomeryModint](n:\
    \ int) =\n  for length in [0, 3, n + 5]:\n    var f = newSeq[T](length)\n    for\
    \ i in 0..<length: f[i] = init(T, rng.rand(T.umod.int - 1))\n    let original\
    \ = f\n    var exponentialInput = f\n    if length > 0: exponentialInput[0] =\
    \ init(T, 0)\n    doAssert same(exponentialInput.exp(n), naiveExp(exponentialInput,\
    \ n))\n    var unit = prefix(f, max(1, length))\n    unit[0] = init(T, 1)\n  \
    \  let inverse = naiveInverse(unit, n)\n    doAssert same(unit.inv(n), inverse)\n\
    \    var logarithm = naiveProduct(unit.derivative, inverse, max(0, n - 1))\n \
    \   logarithm.insert(init(T, 0), 0)\n    logarithm.setLen(n)\n    for i in 1..<n:\
    \ logarithm[i] /= i\n    doAssert same(unit.log(n), logarithm)\n    unit[0] =\
    \ init(T, 3)\n    doAssert same(unit.inv(n), naiveInverse(unit, n))\n    for shift\
    \ in [0, 1, 2]:\n      var shifted = newSeq[T](shift) & f\n      var expected\
    \ = newSeq[T](n)\n      if n > 0: expected[0] = init(T, 1)\n      for k in 0..4:\n\
    \        doAssert same(shifted.pow(k, n), expected),\n          $T & \" n=\" &\
    \ $n & \" len=\" & $length & \" shift=\" & $shift & \" k=\" & $k\n        expected\
    \ = naiveProduct(expected, shifted, n)\n      let square = naiveProduct(shifted,\
    \ shifted, n)\n      let root = square.sqrt(n)\n      doAssert root.isSome\n \
    \     doAssert same(naiveProduct(root.get, root.get, n), square)\n    doAssert\
    \ f == original\n  let zero = newSeq[T]()\n  doAssert zero.inv(0).len == 0\n \
    \ doAssert zero.log(0).len == 0\n  doAssert same(zero.sqrt(n).get, newSeq[T](n))\n\
    \  doAssert @[init(T, 0), init(T, 1)].sqrt(max(2, n)).isNone\n\nproc checkSizes[T:\
    \ BarrettModint or MontgomeryModint]() =\n  for n in [0, 1, 2, 3, 7, 16, 31, 32,\
    \ 33, 60, 63, 64, 65,\n            127, 128, 129, 255, 256, 257]:\n    check[T](n)\n\
    \ncheckSizes[modint998244353_barrett]()\ncheckSizes[modint998244353_montgomery]()\n\
    checkSizes[modint1000000007_barrett]()\ncheckSizes[modint1000000007_montgomery]()\n\
    for modulus in [998244353, 1000000007, 754974721, 998244353]:\n  modint_barrett.setMod(modulus)\n\
    \  modint_montgomery.setMod(modulus)\n  for n in [65, 129, 257]:\n    check[modint_barrett](n)\n\
    \    check[modint_montgomery](n)\n\nfor modulus in [17, 257]:\n  modint_barrett.setMod(modulus)\n\
    \  modint_montgomery.setMod(modulus)\n  check[modint_barrett](modulus)\n  check[modint_montgomery](modulus)\n\
    \  let f = @[init(modint_barrett, 1), init(modint_barrett, 2)]\n  doAssert f.inv(300)\
    \ == naiveInverse(f, 300)\n\nblock largeIdentities:\n  type M = modint998244353_barrett\n\
    \  for n in [1023, 1024, 1025, 4097]:\n    var f = newSeq[M](n)\n    f[0] = init(M,\
    \ 1)\n    for i in 1..<n: f[i] = init(M, rng.rand(998244352))\n    var identity\
    \ = newSeq[M](n)\n    identity[0] = init(M, 1)\n    doAssert prefix(f * f.inv(n),\
    \ n) == identity\n    doAssert f.log(n).exp(n) == f\n    doAssert f.pow(3, n)\
    \ == prefix(prefix(f * f, n) * f, n)\n    let root = f.sqrt(n)\n    doAssert root.isSome\n\
    \    doAssert prefix(root.get * root.get, n) == f\n  doAssert @[init(M, 3)].sqrt(1).isNone\n\
    \n\nblock characteristicTwoConstant:\n  type M = StaticBarrettModint[2u32]\n \
    \ doAssert @[init(M, 1)].sqrt(1).get == @[init(M, 1)]\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/convolution/convolution.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/inv_gcd.nim
  - cplib/fps/formal_power_series.nim
  - cplib/modint/barrett_impl.nim
  - cplib/fps/formal_power_series.nim
  - cplib/math/isprime.nim
  - cplib/convolution/convolution.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/math/isqrt.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isprime.nim
  - cplib/math/inv_gcd.nim
  - cplib/modint/modint.nim
  - cplib/modint/modint.nim
  isVerificationFile: true
  path: verify/AI/fps_elementary_test.nim
  requiredBy: []
  timestamp: '2026-09-18 01:13:21+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/fps_elementary_test.nim
layout: document
redirect_from:
- /verify/verify/AI/fps_elementary_test.nim
- /verify/verify/AI/fps_elementary_test.nim.html
title: verify/AI/fps_elementary_test.nim
---
