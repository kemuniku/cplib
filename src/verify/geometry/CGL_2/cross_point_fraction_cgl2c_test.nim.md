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
    path: cplib/geometry/ccw.nim
    title: cplib/geometry/ccw.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/ccw.nim
    title: cplib/geometry/ccw.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/intersect.nim
    title: cplib/geometry/intersect.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/intersect.nim
    title: cplib/geometry/intersect.nim
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
    ERROR: 1e-8
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_2_C
    links:
    - https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_2_C
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_2_C\n\
    # verification-helper: ERROR 1e-8\ninclude cplib/geometry/intersect\nimport cplib/math/fractions\n\
    import strformat\nproc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\n\
    proc ii(): int {.inline.} = scanf(\"%lld\\n\", addr result)\n\nvar q = ii()\n\
    proc get(): Point[Fraction[int]] = initPoint(initFraction(ii()), initFraction(ii()))\n\
    for _ in 0..<q:\n    var l1, l2 = initLine(get(), get())\n    var p = cross_point(l1,\
    \ l2)\n    echo &\"{p.x.toFloat:.10f} {p.y.toFloat:.10f}\"\n"
  dependsOn:
  - cplib/geometry/intersect.nim
  - cplib/math/fractions.nim
  - cplib/geometry/ccw.nim
  - cplib/geometry/angle.nim
  - cplib/geometry/base.nim
  - cplib/math/fractions.nim
  - cplib/geometry/base.nim
  - cplib/geometry/angle.nim
  - cplib/geometry/ccw.nim
  - cplib/geometry/intersect.nim
  isVerificationFile: true
  path: verify/geometry/CGL_2/cross_point_fraction_cgl2c_test.nim
  requiredBy: []
  timestamp: '2024-06-27 15:21:09+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/geometry/CGL_2/cross_point_fraction_cgl2c_test.nim
layout: document
redirect_from:
- /verify/verify/geometry/CGL_2/cross_point_fraction_cgl2c_test.nim
- /verify/verify/geometry/CGL_2/cross_point_fraction_cgl2c_test.nim.html
title: verify/geometry/CGL_2/cross_point_fraction_cgl2c_test.nim
---
