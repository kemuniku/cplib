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
  code: '# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

    echo "Hello World"


    import cplib/math/fractions


    let a = initFraction(2, 4)

    let b = initFraction(1, 3)

    assert $a == "1/2"

    assert (a + b) == initFraction(5, 6)

    assert (a - b) == initFraction(1, 6)

    assert (a * b) == initFraction(1, 6)

    assert (a / b) == initFraction(3, 2)

    assert (a + 1) == initFraction(3, 2)

    assert (1 + a) == initFraction(3, 2)

    assert (1 - a) == initFraction(1, 2)

    assert (2 * b) == initFraction(2, 3)

    assert (1 / b) == initFraction(3, 1)

    assert -a == initFraction(-1, 2)

    assert abs(initFraction(-3, 4)) == initFraction(3, 4)

    assert inv(a) == initFraction(2, 1)

    assert a > b

    assert b < a

    assert a >= initFraction(1, 2)

    assert b <= initFraction(1, 3)

    assert a == initFraction(1, 2)

    assert cmp(a, b) > 0

    assert cmp(a, 1) < 0

    assert cmp(1, a) > 0

    assert abs(a.toFloat - 0.5) < 1e-12

    assert pow(initFraction(2, 3), 3) == initFraction(8, 27)

    assert initFraction(0, 0, false).isNaN

    '
  dependsOn:
  - cplib/math/fractions.nim
  - cplib/math/fractions.nim
  isVerificationFile: true
  path: verify/AI/fractions_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/fractions_test.nim
layout: document
redirect_from:
- /verify/verify/AI/fractions_test.nim
- /verify/verify/AI/fractions_test.nim.html
title: verify/AI/fractions_test.nim
---
