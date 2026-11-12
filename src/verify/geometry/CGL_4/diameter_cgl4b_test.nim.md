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
    path: cplib/geometry/ccw.nim
    title: cplib/geometry/ccw.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/ccw.nim
    title: cplib/geometry/ccw.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/convex_polygon.nim
    title: cplib/geometry/convex_polygon.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/convex_polygon.nim
    title: cplib/geometry/convex_polygon.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/polygon.nim
    title: cplib/geometry/polygon.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/polygon.nim
    title: cplib/geometry/polygon.nim
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
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/CGL_4_B
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/CGL_4_B
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/CGL_4_B

    # verification-helper: ERROR 1e-8

    include cplib/geometry/convex_polygon

    import math, strformat

    proc scanf(formatstr: cstring): cint {.header: "<stdio.h>", varargs.}

    proc ii(): int = discard scanf("%lld", addr result)

    let n = ii()

    proc ff(): float = discard scanf("%lf", addr result)

    var vertices = newSeq[Point[float]](n)

    for i in 0..<n: vertices[i] = initPoint(ff(),ff())

    let answer = initConvexPolygon(vertices).diameter.get

    echo &"{sqrt(float(answer.distance_sq)):.10f}"

    '
  dependsOn:
  - cplib/geometry/convex_polygon.nim
  - cplib/geometry/base.nim
  - cplib/geometry/ccw.nim
  - cplib/geometry/convex_polygon.nim
  - cplib/math/fractions.nim
  - cplib/geometry/base.nim
  - cplib/geometry/ccw.nim
  - cplib/geometry/polygon.nim
  - cplib/geometry/polygon.nim
  - cplib/math/fractions.nim
  isVerificationFile: true
  path: verify/geometry/CGL_4/diameter_cgl4b_test.nim
  requiredBy: []
  timestamp: '2026-11-13 04:50:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/geometry/CGL_4/diameter_cgl4b_test.nim
layout: document
redirect_from:
- /verify/verify/geometry/CGL_4/diameter_cgl4b_test.nim
- /verify/verify/geometry/CGL_4/diameter_cgl4b_test.nim.html
title: verify/geometry/CGL_4/diameter_cgl4b_test.nim
---
