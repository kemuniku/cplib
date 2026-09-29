---
data:
  _extendedDependsOn:
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
    import cplib/modint/modint\n\nproc normalized(x, m: int): int =\n    let r = x\
    \ mod m\n    if r < 0: r + m else: r\n\nproc checkIntegerInit[T: MontgomeryModint]()\
    \ =\n    let modulus = T.umod.uint64\n    template checkSigned(I: typedesc) =\n\
    \        for value in [low(I), high(I), I(-1), I(0), I(1)]:\n            doAssert\
    \ T.init(value).val == normalized(value.int, modulus.int)\n    template checkUnsigned(I:\
    \ typedesc) =\n        for value in [low(I), high(I), I(1)]:\n            doAssert\
    \ T.init(value).val == (value.uint64 mod modulus).int\n    checkSigned(int8)\n\
    \    checkSigned(int16)\n    checkSigned(int32)\n    checkSigned(int64)\n    checkSigned(int)\n\
    \    checkUnsigned(uint8)\n    checkUnsigned(uint16)\n    checkUnsigned(uint32)\n\
    \    checkUnsigned(uint64)\n    checkUnsigned(uint)\n    for value in [modulus\
    \ - 1, modulus, modulus + 1]:\n        doAssert T.init(value).val == (value mod\
    \ modulus).int\n\nproc checkDivision[T]() =\n    let modulus = T.umod.int\n  \
    \  for value in [low(int), high(int), -modulus, -1, 0, 1, modulus - 1, modulus]:\n\
    \        let expected = normalized(value, modulus)\n        var a = T.init(value)\n\
    \        a /= 2\n        doAssert (a * 2).val == expected\n        a = T.init(value)\n\
    \        a /= -2\n        doAssert (a * -2).val == expected\n        a = T.init(value)\n\
    \        const denominator = 1 shl 1\n        a /= denominator\n        doAssert\
    \ (a * denominator).val == expected\n        a = T.init(value)\n        var runtimeDenominator\
    \ = 2\n        a /= runtimeDenominator\n        doAssert (a * runtimeDenominator).val\
    \ == expected\n        a = T.init(value)\n        a /= 2i32\n        doAssert\
    \ (a * 2).val == expected\n        a = T.init(value)\n        a /= T.init(2)\n\
    \        doAssert (a * 2).val == expected\n\nproc checkArithmetic[T]() =\n   \
    \ let modulus = T.umod.int\n    for value in [low(int), high(int), -modulus -\
    \ 1, -modulus, -1,\n                  0, 1, modulus - 1, modulus, modulus + 1]:\n\
    \        doAssert T.init(value).val == normalized(value, modulus)\n    when T\
    \ is MontgomeryModint:\n        checkIntegerInit[T]()\n    when T is StaticBarrettModint:\n\
    \        for value in [0u, T.umod.uint - 1, T.umod.uint,\n                   \
    \   (T.umod.uint - 1) * (T.umod.uint - 1), high(uint)]:\n            doAssert\
    \ rem(T, value) == uint32(value mod T.umod.uint)\n    template checkPair(x, y:\
    \ int) =\n        block:\n            var a = T.init(x)\n            let b = T.init(y)\n\
    \            doAssert (a + b).val == normalized(x + y, modulus)\n            doAssert\
    \ (a - b).val == normalized(x - y, modulus)\n            doAssert (a * b).val\
    \ == normalized(x * y, modulus)\n            a += T.init(modulus - 1)\n      \
    \      a += T.init(1)\n            doAssert a.val == x\n            doAssert (a\
    \ * b).val == normalized(x * y, modulus)\n    for x in [0, 1 mod modulus, modulus\
    \ div 2, modulus - 1]:\n        for y in [0, 1 mod modulus, modulus div 2, modulus\
    \ - 1]:\n            checkPair(x, y)\n    var state = 90123456789u64\n    for\
    \ i in 0..<5000:\n        state = state xor (state shl 13)\n        state = state\
    \ xor (state shr 7)\n        state = state xor (state shl 17)\n        let x =\
    \ (state mod modulus.uint64).int\n        state = state xor (state shl 13)\n \
    \       state = state xor (state shr 7)\n        state = state xor (state shl\
    \ 17)\n        let y = (state mod modulus.uint64).int\n        checkPair(x, y)\n\
    \    when T is StaticMontgomeryModint or T is StaticBarrettModint:\n        when\
    \ T.umod > 1 and T.umod mod 2 == 1:\n            checkDivision[T]()\n    else:\n\
    \        if modulus > 1 and modulus mod 2 == 1:\n            checkDivision[T]()\n\
    \ncheckArithmetic[StaticMontgomeryModint[1u32]]()\ncheckArithmetic[StaticMontgomeryModint[17u32]]()\n\
    checkArithmetic[StaticMontgomeryModint[21u32]]()\ncheckArithmetic[StaticMontgomeryModint[998244353u32]]()\n\
    checkArithmetic[StaticMontgomeryModint[1000000007u32]]()\ncheckArithmetic[StaticMontgomeryModint[1073741823u32]]()\n\
    checkArithmetic[StaticBarrettModint[1u32]]()\ncheckArithmetic[StaticBarrettModint[2u32]]()\n\
    checkArithmetic[StaticBarrettModint[17u32]]()\ncheckArithmetic[StaticBarrettModint[21u32]]()\n\
    checkArithmetic[StaticBarrettModint[998244353u32]]()\ncheckArithmetic[StaticBarrettModint[1000000007u32]]()\n\
    checkArithmetic[StaticBarrettModint[2147483647u32]]()\n\nfor modulus in [1, 3,\
    \ 17, 21, 998244353, 1000000007, 1073741823]:\n    modint_montgomery.setMod(modulus)\n\
    \    checkArithmetic[modint_montgomery]()\nfor modulus in [1, 2, 17, 21, 998244353,\
    \ 1000000007, 2147483647]:\n    modint_barrett.setMod(modulus)\n    checkArithmetic[modint_barrett]()\n\
    \necho \"Hello World\"\n"
  dependsOn:
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  isVerificationFile: true
  path: verify/modint/modint_arithmetic_test.nim
  requiredBy: []
  timestamp: '2026-09-27 01:47:19+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/modint/modint_arithmetic_test.nim
layout: document
redirect_from:
- /verify/verify/modint/modint_arithmetic_test.nim
- /verify/verify/modint/modint_arithmetic_test.nim.html
title: verify/modint/modint_arithmetic_test.nim
---
