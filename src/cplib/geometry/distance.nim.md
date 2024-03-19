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
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_2/distance_cgl2d_test.nim
    title: verify/geometry/CGL_2/distance_cgl2d_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_2/distance_cgl2d_test.nim
    title: verify/geometry/CGL_2/distance_cgl2d_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GEOMETRY_DISTANCE:\n    const CPLIB_GEOMETRY_DISTANCE*\
    \ = 1\n    import math\n    import cplib/geometry/base\n    import cplib/geometry/intersect\n\
    \    proc norm*[T](p1, p2: Point[T]): T = norm(p1 - p2)\n    proc norm*[T](p:\
    \ Point[T], l: Line[T]): T =\n        var area_sq = cross(l.vector, p - l.s)\n\
    \        return area_sq * area_sq / norm(l.vector)\n    proc norm*[T](p: Point[T],\
    \ s: Segment[T]): T =\n        if geometry_lt(dot(s.vector, p - s.s), 0): return\
    \ norm(p - s.s)\n        if geometry_lt(dot(-s.vector, p - s.t), 0): return norm(p\
    \ - s.t)\n        return norm(p, initLine(s.s, s.t))\n    proc norm*[T](s1, s2:\
    \ Segment[T]): T =\n        if intersect(s1, s2): return 0\n        result = norm(s1.s,\
    \ s2)\n        result = min(result, norm(s1.t, s2))\n        result = min(result,\
    \ norm(s2.s, s1))\n        result = min(result, norm(s2.t, s1))\n\n    proc distance*(p1,\
    \ p2: Point[SomeFloat]): float = sqrt(norm(p1, p2))\n    proc distance*(p: Point[SomeFloat],\
    \ l: Line[SomeFloat]): float = sqrt(norm(p, l))\n    proc distance*(p: Point[SomeFloat],\
    \ s: Segment[SomeFloat]): float = sqrt(norm(p, s))\n    proc distance*(s1, s2:\
    \ Segment[SomeFloat]): float = sqrt(norm(s1, s2))\n\n    proc manhattan*[T](p:\
    \ Point[T]): T = abs(p.x) + abs(p.y)\n    proc manhattan*[T](p1, p2: Point[T]):\
    \ T = manhattan(p1 - p2)\n"
  dependsOn:
  - cplib/geometry/base.nim
  - cplib/geometry/base.nim
  - cplib/geometry/intersect.nim
  - cplib/geometry/ccw.nim
  - cplib/geometry/intersect.nim
  - cplib/geometry/ccw.nim
  - cplib/geometry/angle.nim
  - cplib/geometry/angle.nim
  isVerificationFile: false
  path: cplib/geometry/distance.nim
  requiredBy: []
  timestamp: '2024-03-19 13:56:32+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/geometry/CGL_2/distance_cgl2d_test.nim
  - verify/geometry/CGL_2/distance_cgl2d_test.nim
documentation_of: cplib/geometry/distance.nim
layout: document
redirect_from:
- /library/cplib/geometry/distance.nim
- /library/cplib/geometry/distance.nim.html
title: cplib/geometry/distance.nim
---
