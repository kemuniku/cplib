---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/bitwise_and_convolution.nim
    title: cplib/convolution/bitwise_and_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/bitwise_and_convolution.nim
    title: cplib/convolution/bitwise_and_convolution.nim
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
    \nimport random, sequtils\nimport cplib/convolution/bitwise_and_convolution\n\
    import cplib/modint/modint\n\nproc naive[T](a, b: seq[T]): seq[T] =\n    result\
    \ = newSeqWith(a.len, T(0))\n    for i in 0..<a.len:\n        for j in 0..<b.len:\n\
    \            result[i and j] += a[i] * b[j]\n\nproc check[T](a, b: seq[T]) =\n\
    \    let originalA = a\n    let originalB = b\n    let actual = bitwise_and_convolution(a,\
    \ b)\n    let expected = naive(a, b)\n    when T is int:\n        assert actual\
    \ == expected\n    else:\n        assert actual.mapIt(it.val) == expected.mapIt(it.val)\n\
    \    assert a == originalA\n    assert b == originalB\n\nassert bitwiseAndConvolution(newSeq[int](),\
    \ newSeq[int]()) == newSeq[int]()\nassert bitwiseAndConvolution(@[2], @[3]) ==\
    \ @[6]\nassert bitwiseAndConvolution(@[1, 2], @[3, 4]) == @[13, 8]\n\nvar rng\
    \ = initRand(42)\nfor exponent in 0..7:\n    let n = 1 shl exponent\n    for trial\
    \ in 0..<10:\n        let a = newSeqWith(n, rng.rand(-100..100))\n        let\
    \ b = newSeqWith(n, rng.rand(-100..100))\n        check(a, b)\n        check(a,\
    \ a)\n        check(a.mapIt(modint998244353_barrett(it)),\n            b.mapIt(modint998244353_barrett(it)))\n\
    \        check(a.mapIt(modint998244353_montgomery(it)),\n            b.mapIt(modint998244353_montgomery(it)))\n\
    \nfor invalid in [(@[1], @[1, 2]), (@[1, 2, 3], @[4, 5, 6])]:\n    var rejected\
    \ = false\n    try:\n        discard bitwiseAndConvolution(invalid[0], invalid[1])\n\
    \    except AssertionDefect:\n        rejected = true\n    assert rejected\n\n\
    echo \"Hello World\"\n"
  dependsOn:
  - cplib/convolution/bitwise_and_convolution.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/math/isqrt.nim
  - cplib/convolution/bitwise_and_convolution.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  isVerificationFile: true
  path: verify/AI/bitwise_and_convolution_test.nim
  requiredBy: []
  timestamp: '2026-09-13 17:15:27+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/bitwise_and_convolution_test.nim
layout: document
redirect_from:
- /verify/verify/AI/bitwise_and_convolution_test.nim
- /verify/verify/AI/bitwise_and_convolution_test.nim.html
title: verify/AI/bitwise_and_convolution_test.nim
---
