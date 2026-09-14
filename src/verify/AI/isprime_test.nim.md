---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
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
    echo \"Hello World\"\n\nimport cplib/math/isprime\n\nassert not isprime(1)\nassert\
    \ isprime(2)\nassert isprime(97)\nassert not isprime(91)\nassert isprime(1_000_000_007)\n\
    assert not isprime(low(int))\nassert not isprime(-1)\nassert not isprime(0)\n\
    for n in [3, 5, 13, 19, 73, 193, 407521, 299210837]:\n    assert isprime(n)\n\
    when sizeof(int) == 8:\n    assert isprime(2_305_843_009_213_693_951.int)\n  \
    \  assert isprime(9_223_372_036_854_775_783.int)\n    assert not isprime(high(int))\n\
    \    assert not isprime(341_550_071_728_321.int)\n    assert not isprime(3_825_123_056_546_413_051.int)\n\
    \    assert not isprime(1_000_000_014_000_000_049.int)\n\nproc testIntegerType[T:\
    \ SomeInteger]() =\n    assert not isprime(T(0))\n    assert not isprime(T(1))\n\
    \    assert isprime(T(2))\n    assert isprime(T(97))\n    assert not isprime(T(91))\n\
    \ntestIntegerType[int]()\ntestIntegerType[int8]()\ntestIntegerType[int16]()\n\
    testIntegerType[int32]()\ntestIntegerType[int64]()\ntestIntegerType[uint]()\n\
    testIntegerType[uint8]()\ntestIntegerType[uint16]()\ntestIntegerType[uint32]()\n\
    testIntegerType[uint64]()\n\nassert isprime(18_446_744_073_709_551_557u64)\nassert\
    \ not isprime(high(uint64))\nassert not isprime(9_223_372_036_854_775_808u64)\n\
    assert not isprime(18_446_744_030_759_878_681u64)\nwhen sizeof(uint) == 8:\n \
    \   assert isprime(18_446_744_073_709_551_557u64.uint)\n    assert not isprime(high(uint))\n\
    \nvar composite: array[10001, bool]\nfor n in 2..10000:\n    if not composite[n]:\n\
    \        for multiple in countup(n * 2, 10000, n):\n            composite[multiple]\
    \ = true\n    assert isprime(n.uint) == not composite[n]\n"
  dependsOn:
  - cplib/math/isprime.nim
  - cplib/math/isprime.nim
  isVerificationFile: true
  path: verify/AI/isprime_test.nim
  requiredBy: []
  timestamp: '2026-09-14 18:23:55+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/isprime_test.nim
layout: document
redirect_from:
- /verify/verify/AI/isprime_test.nim
- /verify/verify/AI/isprime_test.nim.html
title: verify/AI/isprime_test.nim
---
