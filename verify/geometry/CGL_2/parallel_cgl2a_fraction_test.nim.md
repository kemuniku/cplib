---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/angle.nim
    title: cplib/geometry/angle.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/angle.nim
    title: cplib/geometry/angle.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
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
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_2_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_2_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_2_A\n\
    include cplib/geometry/angle\ninclude cplib/math/fractions\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\n\nvar q = ii()\nfor _ in 0..<q:\n    proc get(): Point[Fraction[int]]\
    \ = initPoint(initFraction(ii()), initFraction(ii()))\n    var p1, p2, p3, p4\
    \ = get()\n    var s1 = initLine(p1, p2)\n    var s2 = initLine(p3, p4)\n\n  \
    \  if is_parallel(s1, s2): echo 2\n    elif is_orthogonal(s1, s2): echo 1\n  \
    \  else: echo 0\n"
  dependsOn:
  - cplib/math/fractions.nim
  - cplib/geometry/base.nim
  - cplib/geometry/angle.nim
  - cplib/math/fractions.nim
  - cplib/geometry/angle.nim
  - cplib/geometry/base.nim
  isVerificationFile: true
  path: verify/geometry/CGL_2/parallel_cgl2a_fraction_test.nim
  requiredBy: []
  timestamp: '2024-06-27 15:21:09+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/geometry/CGL_2/parallel_cgl2a_fraction_test.nim
layout: document
redirect_from:
- /verify/verify/geometry/CGL_2/parallel_cgl2a_fraction_test.nim
- /verify/verify/geometry/CGL_2/parallel_cgl2a_fraction_test.nim.html
title: verify/geometry/CGL_2/parallel_cgl2a_fraction_test.nim
---
