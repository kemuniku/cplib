---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/algorithm_ntt.nim
    title: cplib/convolution/algorithm_ntt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/algorithm_ntt.nim
    title: cplib/convolution/algorithm_ntt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/composition.nim
    title: cplib/fps/composition.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/composition.nim
    title: cplib/fps/composition.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/formal_power_series.nim
    title: cplib/fps/formal_power_series.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/formal_power_series.nim
    title: cplib/fps/formal_power_series.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/power_projection.nim
    title: cplib/fps/power_projection.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/power_projection.nim
    title: cplib/fps/power_projection.nim
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
    \nimport random\nimport cplib/fps/composition\nimport cplib/fps/power_projection\n\
    import cplib/modint/modint\n\nproc naiveCompose[T](outer, inner: seq[T], n: int):\
    \ seq[T] =\n    result = newSeq[T](max(n, 0))\n    if n <= 0: return\n    var\
    \ power = newSeq[T](n)\n    power[0] = init(T, 1)\n    for k in 0..<min(outer.len,\
    \ n):\n        for i in k..<n: result[i] += outer[k] * power[i]\n        var next\
    \ = newSeq[T](n)\n        for i in k..<n:\n            for j in 1..<min(inner.len,\
    \ n - i):\n                next[i + j] += power[i] * inner[j]\n        power =\
    \ move(next)\n\nproc suite[T](seed: int) =\n    var rng = initRand(seed)\n   \
    \ for n in [-1, 0, 1, 2, 3, 4, 7, 8, 9, 15, 16, 17, 30, 31, 32,\n            \
    \  33, 59, 60, 61, 63, 64, 65, 127, 128, 129, 255, 256, 257]:\n        for shape\
    \ in 0..<7:\n            var f = newSeq[T](max(0, n + 3))\n            var g =\
    \ newSeq[T](max(0, n + 5))\n            for i in 0..<f.len: f[i] = init(T, rng.rand(T.umod.int\
    \ - 1))\n            for i in 1..<g.len:\n                if shape != 4 and (shape\
    \ != 1 or i mod 7 == 0):\n                    g[i] = init(T, rng.rand(T.umod.int\
    \ - 1))\n            if shape == 2: g.setLen(min(g.len, 4))\n            if shape\
    \ == 3: f.setLen(min(f.len, 3))\n            if shape == 4: g.setLen(0)\n    \
    \        if shape >= 5:\n                let degree = (if shape == 5: 1 else:\
    \ 7)\n                g = newSeq[T](degree + 1)\n                g[degree] = -init(T,\
    \ rng.rand(1..T.umod.int - 1))\n            if shape == 0:\n                for\
    \ i in 0..<f.len: f[i] = -f[i]\n                for i in 1..<g.len: g[i] = -g[i]\n\
    \            let savedF = f\n            let savedG = g\n            doAssert\
    \ f.compose(g, n) == naiveCompose(f, g, n)\n            doAssert f == savedF and\
    \ g == savedG\n            doAssert f.compose(g) == naiveCompose(f, g, f.len)\n\
    \        doAssert newSeq[T](0).compose(newSeq[T](0), n) == newSeq[T](max(0, n))\n\
    \    for repetition in 0..<80:\n        let n = rng.rand(1..90)\n        var f\
    \ = newSeq[T](rng.rand(0..110))\n        var g = newSeq[T](rng.rand(0..110))\n\
    \        for i in 0..<f.len: f[i] = init(T, rng.rand(T.umod.int - 1))\n      \
    \  for i in 1..<g.len: g[i] = init(T, rng.rand(T.umod.int - 1))\n        doAssert\
    \ f.compose(g, n) == naiveCompose(f, g, n)\n    for n in [511, 512, 513, 1023,\
    \ 1024, 1025, 4095, 4096, 4097]:\n        var f, g, weight = newSeq[T](n)\n  \
    \      for i in 0..<n:\n            f[i] = init(T, rng.rand(T.umod.int - 1))\n\
    \            weight[n - 1 - i] = init(T, rng.rand(T.umod.int - 1))\n         \
    \   if i > 0: g[i] = init(T, rng.rand(T.umod.int - 1))\n        let composed =\
    \ f.compose(g, n)\n        let projected = g.powerProjection(weight, n - 1)\n\
    \        var left, right = init(T, 0)\n        for i in 0..<n:\n            left\
    \ += composed[i] * weight[n - 1 - i]\n            right += f[i] * projected[i]\n\
    \        doAssert left == right\n    var rejected = false\n    try:\n        discard\
    \ @[init(T, 1), init(T, 2)].compose(@[init(T, 1)], 2)\n    except AssertionDefect:\n\
    \        rejected = true\n    doAssert rejected\n\nsuite[modint998244353_barrett](11)\n\
    suite[modint998244353_montgomery](17)\nsuite[modint1000000007_barrett](19)\nsuite[modint1000000007_montgomery](23)\n\
    suite[StaticBarrettModint[9u32]](29)\nsuite[StaticBarrettModint[97u32]](31)\n\
    suite[StaticBarrettModint[257u32]](33)\nsuite[StaticMontgomeryModint[257u32]](35)\n\
    modint_barrett.setMod(998244353)\nsuite[modint_barrett](37)\nmodint_barrett.setMod(1000000007)\n\
    suite[modint_barrett](41)\nmodint_montgomery.setMod(998244353)\nsuite[modint_montgomery](43)\n\
    modint_montgomery.setMod(167772161)\nsuite[modint_montgomery](45)\nmodint_montgomery.setMod(1000000007)\n\
    suite[modint_montgomery](47)\necho \"Hello World\"\n"
  dependsOn:
  - cplib/convolution/algorithm_ntt.nim
  - cplib/convolution/algorithm_ntt.nim
  - cplib/math/inv_gcd.nim
  - cplib/modint/modint.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/isprime.nim
  - cplib/modint/modint.nim
  - cplib/fps/power_projection.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/fps/power_projection.nim
  - cplib/fps/formal_power_series.nim
  - cplib/math/isprime.nim
  - cplib/fps/composition.nim
  - cplib/fps/formal_power_series.nim
  - cplib/convolution/convolution.nim
  - cplib/convolution/convolution.nim
  - cplib/fps/composition.nim
  - cplib/math/isqrt.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  isVerificationFile: true
  path: verify/fps/composition_regression_test.nim
  requiredBy: []
  timestamp: '2026-10-08 06:34:57+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/fps/composition_regression_test.nim
layout: document
redirect_from:
- /verify/verify/fps/composition_regression_test.nim
- /verify/verify/fps/composition_regression_test.nim.html
title: verify/fps/composition_regression_test.nim
---
