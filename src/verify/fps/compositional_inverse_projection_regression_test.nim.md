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
    \nimport random\nimport cplib/fps/composition\nimport cplib/modint/modint\nimport\
    \ cplib/fps/power_projection\n\nproc naiveCompose[T](f, g: seq[T], n: int): seq[T]\
    \ =\n    doAssert g.len == 0 or g[0].val == 0\n    result = newSeq[T](n)\n   \
    \ var power = newSeq[T](n)\n    power[0] = init(T, 1)\n    for k in 0..<min(f.len,\
    \ n):\n        for i in k..<n: result[i] += f[k] * power[i]\n        var next\
    \ = newSeq[T](n)\n        for i in k..<n:\n            for j in 1..<min(g.len,\
    \ n-i): next[i+j] += power[i] * g[j]\n        power = move(next)\n\nproc oracle[T](f:\
    \ seq[T], n: int): seq[T] =\n    result = newSeq[T](n)\n    var powers = newSeq[seq[T]](n)\n\
    \    for i in 0..<n: powers[i] = newSeq[T](n)\n    let slopeInverse = f[1].inv\n\
    \    for degree in 1..<n:\n        for exponent in 2..degree:\n            for\
    \ j in 1..<degree:\n                powers[exponent][degree] += result[j] * powers[exponent\
    \ - 1][degree - j]\n        for exponent in 2..<min(f.len, degree + 1):\n    \
    \        result[degree] -= f[exponent] * powers[exponent][degree]\n        result[degree]\
    \ *= slopeInverse\n        if degree == 1: result[degree] = slopeInverse\n   \
    \     powers[1][degree] = result[degree]\n\nvar checked = 0\nproc check[T](f:\
    \ seq[T], n: int, useOracle = true) =\n    let g = f.compositionalInverse(n)\n\
    \    doAssert g.len == max(n, 0)\n    if n <= 0: return\n    var identity = newSeq[T](n)\n\
    \    if n > 1: identity[1] = init(T, 1)\n    doAssert naiveCompose(f, g, n) ==\
    \ identity\n    doAssert naiveCompose(g, f, n) == identity\n    if useOracle:\
    \ doAssert g == oracle(f, n)\n    inc checked\n\nproc suite[T](seed: int) =\n\
    \    var rng = initRand(seed)\n    for n in [-1, 0, 1, 2, 3, 4, 7, 8, 9, 15, 16,\
    \ 17, 31, 32, 33, 60, 61, 63, 64, 65, 66, 127, 128, 129, 130, 255, 256, 257]:\n\
    \        for rep in 0..<3:\n            var f = newSeq[T](max(2, n + (rep-1)*3))\n\
    \            f[1] = init(T, 1 + rng.rand(15))\n            for i in 2..<f.len:\
    \ f[i] = init(T, rng.rand(1000))\n            check(f, n, n <= 66)\n    for rep\
    \ in 0..<120:\n        let n = rng.rand(2..80)\n        var f = newSeq[T](n)\n\
    \        f[1] = init(T, rng.rand(1..1000))\n        for i in 2..<n: f[i] = init(T,\
    \ rng.rand(1000))\n        check(f, n, n <= 30)\n    for n in [64, 65, 127, 128,\
    \ 129, 257]:\n        check(@[init(T, 0), init(T, 7)], n, false)\n        var\
    \ f = newSeq[T](n)\n        f[1] = init(T, 1)\n        f[^1] = init(T, 19)\n \
    \       check(f, n, false)\n\nsuite[modint998244353_barrett](17)\nsuite[modint998244353_montgomery](23)\n\
    suite[modint1000000007_barrett](29)\nsuite[modint1000000007_montgomery](31)\n\
    type Tiny = StaticBarrettModint[5u32]\nvar combinations = 1\nfor n in 2..6:\n\
    \    for code in 0..<combinations:\n        for linear in 1..4:\n            var\
    \ f = newSeq[Tiny](n)\n            f[1] = init(Tiny, linear)\n            var\
    \ value = code\n            for i in 2..<n:\n                f[i] = init(Tiny,\
    \ value mod 5)\n                value = value div 5\n            check(f, n)\n\
    \    combinations *= 5\nfor n in [63, 64, 65]: check(@[init(Tiny, 0), init(Tiny,\
    \ 2), init(Tiny, 1)], n, false)\ntype Boundary = StaticBarrettModint[97u32]\n\
    for n in [63, 64, 65, 96, 97, 98, 129]:\n    check(@[init(Boundary, 0), init(Boundary,\
    \ 7), init(Boundary, 5), init(Boundary, 3)], n, false)\ntype Ring = StaticBarrettModint[9u32]\n\
    for n in [2, 7, 64, 65]:\n    for linear in [1, 2, 4, 5, 7, 8]:\n        check(@[init(Ring,\
    \ 0), init(Ring, linear), init(Ring, 3), init(Ring, 4)], n, false)\nmodint_barrett.setMod(998244353)\n\
    suite[modint_barrett](37)\nmodint_montgomery.setMod(998244353)\nsuite[modint_montgomery](41)\n\
    doAssert checked == 4418\nproc projectionSuite[T]() =\n    var rng = initRand(47)\n\
    \    for n in [1, 2, 3, 7, 8, 9, 31, 32, 33, 63, 64, 65]:\n        for constant\
    \ in [0, 1, 2]:\n            var f, g = newSeq[T](n)\n            f[0] = init(T,\
    \ constant)\n            for i in 1..<n: f[i] = init(T, rng.rand(1000))\n    \
    \        for i in 0..<n: g[i] = init(T, rng.rand(1000))\n            for m in\
    \ [0, n-1, n, 2*n]:\n                let got = f.powerProjection(g, m)\n     \
    \           var power = g\n                for k in 0..m:\n                  \
    \  doAssert got[k] == power[n-1]\n                    var next = newSeq[T](n)\n\
    \                    for i in 0..<n:\n                        for j in 0..<n-i:\
    \ next[i+j] += power[i] * f[j]\n                    power = move(next)\nprojectionSuite[modint998244353_barrett]()\n\
    projectionSuite[modint998244353_montgomery]()\necho \"Hello World\"\n"
  dependsOn:
  - cplib/modint/montgomery_impl.nim
  - cplib/fps/formal_power_series.nim
  - cplib/fps/composition.nim
  - cplib/fps/power_projection.nim
  - cplib/math/isprime.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/fps/composition.nim
  - cplib/fps/power_projection.nim
  - cplib/math/isqrt.nim
  - cplib/fps/formal_power_series.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/convolution/convolution.nim
  - cplib/math/inv_gcd.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/math/inv_gcd.nim
  - cplib/convolution/convolution.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isprime.nim
  isVerificationFile: true
  path: verify/fps/compositional_inverse_projection_regression_test.nim
  requiredBy: []
  timestamp: '2026-10-05 00:47:58+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/fps/compositional_inverse_projection_regression_test.nim
layout: document
redirect_from:
- /verify/verify/fps/compositional_inverse_projection_regression_test.nim
- /verify/verify/fps/compositional_inverse_projection_regression_test.nim.html
title: verify/fps/compositional_inverse_projection_regression_test.nim
---
