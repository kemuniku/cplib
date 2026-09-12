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
    path: cplib/math/factoradic.nim
    title: cplib/math/factoradic.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/factoradic.nim
    title: cplib/math/factoradic.nim
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
    import hashes, sets, tables\nimport cplib/math/factoradic\nimport cplib/math/bigint\n\
    \nlet zero = initFactoradic(0)\nfor value in [zero, -zero, abs(zero), initFactoradic(@[0,\
    \ 0, 0], true)]:\n    doAssert value == zero\n    doAssert value.sgn == 0\n  \
    \  doAssert $value == \"0\"\n    doAssert hash(value) == hash(zero)\n    doAssert\
    \ value.toInt(uint64) == 0\n\nfor a in -50..50:\n    let x = initFactoradic(a)\n\
    \    doAssert x.toInt() == a\n    doAssert x.sgn == cmp(a, 0)\n    doAssert abs(x)\
    \ == abs(a)\n    doAssert -x == -a\n    doAssert +x == x\n    doAssert initFactoradic(x.digits,\
    \ x.sgn < 0) == x\n    doAssert initFactoradic(x.toBigInt()) == x\n    for b in\
    \ -50..50:\n        let y = initFactoradic(b)\n        doAssert cmp(x, y) == cmp(a,\
    \ b)\n        doAssert cmp(x, b) == cmp(a, b)\n        doAssert cmp(a, y) == cmp(a,\
    \ b)\n        doAssert (x == y) == (a == b)\n        doAssert (x < y) == (a <\
    \ b)\n        doAssert (x >= y) == (a >= b)\n        doAssert x + y == a + b\n\
    \        doAssert x - y == a - b\n        doAssert x * y == a * b\n        doAssert\
    \ x * b == a * b\n        doAssert a * y == a * b\n        var assigned = x\n\
    \        assigned += y\n        doAssert assigned == a + b\n        assigned -=\
    \ y\n        doAssert assigned == x\n        assigned *= y\n        doAssert assigned\
    \ == a * b\n        if b == 0: continue\n        var q = a div b\n        var\
    \ r = a mod b\n        if r != 0 and (a < 0) != (b < 0):\n            dec q\n\
    \            r += b\n        doAssert x // y == q\n        doAssert x div y ==\
    \ a div b\n        doAssert x % y == r\n        doAssert x mod y == a mod b\n\
    \        doAssert x // b == q\n        doAssert x div b == a div b\n        doAssert\
    \ x % b == r\n        doAssert x mod b == a mod b\n        doAssert a // y ==\
    \ q\n        doAssert a div y == a div b\n        doAssert a % y == r\n      \
    \  doAssert a mod y == a mod b\n        let division = divmod(x, y)\n        doAssert\
    \ division.quotient == q\n        doAssert division.remainder == r\n        doAssert\
    \ divmod(x, b).quotient == q\n        doAssert divmod(x, b).remainder == r\n \
    \       doAssert divmod(a, y).quotient == q\n        doAssert divmod(a, y).remainder\
    \ == r\n        assigned = x\n        `div=`(assigned, y)\n        doAssert assigned\
    \ == a div b\n        assigned = x\n        `mod=`(assigned, y)\n        doAssert\
    \ assigned == a mod b\n        assigned = x\n        `div=`(assigned, b)\n   \
    \     doAssert assigned == a div b\n        assigned = x\n        `mod=`(assigned,\
    \ b)\n        doAssert assigned == a mod b\n    var factorial = 1\n    for k in\
    \ 0..8:\n        if k > 0: factorial *= k\n        let expected = ((a mod factorial)\
    \ + factorial) mod factorial\n        doAssert x.modFactorial(k) == expected\n\
    \nproc checkSignedInteger[T: SomeSignedInt]() =\n    for value in [low(T), low(T)\
    \ + 1, T(-1), T(0), T(1), high(T)]:\n        let x = initFactoradic(value)\n \
    \       doAssert x.toInt(T) == value\n        doAssert x.toBigInt() == initBigInt(value)\n\
    \        doAssert initFactoradic(x.toBigInt()) == x\n        doAssert cmp(x, value)\
    \ == 0\n    doAssertRaises(AssertionDefect):\n        discard (initFactoradic(low(T))\
    \ - 1).toInt(T)\n    doAssertRaises(AssertionDefect):\n        discard (initFactoradic(high(T))\
    \ + 1).toInt(T)\n\ncheckSignedInteger[int8]()\ncheckSignedInteger[int16]()\ncheckSignedInteger[int32]()\n\
    checkSignedInteger[int64]()\ncheckSignedInteger[int]()\ndoAssert abs(initFactoradic(low(int)))\
    \ == initFactoradic(high(int)) + 1\ndoAssertRaises(AssertionDefect): discard initFactoradic(-1).toInt(uint)\n\
    doAssertRaises(AssertionDefect): discard initFactoradic(-1).toInt(uint64)\ndoAssertRaises(AssertionDefect):\
    \ discard initFactoradic(-1).toPermutation(5)\ndoAssertRaises(AssertionDefect):\
    \ discard factorialFactoradic(-1)\n\nfor a in [low(int), low(int) + 1, -7, -1,\
    \ 0, 1, 7, high(int)]:\n    for b in [low(int), low(int) + 1, -7, -1, 1, 7, high(int)]:\n\
    \        let x = initFactoradic(a)\n        let y = initFactoradic(b)\n      \
    \  let expected = divmod(initBigInt(a), initBigInt(b))\n        doAssert (x *\
    \ b).toBigInt() == initBigInt(a) * initBigInt(b)\n        doAssert (x // b).toBigInt()\
    \ == expected.quotient\n        doAssert (x div b).toBigInt() == initBigInt(a)\
    \ div initBigInt(b)\n        doAssert initBigInt(x % b) == expected.remainder\n\
    \        doAssert initBigInt(x mod b) == initBigInt(a) mod initBigInt(b)\n   \
    \     doAssert (x // y).toBigInt() == expected.quotient\n        doAssert (x div\
    \ y).toBigInt() == initBigInt(a) div initBigInt(b)\n        doAssert (x % y).toBigInt()\
    \ == expected.remainder\n        doAssert (x mod y).toBigInt() == initBigInt(a)\
    \ mod initBigInt(b)\n        doAssert (a // y).toBigInt() == expected.quotient\n\
    \        doAssert (a div y).toBigInt() == initBigInt(a) div initBigInt(b)\n  \
    \      doAssert (a % y).toBigInt() == expected.remainder\n        doAssert (a\
    \ mod y).toBigInt() == initBigInt(a) mod initBigInt(b)\n\nblock:\n    let large\
    \ = factorialFactoradic(2048) + 123\n    let divisor = factorialFactoradic(1024)\
    \ + 7\n    for a in [large, -large, divisor, -divisor, zero]:\n        for b in\
    \ [divisor, -divisor, large, -large]:\n            let division = divmod(a, b)\n\
    \            doAssert division.quotient * b + division.remainder == a\n      \
    \      doAssert abs(division.remainder) < abs(b)\n            doAssert division.remainder\
    \ == 0 or division.remainder.sgn == b.sgn\n            doAssert a // b == division.quotient\n\
    \            doAssert a % b == division.remainder\n            let truncQ = a.toBigInt()\
    \ div b.toBigInt()\n            let truncR = a.toBigInt() mod b.toBigInt()\n \
    \           doAssert (a div b).toBigInt() == truncQ\n            doAssert (a mod\
    \ b).toBigInt() == truncR\n            var assigned = a\n            `div=`(assigned,\
    \ b)\n            doAssert assigned.toBigInt() == truncQ\n            assigned\
    \ = a\n            `mod=`(assigned, b)\n            doAssert assigned.toBigInt()\
    \ == truncR\n            doAssert initFactoradic(a.toBigInt()) == a\n        \
    \    doAssert (a * b).toBigInt() == a.toBigInt() * b.toBigInt()\n    doAssert\
    \ (-large).modFactorial(2048) == factorialFactoradic(2048) - 123\n    doAssert\
    \ (-factorialFactoradic(2048)).modFactorial(2048) == zero\n    for value in [1,\
    \ 7, high(int), low(int)]:\n        let division = divmod(-large, value)\n   \
    \     doAssert division.quotient * value + division.remainder == -large\n    \
    \    doAssert division.remainder == (-large) % value\n\nblock:\n    let value\
    \ = factorialFactoradic(100_000) - 1\n    doAssert ((-value) * low(int)) div low(int)\
    \ == -value\n    doAssert ((-value) * initFactoradic(low(int))) div initFactoradic(low(int))\
    \ == -value\n    doAssert -1 // value == -1\n    doAssert -1 % value == value\
    \ - 1\n    doAssert 1 // (-value) == -1\n    doAssert 1 % (-value) == 1 - value\n\
    \    doAssert -1 div value == 0\n    doAssert -1 mod value == -1\n    doAssert\
    \ 1 div (-value) == 0\n    doAssert 1 mod (-value) == 1\n    doAssert (-value)\
    \ mod value == 0\n    var copied = -value\n    var absolute = abs(copied)\n  \
    \  absolute += 1\n    doAssert copied == -value\n    copied += value\n    doAssert\
    \ copied == zero\n    doAssert hash(copied) == hash(zero)\n\nblock:\n    var seen\
    \ = initHashSet[Factoradic]()\n    var mapping = initTable[Factoradic, int]()\n\
    \    for a in -100..100:\n        let x = initFactoradic(a)\n        seen.incl(x)\n\
    \        mapping[x] = a\n        let copy = initFactoradic(x.digits & @[0, 0],\
    \ a < 0)\n        doAssert hash(x) == hash(copy)\n        doAssert copy in seen\n\
    \        doAssert mapping[copy] == a\n    doAssert seen.len == 201\n\nfor value\
    \ in [-factorialFactoradic(100), initFactoradic(-1), zero]:\n    doAssertRaises(DivByZeroDefect):\
    \ discard value div 0\n    doAssertRaises(DivByZeroDefect): discard value mod\
    \ 0\n    doAssertRaises(DivByZeroDefect): discard divmod(value, zero)\n    doAssertRaises(DivByZeroDefect):\
    \ discard value div zero\n    doAssertRaises(DivByZeroDefect): discard value mod\
    \ zero\n    doAssertRaises(DivByZeroDefect): discard value // 0\n    doAssertRaises(DivByZeroDefect):\
    \ discard value % 0\n    doAssertRaises(DivByZeroDefect): discard value // zero\n\
    \    doAssertRaises(DivByZeroDefect): discard value % zero\n    doAssertRaises(DivByZeroDefect):\
    \ discard 1 // zero\n    doAssertRaises(DivByZeroDefect): discard 1 % zero\n\n\
    echo \"Hello World\"\n"
  dependsOn:
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/math/powmod.nim
  - cplib/math/factoradic.nim
  - cplib/math/isprime.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/convolution/convolution.nim
  - cplib/math/factoradic.nim
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
  path: verify/AI/factoradic_signed_test.nim
  requiredBy: []
  timestamp: '2026-09-13 02:58:36+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/factoradic_signed_test.nim
layout: document
redirect_from:
- /verify/verify/AI/factoradic_signed_test.nim
- /verify/verify/AI/factoradic_signed_test.nim.html
title: verify/AI/factoradic_signed_test.nim
---
