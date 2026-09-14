---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/gcd_convolution.nim
    title: cplib/convolution/gcd_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/gcd_convolution.nim
    title: cplib/convolution/gcd_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/lcm_convolution.nim
    title: cplib/convolution/lcm_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/lcm_convolution.nim
    title: cplib/convolution/lcm_convolution.nim
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
    \nimport math, random, sequtils\nimport cplib/convolution/gcd_convolution\nimport\
    \ cplib/convolution/lcm_convolution\nimport cplib/modint/modint\n\nproc check[T](a,\
    \ b: seq[T]) =\n    let originalA = a\n    let originalB = b\n    var expectedGcd\
    \ = newSeqWith(a.len, T(0))\n    var expectedLcm = newSeqWith(a.len, T(0))\n \
    \   for i in 0..<a.len:\n        for j in 0..<b.len:\n            let g = gcd(i,\
    \ j)\n            let l = if i == 0 or j == 0: 0 else: i div g * j\n         \
    \   expectedGcd[g] += a[i] * b[j]\n            if l < a.len:\n               \
    \ expectedLcm[l] += a[i] * b[j]\n    let actualGcd = gcd_convolution(a, b)\n \
    \   let actualLcm = lcm_convolution(a, b)\n    when T is int:\n        assert\
    \ actualGcd == expectedGcd\n        assert actualLcm == expectedLcm\n    else:\n\
    \        assert actualGcd.mapIt(it.val) == expectedGcd.mapIt(it.val)\n       \
    \ assert actualLcm.mapIt(it.val) == expectedLcm.mapIt(it.val)\n    assert a ==\
    \ originalA\n    assert b == originalB\n\ncheck(newSeq[int](), newSeq[int]())\n\
    check(@[2], @[3])\nassert gcdConvolution(@[0, 1, 2], @[0, 3, 4]) == @[0, 13, 8]\n\
    assert lcmConvolution(@[0, 1, 2], @[0, 3, 4]) == @[0, 3, 18]\nassert gcdConvolution(@[2,\
    \ 1, 2], @[3, 3, 4]) == @[6, 22, 22]\nassert lcmConvolution(@[2, 1, 2], @[3, 3,\
    \ 4]) == @[29, 3, 18]\n\nfor i in 0..<17:\n    for j in 0..<17:\n        var a\
    \ = newSeq[int](17)\n        var b = newSeq[int](17)\n        a[i] = 1\n     \
    \   b[j] = 1\n        check(a, b)\n\nvar rng = initRand(42)\nfor n in [0, 1, 2,\
    \ 3, 4, 7, 16, 31, 64, 100, 127]:\n    for trial in 0..<10:\n        let a = newSeqWith(n,\
    \ rng.rand(-100..100))\n        let b = newSeqWith(n, rng.rand(-100..100))\n \
    \       check(a, b)\n        check(a, a)\n        check(a, newSeq[int](n))\n \
    \       check(a.mapIt(modint998244353_barrett(it)),\n            b.mapIt(modint998244353_barrett(it)))\n\
    \        check(a.mapIt(modint998244353_montgomery(it)),\n            b.mapIt(modint998244353_montgomery(it)))\n\
    \nfor invalid in [(newSeq[int](), @[1]), (@[1], @[1, 2])]:\n    var rejectedGcd\
    \ = false\n    var rejectedLcm = false\n    try:\n        discard gcdConvolution(invalid[0],\
    \ invalid[1])\n    except AssertionDefect:\n        rejectedGcd = true\n    try:\n\
    \        discard lcmConvolution(invalid[0], invalid[1])\n    except AssertionDefect:\n\
    \        rejectedLcm = true\n    assert rejectedGcd and rejectedLcm\n\necho \"\
    Hello World\"\n"
  dependsOn:
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/convolution/gcd_convolution.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/convolution/gcd_convolution.nim
  - cplib/convolution/lcm_convolution.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/convolution/lcm_convolution.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  isVerificationFile: true
  path: verify/AI/gcd_lcm_convolution_test.nim
  requiredBy: []
  timestamp: '2026-09-13 17:15:27+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/gcd_lcm_convolution_test.nim
layout: document
redirect_from:
- /verify/verify/AI/gcd_lcm_convolution_test.nim
- /verify/verify/AI/gcd_lcm_convolution_test.nim.html
title: verify/AI/gcd_lcm_convolution_test.nim
---
