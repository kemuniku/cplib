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
    import cplib/modint/modint\nproc checkUnsigned[T: BarrettModint, U: SomeUnsignedInt](values:\
    \ openArray[U]) =\n  for value in values:\n    let expected = int(uint64(value)\
    \ mod uint64(T.umod))\n    let x = init(T, value)\n    doAssert x.val == expected\n\
    \    var y = init(T, 0)\n    y += value\n    doAssert y == x\n    y -= value\n\
    \    doAssert y.val == 0\n    y = init(T, 1)\n    y *= value\n    doAssert y ==\
    \ x\n    doAssert (init(T, 0) + value).val == expected\n    doAssert (value +\
    \ init(T, 0)).val == expected\nproc check[T: BarrettModint]() =\n  checkUnsigned[T,\
    \ uint8]([0u8, 1u8, high(uint8)])\n  checkUnsigned[T, uint16]([0u16, 1u16, high(uint16)])\n\
    \  checkUnsigned[T, uint32]([0u32, 1u32, high(uint32)])\n  checkUnsigned[T, uint]([0u,\
    \ 1u, high(uint)])\n  checkUnsigned[T, uint64]([0u64, 1u64, high(int).uint64,\
    \ high(int).uint64 + 1, high(uint64)])\n  for value in [low(int), -1, 0, 1, high(int)]:\n\
    \    var expected = value mod T.umod.int\n    if expected < 0: expected += T.umod.int\n\
    \    doAssert init(T, value).val == expected\ncheck[modint998244353_barrett]()\n\
    check[modint1000000007_barrett]()\nfor modulus in [1, 2, 41, 998244353, 2147483647]:\n\
    \  modint_barrett.setMod(modulus)\n  check[modint_barrett]()\necho \"Hello World\"\
    \n"
  dependsOn:
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  isVerificationFile: true
  path: verify/math/barrett_unsigned_test.nim
  requiredBy: []
  timestamp: '2026-10-08 06:34:57+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/barrett_unsigned_test.nim
layout: document
redirect_from:
- /verify/verify/math/barrett_unsigned_test.nim
- /verify/verify/math/barrett_unsigned_test.nim.html
title: verify/math/barrett_unsigned_test.nim
---
