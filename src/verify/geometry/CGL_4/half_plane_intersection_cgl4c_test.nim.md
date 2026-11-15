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
    path: cplib/geometry/half_plane_intersection.nim
    title: cplib/geometry/half_plane_intersection.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/half_plane_intersection.nim
    title: cplib/geometry/half_plane_intersection.nim
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
    ERROR: 1e-7
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_4_C
    links:
    - https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_4_C
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_4_C\n\
    # verification-helper: ERROR 1e-7\nimport cplib/geometry/base\nimport cplib/geometry/half_plane_intersection\n\
    import strformat\nproc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\n\
    proc ii(): int {.inline.} = scanf(\"%lld\", addr result)\nproc ff(): float {.inline.}\
    \ = scanf(\"%lf\", addr result)\nproc get(): Point[float] = Point[float](x: ff(),\
    \ y: ff())\n\nlet n = ii()\nvar points = newSeq[Point[float]](n)\nfor p in points.mitems:\
    \ p = get()\nvar constraints: seq[Line[float]]\nfor i in 0..<n:\n    constraints.add(Line[float](s:\
    \ points[i], t: points[(i+1) mod n]))\nlet q = ii()\nfor _ in 0..<q:\n    let\
    \ line = Line[float](s: get(), t: get())\n    let region = half_plane_intersection(constraints\
    \ & @[line])\n    var area = 0.0\n    for i in 0..<region.vertices.len:\n    \
    \    let a = region.vertices[i]\n        let b = region.vertices[(i+1) mod region.vertices.len]\n\
    \        area += a.x*b.y-a.y*b.x\n    echo &\"{area/2:.10f}\"\n"
  dependsOn:
  - cplib/math/fractions.nim
  - cplib/math/fractions.nim
  - cplib/geometry/base.nim
  - cplib/geometry/base.nim
  - cplib/geometry/half_plane_intersection.nim
  - cplib/geometry/half_plane_intersection.nim
  isVerificationFile: true
  path: verify/geometry/CGL_4/half_plane_intersection_cgl4c_test.nim
  requiredBy: []
  timestamp: '2026-11-16 00:30:02+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/geometry/CGL_4/half_plane_intersection_cgl4c_test.nim
layout: document
redirect_from:
- /verify/verify/geometry/CGL_4/half_plane_intersection_cgl4c_test.nim
- /verify/verify/geometry/CGL_4/half_plane_intersection_cgl4c_test.nim.html
title: verify/geometry/CGL_4/half_plane_intersection_cgl4c_test.nim
---
