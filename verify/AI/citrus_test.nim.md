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
    path: cplib/tmpl/citrus.nim
    title: cplib/tmpl/citrus.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/citrus.nim
    title: cplib/tmpl/citrus.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
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


    import cplib/tmpl/citrus


    assert (-3) % 5 == 2

    assert 7 // 3 == 2

    assert (-7) // 3 == -3

    assert `^`(6, 3) == 5

    assert `&`(6, 3) == 2

    assert `|`(6, 3) == 7

    assert `>>`(8, 1) == 4

    assert `<<`(3, 2) == 12


    var x = -3

    x %= 5

    assert x == 2

    x //= 2

    assert x == 1

    x ^= 3

    assert x == 2

    x &= 6

    assert x == 2

    x |= 8

    assert x == 10

    x >>= 1

    assert x == 5

    x <<= 2

    assert x == 20


    var mask = 0

    mask[2] = true

    assert mask[2]

    mask[2] = false

    assert not mask[2]


    assert pow(2, 10) == 1024

    assert pow(2, 10, 1000) == 24

    var hi = 3

    assert hi.chmax(5)

    assert not hi.chmax(4)

    assert hi == 5

    assert hi.chmin(2)

    hi.max = 9

    hi.min = 4

    assert hi == 4

    assert at(''7'') == 7

    assert fmtprint(@[1, 2, 3]) == "1 2 3"

    '
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  - cplib/tmpl/citrus.nim
  - cplib/tmpl/citrus.nim
  - cplib/math/isqrt.nim
  - cplib/math/isqrt.nim
  isVerificationFile: true
  path: verify/AI/citrus_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/citrus_test.nim
layout: document
redirect_from:
- /verify/verify/AI/citrus_test.nim
- /verify/verify/AI/citrus_test.nim.html
title: verify/AI/citrus_test.nim
---
