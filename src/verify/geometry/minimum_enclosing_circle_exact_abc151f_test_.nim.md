---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/circle.nim
    title: cplib/geometry/circle.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/circle.nim
    title: cplib/geometry/circle.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/circle_integer_impl.nim
    title: cplib/geometry/circle_integer_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/circle_integer_impl.nim
    title: cplib/geometry/circle_integer_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/minimum_enclosing_circle.nim
    title: cplib/geometry/minimum_enclosing_circle.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/minimum_enclosing_circle.nim
    title: cplib/geometry/minimum_enclosing_circle.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    ERROR: 1e-6
    PROBLEM: https://atcoder.jp/contests/abc151/tasks/abc151_f
    links:
    - https://atcoder.jp/contests/abc151/tasks/abc151_f
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://atcoder.jp/contests/abc151/tasks/abc151_f

    # verification-helper: ERROR 1e-6

    include cplib/geometry/minimum_enclosing_circle

    import strformat

    import cplib/math/int128

    proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}

    proc integer(): int = scanf("%lld", addr result)

    let n = integer()

    var inputPoints: seq[Point[Int128]]

    for _ in 0..<n: inputPoints.add(initPoint(to_Int128(integer()), to_Int128(integer())))

    let answer = minimum_enclosing_circle(inputPoints)

    echo &"{answer.radius_approx:.12f}"

    '
  dependsOn:
  - cplib/geometry/base.nim
  - cplib/math/fractions.nim
  - cplib/geometry/minimum_enclosing_circle.nim
  - cplib/geometry/minimum_enclosing_circle.nim
  - cplib/geometry/base.nim
  - cplib/geometry/circle.nim
  - cplib/math/fractions.nim
  - cplib/geometry/circle.nim
  - cplib/geometry/circle_integer_impl.nim
  - cplib/math/int128.nim
  - cplib/math/int128.nim
  - cplib/geometry/circle_integer_impl.nim
  isVerificationFile: false
  path: verify/geometry/minimum_enclosing_circle_exact_abc151f_test_.nim
  requiredBy: []
  timestamp: '2026-11-15 07:34:05+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/geometry/minimum_enclosing_circle_exact_abc151f_test_.nim
layout: document
redirect_from:
- /library/verify/geometry/minimum_enclosing_circle_exact_abc151f_test_.nim
- /library/verify/geometry/minimum_enclosing_circle_exact_abc151f_test_.nim.html
title: verify/geometry/minimum_enclosing_circle_exact_abc151f_test_.nim
---
