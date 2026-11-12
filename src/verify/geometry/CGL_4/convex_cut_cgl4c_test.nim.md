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
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/CGL_4_C
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/CGL_4_C
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/CGL_4_C\n\
    # verification-helper: ERROR 1e-8\ninclude cplib/geometry/convex_polygon\nimport\
    \ strformat\nproc scanf(formatstr: cstring): cint {.header: \"<stdio.h>\", varargs.}\n\
    proc ii(): int = discard scanf(\"%lld\", addr result)\nproc ff(): float = discard\
    \ scanf(\"%lf\", addr result)\nproc point(): Point[float] = initPoint(ff(),ff())\n\
    let n = ii()\nvar vertices = newSeq[Point[float]](n)\nfor i in 0..<n: vertices[i]\
    \ = point()\nlet poly = initConvexPolygon(vertices)\nlet q = ii()\nfor i in 0..<q:\n\
    \    let s = point()\n    let t = point()\n    let clipped = convex_cut(poly,initLine(s,t))\n\
    \    echo &\"{abs(clipped.area):.10f}\"\n"
  dependsOn:
  - cplib/geometry/ccw.nim
  - cplib/geometry/convex_polygon.nim
  - cplib/geometry/polygon.nim
  - cplib/geometry/convex_polygon.nim
  - cplib/math/fractions.nim
  - cplib/math/fractions.nim
  - cplib/geometry/polygon.nim
  - cplib/geometry/base.nim
  - cplib/geometry/base.nim
  - cplib/geometry/ccw.nim
  isVerificationFile: true
  path: verify/geometry/CGL_4/convex_cut_cgl4c_test.nim
  requiredBy: []
  timestamp: '2026-11-13 04:50:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/geometry/CGL_4/convex_cut_cgl4c_test.nim
layout: document
redirect_from:
- /verify/verify/geometry/CGL_4/convex_cut_cgl4c_test.nim
- /verify/verify/geometry/CGL_4/convex_cut_cgl4c_test.nim.html
title: verify/geometry/CGL_4/convex_cut_cgl4c_test.nim
---
