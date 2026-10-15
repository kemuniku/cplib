---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/private/subset_convolution_barrett.nim
    title: cplib/convolution/private/subset_convolution_barrett.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/private/subset_convolution_barrett.nim
    title: cplib/convolution/private/subset_convolution_barrett.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/subset_convolution.nim
    title: cplib/convolution/subset_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/subset_convolution.nim
    title: cplib/convolution/subset_convolution.nim
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
    import random, bitops\nimport cplib/convolution/subset_convolution\nimport cplib/modint/modint\n\
    \nproc oracle(a, b: seq[int], modulus: int): seq[int] =\n    result = newSeq[int](a.len)\n\
    \    for mask in 0..<a.len:\n        var sub = mask\n        while true:\n   \
    \         result[mask] = int((uint64(result[mask]) + uint64(a[sub]) * uint64(b[mask\
    \ xor sub])) mod uint64(modulus))\n            if sub == 0: break\n          \
    \  sub = (sub - 1) and mask\n\nproc check[T](a, b: seq[int]) =\n    var left,\
    \ right = newSeq[T](a.len)\n    for i in 0..<a.len:\n        left[i] = init(T,\
    \ a[i])\n        right[i] = init(T, b[i])\n    let expected = oracle(a, b, T.umod.int)\n\
    \    let actual = subsetConvolution(left, right)\n    let square = subsetConvolution(left,\
    \ left)\n    let squareExpected = oracle(a, a, T.umod.int)\n    for i in 0..<a.len:\n\
    \        doAssert actual[i].val == expected[i]\n        doAssert square[i].val\
    \ == squareExpected[i]\n        doAssert left[i].val == a[i] and right[i].val\
    \ == b[i]\n\nfor n in 0..3:\n    let size = 1 shl n\n    for x in 0..<(1 shl size):\n\
    \        for y in 0..<(1 shl size):\n            var a, b = newSeq[int](size)\n\
    \            for i in 0..<size:\n                a[i] = (x shr i) and 1\n    \
    \            b[i] = (y shr i) and 1\n            var expected = newSeq[int](size)\n\
    \            for mask in 0..<size:\n                var sub = mask\n         \
    \       while true:\n                    expected[mask] += a[sub] * b[mask xor\
    \ sub]\n                    if sub == 0: break\n                    sub = (sub\
    \ - 1) and mask\n            doAssert subsetConvolution(a, b) == expected\n  \
    \          check[modint998244353_barrett](a, b)\n\nvar rng = initRand(937)\nmodint_barrett.setMod(998244353)\n\
    modint_montgomery.setMod(998244353)\nfor n in 0..9:\n    for repeat in 0..<20:\n\
    \        var a, b = newSeq[int](1 shl n)\n        for i in 0..<a.len:\n      \
    \      a[i] = rng.rand(998244352)\n            b[i] = rng.rand(998244352)\n  \
    \      check[modint998244353_barrett](a, b)\n        check[modint998244353_montgomery](a,\
    \ b)\n        check[modint_barrett](a, b)\n        check[modint_montgomery](a,\
    \ b)\n    for edge in [0, 1, 998244352]:\n        var a, b = newSeq[int](1 shl\
    \ n)\n        for i in 0..<a.len: a[i] = edge\n        b[0] = 1\n        check[modint998244353_barrett](a,\
    \ b)\n        check[modint998244353_montgomery](a, b)\n        for i in 0..<b.len:\
    \ b[i] = edge\n        check[modint998244353_barrett](a, b)\n        check[modint998244353_montgomery](a,\
    \ b)\nfor modulus in [2, 3, 5, 9, 1000000007]:\n    modint_barrett.setMod(modulus)\n\
    \    for repeat in 0..<20:\n        var a, b = newSeq[int](64)\n        for i\
    \ in 0..<a.len:\n            a[i] = rng.rand(modulus - 1)\n            b[i] =\
    \ rng.rand(modulus - 1)\n        check[modint_barrett](a, b)\n    if modulus mod\
    \ 2 == 1:\n        modint_montgomery.setMod(modulus)\n        for repeat in 0..<20:\n\
    \            var a, b = newSeq[int](64)\n            for i in 0..<a.len:\n   \
    \             a[i] = rng.rand(modulus - 1)\n                b[i] = rng.rand(modulus\
    \ - 1)\n            check[modint_montgomery](a, b)\nfor repeat in 0..<30:\n  \
    \  var a, b = newSeq[int](256)\n    for i in 0..<a.len:\n        a[i] = rng.rand(8)\
    \ - 4\n        b[i] = rng.rand(8) - 4\n    var expected = newSeq[int](a.len)\n\
    \    for i in 0..<a.len:\n        for j in 0..<a.len:\n            if (i and j)\
    \ == 0: expected[i or j] += a[i] * b[j]\n    doAssert subsetConvolution(a, b)\
    \ == expected\n\nproc checkStatic[T]() =\n    check[T](@[], @[])\n    for n in\
    \ 0..8:\n        var a, b = newSeq[int](1 shl n)\n        for i in 0..<a.len:\n\
    \            a[i] = rng.rand(T.umod.int - 1)\n            b[i] = rng.rand(T.umod.int\
    \ - 1)\n        check[T](a, b)\n        for i in 0..<a.len:\n            a[i]\
    \ = T.umod.int - 1\n            b[i] = T.umod.int - 1\n        check[T](a, b)\n\
    checkStatic[StaticBarrettModint[1u32]]()\ncheckStatic[StaticBarrettModint[2u32]]()\n\
    checkStatic[StaticBarrettModint[9u32]]()\ncheckStatic[modint1000000007_barrett]()\n\
    checkStatic[StaticBarrettModint[1073741824u32]]()\ncheckStatic[StaticBarrettModint[1073741825u32]]()\n\
    \nvar overflowed = false\ntry: discard subsetConvolution(@[high(int)], @[2])\n\
    except OverflowDefect: overflowed = true\ndoAssert overflowed\necho \"Hello World\"\
    \n"
  dependsOn:
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/convolution/private/subset_convolution_barrett.nim
  - cplib/modint/modint.nim
  - cplib/convolution/subset_convolution.nim
  - cplib/convolution/subset_convolution.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/convolution/private/subset_convolution_barrett.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  isVerificationFile: true
  path: verify/set_power_series/subset_convolution_regression_test.nim
  requiredBy: []
  timestamp: '2026-10-08 06:34:57+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/set_power_series/subset_convolution_regression_test.nim
layout: document
redirect_from:
- /verify/verify/set_power_series/subset_convolution_regression_test.nim
- /verify/verify/set_power_series/subset_convolution_regression_test.nim.html
title: verify/set_power_series/subset_convolution_regression_test.nim
---
