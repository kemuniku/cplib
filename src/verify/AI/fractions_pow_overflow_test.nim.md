---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
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
    import cplib/math/fractions\n\nproc check[T](x: Fraction[T], n: int, num, den:\
    \ T) =\n    let value = pow(x, n)\n    doAssert value.num == num\n    doAssert\
    \ value.den == den\n\ncheck(initFraction(4_000_000_000'i64), 1, 4_000_000_000'i64,\
    \ 1'i64)\ncheck(initFraction(1'i64, 4_000_000_000'i64), 1, 1'i64, 4_000_000_000'i64)\n\
    check(initFraction(-4_000_000_000'i64), 1, -4_000_000_000'i64, 1'i64)\ncheck(initFraction(50_000'i32),\
    \ 1, 50_000'i32, 1'i32)\ncheck(initFraction(1'i32, 50_000'i32), 1, 1'i32, 50_000'i32)\n\
    check(initFraction(100_000'i64), 2, 10_000_000_000'i64, 1'i64)\ncheck(initFraction(1'i64,\
    \ 100_000'i64), 2, 1'i64, 10_000_000_000'i64)\ncheck(initFraction(4_000_000_000'i64),\
    \ 0, 1'i64, 1'i64)\ncheck(initFraction(0'i64), 0, 1'i64, 1'i64)\ncheck(initFraction(0'i64),\
    \ 5, 0'i64, 1'i64)\ncheck(initFraction(-2'i64, 3'i64), 3, -8'i64, 27'i64)\ncheck(initFraction(-2'i64,\
    \ 3'i64), 4, 16'i64, 81'i64)\n\nfor num in -3..3:\n    for den in 1..3:\n    \
    \    let x = initFraction(num, den)\n        var expected = initFraction(1)\n\
    \        for exponent in 0..5:\n            doAssert pow(x, exponent) == expected\n\
    \            expected *= x\necho \"Hello World\"\n"
  dependsOn:
  - cplib/math/fractions.nim
  - cplib/math/fractions.nim
  isVerificationFile: true
  path: verify/AI/fractions_pow_overflow_test.nim
  requiredBy: []
  timestamp: '2026-10-01 02:25:40+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/fractions_pow_overflow_test.nim
layout: document
redirect_from:
- /verify/verify/AI/fractions_pow_overflow_test.nim
- /verify/verify/AI/fractions_pow_overflow_test.nim.html
title: verify/AI/fractions_pow_overflow_test.nim
---
