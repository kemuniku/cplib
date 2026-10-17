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
    path: cplib/fps/polynomial_interpolation.nim
    title: cplib/fps/polynomial_interpolation.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/polynomial_interpolation.nim
    title: cplib/fps/polynomial_interpolation.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/power_projection.nim
    title: cplib/fps/power_projection.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/power_projection.nim
    title: cplib/fps/power_projection.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/product_tree.nim
    title: cplib/fps/product_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/product_tree.nim
    title: cplib/fps/product_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/sparse_formal_power_series.nim
    title: cplib/fps/sparse_formal_power_series.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/sparse_formal_power_series.nim
    title: cplib/fps/sparse_formal_power_series.nim
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
    \nimport random, options\nimport cplib/convolution/algorithm_ntt\nimport cplib/convolution/relaxed_convolution\n\
    import cplib/fps/formal_power_series\nimport cplib/fps/power_projection\nimport\
    \ cplib/fps/product_tree\ninclude cplib/fps/polynomial_interpolation\ninclude\
    \ cplib/fps/sparse_formal_power_series\n\nproc naive[T](a, b: seq[T]): seq[T]\
    \ =\n    if a.len == 0 or b.len == 0: return @[]\n    result = newSeq[T](a.len\
    \ + b.len - 1)\n    for i in 0..<a.len:\n        for j in 0..<b.len: result[i+j]\
    \ += a[i] * b[j]\n\nproc check[T]() =\n    var rng = initRand(796231)\n    for\
    \ n in [1, 31, 32, 33, 63, 64, 65, 127, 128, 129, 255, 256, 257, 513]:\n     \
    \   var a, b, xs = newSeq[T](n)\n        for i in 0..<n:\n            a[i] = -init(T,\
    \ rng.rand(T.umod.int - 1))\n            b[i] = -init(T, rng.rand(T.umod.int -\
    \ 1))\n            xs[i] = init(T, i)\n        let product = naive(a, b)\n   \
    \     var online = initRelaxedConvolution[T](product.len)\n        for i in 0..<product.len:\n\
    \            let x = if i < n: a[i] else: init(T, 0)\n            let y = if i\
    \ < n: b[i] else: init(T, 0)\n            doAssert online.add(x, y) == product[i]\n\
    \        let tree = initPolynomialProductTree[T](xs)\n        let ys = evaluate[T](tree,\
    \ a)\n        for i in 0..<n: doAssert ys[i] == a.eval(xs[i])\n        doAssert\
    \ polynomialInterpolation[T](xs, ys) == a\n        let longValues = multipointEvaluation[T](product,\
    \ xs)\n        for i in 0..<n: doAssert longValues[i] == product.eval(xs[i])\n\
    \        if n <= 65:\n            for constant in 0..1:\n                a[0]\
    \ = init(T, constant)\n                let projected = a.powerProjection(b, n\
    \ + 3)\n                var power = b\n                for k in 0..n+3:\n    \
    \                doAssert projected[k] == power[n - 1]\n                    power\
    \ = naive(power, a)\n                    power.setLen(n)\n    for dimension in\
    \ [2, 3]:\n        var left, right = newSeq[seq[T]](dimension * dimension)\n \
    \       for i in 0..<left.len:\n            if i mod 3 != 0:\n               \
    \ left[i] = newSeq[T](63 + i)\n                for x in left[i].mitems: x = -init(T,\
    \ rng.rand(T.umod.int - 1))\n            if i mod 4 != 0:\n                right[i]\
    \ = newSeq[T](65 + i)\n                for x in right[i].mitems: x = -init(T,\
    \ rng.rand(T.umod.int - 1))\n        let got = multiplyPolynomialMatrices[T](left,\
    \ right, dimension)\n        for row in 0..<dimension:\n            for column\
    \ in 0..<dimension:\n                var expected: seq[T]\n                for\
    \ k in 0..<dimension:\n                    let product = naive(left[row * dimension\
    \ + k], right[k * dimension + column])\n                    if expected.len <\
    \ product.len: expected.setLen(product.len)\n                    for i in 0..<product.len:\
    \ expected[i] += product[i]\n                doAssert got[row * dimension + column]\
    \ == expected\n\ncheck[modint998244353_barrett]()\ncheck[modint998244353_montgomery]()\n\
    check[modint1000000007_barrett]()\nfor p in [167772161, 998244353]:\n    modint_barrett.setMod(p)\n\
    \    modint_montgomery.setMod(p)\n    check[modint_barrett]()\n    check[modint_montgomery]()\n\
    \nproc largeNewtonSteps[T]() =\n    const n = 65537\n    var f = newSeq[T](n)\n\
    \    for i in 1..<n: f[i] = init(T, i * i + 5)\n    let e = f.exp(n)\n    doAssert\
    \ e.log(n) == f\n    f[0] = init(T, 1)\n    let root = f.sqrt(n).get\n    doAssert\
    \ prefix(root * root, n) == f\n\nlargeNewtonSteps[modint998244353_barrett]()\n\
    largeNewtonSteps[modint998244353_montgomery]()\n\nblock sparseCoefficients:\n\
    \    type T = modint998244353_barrett\n    const degree = 20000\n    let f = sfps[T](3*x\
    \ + 7*x^2)\n    doAssert f.expCoefficient(degree) == f.exp(degree + 1)[degree]\n\
    \    let unit = f + 1\n    doAssert unit.powCoefficient(123456, degree) == unit.pow(123456,\
    \ degree + 1)[degree]\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/convolution/convolution.nim
  - cplib/fps/product_tree.nim
  - cplib/convolution/relaxed_convolution.nim
  - cplib/fps/formal_power_series.nim
  - cplib/fps/sparse_formal_power_series.nim
  - cplib/fps/polynomial_interpolation.nim
  - cplib/math/isprime.nim
  - cplib/convolution/algorithm_ntt.nim
  - cplib/fps/bostan_mori.nim
  - cplib/fps/power_projection.nim
  - cplib/fps/bostan_mori.nim
  - cplib/math/isqrt.nim
  - cplib/math/isprime.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/inv_gcd.nim
  - cplib/fps/polynomial_interpolation.nim
  - cplib/convolution/relaxed_convolution.nim
  - cplib/modint/modint.nim
  - cplib/fps/formal_power_series.nim
  - cplib/fps/power_projection.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/inv_gcd.nim
  - cplib/fps/product_tree.nim
  - cplib/modint/barrett_impl.nim
  - cplib/convolution/convolution.nim
  - cplib/convolution/algorithm_ntt.nim
  - cplib/math/isqrt.nim
  - cplib/fps/sparse_formal_power_series.nim
  - cplib/convolution/ntt.nim
  - cplib/modint/modint.nim
  - cplib/modint/barrett_impl.nim
  - cplib/convolution/ntt.nim
  isVerificationFile: true
  path: verify/fps/algorithm_ntt_regression_test.nim
  requiredBy: []
  timestamp: '2026-10-08 06:34:57+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/fps/algorithm_ntt_regression_test.nim
layout: document
redirect_from:
- /verify/verify/fps/algorithm_ntt_regression_test.nim
- /verify/verify/fps/algorithm_ntt_regression_test.nim.html
title: verify/fps/algorithm_ntt_regression_test.nim
---
