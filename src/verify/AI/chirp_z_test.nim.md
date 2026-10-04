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
    path: cplib/fps/chirp_z.nim
    title: cplib/fps/chirp_z.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/chirp_z.nim
    title: cplib/fps/chirp_z.nim
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
    \nimport random, sequtils\nimport cplib/fps/chirp_z\nimport cplib/fps/product_tree\n\
    import cplib/modint/modint\n\nvar checks = 0\nproc check[T: BarrettModint or MontgomeryModint](f:\
    \ seq[T], a, r: T, m: int) =\n    let saved = f.mapIt(it.val)\n    var xs = newSeq[T](m)\n\
    \    var expected = newSeq[T](m)\n    var x = a\n    for i in 0..<m:\n       \
    \ xs[i] = x\n        for j in countdown(f.high, 0): expected[i] = expected[i]\
    \ * x + f[j]\n        x *= r\n    let actual = multipointEvaluationGeometric(f,\
    \ a, r, m)\n    doAssert actual == expected, $T & \" n=\" & $f.len & \" m=\" &\
    \ $m & \" a=\" & $a & \" r=\" & $r\n    if T.umod != 1: doAssert actual == multipointEvaluation(f,\
    \ xs)\n    doAssert chirpZ(f, r, m, a) == expected\n    if a == init(T, 1): doAssert\
    \ chirpZ(f, r, m) == expected\n    doAssert f.mapIt(it.val) == saved\n    inc\
    \ checks\n\nproc run[T: BarrettModint or MontgomeryModint]() =\n    var rng =\
    \ initRand(20261002)\n    for n in [0, 1, 2, 59, 60, 61, 63, 64, 65, 127, 129]:\n\
    \        var f = newSeq[T](n)\n        for j in 0..<n: f[j] = init(T, rng.rand(T.umod.int\
    \ - 1))\n        for m in [0, 1, 2, 7, 61, 65, 129]:\n            for r in [0,\
    \ 1, -1, 2, 3]:\n                check(f, init(T, 7), init(T, r), m)\n       \
    \     check(f, init(T, 0), init(T, 2), m)\n            check(f, init(T, 1), init(T,\
    \ 2), m)\n    for trial in 0..<40:\n        let n = rng.rand(257)\n        let\
    \ m = rng.rand(257)\n        var f = newSeq[T](n)\n        for j in 0..<n:\n \
    \           f[j] = init(T, if trial mod 5 == 0: 0 else: rng.rand(T.umod.int -\
    \ 1))\n        check(f, init(T, rng.rand(T.umod.int - 1)), init(T, rng.rand(T.umod.int\
    \ - 1)), m)\n    let large = @[init(T, high(int)), init(T, low(int)), init(T,\
    \ 0), init(T, high(int) - 17)]\n    check(large, init(T, high(int)), init(T, low(int)),\
    \ 67)\n    check(large, init(T, low(int)), init(T, high(int)), 67)\n\nproc exhaustive[T:\
    \ BarrettModint or MontgomeryModint](maxN: int) =\n    let p = T.umod.int\n  \
    \  var count = 1\n    for n in 0..maxN:\n        for encoded in 0..<count:\n \
    \           var f = newSeq[T](n)\n            var code = encoded\n           \
    \ for j in 0..<n:\n                f[j] = init(T, code mod p)\n              \
    \  code = code div p\n            for a in 0..<p:\n                for r in 0..<p:\n\
    \                    for m in 0..4: check(f, init(T, a), init(T, r), m)\n    \
    \    count *= p\n\ndeclarStaticBarrettModint(Mint3, 3u32)\ndeclarStaticMontgomeryModint(Mint5,\
    \ 5u32)\ndeclarStaticBarrettModint(CompositeBarrett, 129u32)\ndeclarStaticMontgomeryModint(CompositeMontgomery,\
    \ 129u32)\nexhaustive[Mint3](3)\nexhaustive[Mint5](2)\nrun[modint998244353_barrett]()\n\
    run[modint998244353_montgomery]()\nrun[modint1000000007_barrett]()\nrun[modint1000000007_montgomery]()\n\
    run[CompositeBarrett]()\nrun[CompositeMontgomery]()\nfor modulus in [17, 998244353,\
    \ 129, 1000000007, 9, 17]:\n    modint_barrett.setMod(modulus)\n    modint_montgomery.setMod(modulus)\n\
    \    run[modint_barrett]()\n    run[modint_montgomery]()\nmodint_barrett.setMod(1)\n\
    check(@[init(modint_barrett, 7), init(modint_barrett, 9)], init(modint_barrett,\
    \ 3), init(modint_barrett, 2), 5)\ndoAssert checks == 16134\necho \"Hello World\"\
    \n"
  dependsOn:
  - cplib/modint/montgomery_impl.nim
  - cplib/fps/chirp_z.nim
  - cplib/fps/formal_power_series.nim
  - cplib/math/isprime.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/fps/formal_power_series.nim
  - cplib/fps/product_tree.nim
  - cplib/fps/product_tree.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/fps/chirp_z.nim
  - cplib/convolution/convolution.nim
  - cplib/math/inv_gcd.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/math/inv_gcd.nim
  - cplib/convolution/convolution.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isprime.nim
  isVerificationFile: true
  path: verify/AI/chirp_z_test.nim
  requiredBy: []
  timestamp: '2026-10-05 00:27:38+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/chirp_z_test.nim
layout: document
redirect_from:
- /verify/verify/AI/chirp_z_test.nim
- /verify/verify/AI/chirp_z_test.nim.html
title: verify/AI/chirp_z_test.nim
---
