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
    import sequtils\nimport cplib/fps/product_tree\nimport cplib/convolution/convolution\n\
    import cplib/modint/modint\n\ndeclarStaticBarrettModint(Mint257, 257u32)\ndeclarStaticMontgomeryModint(MintNearLimit,\
    \ 1073692673u32)\n\nproc check[T: BarrettModint or MontgomeryModint](\n    M:\
    \ typedesc[T], n, m, mode: int, primitive: int) =\n    var size = 1\n    while\
    \ size < m: size *= 2\n    let supports = (T.umod.int - 1) mod size == 0\n   \
    \ let root = if supports: init(T, primitive).pow(\n        (T.umod.int - 1) div\
    \ size) else: init(T, 1)\n    var f = newSeq[T](n)\n    var xs = newSeq[T](m)\n\
    \    for i in 0..<n:\n        f[i] = init(T, i * i * 13 + i * 31 + 19)\n     \
    \   if i mod 3 == 0: f[i] = init(T, -1 - i)\n        if mode == 3: f[i] = init(T,\
    \ 0)\n    for i in 0..<m:\n        case mode\n        of 0: xs[i] = root.pow(i)\n\
    \        of 1: xs[i] = root.pow(i mod 3)\n        of 2:\n            xs[i] = if\
    \ i mod 3 == 0: init(T, 0)\n                elif i mod 3 == 1: root.pow(i) else:\
    \ init(T, i + 2)\n        else: xs[i] = init(T, -1)\n    let savedF = f.mapIt(it.val)\n\
    \    let savedXs = xs.mapIt(it.val)\n    let actual = multipointEvaluation(f,\
    \ xs)\n    doAssert actual == multipointEvaluation(f, xs)\n    doAssert f.mapIt(it.val)\
    \ == savedF\n    doAssert xs.mapIt(it.val) == savedXs\n    doAssert actual.len\
    \ == m\n    for i in 0..<m:\n        var expected = init(T, 0)\n        for j\
    \ in countdown(n - 1, 0):\n            expected = expected * xs[i] + f[j]\n  \
    \      doAssert actual[i] == expected,\n            $M & \" n=\" & $n & \" m=\"\
    \ & $m & \" mode=\" & $mode & \" i=\" & $i\n\nproc run[T: BarrettModint or MontgomeryModint](\n\
    \    M: typedesc[T], primitive: int) =\n    for m in [0, 1, 15, 16, 17, 31, 32,\
    \ 33, 63, 64, 65,\n        127, 128, 129, 255, 256, 257]:\n        for n in [0,\
    \ 1, 17, max(0, m - 1), m, m + 1, 2 * m + 1]:\n            for mode in 0..3:\n\
    \                check(M, n, m, mode, primitive)\n    var a = newSeq[T](65)\n\
    \    var b = newSeq[T](73)\n    for i in 0..<a.len: a[i] = init(T, -1 - i * 999983)\n\
    \    for i in 0..<b.len: b[i] = init(T, -1 - i * 1000003)\n    doAssert convolution(a,\
    \ b) == convolution_naive(a, b)\n    let product = convolution_naive(a, b)\n \
    \   var cyclic = newSeq[T](128)\n    for i in 0..<product.len: cyclic[i mod 128]\
    \ += product[i]\n    doAssert convolutionCyclicPowerOfTwo(a, b, 128) == cyclic\n\
    \nrun(modint998244353_barrett, 3)\nrun(modint998244353_montgomery, 3)\nrun(Mint257,\
    \ 3)\nrun(MintNearLimit, 3)\nrun(modint1000000007_barrett, 5)\nfor modulus in\
    \ [998244353, 257, 1000000007, 17, 998244353]:\n    modint_barrett.setMod(modulus)\n\
    \    modint_montgomery.setMod(modulus)\n    run(modint_barrett, 3)\n    run(modint_montgomery,\
    \ 3)\necho \"Hello World\"\n"
  dependsOn:
  - cplib/convolution/convolution.nim
  - cplib/math/isqrt.nim
  - cplib/fps/product_tree.nim
  - cplib/fps/formal_power_series.nim
  - cplib/modint/modint.nim
  - cplib/math/isprime.nim
  - cplib/modint/barrett_impl.nim
  - cplib/fps/formal_power_series.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/inv_gcd.nim
  - cplib/convolution/convolution.nim
  - cplib/fps/product_tree.nim
  - cplib/math/isprime.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/inv_gcd.nim
  isVerificationFile: true
  path: verify/AI/multipoint_cyclic_ntt_test.nim
  requiredBy: []
  timestamp: '2026-10-02 22:16:44+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/multipoint_cyclic_ntt_test.nim
layout: document
redirect_from:
- /verify/verify/AI/multipoint_cyclic_ntt_test.nim
- /verify/verify/AI/multipoint_cyclic_ntt_test.nim.html
title: verify/AI/multipoint_cyclic_ntt_test.nim
---
