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
    path: cplib/math/bigint.nim
    title: cplib/math/bigint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/bigint.nim
    title: cplib/math/bigint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
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
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
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
    import random\nimport cplib/math/bigint\n\nproc checkBitwise(a, b: int) =\n  \
    \  let x = initBigInt(a)\n    let y = initBigInt(b)\n    doAssert (x and y) ==\
    \ initBigInt(a and b)\n    doAssert (x or y) == initBigInt(a or b)\n    doAssert\
    \ (x xor y) == initBigInt(a xor b)\n    doAssert (not x) == initBigInt(not a)\n\
    \    doAssert (x and b) == (a and y)\n    doAssert (x or b) == (a or y)\n    doAssert\
    \ (x xor b) == (a xor y)\n\nfor a in -40..40:\n    for b in -40..40:\n       \
    \ checkBitwise(a, b)\nfor a in [low(int), low(int) + 1, -1, 0, 1, high(int)]:\n\
    \    for b in [low(int), low(int) + 1, -1, 0, 1, high(int)]:\n        checkBitwise(a,\
    \ b)\nvar rng = initRand(20260913)\nfor _ in 0..<1000:\n    checkBitwise(rng.rand(low(int)..high(int)),\
    \ rng.rand(low(int)..high(int)))\n\nfor width in [0, 1, 29, 30, 31, 32, 33, 63,\
    \ 64, 65, 127, 128, 129, 1024]:\n    let power = initBigInt(2).pow(width)\n  \
    \  doAssert (initBigInt(1) shl width) == power\n    for x in [power - 1, power,\
    \ power + 1, -power - 1, -power, -power + 1]:\n        let original = $x\n   \
    \     doAssert (not x) == -x - 1\n        doAssert (not (not x)) == x\n      \
    \  doAssert (x and (not x)) == 0\n        doAssert (x or (not x)) == -1\n    \
    \    doAssert (x xor (not x)) == -1\n        doAssert (x and -1) == x\n      \
    \  doAssert (x or 0) == x\n        doAssert (x xor x) == 0\n        doAssert (x\
    \ shr high(int)) == (if x < 0: -1 else: 0)\n        for shift in [0, 1, 31, 32,\
    \ 33, 63, 64, 65, 129, 1025]:\n            let factor = initBigInt(2).pow(shift)\n\
    \            doAssert (x shl shift) == x * factor\n            doAssert (x shr\
    \ shift) == x // factor\n            doAssert ((x shl shift) shr shift) == x\n\
    \            var assigned = x\n            `shl=`(assigned, shift)\n         \
    \   doAssert assigned == x * factor\n            `shr=`(assigned, shift)\n   \
    \         doAssert assigned == x\n        let y = initBigInt(\"1234567890123456789012345678901234567890\"\
    )\n        doAssert (not (x and y)) == ((not x) or (not y))\n        doAssert\
    \ (not (x or y)) == ((not x) and (not y))\n        var assigned = x\n        `and=`(assigned,\
    \ y)\n        doAssert assigned == (x and y)\n        assigned = x\n        `or=`(assigned,\
    \ y)\n        doAssert assigned == (x or y)\n        assigned = x\n        `xor=`(assigned,\
    \ y)\n        doAssert assigned == (x xor y)\n        assigned = x\n        `and=`(assigned,\
    \ assigned)\n        doAssert assigned == x\n        `or=`(assigned, assigned)\n\
    \        doAssert assigned == x\n        `xor=`(assigned, assigned)\n        doAssert\
    \ assigned == 0\n        doAssert (x xor x).sgn == 0\n        doAssert $x == original\n\
    \nfor x in [initBigInt(0), initBigInt(1), initBigInt(-1)]:\n    for shift in [-1,\
    \ low(int)]:\n        doAssertRaises(ValueError):\n            discard x shl shift\n\
    \        doAssertRaises(ValueError):\n            discard x shr shift\n      \
    \  var assigned = x\n        doAssertRaises(ValueError):\n            `shl=`(assigned,\
    \ shift)\n        doAssert assigned == x\n        doAssertRaises(ValueError):\n\
    \            `shr=`(assigned, shift)\n        doAssert assigned == x\ndoAssert\
    \ (initBigInt(0) shl high(int)) == 0\n\nstatic:\n    let x = initBigInt(\"18446744073709551615\"\
    )\n    doAssert (x shl 64) == initBigInt(\"340282366920938463444927863358058659840\"\
    )\n    doAssert (-x shr 64) == -1\n    doAssert (x and (initBigInt(1) shl 64))\
    \ == 0\n    doAssert (x or (initBigInt(1) shl 64)) == initBigInt(\"36893488147419103231\"\
    )\n    doAssert (x xor -1) == -x - 1\n    doAssert (not x) == -x - 1\n\necho \"\
    Hello World\"\n"
  dependsOn:
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/math/powmod.nim
  - cplib/math/isprime.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/convolution/convolution.nim
  - cplib/math/inner_math.nim
  - cplib/modint/barrett_impl.nim
  - cplib/convolution/convolution.nim
  - cplib/math/inv_gcd.nim
  - cplib/modint/modint.nim
  - cplib/math/bigint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/bigint.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/inner_math.nim
  - cplib/math/powmod.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isprime.nim
  isVerificationFile: true
  path: verify/math/bigint_bitops_unit_test.nim
  requiredBy: []
  timestamp: '2026-09-13 02:58:36+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/bigint_bitops_unit_test.nim
layout: document
redirect_from:
- /verify/verify/math/bigint_bitops_unit_test.nim
- /verify/verify/math/bigint_bitops_unit_test.nim.html
title: verify/math/bigint_bitops_unit_test.nim
---
