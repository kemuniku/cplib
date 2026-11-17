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
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/CGL_7_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/CGL_7_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/CGL_7_A

    import strutils

    import cplib/geometry/base

    import cplib/geometry/circle

    let first = stdin.readLine.splitWhitespace

    let second = stdin.readLine.splitWhitespace

    let a = initCircle(initPoint(parseInt(first[0]), parseInt(first[1])), parseInt(first[2]))

    let b = initCircle(initPoint(parseInt(second[0]), parseInt(second[1])), parseInt(second[2]))

    echo common_tangent_count(a, b)

    '
  dependsOn:
  - cplib/geometry/base.nim
  - cplib/math/fractions.nim
  - cplib/geometry/circle.nim
  - cplib/geometry/base.nim
  - cplib/math/fractions.nim
  - cplib/geometry/circle.nim
  - cplib/geometry/circle_integer_impl.nim
  - cplib/geometry/circle_integer_impl.nim
  isVerificationFile: true
  path: verify/geometry/CGL_7/exact_circle_relation_test.nim
  requiredBy: []
  timestamp: '2026-11-15 07:34:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/geometry/CGL_7/exact_circle_relation_test.nim
layout: document
redirect_from:
- /verify/verify/geometry/CGL_7/exact_circle_relation_test.nim
- /verify/verify/geometry/CGL_7/exact_circle_relation_test.nim.html
title: verify/geometry/CGL_7/exact_circle_relation_test.nim
---
