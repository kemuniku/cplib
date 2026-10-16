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
    \nimport random\nimport cplib/convolution/convolution\nimport cplib/modint/modint\n\
    \nproc suite[T](seed: int) =\n    var rng = initRand(seed)\n    for n in [1, 2,\
    \ 4, 8, 16, 32, 64, 128, 256, 512, 1024]:\n        for repetition in 0..<12:\n\
    \            let lengths = [0, 1, max(0, n div 2 - 1), n div 2,\n            \
    \               min(n, n div 2 + 1), max(0, n - 1), n]\n            let flen =\
    \ (if repetition < lengths.len: lengths[repetition]\n                        else:\
    \ rng.rand(0..n))\n            let glen = (if repetition < lengths.len: lengths[^(repetition\
    \ + 1)]\n                        else: rng.rand(0..n))\n            var f = newSeq[T](flen)\n\
    \            var g = newSeq[T](glen)\n            for i in 0..<flen: f[i] = init(T,\
    \ rng.rand(0..T.umod.int - 1))\n            for i in 0..<glen: g[i] = init(T,\
    \ rng.rand(0..T.umod.int - 1))\n            let savedF = f\n            let savedG\
    \ = g\n            var expected = newSeq[T](n)\n            for i in 0..<flen:\n\
    \                for j in 0..<glen: expected[(i + j) mod n] += f[i] * g[j]\n \
    \           doAssert convolutionCyclicPowerOfTwo(f, g, n) == expected\n      \
    \      doAssert f == savedF and g == savedG\n        var full = newSeq[T](n)\n\
    \        for i in 0..<n: full[i] = init(T, T.umod.int - 1 - i mod 3)\n       \
    \ var expected = newSeq[T](n)\n        for i in 0..<n:\n            for j in 0..<n:\
    \ expected[(i + j) mod n] += full[i] * full[j]\n        doAssert convolutionCyclicPowerOfTwo(full,\
    \ full, n) == expected\n        doAssert convolutionCyclicPowerOfTwo(@[init(T,\
    \ 3)], @[init(T, 7)], n)[0] == init(T, 21)\n\nsuite[modint998244353_barrett](11)\n\
    suite[modint998244353_montgomery](17)\nsuite[StaticBarrettModint[167772161u32]](19)\n\
    suite[StaticMontgomeryModint[167772161u32]](23)\nsuite[modint1000000007_barrett](29)\n\
    suite[modint1000000007_montgomery](31)\nmodint_barrett.setMod(998244353)\nsuite[modint_barrett](37)\n\
    modint_barrett.setMod(1000000007)\nsuite[modint_barrett](41)\nmodint_montgomery.setMod(998244353)\n\
    suite[modint_montgomery](43)\nmodint_montgomery.setMod(1000000007)\nsuite[modint_montgomery](47)\n\
    echo \"Hello World\"\n"
  dependsOn:
  - cplib/math/isprime.nim
  - cplib/math/isprime.nim
  - cplib/math/inv_gcd.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/inv_gcd.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/convolution/convolution.nim
  - cplib/modint/modint.nim
  - cplib/convolution/convolution.nim
  - cplib/math/isqrt.nim
  isVerificationFile: true
  path: verify/convolution/convolution/convolution_cyclic_regression_test.nim
  requiredBy: []
  timestamp: '2026-10-08 06:34:57+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/convolution/convolution/convolution_cyclic_regression_test.nim
layout: document
redirect_from:
- /verify/verify/convolution/convolution/convolution_cyclic_regression_test.nim
- /verify/verify/convolution/convolution/convolution_cyclic_regression_test.nim.html
title: verify/convolution/convolution/convolution_cyclic_regression_test.nim
---
