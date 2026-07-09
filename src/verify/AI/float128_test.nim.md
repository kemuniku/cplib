---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/float128.nim
    title: cplib/math/float128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/float128.nim
    title: cplib/math/float128.nim
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


    import cplib/math/float128


    let a: float128 = 1.5

    let b: float128 = 2

    assert ((a + b).to_float - 3.5).abs < 1e-12

    assert ((b - a).to_float - 0.5).abs < 1e-12

    assert ((a * b).to_float - 3.0).abs < 1e-12

    assert ((b / a).to_float - (4.0 / 3.0)).abs < 1e-12

    assert (-a).to_float < 0

    assert abs(-a) == a

    assert cmp(a, b) < 0

    assert b > a

    assert a < b

    assert a == a


    doAssert not compiles(a mod b)

    doAssert not compiles(a & b)

    doAssert not compiles(a | b)

    doAssert not compiles(a ^ b)

    doAssert not compiles(a << b)

    doAssert not compiles(a >> b)

    '
  dependsOn:
  - cplib/math/float128.nim
  - cplib/math/float128.nim
  isVerificationFile: true
  path: verify/AI/float128_test.nim
  requiredBy: []
  timestamp: '2026-07-07 07:39:31+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/float128_test.nim
layout: document
redirect_from:
- /verify/verify/AI/float128_test.nim
- /verify/verify/AI/float128_test.nim.html
title: verify/AI/float128_test.nim
---
