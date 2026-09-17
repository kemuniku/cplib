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
    echo \"Hello World\"\n\nimport cplib/math/fractions\n\nproc checkInverse[T]()\
    \ =\n    for numerator in -5..5:\n        for denominator in 1..5:\n         \
    \   let value = initFraction(T(numerator), T(denominator))\n            let inverse\
    \ = value.inv()\n            assert inverse.den >= T(0)\n            if numerator\
    \ != 0:\n                assert (inverse < initFraction(T(0))) == (numerator <\
    \ 0)\n                assert inverse.inv() == value\n                assert abs(inverse)\
    \ == initFraction(T(denominator), T(abs(numerator)))\n                assert value\
    \ * inverse == initFraction(T(1))\n            else:\n                assert inverse\
    \ == initFraction(T(1), T(0))\n    assert initFraction(T(-1), T(0)).inv().den\
    \ > T(0)\n    assert initFraction(T(-1), T(0)).inv() == initFraction(T(0))\n \
    \   assert initFraction(T(1), T(0)).inv() == initFraction(T(0))\n    assert initFraction(T(0),\
    \ T(0)).inv().isNaN\n    let inverse = initFraction(T(-2), T(4), false).inv()\n\
    \    assert inverse.den > T(0)\n    assert inverse == initFraction(T(-2))\n\n\
    checkInverse[int]()\ncheckInverse[int64]()\n"
  dependsOn:
  - cplib/math/fractions.nim
  - cplib/math/fractions.nim
  isVerificationFile: true
  path: verify/math/fraction_inverse_sign_test.nim
  requiredBy: []
  timestamp: '2026-09-18 01:13:21+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/fraction_inverse_sign_test.nim
layout: document
redirect_from:
- /verify/verify/math/fraction_inverse_sign_test.nim
- /verify/verify/math/fraction_inverse_sign_test.nim.html
title: verify/math/fraction_inverse_sign_test.nim
---
